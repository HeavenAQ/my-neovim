return {
  "windwp/nvim-ts-autotag",
  ft = { "html", "xml", "javascriptreact", "typescriptreact", "svelte", "vue" },
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}

