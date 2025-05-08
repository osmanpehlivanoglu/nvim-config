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
      },
    }

    vim.keymap.set('n', '<leader>x', ':NvimTreeToggle<CR>', {
      noremap = true,
      silent = true,
      desc = 'NvimTree toggle',
    })
  end,
}
