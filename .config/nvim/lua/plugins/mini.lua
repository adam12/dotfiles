return {
  'echasnovski/mini.nvim',
  -- version = false,
  -- commit = 'aeb4e0cfa1cb66d54132565ef032e00f0c150930',
  config = function()
    -- Quick-moving [ ] bracket commands
    require('mini.bracketed').setup()

    require('mini.icons').setup()

    -- Nicer status line
    require('mini.statusline').setup()

    -- Quickpick menu
    require('mini.pick').setup()

    -- Comment out code
    require('mini.comment').setup()

    require('mini.files').setup()

    -- Popup clue/next key
    local miniclue = require('mini.clue')
    miniclue.setup({
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },

        -- mini.bracketed
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
        { mode = 'x', keys = '[' },
        { mode = 'x', keys = ']' },
      },

      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),

        -- Custom clues
        { mode = 'i', keys = '<C-x><C-f>', desc = 'File names' },
        { mode = 'i', keys = '<C-x><C-l>', desc = 'Whole lines' },
        { mode = 'i', keys = '<C-x><C-o>', desc = 'Omni completion' },
        { mode = 'i', keys = '<C-x><C-s>', desc = 'Spelling suggestions' },
        { mode = 'i', keys = '<C-x><C-u>', desc = "With 'completefunc'" },
      },
    })

    -- Disabled: Set's weird defaults and affects default key bindings
    -- require('mini.basics').setup({
    --   options = {
    --     extra_ui = true,
    --     win_borders = 'double',
    --   },
    --   mappings = {
    --     windows = true
    --   },
    --   autocommands = {
    --     basic = true,
    --   }
    -- })

    -- Disabled: Not sure I like interface to this
    -- require('mini.files').setup({
    --   windows = {
    --     preview = true
    --   }
    -- })

    -- Disabled: Can't seem to make this work automatically
    -- require('mini.sessions').setup()

    -- Shows up all the time, even without a tab open
    -- require('mini.tabline').setup()

    -- Create closing pairs when opening a pair
    -- require('mini.pairs').setup()

    require('mini.diff').setup({
      view = {
        style = 'sign',
        -- signs = { add = '+', change = '~', delete = '-' },
      }
    })

    -- Work with surrounding characters
    require('mini.surround').setup()

    -- Move lines/blocks of lines with M-hjkl
    -- require('mini.move').setup()

    require('mini.completion').setup()

    local hipatterns = require('mini.hipatterns')
    hipatterns.setup({
      highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color(),
      }
    })

    require('mini.extra').setup()

    require('mini.visits').setup()

    local notify = require('mini.notify')
    notify.setup()

    vim.notify = notify.make_notify()

    require('mini.jump').setup()
    require('mini.jump2d').setup()
  end
}
