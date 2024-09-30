
//Original Casino Code created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 for use with VOREstation

//
//Casino Manual - NEEDS EDITING
//
/obj/item/book/manual/casino
	name = "A dummy guide to losing your thalers"
	icon = 'icons/obj/casino.dmi'
	icon_state ="casinomanual"
	author = "Sleazy Serpent Saren"
	w_class = 2 // To allow it to be stuffed away into wallets for easy readings during events
	title = "A dummy guide to losing your thalers"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Foreword">Foreword: Welcome to gambling!</a></li>
					<li><a href="#Blackjack">Blackjack</a></li>
					<li><a href="#Roulette">Roulette</a></li>
					<li><a href="#Poker">Poker</a></li>
					<li><a href="#CoH">Cards against the galaxy</a></li>
					<li><a href="#Prizes">Prizes</a></li>
					<li><a href="#SentientPrizes">Sentient prizes</a></li>
				</ol>
				<br>
				<h1><a name="Foreword">Foreword: Welcome to gambling!</a></h1>
				In this book I'll teach you all about how to gamble your money away or at least get lucky and win some! This book also has a handy little overview of the prizes one can earn and the limitations of what can do with the living and breathing ones.<br>
				(This book will also contain out of character information to help people be aware of how touchy subjects like sentient prizes are to be handled.)

				<h1><a name="Blackjack">Blackjack</a></h1>
				First up is the classic sport of blackjack, blackjack is played normally between a gambler and a dealer, the goal is to have the higher number than the opponent but not go above 21 or it will be a bust and one loses automatically. <br>
				The values of cards are as follow:
				<ul>
					<li>Ace - 1 or 11, can be freely decided at any moment</li>
					<li>2 - 10 - value corresponding to their number</li>
					<li>All face cards excluding joker - Value of 10</li>
				</ul>
				A game of blackjack begins with the dealer giving the gambler two cards, in normal blackjack all cards dealt to gambler and dealer are always shown. The two cards dealt have their values put together, the gambler has three choices, stand, hit, or double down.
				<ul>
					<li>Stand - Gambler or dealer decides not to draw any more cards and it becomes the dealers turn or ends.</li>
					<li>Hit - 10 - The dealer draws a new card, adding to the existing hand, if its a bust the game will end and they will lose.</li>
					<li>Double down - A risky move the gambler can do, the dealer draws one more card and the bet is doubled, but no more cards can be drawn and it becomes the dealer's turn.</li>
				</ul>
				When it becomes the dealer's turn they do the same as the gambler, though their only goal is to get a higher or equal value to gambler. The dealer cant double down, and the large majority of casino's has the rule that a dealer cant draw anymore cards once they reach or go above a value. The most common value is 17, and there are two variants to that rule, soft and hard 17.
				<ul>
					<li>Soft 17 - If the gambler gets 17, they can draw another card.</li>
					<li>Hard 17 - They dealer must stop if they get a value of 17.</li>
				</ul>
				The casino who supplies this version of the manual follows the rule of hard 17. <br>
				The game ends when the dealer busts, reaches the threshold of what they are allowed to draw, or if they get a higher value than the gambler. Again, the one who has the highest value that isn't higher than 21 wins, but if both has the same value no one wins and the bet goes back to the gambler. <br>
				And that's it! Now go out there and gamble your savings away! This casino allows bets between 5 and 50 with double down ignoring that limit! <br><br>

				But wait! There's more! There's also group blackjack! This game is a little different, the dealer can be part of it or simple deal for players, this game works differently with everyone keeping their hands hidden, everyone makes initial bets, gets two facedown cards, then its a matter of trying to get as good a hand as possible, but if you go bust, its over. But don't tell or show until everyone reveals! If your going down, its best if your opponents don't know they simply can play safe and win, if you're lucky everyone else gets themselves busted and you don't lose your beloved chips! <br>
				Its kinda like Texas hold em in a way, everyone draws, folks can raise bets or fold, then draw more. Rinse and repeat until no one wants to raise any more nor draw cards, if everyone except one person has folded, they win by default even if they have busted, cause they don't need to reveal their hand that game, so you can choose to either sit and wait and fold if someone raise the bets, or you can gamble and make it look like you have an amazing hand and win by default since everyone else folds and no one is wise that you had a bust! This game has turned from simple probability and chance against the dealer to a game of risk and deception, fun fun fun!

				<h1><a name="Roulette">Roulette</a></h1>
				So this game of roulette is all about chance! what happens is that people bet on different odds and hope for the best as the dealer rolls the ball and makes that roulette thingy make than fun addicting spin! Once it lands on a number between 0 and 36 its either bust or payout! Pretty simple, right? <br>
				Everyone starts by putting their bets down, people can bet more than once before the ball goes rolling, the odds and their payoffs are these:
				<ul>
					<li>Single number - 35/1 payoff - The most unlikely one to get, but if the ball lands on your number, then you're loaded!</li>
					<li>Split Number - 17/1 - Choose an interval of 2, not very likely and therefore big reward!</li>
					<li>Row - 11/1 - Choose an interval of 3, more likely so not the biggest outcome!</li>
					<li>Split - 8/1 - Choose an interval of 4, not gonna win big time.</li>
					<li>Split row - 5/1 - Choose an interval of 6, getting to the safer bets.</li>
					<li>Column - 2/1 - Choose an interval of 12, boring, but likely.</li>
					<li>Red/Black or even/odd numbers - 1/1 - Odd or even numbers explains themselves. Red numbers are from 0 to 11 and 18 to 29 while the rest is black. These are the safest bets there are!</li>
				</ul>
				There's not much more to it! Bets made, ball rolls, number announced, people win, people lose! Bets allowed here are from 1 to 25 per bet. Oh, I'm also being told this casino has the fancy rule that if ball lands on 0, one wins at least one bet no matter what it is! So lets hope you got that big bet on a single number!

				<h1><a name="Poker">Poker</a></h1>
				Aaah yes, good old poker. This casino runs by the rules of Texas hold em, though the might be a little modified to be simpler for the average joe. In a game of poker it can be a single gambler and a dealer against each other, but most often its the dealer making the game proceed while several gamblers fights tooth and nail to steal each others chips, but the dealer can still join in on the free for all if they so wish! <br>
				To simply explain the game, people gamble with each other, a game of trying to get the best hand and raise bets or back out depending on what the outcome may be. The game starts with everyone betting a certain amount, it can be 5 or 10 chips depending on dealer, but if one wants to join, there needs to be chips on that table! Once everyone has made their initial bet, everyone gets two cards face down, these are kept hidden, no one not even dealer gets to see players cards until the end, not even folded cards are to be shown unless wanted to, sometimes its better making people unsure if you dropped out with bad cards or if you have other motives, deception is a large part of this game! <br>
				With everyone having cards dealt, its time for the dealer to lay three on the table face up, these cards are 3 of 5 cards in the community pool, everyone can use these cards to make sets like pairs and such, this doesn't mean they are taken, multiple people can use the same community card for their own sets! <br>
				With the community having three we enter the second betting stage, here people have two options, standing or raising. Standing means you don't want to raise, raising explains itself, though if someone bets, people have three options, commit putting the chips in to risk as much as the raised bet, but if one doesn't have enough, then they can still go all in with their remaining chips, one can also drop out if its too risky, the chips bet will remain on the table, but at least you wont lose more eh? Final one is to raise further, sometimes people can dare each other to raise more, but its not allowed for someone to raise, then raise further if no one else raises after them! <br>
				As said earlier, we got like a community pool of 5 cards total, this time another card is revealed and we enter a new betting phase, then the final fifth card is revealed and final bets are made, and then the cards are revealed so it can be determined who has the best hand! If two or more have equally good sets, then the chips are split evenly between them. <br>
				But notice, if someone is left because everyone else didn't dare to raise with their bet, they can decide to not reveal their hand, they might have had a winning hand, or maybe its terrible and they just bluffed their way to victory, only they know and can decide if they want to expose their cards to gloat or confuse their opponents. So in summary, the game can be simple, but hard to master! <br><br>
				And here is the order of winning hands folks!
				<ul>
					<li>Royal flush - The big and best one, this is a set of a 10, Ace, Knave/Jack, Queen and King of the same suit.</li>
					<li>Straight flush - This one is also definitely a winner, though can be easier to get as it just needs to be five cards making a straight of the same suit, an example being black 3 to 7.</li>
					<li>Four of a kind - Nice one, if you get this then you got a good chance to win. The value of the cards determine who wins, so ace is the best followed by king, queen and jack, then the peasant number cards!</li>
					<li>Full House - This one is good, but it requires you have three of a kind and a two of a kind, obviously value is part of the house, so the best roof is made of Ace with king making a strong foundation!</li>
					<li>Flush - This one requires the gambler to have 5 cards of a suit, not in any order, but the highest value card determines worth, so hope you got an Ace in your combo!</li>
					<li>Straight - Its like the royal flush, but can be any suits in combo, Ace can be lowest from Ace to 5 or highest from 10 to Ace!</li>
					<li>Three of a kind - Explains itself well enough, get three together and you got something going, lets hope you can build a house!</li>
					<li>Two pairs - You almost got yourself a house! But at least at this point its something!</li>
					<li>A pair - The worst set you can get, but you might be extremely lucky and have this while others have an inferior pair or the worst possible hand ever which is...</li>
					<li>High card - The absolute worst, if you cant get any of those sets, then you got this sad case, if a game manages to end with no one getting a set, then the one with the highest value cards wins!</li>

				</ul>
				Wew, what a long lesson, but that's how one does the Texas hold em here at this casino, hope you guys have fun winning and losing your hard earned cash with this one!

				<h1><a name="CoH">Cards against the galaxy</a></h1>

				So hear this, NT is now sponsoring team building at the casino, so folks who wants to just relax with friends, play some games, earn chips with no risk, even the ones broke can join in on a fun game of Cards against the galaxy and have fun! <br>
				The idea is that once a round has concluded and a casino member is present to see the game being actually played, everyone gets 10 chips while the one who won the round gets 25 instead! Interested? Good! Its easy and simple to play and very fun and vulgar! <br><br>

				The game is best played with at least 4 players and starts with everyone drawing 7 white cards, the person who most recently pooped starts as the 'card czar', but folks can agree on another criteria for the czar or simply pick one. Each round the current card czar draws a black card that has text written on it and blank lines, everyone aside from the czar takes a white card from their hand for every blank line which they find funny in that sentence and puts on the table face down with the others. The card czar cant know who has which white card and simply reads the black card with the white ones, the most funniest combination is chosen by the czar and the one who made that combination is the current rounds winner and the next rounds czar. At the end of each round everyone makes sure to draw enough white card to have 7 on hand and if there's a casino staff member playing or watching, they note down or hand out chips for everyone, and if they are playing, they get to add chips to their own personal stockpile too! <br>
				That's it for cards against the galaxy! Simple, fun and vulgar, what's there not to love?

				<h1><a name="Prizes">Prizes</a></h1>

				Hey folks, welcome to the prize section! This part is definitely important for you folks operating the prize booth! First off I wanna tell you some great news! Nanotransen has gone along with a nice deal that allows crew to occasionally keep their hard earned rewards on station for a limited time, now you can enjoy your new fancy toolbelt or bluespace beaker for more than just the shift where the casino comes around! <br>
				((Be aware, there can be limitations on how many rewards you get to keep after the shift, it might be unfair if some shows up and wins one thing, while they watch as command staff crew with high background income as well as hyperactive miners walks home with 20 prizes they get to enjoy while having almost done no gambling at all.)) <br><br>

				Lets get to the prizes and exchange rate before we get started on the stuff specifically for the booth operators, so heres the current prizes one can win and their costs! Be aware there might be new prizes or absent ones from time to time! <br>

				EXCHANGE RATE <br>
				FROM	=	TO <br>
				1 Thaler = 1 casino chip <br>
				1 casino chip = 1 Thaler <br> <br>

				The special sentient prize is 200 chips! More about it in section below! <br> <br>

				This section was outdated, someone better write it.

				That's it for prizes! <br><br>

				Now comes the part for the both operators, you got a very important job, it has a lot of responsibility, so it means that you gotta put that first before your own fun, cause unless you do it, a lot of folks are gonna be left sad and disappointed they cant get any goodies! But the process is simple and can be quick, someone comes to you, they want some chips, or thalers back or a prize, you simply check this nice guide above to determine cost and ask for the amount of thalers or chips needed, if its a prize, then you follow this procedure:
				<ol>
					<li>First get the thalers or chips for payment.</li>
					<li>Before giving the prize you take out your prize winner folder and a piece of paper, this paper will be named after the one getting the reward and will have further prizes noted down into it, so make sure its safe in that folder!</li>
					<li>You write at the top of the document the winner's name, then below write in big letters 'PRIZES' and put each new reward on its own line! ((You skip to a new line by writing < br > without the space between the br and the clamps))</li>
					<li>Once written down, you just put the paper back in the folder and hand over the prize!</li>
				</ol>
				((When shift is nearing its end you pray to staff or DM the one responsible for the event, they will get the folder and copy paste all the reward info before shift is over and ensure people get their rewards. This is a very important job and we understand it might not be so fun being restricted during an event, but just like the rest of volunteer staff, you get rewarded with guaranteed prizes to enjoy after the shift for being a big help!)) <br>
				((This gets to the sour part, cheating and giving others and yourself free prizes and/or chips is absolutely forbidden, this has OOC consequences and will likely blacklist you from being important roles in future events. Though don't fear getting punished even if you haven't done anything wrong, we will rather let cheaters slip than let honest players get wrongfully punished!))

				<h1><a name="SentientPrizes">Sentient prizes</a></h1>
				Goodness me this is quite the casino huh? Who would have thought one could win other people as a prize? Well you can do just about anything you want with them! Be it just company, some less children friendly company, heck you can even eat them or make them eat you! The options and possibilities are quite frankly limitless! <br>
				Now you might ask, how does one get these fancy prizes? Well they can be obtained by checking in at the exchange both and see the list of prizes, there might be none, there might be many, it depends on volunteers and losers! This brings us first to volunteers and then to losers! <br>
				Volunteering is simple! Anyone can walk up to the booth and ask to be a sentient prize, what this means is that you get a nice sum of 150 chips for you to do whatever you want, but someone might come at any point and claim you! <br>
				Losers are obtained differently, if you're completely busted and have nothing left, you become a prize that the one you lost to can do whatever they want with, this means both gamblers and dealers can end up as a prize, though if for whatever reason you don't become their prize, you get added to the list for someone else to enjoy. Becoming a prize means you also get 100 chips in compensation! <br>

				Now hear this! The casino has decided that to spice things up, folks can bet themselves at any time and aren't already a prize on the list! Doesn't matter if you're rich or broke, playing blackjack or roulette, you can bet yourself in any game and you're worth 250 chips! But be careful, cause if you lose, you're the winners prize! They can keep you, give you to someone else. or to the prize booth and get the chips you would have gotten as volunteer! But if given to the booth, the winner cant buy their prize back for the lower cost!<br><br>

				((Sour part again, but very important. These sentient prizes can be fun, but one thing always dictates how these things goes down, preferences and ooc wants. If preferences don't line up and people don't agree to do winner/loser scene it becomes sentient prize on list. And someone cant win a prize if the prize ooc doesn't want to do what the winner wants to do. We still wish people to try and reach out and try things with new people and/or new things they are comfortable doing, but never shall anyone be forced into a situation they don't want!))

				</body>
				</html>
			"}
