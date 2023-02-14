local status, copilot_cmp = pcall(require, "copilot-cmp")
if (not status) then return end

copilot_cmp.setup {
  method = "getCompletionsCycling",
  formatters = {
    label = require("copilot_cmp.format").format_label_text,
    insert_text = require("copilot_cmp.format").format_insert_text,
    preview = require("copilot_cmp.format").deindent,
    insert_text = require("copilot_cmp.format").remove_existing
  },
}
