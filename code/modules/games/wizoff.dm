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

/obj/item/weapon/deck/wizoff
	name = "\improper Wiz-Off deck"
	desc = "A Wiz-Off deck. Fight an arcane battle for the fate of the universe: Draw 5! Play 5! Best of 5!"
	icon_state = "wizoff"

/obj/item/weapon/deck/wizoff/New()
	..()
	var/datum/playingcard/P
	for(var/cardtext in card_wiz_list)
		P = new()
		P.name = "[cardtext]"
		P.card_icon = "[icon_state]_card"
		P.back_icon = "[icon_state]_card_back"
		cards += P

/obj/item/weapon/deck/wizoff/var/list/card_wiz_list = list(
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

