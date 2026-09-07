local M = {}

local config = {
  browser = {
    command = nil,
    args = {
      '--new-window'
    },
    launch_grace_ms = 3000
  }
}

-- 現状の状態管理
local state = {
  bufnr = nil,
  svg = nil,
  generation = 0,
  revision = 0,
  server = nil,
  event_clients = {},
  browser_launch_ms = nil,
  host = '127.0.0.1',
  port = nil
}

local function now_ms()
  return vim.uv.hrtime() / 1000000
end

local function get_buffer_source(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return nil, 'Buffer is invalid.'
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return table.concat(lines, '\n')
end

local function build_http_response(status, content_type, body)
  return table.concat({
    'HTTP/1.1 ' .. status,
    'Content-Type: ' .. content_type,
    'Content-Length: ' .. #body,
    'Cache-Control: no-store',
    'Connection: close',
    '',
    body,
  }, '\r\n')
end

local function close_client(client)
  state.event_clients[client] = nil
  if client and not client:is_closing() then
    client:close()
  end
end

local function build_preview_html()
  return [[<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>PlantUML Preview</title>
  <style>
    html,
    body {
      margin: 0;
      padding: 0;
      background: #ffffff;
    }

    #diagram {
      display: block;
      max-width: 100%;
      height: auto;
      margin: 0 auto;
    }
  </style>
</head>
<body>
  <img id="diagram" src="/diagram.svg" alt="PlantUML preview">

  <script>
    const diagram = document.getElementById('diagram');
    const events = new EventSource('/events');

    events.addEventListener('update', (event) => {
      diagram.src =
        '/diagram.svg?v=' + encodeURIComponent(event.data);
    });
  </script>
</body>
</html>
]]
end

local function register_event_client(client)
  state.event_clients[client] = true

  local response = table.concat({
    'HTTP/1.1 200 OK',
    'Content-Type: text/event-stream; charset=utf-8',
    'Cache-Control: no-cache',
    'Connection: keep-alive',
    '',
    'event: update',
    'data: ' .. state.revision,
    '',
    ''
  }, '\r\n')

  client:write(response, function(err)
    if err then
      close_client(client)
    end
  end)

  -- SSE接続ではブラウザからデータは送信されないが,
  -- EOFを監視することでブラウザの切断を検知する.
  client:read_start(function(err, chunk)
    if err or not chunk then
      close_client(client)
    end
  end)
end

local function broadcast_update()
  local message = table.concat({
    'event: update',
    'data: ' .. state.revision,
    '',
    ''
  }, '\r\n')

  for client in pairs(state.event_clients) do
    if client:is_closing() then
      state.event_clients[client] = nil
    else
      client:write(message, function(err)
        if err then
          close_client(client)
        end
      end)
    end
  end
end

local function handle_http_request(client, request)
  local method, target = request:match('^(%u+)%s+([^%s]+)')
  if method ~= 'GET' then
    client:write(
      build_http_response(
        '405 Method Not Allowed',
        'text/plain; charset=utf-8',
        'Method Not Allowed\n'
      ),
      function()
        close_client(client)
      end
    )
    return
  end

  target = target and target:match('^[^?]+') or target
  if target == '/events' then
    register_event_client(client)
    return
  end

  local status
  local content_type
  local body

  if target == '/' then
    status = '200 OK'
    content_type = 'text/html; charset=utf-8'
    body = build_preview_html()
  elseif target == '/diagram.svg' then
    if state.svg then
      status = '200 OK'
      content_type = 'image/svg+xml; charset=utf-8'
      body = state.svg
    else
      status = '503 Service Unavailable'
      content_type = 'text/plain; charset=utf-8'
      body = 'PlantUML preview is not ready.\n'
    end
  else
    status = '404 Not Found'
    content_type = 'text/plain; charset=utf-8'
    body = 'Not Found\n'
  end

  client:write(
    build_http_response(status, content_type, body),
    function()
      close_client(client)
    end
  )
end

local function start_server()
  if state.server and not state.server:is_closing() then
    return state.port
  end

  local server = vim.uv.new_tcp()
  if not server then
    return nil, 'Failed to create TCP server.'
  end

  local bind_ok, bind_err = server:bind(state.host, 0)
  if not bind_ok then
    server:close()
    return nil, 'Failed to bind preview server: ' .. tostring(bind_err)
  end

  local listen_ok, listen_err = server:listen(16, function(err)
    if err then
      vim.schedule(function()
        vim.notify(
          'PlantUML preview server error: ' .. tostring(err),
          vim.log.levels.ERROR
        )
      end)
      return
    end

    local client = vim.uv.new_tcp()
    if not client then
      return
    end

    local accept_ok = server:accept(client)
    if not accept_ok then
      close_client(client)
      return
    end

    local request = ''

    client:read_start(function(read_err, chunk)
      if read_err then
        close_client(client)
        return
      end

      if not chunk then
        close_client(client)
        return
      end

      request = request .. chunk

      if #request > 16384 then
        client:read_stop()
        close_client(client)
        return
      end

      if request:find('\r\n\r\n', 1, true) then
        client:read_stop()
        handle_http_request(client, request)
      end
    end)
  end)

  if not listen_ok then
    server:close()
    return nil, 'Failed to listen on preview server: ' .. tostring(listen_err)
  end

  local address, address_err = server:getsockname()
  if not address then
    server:close()
    return nil, 'Failed to get preview server address: '
      .. tostring(address_err)
  end

  state.server = server
  state.port = address.port

  return state.port
