-- vi: sw=2 ts=2

local g = vim.g
local opt = vim.opt
local is_mac = vim.fn.has('unix') and vim.fn.system("uname -s"):gsub('%s+', '') == 'Darwin'

opt.number          = true
opt.relativenumber  = true

opt.smartcase       = true
opt.ignorecase      = true
opt.wildignorecase  = true

opt.modeline    = true
opt.cursorline  = true

opt.hidden     = true
opt.backup     = false
opt.undofile   = false
opt.swapfile   = false
opt.compatible = false

opt.encoding = 'utf-8'

opt.mouse     = 'a'
opt.belloff   = 'all'
opt.backspace = '2'

opt.splitbelow = true
opt.splitright = true

opt.timeout = false
opt.timeoutlen = 250
opt.updatetime = 100
opt.redrawtime = 15000

opt.list = true
opt.listchars = 'tab:>-,trail:.'
opt.fillchars = 'vert:│,fold: '

opt.showtabline = 2
opt.tabline = '%!v:lua.Funcs.tabline()'
opt.statusline = '%!v:lua.Funcs.stt()'

opt.grepprg = 'rg --smart-case --vimgrep --sort=path'
opt.grepformat = '%f:%l:%c:%m'

vim.cmd [[ colorscheme onedark ]]

g.highlight_delay_time = 2000

g.gitgutter_sign_added = '│'
g.gitgutter_sign_modified = '│'
g.gitgutter_sign_removed = '│'
g.gitgutter_sign_modified_removed = '│'

g.camelcasemotion_key = '<leader>'

if g.neovide then
  g.neovide_refresh_rate = 60
  g.neovide_refresh_rate_idle = 5

  g.neovide_cursor_antialiasing     = true
  g.neovide_cursor_animation_length = 0.13
  g.neovide_cursor_vfx_opacity      = 500.0
  g.neovide_cursor_vfx_mode         = 'railgun'
  g.neovide_cursor_vfx_particle_density = 10.0

  opt.guifont = 'SauceCodePro Nerd Font Mono:h8'
  if is_mac then
    opt.guifont = 'SauceCodePro Nerd Font Mono:h13'
  end

  vim.cmd [[ nn <silent> <c-=> :call v:lua.Funcs.fontsize()<cr> ]]
  vim.cmd [[ nn <silent> <c--> :call v:lua.Funcs.fontsize(-1)<cr> ]]
end

g.user_emmet_leader_key = ','

g.netrw_liststyle = 3
g.netrw_browser_split = 4

g.NERDTreeQuitOnOpen        =   true
g.NERDTreeMinimalUI         =   true
g.NERDTreeMinimalMenu       =   true
g.NERDTreeShowHidden        =   true
g.NERDTreeShowLineNumbers   =   true
g.NERDTreeWinSize           =   36
g.NERDTreeStatusline        =   "%{''}"

g.rustfmt_options = "--edition 2021"

g.indent_guides_start_level = 2
g.indent_guides_guide_size  = 1

g.webdevicons_enable = 1
g.webdevicons_enable_nerdtree = 1

g.db_ui_show_help = 0
g.db_ui_execute_on_save = 0

g.fzf_action = {
  ['ctrl-l'] = 'tab split',
}

g.CtrlSpaceUseTabline = 0
g.CtrlSpaceGlobCommand = 'rg --color=never --hidden --files'
g.CtrlSpaceDefaultMappingKey = '<C-Space>'
g.CtrlSpaceLoadLastWorkspaceOnStart = 1
g.CtrlSpaceWorkspaceFile = '~/.cache/nvim/ctrlspace_workspaces'
g.CtrlSpaceSaveWorkspaceOnSwitch = 1
g.CtrlSpaceSaveWorkspaceOnExit = 1

g.vimtex_view_method = 'zathura'
g.vimtex_compiler_method = 'latexmk'
g.vimtex_compiler_latexmk = {
  build_dir = 'build',
  executable = 'latexmk',
  options = {
    '-xelatex',
    '-verbose',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
  }
}
g.vimtex_compiler_latexmk_engines = {
  _ = ''
}

local au = {}

au['update_title'] = {
  { 'VimEnter', '*', 'lua Funcs.update_title()' },
  { 'BufEnter', '*', 'lua Funcs.update_title()' },
  { 'TermEnter', '*', 'lua Funcs.update_title()' },
  { 'TermOpen', '*', 'lua Funcs.update_title()' },
}

au['syntax'] = {
  { 'BufNewFile', '*', 'syntax sync fromstart' },
  { 'BufReadPost', '*', 'syntax sync fromstart' },
}

au['dynamic_startcase'] = {
  { 'CmdLineEnter', ':', 'set nosmartcase' },
  { 'CmdLineLeave', ':', 'set smartcase' },
}

au['insert_timeout'] = {
  { 'InsertEnter', '*', 'set timeout' },
  { 'InsertLeave', '*', 'set notimeout' },
}

au['clear_highlight'] = {
  { 'CmdLineLeave', '/,?', 'lua Funcs.autoClearHighlight()' },
}

au['leave_cursor'] = {
  { 'VimLeave', '*', 'sil! set gcr=a:hor20-blinkwait175-blinkoff150-blinkon175' },
}

au['terminal_mode'] = {
  { 'BufEnter', 'term://*', 'startinsert' },
  { 'TermOpen', '*', 'setlocal statusline=%{b:term_title} | set nornu | set nonu | startinsert' },
  { 'TermClose', '*', 'call feedkeys("<cr>")' },
}

au['check_file_changed'] = {
  { 'FocusGained', '*', ':checktime' },
}

for gr, cmds in pairs(au) do
  vim.api.nvim_create_augroup(gr, { clear = true })
  for i = 1, #cmds do
    vim.api.nvim_create_autocmd(cmds[i][1], {
      group = gr,
      pattern = cmds[i][2],
      command = cmds[i][3]
    })
  end
end
