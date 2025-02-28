return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ['<C-p>'] = false,
    },
  },
  config = function(_, opts)
    require('oil').setup(opts)
  end,
}
