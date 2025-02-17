-- vi: sw=2 ts=2

vim.g.mapleader = ';'

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = false }
local opts_sl = { noremap = true, silent = true }

local is_mac = vim.fn.has('unix') and vim.fn.system("uname -s"):gsub('%s+', '') == 'Darwin'

-- insert mode
keymap('i', 'jk', '<esc>', opts)
keymap('i', 'kj', '<esc>', opts)

keymap('i', '<c-k>', '<up>', opts)
keymap('i', '<c-j>', '<down>', opts)
keymap('i', '<c-h>', '<left>', opts)
keymap('i', '<c-l>', '<right>', opts)

keymap('i', '<c-cr>', '<esc>A', opts_sl)
keymap('i', '<s-cr>', '<esc>A;<esc>', opts_sl)

keymap('i', '<c-s-v>', '<c-r><c-o>+', opts_sl)
keymap('i', '<s-insert>', '<c-r><c-o>+', opts_sl)
if is_mac then
  keymap('i', '<D-v>', '<c-r><c-o>+', opts_sl)
end

keymap('c', '<c-s-v>', '<c-r><c-o>+', opts)
keymap('c', '<s-insert>', '<c-r><c-o>+', opts)
if is_mac then
  keymap('c', '<D-v>', '<c-r><c-o>+', opts)
end

-- visual mode
keymap('v', '<c-c>', '"+y', opts_sl)
keymap('v', '<c-x>', '"+x', opts_sl)

-- terminal mode
keymap('t', '<c-h>', '<c-w>', opts_sl)
keymap('t', '<c-n>', '<c-\\><c-n>', opts_sl)
keymap('t', '<c-w>', '<c-\\><c-n><c-w>', opts_sl)
keymap('t', '<c-p>', '<c-\\><c-n>pi', opts_sl)
keymap('t', '<c-s-p>', '<c-\\><c-n>"*pi', opts_sl)

keymap('n', '<leader>;', ';', opts)
keymap('n', '<leader>,', ',', opts)
keymap('n', '<space>', 'f', opts)
keymap('n', '<s-space>', 'F', opts)
keymap('v', '<space>', 'f', opts)
keymap('v', '<s-space>', 'F', opts)

-- tab operations
for _, mode in ipairs({ 'n', 't' }) do
  local prefix = mode ~= 'n' and '<c-\\><c-n><c-w>' or ''

  keymap(mode, '<c-t>', prefix .. ':tabe<cr>', opts_sl)
  keymap(mode, '<s-t>', prefix .. ':tab sp<cr>', opts_sl)

  keymap(mode, '<a-t>', prefix .. ':tabe | lua Funcs.nerdtree()<cr>', opts_sl)
  keymap(mode, '<a-s-t>', prefix .. ':tabe | term<cr>', opts_sl)

  keymap(mode, '<a-h>', prefix .. ':tabp<cr>', opts_sl)
  keymap(mode, '<a-l>', prefix .. ':tabn<cr>', opts_sl)
  if is_mac then
    keymap(mode, '†', prefix .. ':tabe | lua Funcs.nerdtree()<cr>', opts_sl)
    keymap(mode, 'ˇ', prefix .. ':tabe | term<cr>', opts_sl)

    keymap(mode, '˙', prefix .. ':tabp<cr>', opts_sl)
    keymap(mode, '¬', prefix .. ':tabn<cr>', opts_sl)
  end

  keymap(mode, '<a-left>', prefix .. ':tabp<cr>', opts_sl)
  keymap(mode, '<a-right>', prefix .. ':tabn<cr>', opts_sl)

  keymap(mode, '<a-s-h>', prefix .. ':tabm -1<cr>', opts_sl)
  keymap(mode, '<a-s-l>', prefix .. ':tabm +1<cr>', opts_sl)
  keymap(mode, '<a-s-left>', prefix .. ':tabm -1<cr>', opts_sl)
  keymap(mode, '<a-s-right>', prefix .. ':tabm +1<cr>', opts_sl)
  if is_mac then
    keymap(mode, 'Ó', prefix .. ':tabm -1<cr>', opts_sl)
    keymap(mode, 'Ò', prefix .. ':tabm +1<cr>', opts_sl)
  end

  for i = 1, 9 do
    keymap(mode, '<a-' .. i .. '>', prefix .. ':tabn ' .. i .. '<cr>', opts_sl)
  end

  keymap(mode, '<a-0>', '', {
    callback = function()
      vim.cmd('tabn ' .. vim.fn.tabpagenr('$'))
    end
  })

  if is_mac then
    keymap(mode, '¡', prefix .. ':tabn 1<cr>', opts_sl)
    keymap(mode, '™', prefix .. ':tabn 2<cr>', opts_sl)
    keymap(mode, '£', prefix .. ':tabn 3<cr>', opts_sl)
    keymap(mode, '¢', prefix .. ':tabn 4<cr>', opts_sl)
    keymap(mode, '∞', prefix .. ':tabn 5<cr>', opts_sl)
    keymap(mode, '§', prefix .. ':tabn 6<cr>', opts_sl)
    keymap(mode, '¶', prefix .. ':tabn 7<cr>', opts_sl)
    keymap(mode, '•', prefix .. ':tabn 8<cr>', opts_sl)
    keymap(mode, 'ª', prefix .. ':tabn 9<cr>', opts_sl)

    keymap(mode, 'º', '', {
      callback = function()
        vim.cmd('tabn ' .. vim.fn.tabpagenr('$'))
      end
    })
  end
end

