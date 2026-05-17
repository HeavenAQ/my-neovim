local function patch_markdown_preview_alerts(plugin)
  local index_path = plugin.dir .. "/app/pages/index.jsx"
  local css_path = plugin.dir .. "/app/_static/markdown.css"

  local index = table.concat(vim.fn.readfile(index_path), "\n")
  local alert_plugin = [[
const githubAlertPlugin = md => {
  const labels = {
    NOTE: 'Note',
    TIP: 'Tip',
    IMPORTANT: 'Important',
    WARNING: 'Warning',
    CAUTION: 'Caution'
  }

  md.core.ruler.after('block', 'github_alerts', state => {
    const tokens = state.tokens

    for (let i = 0; i < tokens.length - 3; i += 1) {
      const quote = tokens[i]
      const paragraph = tokens[i + 1]
      const inline = tokens[i + 2]
      const paragraphClose = tokens[i + 3]

      if (
        quote.type !== 'blockquote_open' ||
        paragraph.type !== 'paragraph_open' ||
        inline.type !== 'inline' ||
        paragraphClose.type !== 'paragraph_close'
      ) {
        continue
      }

      const match = inline.content.match(/^\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\](?:[ \t]*(?:\n|$))?/i)
      if (!match) {
        continue
      }

      const kind = match[1].toUpperCase()
      const body = inline.content.slice(match[0].length)
      quote.attrJoin('class', `markdown-alert markdown-alert-${kind.toLowerCase()}`)

      const titleOpen = new state.Token('paragraph_open', 'p', 1)
      const titleInline = new state.Token('inline', '', 0)
      const titleText = new state.Token('text', '', 0)
      const titleClose = new state.Token('paragraph_close', 'p', -1)

      titleOpen.attrJoin('class', 'markdown-alert-title')
      titleInline.content = labels[kind]
      titleText.content = labels[kind]
      titleInline.children = [titleText]

      if (body.trim() === '') {
        tokens.splice(i + 1, 3, titleOpen, titleInline, titleClose)
        continue
      }

      const bodyChildren = []
      state.md.inline.parse(body, state.md, state.env, bodyChildren)
      inline.content = body
      inline.children = bodyChildren
      tokens.splice(i + 1, 0, titleOpen, titleInline, titleClose)
      i += 3
    }
  })
}

]]
  if index:find("const githubAlertPlugin = md => {", 1, true) then
    index = index:gsub(
      "const githubAlertPlugin = md => {.-\n}\n\nconst anchorSymbol =",
      alert_plugin .. "const anchorSymbol =",
      1
    )
  else
    index = index:gsub("const anchorSymbol =", alert_plugin .. "const anchorSymbol =", 1)
    index = index:gsub("%.use%(emoji%)", ".use(githubAlertPlugin)\n        .use(emoji)", 1)
  end
  vim.fn.writefile(vim.split(index, "\n", { plain = true }), index_path)

  local css = table.concat(vim.fn.readfile(css_path), "\n")
  if not css:find("markdown%-alert", 1, false) then
    local alert_css = [[

.markdown-body .markdown-alert {
  padding: 0.5rem 1rem;
  margin-bottom: 16px;
  color: inherit;
  border-left: 0.25em solid var(--color-border-default, #d0d7de);
}

.markdown-body .markdown-alert > :last-child {
  margin-bottom: 0;
}

.markdown-body .markdown-alert-title {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
  font-weight: 600;
}

.markdown-body .markdown-alert-note {
  border-left-color: #0969da;
}

.markdown-body .markdown-alert-tip {
  border-left-color: #1a7f37;
}

.markdown-body .markdown-alert-important {
  border-left-color: #8250df;
}

.markdown-body .markdown-alert-warning {
  border-left-color: #9a6700;
}

.markdown-body .markdown-alert-caution {
  border-left-color: #cf222e;
}
]]
    vim.fn.writefile(vim.split(css .. alert_css, "\n", { plain = true }), css_path)
  end

  local command = "cd "
    .. vim.fn.shellescape(plugin.dir)
    .. " && yarn install && NODE_OPTIONS=--openssl-legacy-provider yarn build-app"
  local output = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then
    error(output)
  end
end

return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = patch_markdown_preview_alerts,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "light"
    end,
    ft = { "markdown" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    keys = {
      { "<leader>um", "<cmd>Markview Toggle<cr>", desc = "Toggle Markview" },
    },
  },
}
