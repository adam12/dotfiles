return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    { 'RRethy/nvim-treesitter-endwise' },
    { 'jlcrochet/vim-ruby' }, -- better, faster highlighting/indentation
  },
  enabled = true,
  build = ':TSUpdate',
  config = function()
    require 'nvim-treesitter.configs'.setup {
      ensure_installed = {
        'css',
        'embedded_template',
        'javascript',
        'lua',
        'ruby',
        'typescript',
        'vim',
      },
      auto_install = false,
      highlight = {
        enable = true,
        -- needed for indentation in vim-ruby to work
        additional_vim_regex_highlighting = { 'ruby', 'elixir' },
        disable = { 'perl' },
      },
      indent = {
        enable = true,
        disable = { 'ruby', 'perl', 'elixir' },
      },
      endwise = {
        enable = true,
        disable = { 'ruby', 'perl' },
      },
    }
  end,
}
