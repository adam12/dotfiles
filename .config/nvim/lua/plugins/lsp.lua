return { -- LSP Support
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
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

    -- Herb is defined in lsp/herb.lua
    vim.lsp.enable({'herb'})

    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = { "lua_ls" }
    })

    local lspconfig = require('lspconfig')
    local configs = require('lspconfig.configs')

    -- lspconfig.ruby_lsp.setup({
    --   cmd = { 'ruby-lsp', '--debug', },
    --   init_options = {
    --     formatter = 'standard',
    --     linters = { 'standard' },
    --     experimentalFeaturesEnabled = true,
    --   },
    -- })

    -- lspconfig.steep.setup({
    --   cmd = { 'steep', 'langserver', '--log-level=warn' }, -- not sure warn even does anything
    -- })

    -- lspconfig.solargraph.setup({})
    -- lspconfig.standardrb.setup({})

    local unpoly_lsp_exe = os.getenv('HOME') .. '/go/bin/unpoly-lsp'
    if vim.fn.executable(unpoly_lsp_exe) == 1 then
      if not configs.unpoly_lsp then
        configs.unpoly_lsp = {
          default_config = {
            cmd = {unpoly_lsp_exe},
            filetypes = {'eruby', 'html'},
            root_dir = function(fname)
              return lspconfig.util.find_git_ancestor(fname)
            end,
            settings = {},
          }
        }
      end

      lspconfig.unpoly_lsp.setup({})
    end

    require('mason-lspconfig').setup_handlers {
      function(server_name) -- default handler
        require('lspconfig')[server_name].setup({})
      end,

      ['ts_ls'] = function()
        lspconfig.ts_ls.setup({
          init_options = {
            -- prevent extra period being inserted
            completionDisablefilterText = false,
          },
        })
      end,

      ['lua_ls'] = function()
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = {
                  "vim",
                  "MiniPick",
                  "MiniExtra"
                }
              }
            }
          }
        })
      end,
    }
  end
}
