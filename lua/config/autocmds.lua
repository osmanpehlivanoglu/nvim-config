-- [[ Otomatik Komutlar ]]
-- Daha fazla bilgi için: :help lua-guide-autocommands

-- Yank sonrası vurgulama
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Yank sonrası vurgula',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
