return {
  {
    "saghen/blink.cmp",
    -- Customize blink.cmp menu/doc borders (schema without `windows`)
    opts = function(_, opts)
      opts = opts or {}
      opts.completion = opts.completion or {}

      local rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

      -- Menu border shape
      opts.completion.menu = vim.tbl_deep_extend("force", opts.completion.menu or {}, {
        border = rounded,
      })

      -- Documentation window border shape
      opts.completion.documentation = vim.tbl_deep_extend("force", opts.completion.documentation or {}, {
        window = { border = rounded },
      })

      return opts
    end,
  },
}
