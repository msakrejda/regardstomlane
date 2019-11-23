require 'bundler'
Bundler.require(:default, :test)

require_relative '../helpers'

describe "@regardstomlane" do
  tests = [
    [ "Hello.\nregards, tom lane", "Hello." ],
    [ "Hello?\nregards, tom lane", "Hello?" ],
    [ "Hello!\nregards, tom lane", "Hello!" ],
    [ "Hello world.\nregards, tom lane", "Hello world." ],
    [ "Hello\nworld.\nregards, tom lane", "Hello world." ],
    [ "Hello world. Goodbye.\nregards, tom lane", "Goodbye." ],
    [ "Hello world.\nGoodbye.\nregards, tom lane", "Goodbye." ],
    [ "Hello world. C.C.H. Pounder is an actor.\nregards, tom lane",
      "C.C.H. Pounder is an actor." ],
    [ "Hello world. C.C.H. Pounder is an actor. B.D. Wong is also an actor.\nregards, tom lane",
      "B.D. Wong is also an actor." ],
    [ "Something something. There's definitely a CommandCounterIncrement in exec_execute_message ...\nregards, tom lane",
      "There's definitely a CommandCounterIncrement in exec_execute_message ..."],
    [ %q(Which is why we invented the ENCRYPTED PASSWORD syntax, as well as
psql's \password command ... but using that approach for actual
login to an account would be a security fail as well.



			regards, tom lane), "Which is why we invented the ENCRYPTED PASSWORD syntax, as well as psql's \\password command ... but using that approach for actual login to an account would be a security fail as well." ],
    [ %q(Merlin Moncure <mmoncure(at)gmail(dot)com> writes:
> This is working great.  Is there anything left for me to do here?

Nope, it's committed.
			regards, tom lane), "Nope, it's committed." ],
    [ %q((Said coverage is only marginally
better than what we get without running the bloom TAP test, AFAICT.)

It seems like some effort could be put into both shortening this test
and improving the amount of code it exercises.

                        regards, tom lane), "It seems like some effort could be put into both shortening this test and improving the amount of code it exercises." ],
    [ %q(> Why "AS" is throwing an error ?

"AS" is part of SELECT-list syntax, not ROW(...) syntax.

Even if it were allowed in ROW(), it would be totally pointless in
this context, because when you cast the ROW() result to the
ap.validate_crtr_line_items$inv_lines_rt composite type, that type
is what determines the column names.

        regards, tom lane), "Even if it were allowed in ROW(), it would be totally pointless in this context, because when you cast the ROW() result to the ap.validate_crtr_line_items$inv_lines_rt composite type, that type is what determines the column names." ],
    [ %q(What might be worth thinking about is allowing the syslogger process to
inherit the postmaster's OOM-kill-proofness setting, instead of dropping
down to the same vulnerability as the postmaster's other child processes.
That presumes that this was an otherwise-unjustified OOM kill, which
I'm not quite sure of ... but it does seem like a situation that could
arise from time to time.

regards, tom lane), "That presumes that this was an otherwise-unjustified OOM kill, which I'm not quite sure of ... but it does seem like a situation that could arise from time to time." ]
    ]

  tests.each do |(body, expected)|
    it "extracts '#{expected}' from '#{body}'" do
      result = find_last_sentence(body)
      expect(result).to eq(expected)
    end
  end
end
