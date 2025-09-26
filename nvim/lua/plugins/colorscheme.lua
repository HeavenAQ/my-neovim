return {

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local transparent = true -- set to true if you would like to enable transparency

      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

      require("tokyonight").setup({
        style = "night",
        transparent = transparent,
        styles = {
          sidebars = transparent and "transparent" or "dark",
          floats = transparent and "transparent" or "dark",
        },
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = transparent and colors.none or bg_dark
          colors.bg_float = transparent and colors.none or bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = transparent and colors.none or bg_dark
          colors.bg_statusline = transparent and colors.none or bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
      })
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").setup({
        -- This callback can be used to override the colors used in the base palette.
        on_palette = function(palette) end,
        -- This callback can be used to override the colors used in the extended palette.
        after_palette = function(palette) end,
        -- This callback can be used to override highlights before they are applied.
        on_highlight = function(highlights, palette) end,
        -- Enable bold keywords.
        bold_keywords = false,
        -- Enable italic comments.
        italic_comments = true,
        -- Enable editor background transparency.
        transparent = {
          -- Enable transparent background.
          bg = true,
          -- Enable transparent background for floating windows.
          float = true,
        },
        -- Enable brighter float border.
        bright_border = false,
        -- Reduce the overall amount of blue in the theme (diverges from base Nord).
        reduced_blue = true,
        -- Swap the dark background with the normal one.
        swap_backgrounds = false,
        -- Cursorline options.  Also includes visual/selection.
        cursorline = {
          -- Bold font in cursorline.
          bold = false,
          -- Bold cursorline number.
          bold_number = true,
          -- Available styles: 'dark', 'light'.
          theme = "dark",
          -- Blending the cursorline bg with the buffer bg.
          blend = 0.85,
        },
        noice = {
          -- Available styles: `classic`, `flat`.
          style = "classic",
        },
        telescope = {
          -- Available styles: `classic`, `flat`.
          style = "flat",
        },
        leap = {
          -- Dims the backdrop when using leap.
          dim_backdrop = false,
        },
        ts_context = {
          -- Enables dark background for treesitter-context window
          dark_background = true,
        },
      })

      vim.cmd("colorscheme nordic")
      vim.api.nvim_set_hl(0, "@boolean", { fg = "#f78c6c" })
      vim.api.nvim_set_hl(0, "@number", { fg = "#f78c6c" })
      vim.api.nvim_set_hl(0, "@number.float", { fg = "#f78c6c" })
      vim.api.nvim_set_hl(0, "@markup.strong", { fg = "#f78c6c" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#404040" })
      vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#404040" })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#404040" })
    end,
  },
  -- Lazy
  {
    "vague2k/vague.nvim",
    config = function()
      -- NOTE: you do not need to call setup if you don't want to.
    end,
  },
  {
    "rmehri01/onenord.nvim",
    config = function()
      -- require("onenord").setup({
      --   theme = nil, -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
      --   borders = true, -- Split window borders
      --   fade_nc = false, -- Fade non-current windows, making them more distinguishable
      --   -- Style that is applied to various groups: see `highlight-args` for options
      --   styles = {
      --     comments = "italic",
      --     strings = "NONE",
      --     keywords = "NONE",
      --     functions = "NONE",
      --     variables = "NONE",
      --     diagnostics = "underline",
      --   },
      --   disable = {
      --     background = true, -- Disable setting the background color
      --     float_background = true, -- Disable setting the background color for floating windows
      --     cursorline = false, -- Disable the cursorline
      --     eob_lines = true, -- Hide the end-of-buffer lines
      --   },
      --   -- Inverse highlight for different groups
      --   inverse = {
      --     match_paren = false,
      --   },
      --   custom_highlights = {
      --     ["@keyword"] = { fg = "#f78c6c" },
      --     -- a red color for the operator
      --     ["@operator"] = { fg = "#f76c6c" },
      --   }, -- Overwrite default highlight groups
      --   custom_colors = {}, -- Overwrite default colors
      -- })
    end,
  },
}
