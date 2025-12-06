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

    -- Configure LSP servers using vim.lsp.config()
    -- Configs in lsp/*.lua are auto-discovered

    vim.lsp.config('ts_ls', {
      init_options = {
        -- prevent extra period being inserted
        completionDisablefilterText = false,
      },
    })

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              "vim",
              "MiniPick",
              "MiniExtra",
              'MiniFiles'
            }
          }
        }
      }
    })

    -- vim.lsp.config('ruby_lsp', {
    --   cmd = { 'ruby-lsp', '--debug', },
    --   init_options = {
    --     formatter = 'standard',
    --     linters = { 'standard' },
    --     experimentalFeaturesEnabled = true,
    --   },
    -- })

    -- vim.lsp.config('steep', {
    --   cmd = { 'steep', 'langserver', '--log-level=warn' },
    -- })

    -- Enable all LSP servers
    -- Custom configs: herb, expert, unpoly are in lsp/*.lua
    vim.lsp.enable('herb')
    vim.lsp.enable('unpoly')
    vim.lsp.enable('gleam')
    -- vim.lsp.enable('expert')

    -- Enable Mason-installed servers
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('ts_ls')
  end
}
