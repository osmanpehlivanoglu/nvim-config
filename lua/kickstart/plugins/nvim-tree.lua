return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      disable_netrw = true,
      hijack_netrw = true,
      view = {
        width = 50,
        side = 'left',
      },
      update_focused_file = {
        enable = true,
      },
      filters = {
        dotfiles = false,
        git_clean = false,
        custom = {},
      },
      git = {
        enable = true,
        ignore = false, -- .gitignore içinde olan dosyalar da görünsün
      },
    }

    vim.keymap.set('n', '<leader>x', ':NvimTreeToggle<CR>', {
      noremap = true,
      silent = true,
      desc = 'NvimTree toggle',
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'NvimTree',
      callback = function()
        vim.keymap.set('n', 'H', function()
          require('nvim-tree.api').tree.toggle_hidden_filter()
        end, { buffer = true, desc = 'Toggle hidden files' })
      end,
    })
  end,
}
