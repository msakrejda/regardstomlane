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

regards, tom lane), "That presumes that this was an otherwise-unjustified OOM kill, which I'm not quite sure of ... but it does seem like a situation that could arise from time to time." ],
    [ %q(Alvaro Herrera  writes:
> I think odd coding this was introduced recently because of the
> pg_resetxlog -> pg_resetwal renaming.

Dunno about that, but certainly somebody fat-fingered a refactoring
there.  The 9.6 code looks quite different but doesn't seem to be
doing anything silly.

regards, tom lane), "The 9.6 code looks quite different but doesn't seem to be doing anything silly." ],
    [ %q(*** WARNING *** The program 'postgres' uses the Apple Bonjour compatibility layer of Avahi.
*** WARNING *** Please fix your application to use the native API of Avahi!
*** WARNING *** For more information see <http://0pointer.de/avahi-compat?s=libdns_sd&e=postgres>
2017-11-08 17:58:42.451 EST [23762] LOG:  DNSServiceRegister() failed: error code -65540

I wonder which libdns_sd you are using.

                        regards, tom lane), "I wonder which libdns_sd you are using." ],
    [ %q(> reasons mentioned in the comments in gen_qsort_tuple.pl, viz:
Some bogus content to force a failure.

+1 for somebody trying that (I'm not volunteering, though).
			regards, tom lane), "+1 for somebody trying that (I'm not volunteering, though)." ],
    [ %q(> Similarly for the changes in create_minmaxagg_path().

I'm sure you realize that's because the estimate is already just one
row ... but sure, we can spell that out.

                        regards, tom lane), "I'm sure you realize that's because the estimate is already just one row ... but sure, we can spell that out." ],
    [ %q(Thus, in your example, the sub-query should give

regression=# select 1 from dual where 0=1 group by grouping sets(());
 ?column? 
----------
        1
(1 row)

and therefore it's correct that

regression=# select count(*) from (select 1 from dual where 0=1 group by grouping sets(())) tmp;
 count 
-------
     1
(1 row)

AFAICS, Oracle and SQL Server are getting it wrong.

			regards, tom lane), "AFAICS, Oracle and SQL Server are getting it wrong." ],
    [ %q(BTW, in the back of my mind here is Chapman's point that it'd be
a large step forward in usability if we allowed Unicode escapes
when the backend encoding is *not* UTF-8.  I think I see how to
get there once this patch is done, so I definitely would not like
to introduce some comparable restriction in ecpg.

			regards, tom lane), "I think I see how to get there once this patch is done, so I definitely would not like to introduce some comparable restriction in ecpg." ],
    [ %q{I've not studied the test case too closely yet, other than to verify
that it does fail without the code fix :-).  Other than that, though,
I think this patch is committable for v11 through HEAD.

			regards, tom lane}, "Other than that, though, I think this patch is committable for v11 through HEAD." ],
    [ %q(That seems a bit premature --- the new patch is only a couple of days
old.  The CF entry should've been moved back to "Needs Review",
sure.

(Having said that, the end of the month isn't that far away,
so it may well end up in the next CF anyway.)

			regards, tom lane), "(Having said that, the end of the month isn't that far away, so it may well end up in the next CF anyway.)" ],
    [ %q(> That could be a way, yes. Any thoughts on this from others following this thread?

I whined about this on the tz mailing list, and got the attention of
the FreeBSD tzdata package maintainer [1].  It seems possible that he'll
change that policy, so I'd advise doing nothing until that discussion
settles.

			regards, tom lane

[1] https://mm.icann.org/pipermail/tz/2019-November/028633.html), "It seems possible that he'll change that policy, so I'd advise doing nothing until that discussion settles." ]
    ]

  tests.each do |(body, expected)|
    it "extracts '#{expected}' from '#{body}'" do
      result = find_last_sentence(body)
      expect(result).to eq(expected)
    end
  end
end
