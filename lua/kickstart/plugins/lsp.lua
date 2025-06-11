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

        -- LSP keymaps
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

        -- Format command
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })

        -- Which-key mappings (yeni format)
        local wk = require 'which-key'
        wk.add {
          { '<C-k>', desc = 'İmza dokümanı', buffer = bufnr },
          { '<F5>', desc = 'C dosyasını çalıştır', buffer = bufnr },
          { '<leader>D', desc = 'Tip tanımı', buffer = bufnr },
          { '<leader>ca', desc = 'Kod aksiyonu', buffer = bufnr },
          { '<leader>ds', desc = 'Döküman sembolleri', buffer = bufnr },
          { '<leader>rn', desc = 'Yeniden adlandır', buffer = bufnr },
          { '<leader>th', desc = 'İpucu gösterimini değiştir', buffer = bufnr },
          { '<leader>ws', desc = 'Çalışma alanı sembolleri', buffer = bufnr },
          { 'K', desc = 'Hover dokümanı', buffer = bufnr },
          { 'gI', desc = 'Implementasyona git', buffer = bufnr },
          { 'gd', desc = 'Tanıma git', buffer = bufnr },
          { 'gr', desc = 'Nerede kullanılmış?', buffer = bufnr },
        }
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
        vls = { filetypes = { 'vue' } },
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
