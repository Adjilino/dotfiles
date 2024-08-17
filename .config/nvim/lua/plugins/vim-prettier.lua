return {
  'prettier/vim-prettier',
  config = function()
    -- The line beneath this is called `modeline`. See `:help modeline`
    -- vim: ts=2 sts=2 sw=2 et
    -- local map = function(mode, key, command)
    --     vim.api.nvim_set_keymap(mode, key, command, )
    -- end

    vim.keymap.set('n', '<leader>fp', ':PrettierAsync<CR>',
      { noremap = true, silent = true, desc = ' [F]ormat with [P]rettier' })

    vim.g['prettier#quickfix_enabled'] = '1'
    vim.g['prettier#prose_wrap'] = 'always'
  end
}
