local group = vim.api.nvim_create_augroup('autocommands.lua', { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = {"Steepfile", "*.jbuilder"},
  command = "setl ft=ruby",
  group = group
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rbs",
  command = "setl ts=2 sts=2 sw=2 et",
  group = group
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.mote" },
  command = "setl ft=mote",
  group = group
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = ".env*",
  command = "setl ft=sh",
  group = group
})

-- Start commits in insert mode
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "gitcommit",
--   command = "1 | startinsert",
--   group = group
-- })

-- Set up inlay hints if LSP supports them
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, {bufnr = args.buf})
    end
  end,
  group = group
})

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = { "*.ex", "*.exs" },
--   command = "!mix format %",
--   group = group
-- })

-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--   pattern = { "Rexfile" },
--   command = "setl ft=perl",
--   group = group
-- })
