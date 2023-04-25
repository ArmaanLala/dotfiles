-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })


-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<Tab>", vim.cmd.tabN)
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "qq", function()
  vim.cmd.update()
  vim.cmd.qa()
end
)
vim.keymap.set("n", "qq", function()
  vim.cmd.update()
  vim.cmd.q()
end
)

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


vim.keymap.set('n', '<leader>h', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  vim.lsp.buf.hover()
end, { desc = 'Show Code [H]over' })
vim.keymap.set("n", "<leader>ee", '<Cmd>Neotree toggle<CR>', { desc = "Open [E]xplorer" })
vim.api.nvim_create_autocmd('InsertLeave', {
  command = 'update',
})
