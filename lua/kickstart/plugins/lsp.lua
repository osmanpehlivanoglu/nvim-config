return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
        local wk = require 'which-key'
        wk.register({
          g = {
            d = 'Tanıma git',
            r = 'Nerede kullanılmış?',
            I = 'Implementasyona git',
          },
          ['<leader>'] = {
            rn = 'Yeniden adlandır',
            ca = 'Kod aksiyonu',
            ds = 'Döküman sembolleri',
            ws = 'Çalışma alanı sembolleri',
            th = 'İpucu gösterimini değiştir',
            D = 'Tip tanımı',
          },
          K = 'Hover dokümanı',
          ['<C-k>'] = 'İmza dokümanı',
          ['<F5>'] = 'C dosyasını çalıştır',
        }, { buffer = bufnr })
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
              },
            },
          },
        },
        intelephense = {},
        volar = { filetypes = { 'vue' } },
        clangd = {
          cmd = { 'clangd', '--offset-encoding=utf-16', '--clang-tidy' },
        },
        eslint = {},
        vtsls = {},
      }

      require('mason').setup()
      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup {
              capabilities = capabilities,
              on_attach = on_attach,
              settings = servers[server_name] and servers[server_name].settings or {},
              filetypes = servers[server_name] and servers[server_name].filetypes,
              cmd = servers[server_name] and servers[server_name].cmd,
            }
          end,
        },
      }
      require('lspconfig').vtsls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end,
  },
}
