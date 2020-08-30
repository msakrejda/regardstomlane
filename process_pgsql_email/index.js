exports.handler = async (event) => {
  const matchingEmails = findMatchingEmails(event);
  const lastSentences = matchingEmails.map(email => findLastSentence(email))

  const response = {
    statusCode: 200,
    body: JSON.stringify('Hello from Lambda!'),
  };
  return response;
};

const startsSentence = (token) => {
  return token != null && (token == '??' || /^(?:[A-Z]|\+1|\()/.test(token))
}

const endsSentence = (token) => {
  // True if it matches one set of specific tokens:
  //  * two or more newlines (we assume sentences won't span those)
  //  * an ellipsis (as its own token since Tom separates it with a space)
  //  * a numbered footnote reference [1], [2], etc.
  // Or it is *not* an initialism/acronym *and*
  //  * starts with a letter
  //  * ends with a period, question mark or exclamation mark
  //   - optionally followed by a closing parenthesis
  /(?:(?:[\r\n]|\r\n)\s*){2}/.test(token) || token == '...' || /\[\d+\]/.test(token) || (
    !(/\A(?:[A-Z]\.)+\z/.test(token)) &&
    /^([a-zA-Z"]|:-\)).*(?:[.?!][\)"]?)$/.test(token)
  )
}

const findLastSentence = (email_body) => {
  // 1. Match every line before "regards, tom lane" going back
  //    to just after after the last >quoted line (if any). We
  //    assume the last line is not going to span a quote and
  //    ignore any that do.
  const match = email_body.match(/((?:^[^>].*?\n)+)\s*regards, tom lane/im)
  if (!match) {
    return
  }
  const emailEnd = match[1]

  // 2. Tokenize on whitespace
  parts = emailEnd.split(/\s+/)

  // 3. Go backwards through tokens starting at right before signature
  previous = nil
  last_sentence = parts.reverse.take_while do |token|
    // 4. Stop at token that ends the previous sentence if the last
    //    token starts the current sentence
    stop = starts_sentence?(previous) && ends_sentence?(token)
    if token =~ /\S+/
      previous = token
    end
    !stop
  end.reverse.map do |token|
    token =~ /\s+/ ? " " : token
  end.join.strip

  if (lastSentence.endsWith(')') && !lastSentence.startsWith?('(')) {
    return '(' + lastSentence;
  } else {
    return lastSentence;
  }
}