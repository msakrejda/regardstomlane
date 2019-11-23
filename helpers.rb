def maybe_starts_sentence(token)
  !token.nil? && token =~ /^[A-Z]/
end

def maybe_ends_sentence(token)
  token !~ /\A(?:[A-Z]\.)+\z/ &&
    token =~ /[a-zA-Z]+(?:[.?!]\)?| ...)/
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
    # 4. Stop at token that ends the previous sentence:
    #    a. is the following (i.e., previous, since we're going backwards) word capitalized?
    #    b. if so, does this word end in a period, question mark or exclamation mark,
    #       optionally followed by a closing parenthesis?
    keep_going = !(maybe_starts_sentence(previous) && maybe_ends_sentence(token))
    if token =~ /\S+/
      previous = token
    end
    keep_going
  end.reverse.map do |token|
    token == "\n" ? " " : token
  end.join.strip
end
