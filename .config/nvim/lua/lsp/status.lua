-- vi: sw=2 ts=2

local system_signs = require('settings.signs')

local levels = {
  errors = 'Error',
  warnings = 'Warn',
  info = 'Info',
  hints = 'Hint',
}

local function is_lsp_active()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  return #clients > 0
end

local function lsp_status()
  local count = {}

  local is_ok = is_lsp_active()
  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    if count[k] > 0 then
      is_ok = false
    end
  end

  local errors = ''
  local warnings = ''
  local hints = ''
  local info = ''
  local ok = ''

  if count['errors'] ~= 0 then
    errors = ' ' .. system_signs.error_cl .. ' ' .. count['errors']
  end

  if count['warnings'] ~= 0 then
    warnings = ' ' .. system_signs.warn_cl .. ' ' .. count['warnings']
  end

  if count['hints'] ~= 0 then
    hints = ' ' .. system_signs.hint_cl .. ' ' .. count['hints']
  end

  if count['info'] ~= 0 then
    info = ' ' .. system_signs.info_cl .. ' ' .. count['info']
  end

  if is_ok then
    ok = system_signs.ok_cl
  end

  return ok .. errors .. warnings .. hints .. info .. system_signs.color_normal
end

local stt_ok, lspstt = pcall(require, 'lsp-status')
if not stt_ok then
  return lsp_status
end

lspstt.register_progress()
lspstt.config({
  indicator_errors = system_signs.error_cl,
  indicator_warnings = system_signs.warn_cl,
  indicator_info = system_signs.info_cl,
  indicator_hint = system_signs.hint_cl,
  indicator_ok = system_signs.ok_cl,
  status_symbol = '',
})

return lspstt.status
