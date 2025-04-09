vim.keymap.set('n', '<leader>p', function() MiniPick.builtin.files({ tool = 'git' }) end, {desc = 'Find files'})
vim.keymap.set('n', '<c-p>', function() MiniPick.builtin.files({ tool = 'git' }) end, {desc = 'Find files'})
vim.keymap.set('n', '<leader>fb', function() MiniPick.builtin.buffers() end, {desc = 'Find buffers'})
vim.keymap.set('n', '<leader>ff', function() MiniPick.builtin.files({ tool = 'git' }) end, {desc = 'Find files'})
vim.keymap.set('n', '<leader>fr', function() MiniExtra.pickers.registers() end, {desc = 'Find register'})
vim.keymap.set('n', '<leader>fs', function() MiniExtra.pickers.lsp({scope = 'workspace_symbol'}) end, {desc = 'Find symbol'})

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
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(args)
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)

    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostics', buffer = args.buf })

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition', buffer = args.buf })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration', buffer = args.buf })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation', buffer = args.buf })
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { desc = 'Go to type definition', buffer = args.buf })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Show references', buffer = args.buf })
  end
 })
