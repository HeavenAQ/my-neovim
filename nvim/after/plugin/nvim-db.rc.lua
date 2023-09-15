local status, dbee = pcall(require, "nvim-dbee")
if (not status) then return end

dbee.setup()
