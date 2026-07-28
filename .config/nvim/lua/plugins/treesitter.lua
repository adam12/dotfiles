return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  dependencies = {
    { 'RRethy/nvim-treesitter-endwise' },
    { 'jlcrochet/vim-ruby' }, -- better, faster highlighting/indentation
  },
  enabled = true,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {}
    -- main branch no longer starts highlighting itself; opt in per filetype
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'elixir' },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
