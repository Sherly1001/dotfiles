-- vi: sw=2 ts=2

local lspstt = require('lsp.status')

Funcs = {}

local function modified(bufnr)
  return vim.fn.getbufvar(bufnr, '&modified') == 1
end

local function title(bufnr)
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

function Funcs.tabline()
  local numtab = vim.fn.tabpagenr('$')
  local curtab = vim.fn.tabpagenr()
  local pertab = numtab > 1 and (curtab .. '/' .. numtab) or ''
  local cols = vim.o.columns

  local tabs = {}
  for tab = 1, numtab do
    local wins = vim.fn.tabpagewinnr(tab)
    local bufs = vim.fn.tabpagebuflist(tab)
    local bufnr = bufs[wins]

    local bufsNum = ''
    local ok, res = pcall(vim.fn['ctrlspace#api#Buffers'], tab)
    if ok then
      bufsNum = vim.fn.len(res)
      bufsNum = Funcs.bufsNum(bufsNum)
    end

    local tabname = tab == curtab and '%#TabLineSel#' or '%#TabLine#'
    tabname = tabname .. '%' .. tab .. 'T '
    tabname = tabname .. title(bufnr) .. bufsNum
    tabname = tabname .. (modified(bufnr) and ' •' or '')
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
  return '%f%=' .. lspstt() .. ' %y%r %-14(%3c-%l/%L%)%P'
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
        vim.fn.getbufvar(bufnr, '&filetype') ~= 'nerdtree' then
      vim.cmd('bwipeout ' .. bufnr)
      deleted = deleted + 1
    end
  end

  print('Deleted ' .. deleted .. ' buffers')
end

local function is_nerdtree_open()
  return vim.fn.exists('t:NERDTreeBufName') and vim.fn.bufwinnr('t:NERDTreeBufName') ~= -1
end

function Funcs.nerdtree()
  if is_nerdtree_open() then return end
  local previous_winnr = vim.fn.winnr('$')
  vim.fn.execute('NERDTreeMirror', 'silent!')
  if previous_winnr == vim.fn.winnr('$') then
    vim.fn.execute('NERDTreeToggle', 'silent!')
  end
end
