require 'bundler'
Bundler.require(:default, :test)

require_relative '../helpers'

describe "@regardstomlane" do
  tests = [
    [ "Hello. regards, tom lane", "Hello." ],
    [ "Hello? regards, tom lane", "Hello?" ],
    [ "Hello! regards, tom lane", "Hello!" ],
    [ "Hello world. regards, tom lane", "Hello world." ],
    [ "Hello\nworld. regards, tom lane", "Hello world." ],
    [ "Hello world. goodbye. regards, tom lane", "goodbye." ],
    [ "Hello world. goodbye.  regards, tom lane", "goodbye." ],
    [ "Hello world.\ngoodbye. regards, tom lane", "goodbye." ],
    [ "Hello world. goodbye. \n regards, tom lane", "goodbye." ],
    [ "Hello world. C.C.H. Pounder is an actor. regards, tom lane",
      "C.C.H. Pounder is an actor." ],
    [ "Hello world. C.C.H. pounder is an actor. B.D. Wong is also an actor. regards, tom lane",
      "B.D. Wong is also an actor." ],
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
