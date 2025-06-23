-- Leader must be set first for lazy.nvim
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

-- vim.lsp.set_log_level('trace')
-- require('vim.lsp.log').set_format_func(vim.inspect)

require('adam12.keymap')
require('adam12.autocommands')

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse in normal/visual mode
vim.opt.mouse = 'nv'

-- Disable line wrapping
vim.opt.wrap = false

-- Set completeopt to have a better completion experience
-- vim.opt.completeopt = 'menuone,noselect'

-- Set popup border to rounded
vim.opt.winborder = 'rounded'

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Set colorscheme
-- vim.cmd [[colorscheme mellow]]
vim.cmd [[colorscheme catppuccin-mocha]]

-- Don't highlight previous search pattern
-- vim.opt.hlsearch = false

-- Show matches while typing search options
vim.opt.incsearch = true

-- Disable swapfile
vim.opt.swapfile = false

-- Always enable color column
vim.opt.colorcolumn = "80"

-- Allow local exrc
vim.opt.exrc = true

-- Set 'indent' foling method
vim.opt.foldmethod = 'indent'

-- Disable all folds except top ones
-- vim.opt.foldlevel = 1

-- Keep all folds open
vim.opt.foldlevelstart = 99

-- Create folds only for some number of nested levels
vim.opt.foldnestmax = 10

-- Set background of wezterm to match current background colour
vim.api.nvim_create_autocmd({ "ColorScheme", "UIEnter", "VimResume" }, {
  group = vim.api.nvim_create_augroup("set_terminal_bg", {}),
  callback = function()
    local bg = vim.api.nvim_get_hl_by_name("Normal", true)["background"]
    if not bg then
      return
    end

    local fmt = string.format

    bg = fmt('printf "\\033]11;#%06x\\007"', bg)

    os.execute(bg)
    return true
  end,
})

-- TODO: Replace with MiniMisc.setup_termbg_sync ?
vim.api.nvim_create_autocmd({ "VimLeavePre", "UILeave" }, {
  group = vim.api.nvim_create_augroup("reset_set_terminal_bg", {}),
  callback = function()
    local bg = 'printf "\\033]104\\007"'

    os.execute(bg)
    return true
  end,
})

-- From mini.completion on fixing <CR> in insert mode
local keys = {
  ['cr']        = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
  ['ctrl-y']    = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
  ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
}

_G.cr_action = function()
  if vim.fn.pumvisible() ~= 0 then
    -- If popup is visible, confirm selected item or add new line otherwise
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
  else
    -- If popup is not visible, use plain `<CR>`. You might want to customize
    -- according to other plugins. For example, to use 'mini.pairs', replace
    -- next line with `return require('mini.pairs').cr()`
    return keys['cr']
  end
end

vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })

-- Prevent annoying Elixir LS message about formatter not being loaded
local original_handler = vim.lsp.handlers['window/showMessage']

-- Override with our custom handler
vim.lsp.handlers['window/showMessage'] = function(err, result, ctx, config)
  -- Skip messages about the formatter plugin not being loaded
  if result.message:find('Formatter plugin Phoenix.LiveView.HTMLFormatter is not loaded and will be skipped.') then
    return
  end

  -- Call the original handler for all other messages
  return original_handler(err, result, ctx, config)
end
