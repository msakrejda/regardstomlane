def find_last_sentence(email_body)
  if email_body =~ /(?:.*?[.!?]\s+)?((?:\w\.)*[^.]*(?:[.!?]| \.{3}))\s+(regards, tom lane|Greetings,\s+Andres)/im
    puts 'matched'
    $1.gsub("\n", " ")
  end
end
