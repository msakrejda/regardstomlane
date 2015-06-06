require_relative 'helpers'

tests = [
 [ "hello. regards, tom lane", "hello." ],
 [ "hello? regards, tom lane", "hello?" ],
 [ "hello! regards, tom lane", "hello!" ],
 [ "hello world. regards, tom lane", "hello world." ],
 [ "hello world. goodbye. regards, tom lane", "goodbye." ],
 [ "hello world. goodbye.  regards, tom lane", "goodbye." ],
 [ "hello world.\ngoodbye. regards, tom lane", "goodbye." ],
 [ "hello world. goodbye. \n regards, tom lane", "goodbye." ],
 [ "hello world. c.c.h. pounder is an actor. regards, tom lane",
   "c.c.h. pounder is an actor." ],
 [ "hello world. c.c.h. pounder is an actor. b.d. wong is also an actor. regards, tom lane",
   "b.d. wong is also an actor." ],
]

failed = 0

tests.each_with_index do |(body, expected), index|
  print "test #{index}: "
  result = last_sentence(body)
  if result == expected
    puts "ok"
  else
    failed += 1
    puts "fail: expected\n\t#{expected}\ngot\n\t#{result}"
  end
end

if failed.zero?
  puts "All #{tests.count} tests succeeded"
else
  puts "#{failed}/#{tests.count} tests failed"
end
