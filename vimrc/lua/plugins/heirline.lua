local M = {}

function M.setup()
  local mode = {
    init = function(self)
    end,

    static = {
      mode_names = { -- change the strings if you like it vvvvverbose!
        n = "NORMAL",
        no = "O-PENDING",
        nov = "N?",
        noV = "N?",
        ["no\22"] = "N?",
        niI = "Ni",
        niR = "Nr",
        niV = "Nv",
        nt = "Nt",
        v = "V",
        vs = "Vs",
        V = "V_",
        Vs = "Vs",
        ["\22"] = "^V",
        ["\22s"] = "^V",
        s = "S",
        S = "S_",
        ["\19"] = "^S",
        i = "I",
        ic = "Ic",
        ix = "Ix",
        R = "R",
        Rc = "Rc",
        Rx = "Rx",
        Rv = "Rv",
        Rvc = "Rv",
        Rvx = "Rv",
        c = "C",
        cv = "Ex",
        r = "...",
        rm = "M",
        ["r?"] = "?",
        ["!"] = "!",
        t = "T",
      },
      mode_colors = {
        n = "red" ,
        i = "green",
        v = "cyan",
        V =  "cyan",
        ["\22"] =  "cyan",
        c =  "orange",
        s =  "purple",
        S =  "purple",
        ["\19"] =  "purple",
        R =  "orange",
        r =  "orange",
        ["!"] =  "red",
        t =  "red",
      },
    },
  }

  require('heirline').setup({})
end

return M
