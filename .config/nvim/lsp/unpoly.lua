local unpoly_lsp_exe = os.getenv('HOME') .. '/go/bin/unpoly-lsp'

return {
  cmd = { unpoly_lsp_exe },
  filetypes = { 'eruby', 'html' },
  root_markers = { '.git' },
}
