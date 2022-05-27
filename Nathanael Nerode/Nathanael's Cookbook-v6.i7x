Version 6.0.220522 of Nathanael's Cookbook by Nathanael Nerode begins here.

"This is just a collection of documentation and worked examples illustrating various features of Inform.  There isn't much in the extension per se, but the examples in the documentation can be click-pasted in the Inform IDE for convenience."

Nathanael's Cookbook ends here.

---- DOCUMENTATION ----

This is a collection of examples and documentation.  The documentation hopes to make up to some degree for the lack of an Inform reference manual.

Chapter - Line Breaks and Paragraph Breaks

Controlling Inform 7's line breaks is a well-known headache, and this is largely due to poor documentation, along with the compiler's ineffective attempts to guess what the game writer wanted.  This documentation should give you enough power to defeat it, though.

Inform 7 has two separate and largely-independent systems for generating line breaks: the paragraph break system and the line break system.

Section - The Line Break System

(A) The line break system is supposed to generate a single newline, without any blank lines. The line break system is extremely rigid.  Things you need to know about it:

(1) The clean way to invoke it is "[line break]".

(2) Every time you invoke
	say "Something with a period just before a closing quote.";
Inform 7 will add an implicit [line break].

(3) Nearly every time you invoke
	say "Something with a period just before a left bracket.[if true] This one too.[end if]";
Inform 7 will add an implicit [line break] just before the left bracket.

(4) These can be suppressed with explicit [no line break]:
	say "Something with a period.[no line break][if true] This one too.[no line break][end if]";

(5) These can also be suppressed by adding a space after the period, since it only checks if the period is *immediately* before the close quote or left bracket.

(6) The same happens with question marks or exclamation points.

