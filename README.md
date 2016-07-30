[![Build Status](https://travis-ci.org/kyohsuke/sinplu.vim.svg?branch=master)](https://travis-ci.org/kyohsuke/sinplu.vim)

## sinplu.vim - Singularize <-> Pluralize

Based on [Active Support](https://github.com/rails/rails/blob/92f567ab30f240a1de152061a6eee76ca6c4da86/activesupport/lib/active_support/inflections.rb)

![](https://cloud.githubusercontent.com/assets/573880/17268236/50690df4-5660-11e6-98ac-746d2ae953e5.gif)

## Installation
```vim
NeoBundle 'kyohsuke/sinplu.vim'
```
of course you can use Vundle, pathogen or any plug-in manager.

## Configuration

### keymap

```vim
" if you need mapping as you like, you can do like this.
let g:sinplu_no_mappings = 1
nmap <Leader>s <Plug>SingularizeWord
nmap <Leader>p <Plug>PluralizeWord
nmap <Leader>t <Plug>ToggleWord
```

### Singularize and/or Pluralize
```vim
" you can add Singularize/Pluralize rule.
" syntax is same as substitute(<word>, <from>, <to>, <flag>) 
let g:sinplu_singular_override_wards = [
      \ ['from', 'to', 'flag']
      \ ]

" for example, here is override the 'index -> indices' rule to 'index -> indexes'
let g:sinplu_plural_override_wards = [
      \ ['(ind)ex$', '\1exes', 'i']
      \ ]

```


## LICENSE

MIT
