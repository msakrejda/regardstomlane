require 'bundler'
Bundler.require(:default, :test)

require_relative '../helpers'

describe "@regardstomlane" do
  tests = [
    [ "hello. regards, tom lane", "hello." ],
    [ "hello? regards, tom lane", "hello?" ],
    [ "hello! regards, tom lane", "hello!" ],
    [ "hello world. regards, tom lane", "hello world." ],
    [ "hello\nworld. regards, tom lane", "hello world." ],
    [ "hello world. goodbye. regards, tom lane", "goodbye." ],
    [ "hello world. goodbye.  regards, tom lane", "goodbye." ],
    [ "hello world.\ngoodbye. regards, tom lane", "goodbye." ],
    [ "hello world. goodbye. \n regards, tom lane", "goodbye." ],
    [ "hello world. c.c.h. pounder is an actor. regards, tom lane",
      "c.c.h. pounder is an actor." ],
    [ "hello world. c.c.h. pounder is an actor. b.d. wong is also an actor. regards, tom lane",
      "b.d. wong is also an actor." ],
    [ "Something something. There's definitely a CommandCounterIncrement in exec_execute_message ...\nregards, tom lane",
      "There's definitely a CommandCounterIncrement in exec_execute_message ..."]
  ]

  tests.each do |(body, expected)|
    it "extracts '#{expected}' from '#{body}'" do
      result = find_last_sentence(body)
      expect(result).to eq(expected)
    end
  end
end