end

local function stop_server()
  for client in pairs(state.event_clients) do
    if not client:is_closing() then
      client:close()
    end
  end

  if state.server and not state.server:is_closing() then
    state.server:close()
  end

  state.event_clients = {}
  state.server = nil
  state.port = nil
  state.browser_launch_ms = nil
end

local function is_wsl()
  return vim.env.WSL_INTEROP ~= nil
    or vim.env.WSL_DISTRO_NAME ~= nil
end

local function add_windows_chrome_candidate(candidates, root)
  if not root or root == '' then
    return
  end

  table.insert(
    candidates,
    vim.fs.joinpath(
      root,
      'Google',
      'Chrome',
      'Application',
      'chrome.exe'
    )
  )
end

local function find_browser()
  if config.browser.command and config.browser.command ~= '' then
    if vim.fn.executable(config.browser.command) == 1 then
      return config.browser.command
    end

    return nil,
      'Configured browser was not found: '
      .. config.browser.command
  end

  local candidates = {}

  if vim.fn.has('win32') == 1 then
    add_windows_chrome_candidate(
      candidates,
      vim.env.LOCALAPPDATA
    )

    add_windows_chrome_candidate(
      candidates,
      vim.env.ProgramFiles
    )

    add_windows_chrome_candidate(
      candidates,
      vim.env['ProgramFiles(x86)']
    )

    table.insert(candidates, 'chrome.exe')
  elseif is_wsl() then
    table.insert(
      candidates,
      '/mnt/c/Program Files/Google/Chrome/Application/chrome.exe'
    )

    table.insert(
      candidates,
      '/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe'
    )

    table.insert(candidates, 'chrome.exe')
  else
    table.insert(candidates, 'google-chrome')
    table.insert(candidates, 'google-chrome-stable')
    table.insert(candidates, 'chromium')
    table.insert(candidates, 'chromium-browser')
  end

  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  return nil,
    'Google Chrome was not found. '
    .. 'Configure browser.command in setup().'
end

local function browser_is_open()
  for client in pairs(state.event_clients) do
    if client:is_closing() then
      state.event_clients[client] = nil
    else
      return true
    end
  end

  -- ブラウザ起動直後はSSE接続がまだ確立していないため,
  -- 一定時間は起動済みとして扱う.
  if state.browser_launch_ms then
    local elapsed = now_ms() - state.browser_launch_ms

    if elapsed < config.browser.launch_grace_ms then
      return true
    end
  end

  return false
end

local function launch_browser(url)
  local browser, err = find_browser()
  if not browser then
    return nil, err
  end

  local command = {
    browser
  }

  for _, arg in ipairs(config.browser.args or {}) do
    table.insert(command, arg)
  end

  table.insert(command, url)

  local job_id = vim.fn.jobstart(
    command,
    {
      detach = true
    }
  )

  if job_id <= 0 then
    return nil,
      'Failed to launch browser: ' .. browser
  end

  state.browser_launch_ms = now_ms()

  return true
end

local function ensure_browser(url)
  if browser_is_open() then
    return true
  end

  return launch_browser(url)
end

local function get_plantuml_jar()
  local plantuml_jar = vim.env.PLANTUML_JAR

  if not plantuml_jar or plantuml_jar == '' then
    return nil, 'PLANTUML_JAR is not defined.'
  end

  if vim.fn.filereadable(plantuml_jar) ~= 1 then
    return nil, 'plantuml.jar was not found: ' .. plantuml_jar
  end

  return plantuml_jar
end

local function run_plantuml(bufnr, format, callback)
  local plantuml_jar, err = get_plantuml_jar()
  if not plantuml_jar then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable('java') ~= 1 then
    vim.notify(
      'java command was not found.',
      vim.log.levels.ERROR
    )
    return
  end

  local source
  source, err = get_buffer_source(bufnr)
  if not source then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  vim.system(
    {
      'java',
      '-Djava.awt.headless=true',
      '-jar',
      plantuml_jar,
      '-t' .. format,
      '-pipe'
    },
    {
      stdin = source
    },
    function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          local message = vim.trim(result.stderr or '')
          if message == '' then
            message =
              'PlantUML rendering failed (exit code: '
              .. result.code
              .. ').'
          end
          vim.notify(message, vim.log.levels.ERROR)
          return
        end

        if not result.stdout or result.stdout == '' then
          vim.notify(
            'PlantUML returned empty output.',
            vim.log.levels.ERROR
          )
          return
        end

        callback(result.stdout)
      end)
    end
  )
