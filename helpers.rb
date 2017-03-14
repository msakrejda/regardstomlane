def find_last_sentence(email_body)
  if email_body =~ /(?:.*?[.!?]\s+)?((?:\w\.)*[^.]*(?:[.!?]| \.{3}))\s+regards, tom lane/im
    $1.gsub("\n", " ")
  end
end
