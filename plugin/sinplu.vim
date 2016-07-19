"=============================================================================
" File: sinplu.vim
" Author: Keisuke Kawhara
" Created: 2016-07-19
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_sinplu')
    finish
endif
let g:loaded_sinplu = 1

let s:save_cpo = &cpo
set cpo&vim

function! SingularizeWard()
  let result = s:singularizeWard(expand('<cword>'))
  call s:replaceWard(result)
endfunction

function! PluralizeWard()
  let result = s:pluralizeWard(expand('<cword>'))
  call s:replaceWard(result)
endfunction

function! ToggleWard()
  let ward = expand('<cword>')
  let singlar = s:singularizeWard(ward)
  let result = ward ==? singlar ? s:pluralizeWard(ward) : singlar
  call s:replaceWard(result)
endfunction

function! s:replaceAll(src, irregular, inflicts)
  let uncountable = []
  call add(uncountable, 'equipment')
  call add(uncountable, 'information')
  call add(uncountable, 'rice')
  call add(uncountable, 'money')
  call add(uncountable, 'species')
  call add(uncountable, 'series')
  call add(uncountable, 'fish')
  call add(uncountable, 'sheep')
  call add(uncountable, 'jeans')
  call add(uncountable, 'police')

  for passthrow in uncountable
    if 0 <= match(a:src, passthrow)
      return a:src
    endif
  endfor

  let temp = a:src
  for inflict in a:irregular
    let before = inflict[0]
    let after = inflict[1]
    let flag = inflict[2]
    let temp = substitute(temp, before, after, flag)
  endfor

  if temp != a:src
    return temp
  endif

  let temp = a:src
  for inflict in a:inflicts
    let before = inflict[0]
    let after = inflict[1]
    let flag = inflict[2]
    let temp = substitute(temp, before, after, flag)
  endfor
  return substitute(temp, '\n', '', 'g')
endfunction

function! s:replaceWard(result)
  let pos = getpos('.')
  execute ":normal ciw" . a:result . "\<ESC>"
  call setpos('.', pos)
endfunction

function! s:singularizeWard(ward)
  let inflicts = []
  let irregular = []
  " Singular
  call add(inflicts, ['s$', '', 'i'])
  call add(inflicts, ['(ss)$', '\1', 'i'])
  call add(inflicts, ['(n)ews$', '\1ews', 'i'])
  call add(inflicts, ['([ti])a$', '\1um', 'i'])
  call add(inflicts, ['((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$', '\1sis', 'i'])
  call add(inflicts, ['(^analy)(sis|ses)$', '\1sis', 'i'])
  call add(inflicts, ['([^f])ves$', '\1fe', 'i'])
  call add(inflicts, ['(hive)s$', '\1', 'i'])
  call add(inflicts, ['(tive)s$', '\1', 'i'])
  call add(inflicts, ['([lr])ves$', '\1f', 'i'])
  call add(inflicts, ['([^aeiouy]|qu)ies$', '\1y', 'i'])
  call add(inflicts, ['(s)eries$', '\1eries', 'i'])
  call add(inflicts, ['(m)ovies$', '\1ovie', 'i'])
  call add(inflicts, ['(x|ch|ss|sh)es$', '\1', 'i'])
  call add(inflicts, ['^(m|l)ice$', '\1ouse', 'i'])
  call add(inflicts, ['(bus)(es)?$', '\1', 'i'])
  call add(inflicts, ['(o)es$', '\1', 'i'])
  call add(inflicts, ['(shoe)s$', '\1', 'i'])
  call add(inflicts, ['(cris|test)(is|es)$', '\1is', 'i'])
  call add(inflicts, ['^(a)x[ie]s$', '\1xis', 'i'])
  call add(inflicts, ['(octop|vir)(us|i)$', '\1us', 'i'])
  call add(inflicts, ['(alias|status)(es)?$', '\1', 'i'])
  call add(inflicts, ['^(ox)en', '\1', 'i'])
  call add(inflicts, ['(vert|ind)ices$', '\1ex', 'i'])
  call add(inflicts, ['(matr)ices$', '\1ix', 'i'])
  call add(inflicts, ['(quiz)zes$', '\1', 'i'])
  call add(inflicts, ['(database)s$', '\1', 'i'])
  " Irregular
  call add(irregular, ['people', 'person', ''])
  call add(irregular, ['men', 'man', ''])
  call add(irregular, ['children', 'child', ''])
  call add(irregular, ['sexes', 'sex', ''])
  call add(irregular, ['moves', 'move', ''])
  call add(irregular, ['zombies', 'zombie', ''])

  return s:replaceAll(a:ward, irregular, inflicts)
endfunction

function! s:pluralizeWard(ward)
  let inflicts = []
  let irregular = []

  " Plural
  call add(inflicts, ['$', 's', ''])
  call add(inflicts, ['s$', 's', 'i'])
  call add(inflicts, ['^(ax|test)is$', '\1es', 'i'])
  call add(inflicts, ['(octop|vir)us$', '\1i', 'i'])
  call add(inflicts, ['(octop|vir)i$', '\1i', 'i'])
  call add(inflicts, ['(alias|status)$', '\1es', 'i'])
  call add(inflicts, ['(bu)s$', '\1ses', 'i'])
  call add(inflicts, ['(buffal|tomat)o$', '\1oes', 'i'])
  call add(inflicts, ['([ti])um$', '\1a', 'i'])
  call add(inflicts, ['([ti])a$', '\1a', 'i'])
  call add(inflicts, ['sis$', 'ses', 'i'])
  call add(inflicts, ['(?:([^f])fe|([lr])f)$', '\1\2ves', 'i'])
  call add(inflicts, ['(hive)$', '\1s', 'i'])
  call add(inflicts, ['([^aeiouy]|qu)y$', '\1ies', 'i'])
  call add(inflicts, ['(x|ch|ss|sh)$', '\1es', 'i'])
  call add(inflicts, ['(matr|vert|ind)(?:ix|ex)$', '\1ices', 'i'])
  call add(inflicts, ['^(m|l)ouse$', '\1ice', 'i'])
  call add(inflicts, ['^(m|l)ice$', '\1ice', 'i'])
  call add(inflicts, ['^(ox)$', '\1en', 'i'])
  call add(inflicts, ['^(oxen)$', '\1', 'i'])
  call add(inflicts, ['(quiz)$', '\1zes', 'i'])
  " Irregular
  call add(irregular, ['person', 'people', ''])
  call add(irregular, ['man', 'men', ''])
  call add(irregular, ['child', 'children', ''])
  call add(irregular, ['sex', 'sexes', ''])
  call add(irregular, ['move', 'moves', ''])
  call add(irregular, ['zombie', 'zombies', ''])

  return s:replaceAll(a:ward, irregular, inflicts)
endfunction

nnoremap <silent> <Plug>SingularizeWard :<C-u>call <SID>SingularizeWard()<CR>
nnoremap <silent> <Plug>PluralizeWard :<C-u>call <SID>PluralizeWard()<CR>
nnoremap <silent> <Plug>ToggleWard :<C-u>call <SID>ToggleWard()<CR>

if !exists("g:sinplu_no_mappings") || ! g:sinplu_no_mappings
  nnoremap <Leader>s <Plug>SingularizeWard
  nnoremap <Leader>p <Plug>PluralizeWard
  nnoremap <Leader>w <Plug>ToggleWard
end

let &cpo = s:save_cpo
unlet s:save_cpo
