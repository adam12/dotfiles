return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ['<C-p>'] = false,
    },
    columns = {}, -- Remove 'icon'
  },
  config = function(_, opts)
    require('oil').setup(opts)
  end,
  enabled = false
}
