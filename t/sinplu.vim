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

let g:sin_plu = [
      \ ['database', 'databases'],
      \ ['quiz', 'quizzes'],
      \ ['matrix', 'matrices'],
      \ ['vertex', 'vertices'],
      \ ['index', 'indices'],
      \ ['ox', 'oxen'],
      \ ['alias', 'aliases'],
      \ ['status', 'statuses'],
      \ ['hive', 'hives'],
      \ ['bus', 'buses'],
      \ ['word', 'words'],
      \ ['party', 'parties'],
      \ ['mouse', 'mice'],
      \ ['louce', 'lice'],
      \ ['native', 'natives'],
      \ ]

describe 'sinplu#SingularizeWord(word)'
  it 'returns same word'
    for word in g:uncountable
      Expect sinplu#SingularizeWord(word) ==? word
    endfor
  end

  it 'returns irregular word'
    for irregular in g:irregular
      Expect sinplu#SingularizeWord(irregular[1]) ==? irregular[0]
    endfor
  end

  it 'returns singularize word'
    for word in g:sin_plu
      Expect sinplu#SingularizeWord(word[1]) ==? word[0]
    endfor
  end
end

describe 'sinplu#PluralizeWord(word)'
  it 'returns same word'
    for word in g:uncountable
      Expect sinplu#PluralizeWord(word) ==? word
    endfor
  end

  it 'returns irregular word'
    for irregular in g:irregular
      Expect sinplu#PluralizeWord(irregular[0]) ==? irregular[1] 
    endfor
  end

  it 'returns pluralize word'
    for word in g:sin_plu
      Expect sinplu#PluralizeWord(word[0]) ==? word[1]
    endfor
  end
end
