local status, hex = pcall(require, 'hex')
if (not status) then
  return
end

hex.setup()
