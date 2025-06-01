-- [[ Kısayol Tanımlamaları ]]
-- Daha fazla bilgi için: :help vim.keymap.set()

-- Arama sonrası vurguyu temizle
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- LSP Hata Mesajları
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal moddan çıkış
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Pencere geçişleri (CTRL + h/j/k/l)
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Sağ split
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = 'Sağa böl (vsplit)' })

-- BufferLine tab geçişleri
vim.keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-j>', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-k>', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })

-- Aktif buffer'ı kapat ve öncekine geç
vim.keymap.set('n', '<leader>bd', ':bp | bd #<CR>', { desc = 'Bufferı kapat ve öncekine geç' })

-- Tüm buffer'ları kapat
vim.keymap.set('n', '<leader>ba', ':%bd<CR>', { desc = 'Tüm bufferları kapat' })

-- Sonraki / önceki buffer
vim.keymap.set('n', '<leader>bn', ':bn<CR>', { desc = 'Sonraki buffer' })
vim.keymap.set('n', '<leader>bp', ':bp<CR>', { desc = 'Önceki buffer' })

-- Önceki buffer'a geç (en son ziyaret edilen)
vim.keymap.set('n', '<leader>bl', '<C-^>', { desc = 'Son kullanılan buffer' })

-- C dosyası çalıştır (F5 ile)
vim.api.nvim_create_user_command('CompileRunC', function()
  vim.cmd 'write'
  local file = vim.fn.expand '%'
  local name = vim.fn.expand '%:r'
  vim.cmd('split term://gcc -o ' .. name .. ' ' .. file .. ' && ./' .. name)
  vim.cmd 'startinsert'
end, {})

vim.keymap.set('n', '<F5>', ':CompileRunC<CR>', { noremap = true, silent = true })
