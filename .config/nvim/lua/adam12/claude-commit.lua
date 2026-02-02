local M = {}

M.config = {
  model = 'haiku',
  prompt = [[Generate a concise git commit message for the staged changes. Match the style and format of the recent commits shown. Output ONLY the raw commit message with no markdown, no code blocks, no backticks, no explanations.]],
  verbose_prompt = [[Generate a detailed git commit message for the staged changes. Format MUST be: subject line (50 chars or less), then an empty line, then body paragraphs explaining what changed and why. The blank line between subject and body is required. Match the style of the recent commits shown. Output ONLY the raw commit message with no markdown, no code blocks, no backticks, no explanations.]],
  insert_at_cursor = true,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
  M.setup_autocmd()
end

function M.generate_commit_message(opts)
  opts = opts or {}
  local verbose = opts.verbose or false

  vim.fn.system('git rev-parse --git-dir 2>/dev/null')
  if vim.v.shell_error ~= 0 then
    vim.notify('Not in a git repository.', vim.log.levels.ERROR)
    return
  end

  vim.fn.system('git diff --staged --quiet')
  if vim.v.shell_error == 0 then
    vim.notify('No staged changes found', vim.log.levels.WARN)
  end

  local prompt = verbose and M.config.verbose_prompt or M.config.prompt
  vim.notify('Generating commit message with Claude...', vim.log.levels.INFO)

  local cmd = string.format(
    '{ echo "Recent commits for style reference:"; git log --oneline -10 2>/dev/null; echo ""; echo "Staged changes:"; git diff --staged; } | claude -p %s --model %s --output-format text',
    vim.fn.shellescape(prompt),
    vim.fn.shellescape(M.config.model)
  )

  local output_lines = {}

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= '' then
            table.insert(output_lines, line)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data and data[1] ~= '' then
        local stderr = table.concat(data, "\n")
        if stderr ~=  '' then
          vim.schedule(function()
            vim.notify('Claude error: ' .. stderr, vim.log.levels.ERROR)
          end)
        end
      end
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if exit_code ~= 0 then
          vim.notify('Claude command failed with exit code: ' .. exit_code, vim.log.levels.ERROR)
          return
        end

        if #output_lines == 0 then
          vim.notify('No output received from Claude', vim.log.levels.WARN)
          return
        end

        if M.config.insert_at_cursor then
          local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, output_lines)
        else
          vim.api.nvim_buf_set_lines(0, 0, 0, false, output_lines)
        end

        vim.notify('Commit message generated!', vim.log.levels.INFO)
      end)
    end
  })
end

function M.setup_autocmd()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    callback = function(ev)
      vim.keymap.set('n', '<leader>cc', function() M.generate_commit_message() end, {
        buffer = ev.buf,
        desc = 'Generate commit message with Claude',
      })

      vim.keymap.set('n', '<leader>cv', function() M.generate_commit_message({ verbose = true }) end, {
        buffer = ev.buf,
        desc = 'Generate verbose commit message with Claude',
      })
    end,
    group = vim.api.nvim_create_augroup('ClaudeCommit', { clear = true }),
  })
end

vim.api.nvim_create_user_command('ClaudeCommit', function(cmd_opts)
  local verbose = cmd_opts.args == 'verbose'
  M.generate_commit_message({ verbose = verbose })
end, {
  desc = 'Generate git commit message using Claude',
  nargs = '?',
  complete = function() return { 'verbose' } end,
})

return M
