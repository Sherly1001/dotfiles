-- vi: sw=2 ts=2

local lspstt = require('lsp.status')

Funcs = {}

local function modified(bufnr)
  return vim.fn.getbufvar(bufnr, '&modified') == 1
end

local function buftitle(bufnr)
  local name = vim.fn.bufname(bufnr)
  local filename = name == '' and '[No Name]' or vim.fn.fnamemodify(name, ':t')
  if #filename > 15 then
    filename = filename:sub(1, 10) .. '..' .. vim.fn.fnamemodify(name, ':e')
  end
  return filename
end

local function evaltab(tab)
  tab = tab:gsub('%%#[^#]+#', '')
  tab = tab:gsub('%%%d*[TX]', '')
  return tab
end

function Funcs.bufsNum(nr)
  if nr < 2 then
    return ''
  end

  local smallNumbers = { '⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹' }
  local strNr = tostring(nr)

  local str = ''
  for i = 1, #strNr do
    local c = strNr:sub(i, i)
    local idx = c - '0' + 1
    str = str .. smallNumbers[idx]
  end

  return str
end

function Funcs.pertab()
  local numtab = vim.fn.tabpagenr('$')
  local curtab = vim.fn.tabpagenr()
  return numtab > 1 and (curtab .. '/' .. numtab) or ''
end

function Funcs.tabname(tab, showmod)
  showmod = showmod or 'left'

  local wins = vim.fn.tabpagewinnr(tab)
  local bufs = vim.fn.tabpagebuflist(tab)
  local bufnr = bufs[wins]

  local bufsNum = ''
  local ok, res = pcall(vim.fn['ctrlspace#api#Buffers'], tab)
  if ok then
    bufsNum = vim.fn.len(res)
    bufsNum = Funcs.bufsNum(bufsNum)
  end

  local modchar = '•'
  local ismod = modified(bufnr)

  return ((showmod == 'right' and ismod) and (modchar .. ' ') or '') ..
      buftitle(bufnr) .. bufsNum .. ((showmod == 'left' and ismod) and (' ' .. modchar) or '')
end

function Funcs.tabline()
  local numtab = vim.fn.tabpagenr('$')
  local curtab = vim.fn.tabpagenr()
  local pertab = numtab > 1 and (curtab .. '/' .. numtab) or ''
  local cols = vim.o.columns

  local tabs = {}
  for tab = 1, numtab do
    local bufsNum = ''
    local ok, res = pcall(vim.fn['ctrlspace#api#Buffers'], tab)
    if ok then
      bufsNum = vim.fn.len(res)
      bufsNum = Funcs.bufsNum(bufsNum)
    end

    local tabname = tab == curtab and '%#TabLineSel#' or '%#TabLine#'
    tabname = tabname .. '%' .. tab .. 'T '
    tabname = tabname .. Funcs.tabname(tab)
    tabname = tabname .. ' %T'

    table.insert(tabs, tabname)
  end

  local tabline = tabs[curtab]
  local is_left = true
  local left = curtab - 1
  local right = curtab + 1

  while left > 0 or right <= numtab do
    local next = tabline

    if is_left and left > 0 then
      next = tabs[left] .. tabline
      left = left - 1
    elseif not is_left and right <= numtab then
      next = tabline .. tabs[right]
      right = right + 1
    end

    if #(evaltab(next) .. pertab) > cols then
      break
    else
      tabline = next
    end

    is_left = not is_left
  end

  return '%#TabLineFill#' .. tabline .. '%#TabLineFill#' .. '%=' .. pertab
end

function Funcs.stt()
  return '%f%=' .. lspstt() .. ' %y%r %(%3c-%l/%L%) %P'
end

vim.o.title = true
function Funcs.update_title()
  local home = '^' .. vim.env.HOME
  local title = vim.fn.expand('%f'):gsub(home, '~')
  local pwd = vim.fn.getcwd():gsub(home, '~')

  if title == '' then
    title = '[No Name] ' .. pwd
  elseif title:find('^term://') ~= nil then
    title = pwd
  end

  vim.o.titlestring = title
  return title
end

function Funcs.fontsize(step)
  step = step or 1
  local font = vim.o.guifont

  if #font < 1 then
    vim.o.guifont = 'Consolas:h9'
    return
  end

  local ff = vim.split(font, ':h')
  if ff[2] + step < 1 then return end

  local new = ff[1] .. ':h' .. (ff[2] + step)
  vim.o.guifont = new
end

local function is_allowed_buf_types(buf_type)
  local allowed_buf_types = { 'nerdtree', 'dbui', 'dbout' }
  for _, type in ipairs(allowed_buf_types) do
    if buf_type == type then
      return true
    end
  end
  return false
end

function Funcs.delete_hidden_bufs()
  local tpbl = {}
  for _, tabnr in ipairs(vim.fn.range(1, vim.fn.tabpagenr('$'))) do
    local ok, res = pcall(vim.fn['ctrlspace#api#Buffers'], tabnr)
    if ok then
      for bufnr, _ in pairs(res) do
        table.insert(tpbl, tonumber(bufnr))
      end
    end
  end

  local deleted = 0
  for _, bufnr in ipairs(vim.fn.range(1, vim.fn.bufnr('$'))) do
    if vim.fn.bufexists(bufnr) == 1 and
        not vim.tbl_contains(tpbl, bufnr) and
        not is_allowed_buf_types(vim.fn.getbufvar(bufnr, '&filetype')) then
      vim.cmd('bwipeout ' .. bufnr)
      deleted = deleted + 1
    end
  end

  print('Deleted ' .. deleted .. ' buffers')
end

function Funcs.nerdtree()
  local previous_winid = vim.api.nvim_get_current_win()
  local previous_winnr = vim.fn.winnr('$')

  vim.fn.execute('NERDTreeMirror', 'silent!')
  if previous_winnr == vim.fn.winnr('$') then
    vim.fn.execute('NERDTreeToggle', 'silent!')
  end

  if previous_winnr < vim.fn.winnr('$') then
    local nerdtree_winid = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(previous_winid)
    vim.fn.execute('NERDTreeFind', 'silent!')
    vim.api.nvim_set_current_win(nerdtree_winid)
  end
end

local highlight_timer = nil
function Funcs.autoClearHighlight()
  local delay = vim.g.highlight_delay_time
  if not delay or delay == 0 then
    return
  end

  if highlight_timer ~= nil then
    highlight_timer:stop()
    highlight_timer:close()
  end

  highlight_timer = vim.defer_fn(function()
    vim.cmd [[ nohlsearch ]]
    highlight_timer = nil
  end, delay)
end
