return { -- LSP Support
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim' },
  },
  init = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- if client.supports_method('textDocument/formatting') then
        --   -- Format the current buffer on save
        --   vim.api.nvim_create_autocmd('BufWritePre', {
        --     buffer = args.buf,
        --     callback = function()
        --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        --     end,
        --   })
        -- end
      end,
    })

    require('mason').setup({})

    -- Configs live in lsp/*.lua and are auto-discovered
    vim.lsp.enable('herb')
    vim.lsp.enable('unpoly')
    vim.lsp.enable('gleam')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('ts_ls')
    -- vim.lsp.enable('expert')
    -- vim.lsp.enable('ruby_lsp')
    -- vim.lsp.enable('steep')
  end
}
