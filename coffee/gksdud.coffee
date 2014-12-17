qwerty = ['q', 'Q', 'w', 'W', 'e', 'E', 'r', 'R', 't', 'T', 'y', 'u', 'i', 'o', 'O', 'p', 'P', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm']
two_set_korean = ['ㅂ', 'ㅃ', 'ㅈ', 'ㅉ', 'ㄷ', 'ㄸ', 'ㄱ', 'ㄲ', 'ㅅ', 'ㅆ', 'ㅛ', 'ㅕ', 'ㅑ', 'ㅐ', 'ㅒ', 'ㅔ', 'ㅖ', 'ㅁ', 'ㄴ', 'ㅇ', 'ㄹ', 'ㅎ', 'ㅗ', 'ㅓ', 'ㅏ', 'ㅣ', 'ㅋ', 'ㅌ', 'ㅊ', 'ㅍ', 'ㅠ', 'ㅜ', 'ㅡ']

initial_letters = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ" ]
medial_letters = ["ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"]
final_letters = ["", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]

#str = "책ㄱㄷㅊㅅ gksdud tlftn"
result = ""
cont = 0

medial_letter_map = {"ㅘ": ["ㅗ", "ㅏ"], "ㅙ": ["ㅗ", "ㅐ"], "ㅚ": ["ㅗ", "ㅣ"], "ㅝ": ["ㅜ", "ㅓ"], "ㅞ": ["ㅜ", "ㅔ"], "ㅟ": ["ㅜ", "ㅣ"], "ㅢ": ["ㅡ", "ㅣ"]}
fix_double_medial_letters = (m1, m2) ->
  for k, v of medial_letter_map
    if v[0] == m1 and v[1] == m2
      return k
  return undefined
separate_double_medial_letters = (m) ->
  return medial_letter_map[m]

final_letter_map = {"ㄲ": ["ㄱ", "ㄱ"], "ㄳ": ["ㄱ", "ㅅ"], "ㄵ": ["ㄴ", "ㅈ"], "ㄶ": ["ㄴ", "ㅎ"], "ㄺ": ["ㄹ", "ㄱ"], "ㄻ": ["ㄹ", "ㅁ"], "ㄼ": ["ㄹ", "ㅂ"], "ㄽ": ["ㄹ", "ㅅ"], "ㄾ": ["ㄹ", "ㅌ"], "ㄿ": ["ㄹ", "ㅍ"], "ㅀ": ["ㄹ", "ㅎ"], "ㅄ": ["ㅂ", "ㅅ"], "ㅆ": ["ㅅ", "ㅅ"]}
fix_double_final_letters = (f1, f2) ->
  for k, v of final_letter_map
    if v[0] == f1 and v[1] == f2
      return k
  return undefined
separate_double_final_letters = (f) ->
  #console.log "fixing double final letters"
  return final_letter_map[f]

convert_gksdud = (str) ->
  result = ""
  for i in [0...str.length]
    if cont > 0
      cont--
      continue
    #console.log i
    ch = str.charCodeAt i
    if ch >= 0xAC00 && ch <= 0xD7AF
      ch -= 0xAC00
      final_letter = ch % 28
      medial_letter = ((ch - final_letter) / 28) % 21
      initial_letter = (((ch - final_letter) / 28) - medial_letter) / 21

      result += qwerty[two_set_korean.indexOf initial_letters[initial_letter]].toLowerCase()
      # 일반적인 자음, 모음
      if (two_set_korean.indexOf medial_letters[medial_letter]) >= 0
        result += qwerty[two_set_korean.indexOf medial_letters[medial_letter]].toLowerCase()
      # 이중모음 처리
      else if (medial_letters.indexOf medial_letters[medial_letter]) >= 0
        for m in (separate_double_medial_letters medial_letters[medial_letter])
          result += qwerty[two_set_korean.indexOf m].toLowerCase()

      # 이중받침 처리
      if (two_set_korean.indexOf final_letters[final_letter]) >= 0
        result += qwerty[two_set_korean.indexOf final_letters[final_letter]]
      else if (final_letters.indexOf final_letters[final_letter]) >= 0 and (separate_double_final_letters final_letters[final_letter])
        for m in (separate_double_final_letters final_letters[final_letter])
          result += qwerty[two_set_korean.indexOf m].toLowerCase()

    else if (ch >= 0x1100 && ch <= 0x11FF) || (ch >= 0x3130 && ch <= 0x318E)
      # 영어는 무조건 소문자 처리
      # TODO: 이중모음 분리 처리, 맥/윈도우 자음처리 구분
      # 일반적인 자음, 모음
      if (two_set_korean.indexOf (str.charAt i)) >= 0
        result += qwerty[two_set_korean.indexOf (str.charAt i)].toLowerCase()
      # 이중모음 처리
      else if (medial_letters.indexOf (str.charAt i)) >= 0
        for m in (separate_double_medial_letters (str.charAt i))
          result += qwerty[two_set_korean.indexOf m].toLowerCase()
      # 받침 분리
      else if (final_letters.indexOf (str.charAt i)) >= 0
        for m in (separate_double_final_letters (str.charAt i))
          result += qwerty[two_set_korean.indexOf m].toLowerCase()
      else
        console.log "처리불가"

    else if (ch >= 0x0041 && ch <= 0x005A) || (ch >= 0x0061 && ch <= 0x007A)
      initial_index = initial_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt i)]
      # shift 오타 보정
      initial_index = initial_letters.indexOf two_set_korean[qwerty.indexOf ((str.charAt i).toLowerCase())] if initial_index == -1
      # 첫 글자가 초성에 해당되지 않는 경우
      if initial_index == -1
        mystery = two_set_korean[qwerty.indexOf (str.charAt i)]
        # shift 보정 한 번 해봄
        mystery = two_set_korean[qwerty.indexOf (str.charAt i).toLowerCase()] if mystery == undefined
        result += mystery
      # 첫 글자가 초성에 해당되는 경우
      else
        medial_index = medial_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt (i+1))]
        # shift 오타 보정
        medial_index = medial_letters.indexOf two_set_korean[qwerty.indexOf ((str.charAt (i+1)).toLowerCase())] if medial_index == -1 && (str.charAt (i+1)) != undefined
        # 두 번째 글자가 중성에 해당되지 않는 경우 더 이상 진행안함, 초성까지만 처리
        if medial_index == -1
          result += initial_letters[initial_index]
          #result += two_set_korean[qwerty.indexOf (str.charAt i)]
        else
          medial_space = 1
          medial_index2 = medial_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt (i+2))]
          # 만약 이중모음인 경우
          if medial_index2 != -1 && (fix_double_medial_letters(two_set_korean[qwerty.indexOf (str.charAt (i+1))], two_set_korean[qwerty.indexOf (str.charAt (i+2))])) != undefined
            medial_index = medial_letters.indexOf fix_double_medial_letters(two_set_korean[qwerty.indexOf (str.charAt (i+1))], two_set_korean[qwerty.indexOf (str.charAt (i+2))])
            medial_space++

          # 네 번째 글자가 모음인 경우 세 번째 글자는 다음 글자의 초성으로 처리됨 (초성+중성)
          if (str.charAt (i+medial_space+2)) != undefined && ((medial_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+2))]) != -1 || (medial_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+2)).toLowerCase()]) != -1)
            result += String.fromCharCode ((initial_index*21 + medial_index) * 28 + 0xAC00).toString()
            cont = medial_space
          # 세 번째 글자가 알파벳인 경우
          else if (str.charAt (i+medial_space+1)) == undefined || (qwerty.indexOf (str.charAt (i+medial_space+1))) == -1
            result += String.fromCharCode ((initial_index*21 + medial_index) * 28 + 0xAC00).toString()
            cont = medial_space
          else
            final_index = final_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+1))]
            final_index = final_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+1)).toLowerCase()] if final_index == -1 and (str.charAt (i+medial_space+1)) != undefined
            final_index2 = final_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+2))]
            final_index2 = final_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+1)).toLowerCase()] if final_index2 == -1 and (str.charAt (i+medial_space+2)) != undefined
            # 종성 + 초성 + 중성 형태 처리 (모음이 나오므로 필연적으로 자음이 올라감)
            if (medial_letters.indexOf two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+3))]) != -1
              result += String.fromCharCode ((initial_index*21 + medial_index) * 28 + final_index + 0xAC00).toString()
              cont = medial_space+1
            # 이중자음(종성) 확인
            else if final_index2 != -1 && (fix_double_final_letters(two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+1))], two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+2))])) != undefined
              final_index = final_letters.indexOf fix_double_final_letters(two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+1))], two_set_korean[qwerty.indexOf (str.charAt (i+medial_space+2))])
              result += String.fromCharCode ((initial_index*21 + medial_index) * 28 + final_index + 0xAC00).toString()
              cont = medial_space+2
            else
              result += String.fromCharCode ((initial_index*21 + medial_index) * 28 + final_index + 0xAC00).toString()
              cont = medial_space+1
              # console.log String.fromCharCode ((initial_index*21 + medial_index) * 28 + final_index + 0xAC00).toString()
    else
      result += (str.charAt i)
  return result
window.convert_gksdud = convert_gksdud