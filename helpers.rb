def find_last_sentence(email_body)
  if email_body =~ /(?:.*?[.!?]\s+)?((?:\w\.)*[^.]*[.!?])\s+regards, tom lane/im
    $1.gsub("\n", " ")
  end
end
