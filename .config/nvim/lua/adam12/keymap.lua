local clipboard = require('adam12/clipboard')

vim.keymap.set('n', '<leader>p', function() MiniPick.builtin.files({ tool = 'git' }) end, {desc = 'Find files'})
vim.keymap.set('n', '<c-p>', function() MiniPick.builtin.files({ tool = 'git' }) end, {desc = 'Find files'})
vim.keymap.set('n', '<leader>fb', function() MiniPick.builtin.buffers() end, {desc = 'Find buffers'})
vim.keymap.set('n', '<leader>ff', function() MiniPick.builtin.files() end, {desc = 'Find files'})
vim.keymap.set('n', '<leader>fr', function() MiniExtra.pickers.registers() end, {desc = 'Find register'})
vim.keymap.set('n', '<leader>fs', function() MiniExtra.pickers.lsp({scope = 'workspace_symbol'}) end, {desc = 'Find symbol'})

-- Make <space> leader function more sane
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', {})

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Allow blocks of lines to be moved by J and K in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Yank to clipboard
-- vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank to OS clipboard' })
-- vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank to OS clipboard' })

-- vim.keymap.set('n', '<leader>j', function() MiniJump2d.start() end, {desc = 'Jump'})

-- local mark = require('harpoon.mark')
-- local ui = require('harpoon.ui')
-- vim.keymap.set('n', '<leader>a', mark.add_file, { desc = 'Add Harpoon mark' })
-- vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = 'Harpoon menu' })
-- vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
-- vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
-- vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
-- vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)
-- vim.keymap.set('n', '<leader>he', ui.toggle_quick_menu, { desc = 'Harpoon menu' })
-- vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = 'Add Harpoon mark' })

-- Make Oil work like Vinegar does
-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set('n', '-', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, { desc = 'Open parent directory' })

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(args)
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)

    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostics', buffer = args.buf })

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition', buffer = args.buf })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration', buffer = args.buf })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation', buffer = args.buf })
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { desc = 'Go to type definition', buffer = args.buf })

    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = 'Run Codelens' })
  end
 })

vim.keymap.set('n', '<leader>yfl', clipboard.copy_file_line, {
  desc = 'Copy file:lineno to clipboard',
  noremap = true,
  silent = true
})