-- normal mode
keymap('n', 'n', 'n:lua Funcs.autoClearHighlight()<cr>', opts_sl)
keymap('n', 'N', 'N:lua Funcs.autoClearHighlight()<cr>', opts_sl)

keymap('n', '<leader>q', '', {
  callback = function()
    if vim.o.filetype == 'nerdtree' then
      vim.fn.execute('q', 'silent!')
    else
      vim.fn.execute('q!', 'silent!')
    end
  end
})

vim.api.nvim_create_user_command('Lrg', 'silent lgrep! <args> | lopen 24', {
  nargs = '+',
  complete = function(arg_lead, cmd_line, _)
    local args = vim.split(cmd_line, '%s+')
    if #args == 2 then
      return ''
    else
      return vim.fn.getcompletion(arg_lead, 'file')
    end
  end
})

keymap('n', 'F', ':Lrg ', opts)

keymap('n', '<c-space>', ':CtrlSpace<cr>', opts_sl)
if is_mac then
  keymap('n', '<a-space>', ':CtrlSpace<cr>', opts_sl)
end

keymap('n', '<a-j>', '<c-]>', opts_sl)
keymap('n', '<a-k>', '<c-t>', opts_sl)
if is_mac then
  keymap('n', '∆', '<c-]>', opts_sl)
  keymap('n', '˚', '<c-t>', opts_sl)
end

keymap('n', '<c-p>', ':Files<cr>', opts)

keymap('n', '<c-j>', ':res +5<cr>', opts_sl)
keymap('n', '<c-k>', ':res -5<cr>', opts_sl)
keymap('n', '<c-h>', ':vert res +5<cr>', opts_sl)
keymap('n', '<c-l>', ':vert res -5<cr>', opts_sl)

keymap('n', '<leader>rl', ':so ~/.config/nvim/init.lua<cr>', opts_sl)
keymap('n', '<leader>rc', ':e ~/.config/nvim/init.lua<cr>', opts_sl)
keymap('n', '<leader>s', ':e ~/.config/nvim/lua/settings/options.lua<cr>', opts_sl)
keymap('n', '<leader>m', ':e ~/.config/nvim/lua/settings/maps.lua<cr>', opts_sl)
keymap('n', '<leader>l', ':e ~/.config/nvim/lua/lsp/lsp.lua<cr>', opts_sl)
keymap('n', '<leader>lc', ':e ~/.config/nvim/lua/lsp/lsp-cfg.lua<cr>', opts_sl)
keymap('n', '<leader>id', ':e ~/.config/nvim/lua/settings/indent.lua<cr>', opts_sl)

keymap('n', '<leader>fs', ':set foldmethod=syntax<cr>', opts_sl)
keymap('n', '<leader>fm', ':set foldmethod=manual<cr>', opts_sl)
keymap('n', '<cr>', [[ foldlevel('.') > 0 ? 'za' : '<cr>' ]], { expr = true })

keymap('n', '<leader>z', ':lua Funcs.nerdtree()<cr>', opts_sl)
keymap('n', '<leader>cl', ':ColorToggle<cr>', opts_sl)
keymap('n', '<leader>tc', ':tabc<cr>', opts_sl)
keymap('n', '<leader>tv', ':bel vs term://fish<cr>', opts_sl)
keymap('n', '<leader>tt', ':bel sp term://fish <bar> resize 14<cr>', opts_sl)
keymap('n', '<leader>vi', [[ &keymap == '' ? ':set keymap=vietnamese-vni<cr>' : ':set keymap=<cr>' ]], { expr = true })

keymap('n', '<leader>dl', ':lua Funcs.delete_hidden_bufs()<cr>', opts)
keymap('n', '<leader>il', ':lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>', opts_sl)

keymap('n', '<f2>', ':lua vim.lsp.buf.rename()<cr>', opts)
keymap('n', '<s-k>', ':lua vim.lsp.buf.hover()<cr>', opts_sl)
keymap('n', '<c-f>', ':lua vim.lsp.buf.format({ async = false })<cr>', opts_sl)
keymap('n', '<c-m>', ':lua vim.lsp.buf.code_action({ apply = true })<cr>', opts_sl)
keymap('n', '<s-l>', ':lua vim.lsp.buf.definition({ reuse_win = true })<cr>', opts_sl)
keymap('n', '<s-h>', ':lua vim.lsp.buf.references()<cr>', opts_sl)

keymap('n', 'f', ':lua vim.diagnostic.open_float()<cr>', opts_sl)
keymap('n', ']g', ':lua vim.diagnostic.goto_next()<cr>', opts_sl)
keymap('n', '[g', ':lua vim.diagnostic.goto_prev()<cr>', opts_sl)
keymap('n', 'g]', ':lua vim.diagnostic.setqflist()<cr>', opts_sl)
keymap('n', 'g[', ':lua vim.diagnostic.setloclist()<cr>', opts_sl)


keymap('n', '<c-i>', '', {
  callback = function()
    vim.lsp.buf.execute_command({
      command = '_typescript.organizeImports',
      arguments = { vim.api.nvim_buf_get_name(0) },
    })
  end,
})

keymap('n', '<leader>gl', ':call gitblame#echo()<cr>', opts_sl)
keymap('n', '<leader>gf', ':GitGutterFold<cr>', opts)
keymap('n', '<leader>dp', ':GitGutterPreviewHunk<cr>', opts_sl)
keymap('n', '<leader>dv', ':DiffviewOpen<cr>', opts_sl)
keymap('n', '<leader>dc', ':DiffviewClose<cr>', opts_sl)