end

local function render_plantuml(bufnr, callback)
  run_plantuml(bufnr, 'svg', callback)
end

local function resolve_export_path(bufnr, requested_path)
  local output_path

  if requested_path and requested_path ~= '' then
    output_path = vim.fn.expand(requested_path)

    if vim.fn.fnamemodify(output_path, ':e') == '' then
      output_path = output_path .. '.png'
    end
  else
    local buffer_name = vim.api.nvim_buf_get_name(bufnr)

    if buffer_name == '' then
      output_path = vim.fs.joinpath(
        vim.fn.getcwd(),
        'plantuml.png'
      )
    else
      output_path =
        vim.fn.fnamemodify(buffer_name, ':r')
        .. '.png'
    end
  end

  output_path = vim.fn.fnamemodify(output_path, ':p')

  local format =
    vim.fn.fnamemodify(output_path, ':e'):lower()

  if format ~= 'png' and format ~= 'svg' then
    return nil, nil,
      'Unsupported image format: .' .. format
  end

  local parent =
    vim.fn.fnamemodify(output_path, ':h')

  if vim.fn.isdirectory(parent) ~= 1 then
    return nil, nil,
      'Output directory was not found: ' .. parent
  end

  return output_path, format
end

function M.preview()
  local bufnr = vim.api.nvim_get_current_buf()

  -- 非同期描画の世代番号管理.
  -- 古い結果が新しいプレビューを上書きすることを防止する.
  state.generation = state.generation + 1
  local generation = state.generation

  render_plantuml(bufnr, function(svg)
    if generation ~= state.generation then
      return
    end

    state.bufnr = bufnr -- 描画に成功したバッファだけ対象.
    state.svg = svg
    state.revision = state.revision + 1

    local port, server_err = start_server()
    if not port then
      vim.notify(server_err, vim.log.levels.ERROR)
      return
    end

    local url =
      'http://'
      .. state.host
      .. ':'
      .. port
      .. '/'

    -- 既存プレビューブラウザへ更新通知
    broadcast_update()

    local browser_ok, browser_err = ensure_browser(url)
    if not browser_ok then
      vim.notify(browser_err, vim.log.levels.ERROR)
      return
    end

    vim.notify(
      'PlantUML preview URL: ' .. url,
      vim.log.levels.INFO
    )
  end)
end

function M.export(path)
  local bufnr = vim.api.nvim_get_current_buf()

  local output_path, format, err =
    resolve_export_path(bufnr, path)

  if not output_path then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  run_plantuml(bufnr, format, function(data)
    local file, open_err =
      io.open(output_path, 'wb')

    if not file then
      vim.notify(
        'Failed to open output file: '
          .. tostring(open_err),
        vim.log.levels.ERROR
      )
      return
    end

    file:write(data)
    file:close()

    vim.notify(
      'PlantUML exported: ' .. output_path,
      vim.log.levels.INFO
    )
  end)
end

local function refresh_preview(bufnr)
  -- 保存したバッファがプレビュー対象でなければ何もしない.
  if bufnr ~= state.bufnr then
    return
  end

  -- プレビューブラウザが閉じられていれば何もしない.
  -- (:w を契機にブラウザを再起動させない)
  if not browser_is_open() then
    return
  end

  state.generation = state.generation + 1
  local generation = state.generation

  render_plantuml(bufnr, function(svg)
    if generation ~= state.generation then
      return
    end
    state.svg = svg
    state.revision = state.revision + 1
    broadcast_update()
  end)
end

function M.setup(opts)
  config = vim.tbl_deep_extend(
    'force',
    config,
    opts or {}
  )

  local group = vim.api.nvim_create_augroup(
    'PlantUMLPreview',
    { clear = true }
  )

  vim.api.nvim_create_autocmd(
    'BufWritePost',
    {
      group = group,
      callback = function(args)
        refresh_preview(args.buf)
      end
    }
  )

  vim.api.nvim_create_autocmd(
    'VimLeavePre',
    {
      group = group,
      callback = stop_server
    }
  )

  vim.api.nvim_create_user_command(
    'PreviewPlantUML',
    function()
      M.preview()
    end,
    {
      desc = 'Preview current PlantUML buffer',
      force = true,
    }
  )

  vim.api.nvim_create_user_command(
    'ExportPlantUML',
    function(args)
      M.export(args.args)
    end,
    {
      nargs = '?',
      complete = 'file',
      desc = 'Export current PlantUML buffer as an image',
      force = true,
    }
  )
end

return M
