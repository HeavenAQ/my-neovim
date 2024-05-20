return {
  -- Disable flash.nvim
  { "folke/flash.nvim", enabled = false },

  -- logo
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
██╗  ██╗███████╗ █████╗ ██╗   ██╗███████╗███╗   ██╗
██║  ██║██╔════╝██╔══██╗██║   ██║██╔════╝████╗  ██║
███████║█████╗  ███████║██║   ██║█████╗  ██╔██╗ ██║
██╔══██║██╔══╝  ██╔══██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║
██║  ██║███████╗██║  ██║ ╚████╔╝ ███████╗██║ ╚████║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝
      ]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}
