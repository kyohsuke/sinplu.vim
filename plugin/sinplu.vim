" vim:set foldmethod=marker:
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

function! s:SingularizeWord()
  let result = sinplu#SingularizeWord(expand('<cword>'))
  call s:replaceWord(result)
endfunction

function! s:PluralizeWord()
  let result = sinplu#PluralizeWord(expand('<cword>'))
  call s:replaceWord(result)
endfunction

function! s:ToggleWord()
  let word = expand('<cword>')
  let singlar = sinplu#SingularizeWord(word)
  let result = word ==? singlar ? sinplu#PluralizeWord(word) : singlar
  call s:replaceWord(result)
endfunction

function! s:replaceAll(src, irregular, inflicts) " {{{
  let base = substitute(a:src, '\n', '', 'g')
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

  for inflict in reverse(copy(a:irregular))
    let before = '\v'. inflict[0]
    " let before = '\v'. escape(inflict[0], '\')
    let after = inflict[1]
    let flag = inflict[2]
    let temp = substitute(base, before, after, flag)
    if temp != base
      return temp
    endif
  endfor

  for inflict in reverse(copy(a:inflicts))
    let before = '\v'. inflict[0]
    " let before = '\v'. escape(inflict[0], '\')
    let after = inflict[1]
    let flag = inflict[2]
    let temp = substitute(base, before, after, flag)
    if temp != base
      return temp
    endif
  endfor
  return temp
endfunction " }}}

function! s:replaceWord(result) " {{{
  let pos = getpos('.')
  execute ":normal ciw" . a:result . "\<ESC>"
  call setpos('.', pos)
endfunction " }}}

function! sinplu#SingularizeWord(word) " {{{
  let inflicts = []
  let irregular = []
  " Singular
  call add(inflicts, ['s$', '', 'i'])
  call add(inflicts, ['(ss)$', '\1', 'i'])
  call add(inflicts, ['ties$', 'ty', 'i'])
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
  call add(inflicts, ['^(m)ice$', '\1ouse', 'i'])
  call add(inflicts, ['^(l)ice$', '\1ouce', 'i'])
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
  call add(irregular, ['(pe)ople$', '\1rson', 'i'])
  call add(irregular, ['(m)en', '\1an', 'i'])
  call add(irregular, ['(child)ren', '\1', 'i'])
  call add(irregular, ['(sex)es', '\1', 'i'])
  call add(irregular, ['(move)s', '\1', 'i'])
  call add(irregular, ['(zombie)s', '\1', 'i'])

  return s:replaceAll(a:word, irregular, inflicts)
endfunction " }}}

function! sinplu#PluralizeWord(word) " {{{
  let inflicts = []
  let irregular = []

  " Plural
  call add(inflicts, ['$', 's', ''])
  call add(inflicts, ['s$', 's', 'i'])
  call add(inflicts, ['ty$', 'ties', 'i'])
  call add(inflicts, ['^(ax|test)is$', '\1es', 'i'])
  call add(inflicts, ['(octop|vir)us$', '\1i', 'i'])
  call add(inflicts, ['(octop|vir)i$', '\1i', 'i'])
  call add(inflicts, ['(alias|status)$', '\1es', 'i'])
  call add(inflicts, ['(bu)s$', '\1ses', 'i'])
  call add(inflicts, ['(buffal|tomat)o$', '\1oes', 'i'])
  call add(inflicts, ['([ti])um$', '\1a', 'i'])
  call add(inflicts, ['([ti])a$', '\1a', 'i'])
  call add(inflicts, ['sis$', 'ses', 'i'])
  call add(inflicts, ['%(([^f])fe|([lr])f)$', '\1\2ves', 'i'])
  call add(inflicts, ['(hive)$', '\1s', 'i'])
  call add(inflicts, ['([^aeiouy]|qu)y$', '\1ies', 'i'])
  call add(inflicts, ['(x|ch|ss|sh)$', '\1es', 'i'])
  call add(inflicts, ['(matr|vert|ind)%(ix|ex)$', '\1ices', 'i'])
  call add(inflicts, ['^(m)ouse$', '\1ice', 'i'])
  call add(inflicts, ['^(l)ouce$', '\1ice', 'i'])
  call add(inflicts, ['^(ox)$', '\1en', 'i'])
  call add(inflicts, ['^(oxen)$', '\1', 'i'])
  call add(inflicts, ['(quiz)$', '\1zes', 'i'])
  " Irregular
  call add(irregular, ['(pe)rson', '\1ople', 'i'])
  call add(irregular, ['(m)an', '\1en', 'i'])
  call add(irregular, ['(child)', '\1ren', 'i'])
  call add(irregular, ['(sex)', '\1es', 'i'])
  call add(irregular, ['(move)', '\1s', ''])
  call add(irregular, ['(zombie)', '\1s', 'i'])

  return s:replaceAll(a:word, irregular, inflicts)
endfunction " }}}

nnoremap <Plug>SingularizeWord :<C-u>call <SID>SingularizeWord()<CR>
nnoremap <Plug>PluralizeWord :<C-u>call <SID>PluralizeWord()<CR>
nnoremap <Plug>ToggleWord :<C-u>call <SID>ToggleWord()<CR>

if !exists("g:sinplu_no_mappings") || !g:sinplu_no_mappings
  nmap <Leader>s <Plug>SingularizeWord
  nmap <Leader>p <Plug>PluralizeWord
  nmap <Leader>w <Plug>ToggleWord
end

let &cpo = s:save_cpo
unlet s:save_cpo
