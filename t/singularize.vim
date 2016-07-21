runtime! plugin/sinplu.vim

let g:irregular = [
      \ ['person' , 'people'],
      \ ['man'    , 'men'],
      \ ['child'  , 'children'],
      \ ['sex'    , 'sexes'],
      \ ['move'   , 'moves'],
      \ ['zombie' , 'zombies'],
      \ ]

let g:uncountable = [
      \ 'equipment',
      \ 'information',
      \ 'rice',
      \ 'money',
      \ 'species',
      \ 'series',
      \ 'fish',
      \ 'sheep',
      \ 'jeans',
      \ 'police',
      \ ]

describe 'sinplu#SingularizeWord(word)'
  it 'returns same word'
    for word in g:uncountable
      Expect sinplu#SingularizeWord(word) == word
    endfor
  end

  it 'returns irregular word'
    for irregular in g:irregular
      Expect sinplu#SingularizeWord(irregular[1]) == irregular[0]
    endfor
  end
end

describe 'sinplu#PluralizeWord(word)'
  it 'returns same word'
    for word in g:uncountable
      Expect sinplu#PluralizeWord(word) == word
    endfor
  end

  it 'returns irregular word'
    for irregular in g:irregular
      Expect sinplu#PluralizeWord(irregular[0]) == irregular[1] 
    endfor
  end
end

