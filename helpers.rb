def last_sentence(email_body)
  email_body =~ /(?:.*?[.!?]\s+)?((?:\w\.)*[^.]*[.!?])\s+regards, tom lane/im && $1
end
