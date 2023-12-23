local signs = {
  error = '󰅙',
  warn = '󰀦',
  hint = '󰀨',
  info = '󰋗',

  installed = '✓',
  pending = '➜',
  uninstalled = '✗',

  color_error = '%#SttDiagnosticError#',
  color_warn = '%#SttDiagnosticWarn#',
  color_hint = '%#SttDiagnosticHint#',
  color_info = '%#SttDiagnosticInfo#',
  color_normal = '%#StatusLine#',
}

signs.error_cl = signs.color_error .. signs.error .. signs.color_normal
signs.warn_cl = signs.color_warn .. signs.warn .. signs.color_normal
signs.hint_cl = signs.color_hint .. signs.hint .. signs.color_normal
signs.info_cl = signs.color_info .. signs.info .. signs.color_normal
signs.ok_cl = signs.color_warn .. signs.installed .. signs.color_normal

return signs;
