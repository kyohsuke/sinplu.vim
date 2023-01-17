vim9script
# vim:set foldmethod=marker:
#=============================================================================
# File: sinplu.vim
# Author: Keisuke Kawhara
# Created: 2016-07-19
#=============================================================================

scriptencoding utf-8

if exists('g:loaded_sinplu')
    finish
endif
g:loaded_sinplu = 1

var save_cpo = &cpo
set cpo&vim

if !exists("g:sinplu_uncountable_wards") # {{{
  g:sinplu_uncountable_wards = [
    'equipment',
    'information',
    'rice',
    'money',
    'species',
    'series',
    'fish',
    'sheep',
    'jeans',
    'police',
  ]
endif # }}}

if !exists("g:sinplu_singular_inflict_wards") # {{{
  g:sinplu_singular_inflict_wards = [
    ['(database)s$', '\1', 'i'],
    ['(quiz)zes$', '\1', 'i'],
    ['(matr)ices$', '\1ix', 'i'],
    ['(vert|ind)ices$', '\1ex', 'i'],
    ['^(ox)en', '\1', 'i'],
    ['(alias|status)(es)?$', '\1', 'i'],
    ['(octop|vir)(us|i)$', '\1us', 'i'],
    ['^(a)x[ie]s$', '\1xis', 'i'],
    ['(cris|test)(is|es)$', '\1is', 'i'],
    ['(shoe)s$', '\1', 'i'],
    ['(o)es$', '\1', 'i'],
    ['(bus)(es)?$', '\1', 'i'],
    ['^(l)ice$', '\1ouce', 'i'],
    ['^(m)ice$', '\1ouse', 'i'],
    ['(x|ch|ss|sh)es$', '\1', 'i'],
    ['(m)ovies$', '\1ovie', 'i'],
    ['(s)eries$', '\1eries', 'i'],
    ['([^aeiouy]|qu)ies$', '\1y', 'i'],
    ['([lr])ves$', '\1f', 'i'],
    ['(tive)s$', '\1', 'i'],
    ['(hive)s$', '\1', 'i'],
    ['([^f])ves$', '\1fe', 'i'],
    ['(^analy)(sis|ses)$', '\1sis', 'i'],
    ['((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$', '\1sis', 'i'],
    ['([ti])a$', '\1um', 'i'],
    ['(n)ews$', '\1ews', 'i'],
    ['ties$', 'ty', 'i'],
    ['(ss)$', '\1', 'i'],
    ['s$', '', 'i'],
  ]
endif # }}}

if !exists("g:sinplu_singular_irregular_wards") # {{{
  g:sinplu_singular_irregular_wards = [
    ['(zombie)s', '\1', 'i'],
    ['(move)s', '\1', 'i'],
    ['(sex)es', '\1', 'i'],
    ['(child)ren', '\1', 'i'],
    ['(m)en', '\1an', 'i'],
    ['(pe)ople$', '\1rson', 'i'],
  ]
endif # }}}

if !exists("g:sinplu_plural_inflict_wards") # {{{
  g:sinplu_plural_inflict_wards = [
    ['(quiz)$', '\1zes', 'i'],
    ['^(oxen)$', '\1', 'i'],
    ['^(ox)$', '\1en', 'i'],
    ['^(l)ouce$', '\1ice', 'i'],
    ['^(m)ouse$', '\1ice', 'i'],
    ['(matr|vert|ind)%(ix|ex)$', '\1ices', 'i'],
    ['(x|ch|ss|sh)$', '\1es', 'i'],
    ['([^aeiouy]|qu)y$', '\1ies', 'i'],
    ['(hive)$', '\1s', 'i'],
    ['%(([^f])fe|([lr])f)$', '\1\2ves', 'i'],
    ['sis$', 'ses', 'i'],
    ['([ti])a$', '\1a', 'i'],
    ['([ti])um$', '\1a', 'i'],
    ['(buffal|tomat)o$', '\1oes', 'i'],
    ['(bu)s$', '\1ses', 'i'],
    ['(alias|status)$', '\1es', 'i'],
    ['(octop|vir)i$', '\1i', 'i'],
    ['(octop|vir)us$', '\1i', 'i'],
    ['^(ax|test)is$', '\1es', 'i'],
    ['ty$', 'ties', 'i'],
    ['s$', 's', 'i'],
    ['$', 's', ''],
  ]
endif # }}}

if !exists("g:sinplu_plural_irregular_wards") # {{{
  g:sinplu_plural_irregular_wards = [
    ['(zombie)', '\1s', 'i'],
    ['(move)', '\1s', ''],
    ['(sex)', '\1es', 'i'],
    ['(child)', '\1ren', 'i'],
    ['(m)an', '\1en', 'i'],
    ['(pe)rson', '\1ople', 'i'],
  ]
endif # }}}

if !exists("g:sinplu_plural_override_wards") # {{{
  g:sinplu_plural_override_wards = []
endif # }}}

if !exists("g:sinplu_singular_override_wards") # {{{
  g:sinplu_singular_override_wards = []
endif # }}}


def g:SingularizeWord() # {{{
  var result = SinpluSingularizeWord(expand('<cword>'))
  ReplaceWord(result)
enddef # }}}

def g:PluralizeWord() # {{{
  var result = SinpluPluralizeWord(expand('<cword>'))
  ReplaceWord(result)
enddef # }}}

def g:ToggleWord() # {{{
  var word = expand('<cword>')
  var singlar = SinpluSingularizeWord(word)
  var result = word ==? singlar ? SinpluPluralizeWord(word) : singlar

  ReplaceWord(result)
enddef # }}}

def ReplaceAll(src: string, override: list<list<string>>, irregular: list<list<string>>, inflicts: list<list<string>>): string # {{{
  var base = substitute(src, '\n', '', 'g')
  for passthrow in g:sinplu_uncountable_wards
    if src ==? passthrow
      return src
    endif
  endfor

  var temp: string
  for check_group in [override, irregular, inflicts]
    for inflict in check_group
      var before = '\v' .. inflict[0]
      var after = inflict[1]
      var flag = inflict[2]
      temp = substitute(base, before, after, flag)
      if temp !=? base
        return temp
      endif
    endfor
  endfor
  return temp
enddef # }}}

def ReplaceWord(result: string) # {{{
  var pos = getpos('.')
  execute ":normal ciw" .. result .. "\<ESC>"
  setpos('.', pos)
enddef # }}}

def g:SinpluSingularizeWord(word: string): string # {{{
  return ReplaceAll(word, g:sinplu_singular_override_wards, g:sinplu_singular_irregular_wards, g:sinplu_singular_inflict_wards)
enddef # }}}

def g:SinpluPluralizeWord(word: string): string # {{{
  return ReplaceAll(word, g:sinplu_plural_override_wards, g:sinplu_plural_irregular_wards, g:sinplu_plural_inflict_wards)
enddef # }}}

nnoremap <Plug>SingularizeWord :<C-u>SingularizeWord()<CR>
nnoremap <Plug>PluralizeWord :<C-u>PluralizeWord()<CR>
nnoremap <Plug>ToggleWord :<C-u>ToggleWord()<CR>

if !exists("g:sinplu_no_mappings") || !g:sinplu_no_mappings
  nmap <Leader>s <Plug>SingularizeWord
  nmap <Leader>p <Plug>PluralizeWord
  nmap <Leader>t <Plug>ToggleWord
endif

&cpo = save_cpo
