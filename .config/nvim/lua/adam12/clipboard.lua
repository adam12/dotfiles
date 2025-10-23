local M = {}

-- Function to copy file:lineno to clipboard
M.copy_file_line = function ()
  local file = vim.fn.expand('%') -- Get relative file path
  local line = vim.fn.line('.')   -- Get current line number
  local text = file .. ':' .. line

  -- Copy to system clipboard
  vim.fn.setreg('+', text)

  print('Copied: ' .. text)
end

return M
