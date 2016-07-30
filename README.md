[![Build Status](https://travis-ci.org/kyohsuke/sinplu.vim.svg?branch=master)](https://travis-ci.org/kyohsuke/sinplu.vim)

## sinplu.vim - Singularize <-> Pluralize

Based on [Active Support](https://github.com/rails/rails/blob/92f567ab30f240a1de152061a6eee76ca6c4da86/activesupport/lib/active_support/inflections.rb)

![](https://cloud.githubusercontent.com/assets/573880/17268236/50690df4-5660-11e6-98ac-746d2ae953e5.gif)

## Installation
```vim
NeoBundle 'kyohsuke/sinplu.vim'
```

## Configuration
```vim
" if you need mapping as you like, you can do like that.
let g:sinplu_no_mappings = 1
nmap <Leader>s <Plug>SingularizeWord
nmap <Leader>p <Plug>PluralizeWord
nmap <Leader>t <Plug>ToggleWord
```

## LICENSE

MIT