(7) Under the hood, what happens is that the left bracket usually breaks the text into multiple "blocks", each of which effectively gets its own say statement.  (But not always; the left bracket in "[no line break]" doesn't create extra "blocks", for example.)

(8) This implicit line break only happens in the direct, immediate argument to a say statement.  You can avoid it reliably by assembling text in a "to decide what text is" routine:
	to decide what text is the magic invocation:
		decide on "Abracadabra!";
This will not generate any line breaks at all when you write
	say "[magic invocation]";

Section - The Paragraph Break System

The paragraph break system is designed to generate a full blank line between paragraphs.  Things you need to know about it:

(1) The paragraph break system works by producing one extra newline.  So it only works as intended if the paragraph break comes *immediately after a line break*.  Otherwise it'll end up being a single newline rather than a blank line.  So you must be careful to emit a line break before your paragraph division point.

(2) Unlike the line break which is emitted immediately, the paragaph break is delayed and admitted just *before* the next rule (such as printing the prompt).  Furthermore, it is typically only emitted before a rule of the sort which would emit a paragraph break, not the other sort.  This can lead to great confusion.

(3) The paragraph break system is documented in Internal/I6T/Printing.i6t.  Not the most convenient location, but there is actually complete documentation there.  Search the file for "paragraph break", and read it.

(4) Every action rule (but not activities rules) generates an implicit paragraph break at the end.  To suppress the implicit paragraph break, the action rule must say
	"[run paragraph on]";
as the very last say-statement in the rule.

(5) In fact, every rulebook can be followed either with or without implicit paragraph breaks, in a manner which requires fancy I6 hacking.  Search "Internal/Extensions/Graham Nelson/Standard Rules.i7x" for "FollowRulebook" for more information.

(6) By default, all action-based or nothing-based rulebooks, including those you write and all activities, will add the implicit paragraph break.

(7) By default, all number-based, object-based, scene-based (etc.) rulebooks will NOT add implicit paragraph breaks.

Section - Recommendations

(A) Preventing unwanted single line breaks.

(1) If you're assembling a line from individual words or sentences, from little pieces, use "to decide what text is ____", which avoids all the implicit line breaks.
(2) Then use one say statement per intended output line.
(3) If you have to use multiple say statements for stuff you want on one line (perhaps because they are generated by multiple rules):
(3A) terminate them all with spaces.  The extra space before the final line break is usually invisible, though it may occasionally confuse interpreter word-wrap.
(3B) keep track of whether you said anything at all (to avoid an extra line break if you said nothing);
(3C) have a bit at the very end which does something like:
	if something was printed, say "[line break]";
(4) This is a decent use of an activity (or another object-based or value-based rulebook).

(B) Preventing unwanted double line breaks.

(1) Generate an entire paragraph in one action rule.
(2) If you need multiple rules for one paragraph, set up an activity, or another object-based or value-based rulebook, to do so, and invoke it from one action rule.
(3) If you have to use multiple action rules, have each one produce a line, and end every one with:
	say "[run paragraph on with special look spacing]";
and have one special rule which runs last and does not have that line -- this rule, by its existence, triggers the paragraph break.  You may want to try putting one of these lines into it, but they could mess up your text spacing:
	say "[paragraph break]";
	say "[conditional paragraph break]";
(4) Unlike in the line break case, Inform is supposed to keep track of blanks here.

(C) Preventing unwanted triple line breaks.

(1) These are almost always due to "blanks": sets of rules which were supposed to produce text which produced nothing, but issued a paragraph break (often explicitly).

(D) Making sure double line breaks happen where desired

(1) Make sure the last say statement before any paragraph break emits a line break.
(2) Make sure that every paragraph-generating machinery ends with a conditional paragraph break.

(E) Making sure single line breaks happen where desired

(1) Make sure there *isn't* a paragraph break.
(2) Make sure there *is* a line break.
(3) You can get a single line break from a paragraph break without a line break, but this is undesirable and always a bug.

Section - Changelog

	6.0.220522: First version for Inform 10.1.  Increment major version to deal with a version number SNAFU.

Section - The Cookbook Proper

Here is the main Cookbook.

Example: * Line Breaks - Understand when Inform implicitly emits line breaks

	*: "Line Breaks"

	The story author is "Nathanael Nerode".
	The release number is 2.

	Section - Everyone's Favorite Test Verb

	The bedroom is a room.
	The bauble is a thing in the bedroom.

	Learning Line Breaks is a scene.
	Learning Line Breaks begins when play begins.

	The block thinking rule is not listed in any rulebook.
	test me with "think".

	Carry out thinking (this is the first thinking rule):
		[#1.  Generates 2 spurious line breaks, then one correct one at the end.]
		say "I am tired of Inform's line break algorithm.[if the player has the bauble] So tired.[end if] It is confusing.";
		[#2. Suppress line breaks.]
		say "I am tired of Inform's line break algorithm.[no line break][if the player has the bauble] So tired.[no line break][end if] It is confusing.";
		[#3. Suppress line breaks by putting trailing spaces instead of leading.]
		say "I am tired of Inform's line break algorithm. [if the player has the bauble]So tired. [end if]It is confusing.";

	Carry out thinking (this is the second thinking rule):
		say "Inform's paragraph break system is almost as confusing."; [Note, line break at end.]
		say "It adds a paragraph break, a.k.a. an extra line break, at the end of each action rule (but not activities rules)...";
		say "But what if there is no line break at the end of the rule, as with";

	Carry out thinking (this is the third thinking rule):
		say "...what you just saw?  Then the paragraph break happens (looking like a line break) but not the line break.[no line break][run paragraph on]";

	Carry out thinking (this is the fourth thinking rule):
		say "..although there is a way to suppress the paragraph break.";

	to decide what text is the first special sentence:
		if the player has the bauble:
			decide on "The automatic line breaking only applies in the immediate, direct argument to a say phrase.";
		otherwise:
			decide on "The automatic line breaking only applies in say phrases.";

	to decide what text is the second special sentence:
		decide on "If you assemble phrases using 'to decide what text is', you don't trigger it.";

	Carry out thinking (this is the fifth thinking rule):
		[ Fails to break line.]
		say "[first special sentence] [second special sentence]";
		[ Does break line.]
		say "[first special sentence] [second special sentence][line break]";

	Whinging is a rulebook. [action-based]

	Whinging (this is the first whinging rule):
		say "Does this generate a paragraph break?";
	Whinging (this is the second whinging rule):
		say "Looks like it!  But note that the paragraph break pending actually is executed at the start of the next action rule.";

	Pondering is an object based rulebook.

	Pondering a thing (called item) (this is the first pondering rule):
		say "Does pondering [item] generate a paragraph break?";
	Pondering  (this is the second pondering rule):
		say "It doesn't!  And also leaves out the pending paragraph break from the other rulebook.";

	Imagining is a number based rulebook.

	Imagining a number (called n) (this is the first imagining rule):
		say "Does imagining [n] generate a paragraph break?";
	Imagining (this is the second imagining rule):
		say "It doesn't!  And the pending paragraph break comes in at the very end.";

	Visualizing is a scene based rulebook.
	Visualizing a scene (called context) (this is the first visualizing rule):
		say "Does visualizing [context] generate a paragraph break?";
	Visualizing  (this is the second visualizing rule):
		say "It doesn't!  And the pending paragraph break comes in at the very end.";

	Woolgathering is a nothing based rulebook.
	Woolgathering (this is the first woolgathering rule):
		say "Does a nothing-based rulebook generate a paragraph break?";
	Woolgathering (this is the second woolgathering rule):
		say "It does!"

	Carry out thinking (this is the sixth thinking rule):
		say "It gets way complicated with extra rulebooks.";
		follow the whinging rulebook;
		follow the pondering rulebook for the bauble;
		follow the imagining rulebook for 7;
		follow the whinging rulebook;
		follow the visualizing rulebook for Learning Line Breaks;
		say "But the pending paragraph break doesn't happen if there's not an action rule starting! And for our final hurrah...";
		follow the woolgathering rulebook;

	Rubbernecking is an action-based rulebook.
	[Action-based and nothing-based seem to be identical.]
	Rubbernecking (this is the first rubbernecking rule):
		say "Does rubbernecking generate a paragraph break?";
	Rubbernecking (this is the second rubbernecking rule):
		say "Looks like rubbernecking does!  But note that the paragraph break pending actually is executed at the start of the next action rule, ";
		say "or in this case, by mysterious internal workings between the last specific action processing rule and 'a first turn sequence rule'. ";
		say "Try RULES ON to see the details.";

	Carry out thinking (this is the seventh thinking rule):
		follow the rubbernecking rulebook;


Chapter - Everything Else

And now for the other examples.

Example: * Careful Startup -- displaying messages at the right time during startup

	*: "Careful Startup"

	Bedroom is a room.

	The description of Bedroom is "There's a double bed here."

	A bed is a kind of supporter.
	The latticework double bed is a bed in the bedroom.
	The description of the latticework double bed is "It's a double bed with a latticework headboard."
	
	The player is on the latticework double bed.  [This is the correct way to set a starting location.]

	This is the teaser rule:
		say "Nightmares.  Fear.  Running."

	The teaser rule is listed before the display banner rule in the startup rulebook.

	This is the introduce the game rule:
		say "You blearily open your eyes, shaking away dreams.  You're in your bed."

	The introduce the game rule is listed before the initial room description rule in the startup rulebook.
	[Note: "After the display banner rule" won't work, it'll end up after the initial room description.]

	This is the just before the prompt rule:
		say "Maybe you should get up.[line break][paragraph break]";
		[ Note: [paragraph break][line break] will give TWO blank lines after this.
			[paragraph break] alone, [line break] alone, or neither will give NO blank lines.
			This is the way to give the standard ONE blank line before the prompt.
		]

	The just before the prompt rule is listed after the initial room description rule in the startup rulebook.

	[ This is the default order of the startup rulebook:
	First come the very basic rules:
		initalize memory rule
		seed random number generator rule
		update chronological records rule
		declare everything initially unmentioned rule
		position player in model world rule
		start in the correct scenes rule
	Then come the so-called "mid-placed rules":
		when play begins stage rule
		fix baseline scoring rule
		display banner rule
		initial room description rule
	]

Example: * Mention Unmention -- controlling whether something is mentioned

	*: "Mention Unmention"

	To say mention (item - a thing):
		now item is mentioned;

	To say unmention (item - a thing):
		now item is not mentioned;

	A fruit is a kind of thing.
	A banana is a fruit.  The description of the banana is "It's a banana."
	An orange is a fruit.  The description of the orange is "It's an orange."
	A kiwi is a fruit.  The description of the kiwi is "You didn't notice it at first, but that's definitely a kiwi.";

	Fruit Room is a room.
	"This is a room for displaying fruit, such as [a list of fruit].[unmention banana][unmention orange]";

	The banana and the orange are in the fruit room.

Example: * Examine Room -- putting the room in scope

If you're in a room called "Main Street", you probably want "look at main street" to work.  By default, it doesn't.

	*: "Examine Room"

	Main Street is a room.
	"This is the center of the city, where it all happens!"

	After deciding the scope of an object (called character) (this is the put room in scope rule):
		Place the location of the character in scope, but not its contents.

	Rule for deciding whether all includes rooms:
		it does not.

	test me with "examine street/examine main street/take all".

Example: * Meeting Place -- using arbitrary binary relations

Use the full power of arbitrary binary relations, which are poorly documented in the Inform 7 manual.  Show how to specify an action applying to a thing in the room and a thing not in the room.

	*: "Meeting Place"

	Meeting Place is a room.

	A government is a kind of thing.

	[In an earlier version, I used "US" here, but Inform 10.1.0 misinterprets that as the word "us".  So it's "USA".]

	USA, UK, France, Germany, Russia, China, India, Pakistan are governments.

	Alpha, Beta, Gamma, Delta, Epsilon are people in Meeting Place.

	Trusting relates various people to various governments.
	The verb to trust means the trusting relation.

	Alpha trusts USA.  Alpha trusts UK.
	Beta trusts USA.  Beta trusts France.
	Gamma trusts China.  Gamma trusts France.

	Understand "ask [someone] about [any government]" as asking it opinion about.
	Asking it opinion about is an action applying to one thing and one visible thing.
	[Note the completely misleading and perverse use of "visible thing" to mean "thing not necessary touchable".]

	Report asking a person (called who) opinion about a government (called what):
		if who trusts what:
			say "[Who] [say] 'Great country, I'd love to live there.'";
		else:
			say "[Who] [say] 'Nice people there, but I wouldn't want to live under their government.'";

Example: *** Confusion -- polite responses for failed commands to actors

The default "There is no reply" is completely surreal for certain types of games.  This gives a reply which a *compliant* person might give.

	*: "Confusion"

	The Lounge is a room.  "It's a lounge."

	Alan is a man in the lounge.  Ella is a woman in the lounge.

	Persuasion rule for asking Alan to try doing something: persuasion succeeds.
	Persuasion rule for asking Ella to try doing something: persuasion succeeds.

	The confused by command rule is listed before the block answering rule in the report answering it that rulebook.

	Report an actor answering someone that (this is the confused by command rule):
		["noun, gibberish" is converted into "answer noun with the topic understood"]
		if the actor is the player:
			[The alternative is ordering someone else to say something]
			now the prior named object is nothing;
			say "[Noun] [seem] confused by your request." (A);
		stop the action.

	Table of Alan's Confusion Responses
	Response
	"[Noun] [look] at [us], perplexed, and [regarding noun][say] 'I don't know what you mean by ['][the topic understood]['].'"
	"[Noun] [say] 'I didn't understand that, dear.'"
	"[Noun] [say] 'Did you say ['][the topic understood][']?'  [They] [look] confused."

	Report an actor answering Alan that (this is the Alan is confused by command rule):
		["noun, gibberish" is converted into "answer noun with the topic understood"]
		if the actor is the player:
			[The alternative is ordering someone else to say something]
			now the prior named object is nothing;
			choose a random row from the Table of Alan's Confusion Responses;
			say response entry;
		stop the action.

	Table of Ella's Confusion Responses
	Response
	"[Noun] [look] at [us], perplexed, and [regarding noun][say] 'I don't get what you mean by ['][the topic understood]['].'"
	"[Noun] [say] 'I didn't understand that, darling.'"
	"[Noun] [say] 'Did you say ['][the topic understood][']?'  [They] [look] puzzled."

	Report an actor answering Ella that (this is the Ella is confused by command rule):
		["noun, gibberish" is converted into "answer noun with the topic understood"]
		if the actor is the player:
			[The alternative is ordering someone else to say something]
			now the prior named object is nothing;
			choose a random row from the Table of Ella's Confusion Responses;
			say response entry;
		stop the action.

Example: *** Early Command Parsing -- process certain commands specially

This is an offcut from Compliant Characters.i7x.  While I found a much better way to do what I needed there, the code pattern serves as reference for the hooks available in early parsing.

	*: "Early Command Parsing"

	Use command debugging translates as (- CONSTANT COMMAND_DEBUGGING; -).

	Section - Say quoted text

	Original say verb name is a text that varies.

	[It's essentially impossible to match quotation marks with standard grammar tokens; they attach to neighboring words.  Must match with regexes.]

	After reading a command (this is the say quoted text conversion rule):
		let cmdline be text;
		let cmdline be the player's command;
		let command found be false;
		now original say verb name is "";
		let commandee name be text;
		let quoted order be text;
		if cmdline exactly matches the regular expression "(?i)\s*(say)\s*[quotation mark](.*)[quotation mark]\s*to\s*(.*)":
			[ say "something" to someone -- with the double quotation marks ]
			now command found is true;
			now original say verb name is "[text matching subexpression 1]";
			now commandee name is "[text matching subexpression 3]";
			now quoted order is "[text matching subexpression 2]";
		otherwise if cmdline exactly matches the regular expression "(?i)\s*(tell)\s*(<^[quotation mark]>*)[quotation mark](.*)[quotation mark]\s*":
			[ tell someone "something" -- with the double quotation marks ]
			now command found is true;
			now original say verb name is "[text matching subexpression 1]";
			now commandee name is "[text matching subexpression 2]";
			now quoted order is "[text matching subexpression 3]";
		if command found is true:
			let new_cmdline be the substituted form of "[commandee name], [quoted order]";
			if the command debugging option is active:
				say "Original verb: [original say verb name].  Command: [new_cmdline][line break]";
			change the text of the player's command to new_cmdline;

	The testing location is a room.
	Barbie is a person in the testing location.
	The widget is a thing in the testing location.
