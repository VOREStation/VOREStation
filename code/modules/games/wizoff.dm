/* It's Wiz-Off, the wizard themed card game!
 *		Each player draws 5 cards. There are five rounds. Each round,
 *		a player selects a card to play, and the winner is selected
 *		based on the following rules:
 *		-Defensive (D) beats Offensive (O)!
 *		-Offensive (O) beats Utility (U)!
 *		-Utility (U) beats Defensive (D)!
 *		-If both players play the same type of spell, the higher number wins!
 *		The player who wins the most of the 5 rounds wins the game!
 *		Now get ready to battle for the fate of the universe: Wiz-Off!
 */

/obj/item/deck/wizoff
	name = "\improper Wiz-Off deck"
	desc = "A Wiz-Off deck. Fight an arcane battle for the fate of the universe: Draw 5! Play 5! Best of 5!"
	icon_state = "wizoff"

/obj/item/deck/wizoff/Initialize(mapload)
	. = ..()
	var/datum/playingcard/P
	for(var/cardtext in card_wiz_list)
		P = new()
		P.name = "[cardtext]"
		P.card_icon = "[icon_state]_card"
		P.back_icon = "[icon_state]_card_back"
		cards += P

/obj/item/deck/wizoff/var/list/card_wiz_list = list(
	"O1: Spell Cards",
	"O2: Summon Bees",
	"O3: Polymorph",
	"O4: Tesla Blast",
	"O5: Rod Form",
	"O6: Mutate",
	"O7: Fireball",
	"O8: Mjolnir",
	"O9: Smite",
	"D1: Smoke",
	"D2: Battlemage Armor",
	"D3: Repulse",
	"D4: Magic Missile",
	"D5: Disable Technology",
	"D6: Spell Trap",
	"D7: Forcewall",
	"D8: Arcane Heal",
	"D9: Stop Time",
	"U1: Shapechange",
	"U2: Spacetime Distortion",
	"U3: Scrying Orb",
	"U4: Blink",
	"U5: Knock",
	"U6: Teleport",
	"U7: Bind Soul",
	"U8: Warp Whistle",
	"U9: Jaunt"
	)

/obj/item/book/manual/wizzoffguide
	name = "WizOff Guide"
	icon = 'icons/obj/playing_cards.dmi'
	icon_state ="wizoff_guide"
	item_state = "book16"
	author = "Donk Co."
	title = "WizOff Guide"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	dat = {"

		<html>
			<head>
			<style>
			h1 {font-size: 18px; margin: 15px 0px 5px;}
			h2 {font-size: 15px; margin: 15px 0px 5px;}
			h3 {font-size: 13px; margin: 5px 0px 5px;}
			li {margin: 2px 0px 2px 15px;}
			ul {margin: 5px; padding: 0px;}
			ol {margin: 5px; padding: 0px 15px;}
			body {font-size: 13px; font-family: Verdana;}
			</style>
			</head>
			<body>
			<h1><u>Wiz-Off Player Guide</u></h1>
			<h2>How to play Wiz-Off!</h2>
			<h3>The wizard themed card game</h3>
			<p>Each player draws 5 cards. There are five rounds. Each round,<br>
			a player selects a card to play, and the winner is selected<br>
			based on the following rules:</p>
			<ol>
				<li>Offensive (O) beats Utility (U)!</li>
				<li>Defensive (D) beats Offensive (O)!</li>
				<li>Utility (U) beats Defensive (D)!</li>
				<li>If both players play the same type of spell, <br>
				the higher number wins!</li>
			</ol>
			<p>The player who wins the most of the 5 rounds wins the game!<br>
			Now get ready to battle for the fate of the universe: Wiz-Off!</p>
			</body>
		</html>

		"}
