return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
        -- Hata önleme: geçersiz buffer/window kontrolü
        disable = function(lang, buf)
          -- Buffer geçerli değilse highlight'ı devre dışı bırak
          if not vim.api.nvim_buf_is_valid(buf) then
            return true
          end

          -- Büyük dosyalar için highlight'ı devre dışı bırak
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end

          return false
        end,
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
      -- Hata önleme için ek ayarlar
      sync_install = false,
      ignore_install = {},
      modules = {},
    },
    config = function(_, opts)
      -- Standart setup
      require('nvim-treesitter.configs').setup(opts)

      -- Hata önleme autocommand'ları
      vim.api.nvim_create_autocmd('BufWinLeave', {
        pattern = '*',
        callback = function(args)
          local buf = args.buf
          -- Buffer kapanırken treesitter'ı güvenli şekilde durdur
          if vim.api.nvim_buf_is_valid(buf) then
            pcall(function()
              vim.treesitter.stop(buf)
            end)
          end
        end,
        desc = 'Stop treesitter on buffer close',
      })

      -- Window kapanma hatalarını önle
      vim.api.nvim_create_autocmd('WinClosed', {
        pattern = '*',
        callback = function()
          -- Async olarak redraw yap
          vim.schedule(function()
            pcall(function()
              vim.cmd 'redraw!'
            end)
          end)
        end,
        desc = 'Handle window close for treesitter',
      })

      -- Vim çıkışında tüm treesitter işlemlerini durdur
      vim.api.nvim_create_autocmd('VimLeave', {
        callback = function()
          pcall(function()
            vim.treesitter.stop()
          end)
        end,
        desc = 'Stop all treesitter on exit',
      })
    end,
  },
}
