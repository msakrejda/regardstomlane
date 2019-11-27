def starts_sentence?(token)
  !token.nil? && token =~ /^(?:[A-Z]|\+1|\()/
end

def ends_sentence?(token)
  # True if it is two newlines (we assume sentences won't span
  # those), an ellipsis (as its own token since Tom separates it with
  # a space), or is *not* an initialism/acronym and it does start with
  # a letter and ends with a period, question mark or exclamation
  # mark, optionally followed by a closing parenthesis.
  token == "\n\n" || token == '...' || (
    token !~ /\A(?:[A-Z]\.)+\z/ &&
    token =~ /^([a-zA-Z]|:-\)).*(?:[.?!]\)?| ...)/
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
  parts.reverse.take_while do |token|
    # 4. Stop at token that ends the previous sentence if the last
    #    token starts the current sentence
    stop = starts_sentence?(previous) && ends_sentence?(token)
    if token =~ /\S+/
      previous = token
    end
    !stop
  end.reverse.map do |token|
    token == "\n" ? " " : token
  end.join.strip
end
