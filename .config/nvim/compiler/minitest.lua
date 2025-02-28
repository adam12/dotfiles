if vim.g.current_compiler then
  return
end

vim.g.current_compiler = "minitest"

local cpo_save = vim.o.cpo
vim.o.cpo = vim.o.cpo:gsub("C", "")

if vim.fn.filereadable("Gemfile") == 1 then
  vim.cmd([[CompilerSet makeprg=bundle\ exec\ ruby\ -Ilib:test\ -rminitest/autorun\ $*\ %]])
else
  vim.cmd([[CompilerSet makeprg=ruby\ -Ilib:test\ -rminitest/autorun\ $*\ %]])
end

vim.cmd([[CompilerSet errorformat=
      \%W\ %\\+%\\d%\\+)\ Failure:,
      \%C%m\ [%f:%l]:,
      \%E\ %\\+%\\d%\\+)\ Error:,
      \%C%m:,
      \%+Z%.%#,
      \\ \ \ \ %f:%l:%m,
      \%-G%.%#
]])

vim.o.cpo = cpo_save
