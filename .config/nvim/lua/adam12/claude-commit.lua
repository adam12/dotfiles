local M = {}

M.config = {
  model = 'haiku',
  prompt = [[Generate a concise git commit message for the staged changes. Match the style and format of the recent commits shown. Output ONLY the raw commit message with no markdown, no code blocks, no backticks, no explanations.]],
  insert_at_cursor = true,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
  M.setup_autocmd()
end

function M.generate_commit_message()
  vim.fn.system('git rev-parse --git-dir 2>/dev/null')
  if vim.v.shell_error ~= 0 then
    vim.notify('Not in a git repository.', vim.log.levels.ERROR)
    return
  end

  vim.fn.system('git diff --staged --quiet')
  if vim.v.shell_error == 0 then
    vim.notify('No staged changes found', vim.log.levels.WARN)
  end

  vim.notify('Generating commit message with Claude...', vim.log.levels.INFO)

  local cmd = string.format(
    '{ echo "Recent commits for style reference:"; git log --oneline -10 2>/dev/null; echo ""; echo "Staged changes:"; git diff --staged; } | claude -p %s --model %s --output-format text',
    vim.fn.shellescape(M.config.prompt),
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
      vim.keymap.set('n', '<leader>cc', M.generate_commit_message, {
        buffer = ev.buf,
        desc = 'Generate commit message with Claude',
      })

      vim.keymap.set('n', '<leader>cg', M.generate_commit_message, {
        buffer = ev.buf,
        desc = 'Generate commit message with Claude',
      })
    end,
    group = vim.api.nvim_create_augroup('ClaudeCommit', { clear = true }),
  })
end

vim.api.nvim_create_user_command('ClaudeCommit', function()
  M.generate_commit_message()
end, { desc = 'Generate git commit message using Claude' })

return M
