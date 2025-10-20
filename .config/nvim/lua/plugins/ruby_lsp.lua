return {
  "ruby-lsp",
  -- enabled = false,
  dir = "~/code/github.com/adam12/ruby-lsp.nvim",
  opts = {
    -- auto_install = true,
    use_launcher = false,
    autodetect_tools = true,
    lspconfig = {
      init_options = {
        addonSettings = {
          ["Ruby LSP Rails"] = {
            enablePendingMigrationsPrompt = false,
          },
        },
      },
    },
  },
}
