return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        no_italic = true,
        integrations = {
          cmp = true,
          treesitter = true,
          telescope = true,
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'buffers',
          always_show_bufferline = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          color_icons = true,
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'File Explorer',
              text_align = 'left',
              separator = true,
            },
          },
        },
      }
    end,
  },
}
