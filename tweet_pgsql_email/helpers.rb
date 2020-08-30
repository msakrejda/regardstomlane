def starts_sentence?(token)
  !token.nil? && (token == '??' || token =~ /^(?:[A-Z]|\+1|\()/)
end

def ends_sentence?(token)
  # True if it matches one set of specific tokens:
  #  * two or more newlines (we assume sentences won't span those)
  #  * an ellipsis (as its own token since Tom separates it with a space)
  #  * a numbered footnote reference [1], [2], etc.
  # Or it is *not* an initialism/acronym *and*
  #  * starts with a letter
  #  * ends with a period, question mark or exclamation mark
  #    - optionally followed by a closing parenthesis
  token =~ /(?:(?:[\r\n]|\r\n)\s*){2}/ || token == '...' || token =~ /\[\d+\]/ || (
    token !~ /\A(?:[A-Z]\.)+\z/ &&
    token =~ /^([a-zA-Z"]|:-\)).*(?:[.?!][\)"]?)$/
  )
end

def find_last_sentence(email_body)
  # 1. Match every line before "regards, tom lane" going back
  #    to just after after the last >quoted line (if any). We
  #    assume the last line is not going to span a quote and
  #    ignore any that do.
  unless email_body =~ /((?:^[^>].*?\n)+)\s*regards, tom lane/im
    return
  end

  # 2. Tokenize on whitespace
  parts = $1.scan(/\s+|\S+/)

  # 3. Go backwards through tokens starting at right before signature
  previous = nil
  last_sentence = parts.reverse.take_while do |token|
    # 4. Stop at token that ends the previous sentence if the last
    #    token starts the current sentence
    stop = starts_sentence?(previous) && ends_sentence?(token)
    if token =~ /\S+/
      previous = token
    end
    !stop
  end.reverse.map do |token|
    token =~ /\s+/ ? " " : token
  end.join.strip

  if last_sentence.end_with?(')') &&
     !last_sentence.start_with?('(')
    '(' + last_sentence
  else
    last_sentence
  end
end
