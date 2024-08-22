return {
  -- Disable flash.nvim
  { "folke/flash.nvim", enabled = false },

  -- logo
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
   __ _________ _   _______  __       ___  _____   __
  / // / __/ _ | | / / __/ |/ /      / _ \/ __/ | / /
 / _  / _// __ | |/ / _//    /    _ / // / _/ | |/ / 
/_//_/___/_/ |_|___/___/_/|_(_)__(_)____/___/ |___/  
      ]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}
