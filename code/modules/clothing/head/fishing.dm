/* just using these for copypasta purposes

	item_icons = list(
		slot_l_hand_str = 'icons/vore/custom_clothes_left_hand_vr.dmi',
		slot_r_hand_str = 'icons/vore/custom_clothes_right_hand_vr.dmi',
		slot_head_str = 'icons/vore/custom_onmob_32x48_vr.dmi'
		)

these are the default values for a soft cap

	icon_state = "cargosoft"
	item_state_slots = list(slot_r_hand_str = "cargosoft", slot_l_hand_str = "cargosoft")


these are the default icons for a hat
	icon = 'icons/obj/clothing/hats.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hats.dmi',
		)
*/

/obj/item/clothing/head/fishing
	name = "fishing hat"
	desc = "It's a peaked cap with a quirky slogan."
	icon = 'icons/inventory/head/item_vr_fishing.dmi'
	icon_state = "greensoft0"
	item_state_slots = list(slot_r_hand_str = "greensoft", slot_l_hand_str = "greensoft", slot_head_str = "greensoft0")
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hats.dmi',
		slot_head_str = 'icons/inventory/head/mob_vr_fishing.dmi'
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0
	var/slogan = ""
	var/hatsize = 0

/obj/item/clothing/head/fishing/Initialize()
	//short phrases that women and fish may have about you
	var/feelings = list("love me",
						"fear me",
						"despise me",
						"are ambivalent towards me",
						"don't care about me",
						"lust after me",
						"eat me",
						"are down bad for me",
						"can't stand me",
						"want me",
						"kill me",
						"devour me",
						"swallow me",
						"avoid me",
						"have no words for me",
						"hate me",
						"make memes of me",
						"demoralise me",
						"perpetually mock me",
						"scare me",
						"issue restraining orders to me",
						"leave me",
						"took the kids from me",
						"demand satisfaction from me",
						"dropkick me",
						"suplex me",
						"worry about me",
						"gossip about me",
						"defame me",
						"conspire against me",
						"draw me as the soyjack",
						"put me in their tummies",
						"crunchatize me, cap'n!",
						"think of me while kneading dough",
						"leave threatening messages on my voicemail",
						"write fanfiction about me",
						"attempt to approach me"
						)
	//significantly more complex feelings that women and fish may have about you
	var/verylongfeelings = list("construct inferior defensive walls lacking additional fall back locations as they believe their initial defense shall be enough to withstand me",
							"insist upon forming an unsteady yet reliable alliance in which they teeter upon the dual edge of betrayal and ruination in the perpetual desire to bring ruin upon me",
							"construct elaborate fantasies about my graphic and harrowing death at the hands of a giant robot",
							"call it oven when you of in the cold food of out hot eat the food",
							"are hurled millennia into the future for their hubris but nonetheless attempt to enslave me from my abode deep within the earth",
							"make light of my attire while at the coffee shop, unaware that I am a powerful wizard with the means to cast forth the veil of ignorance from their eyes",
							"cower before my T-posing to assert dominance, except I don't know the difference between T-posing and A-posing (neither of which have anything to do with T&A, which is very confusing)",
							"use my power to create a new universe but destroy all life on earth in the process and are left alone to rebuild with nothing for company but me",
							"hold A to charge a buster shot only to get hit by my homing missiles, starting a juggle chain which results in losing all their health and having to restart from the last checkpoint",
							"attempt once more to best me and gain access to my keep of riches and treasure, but I put their foolish ambitions to rest with force",
							"bump into me in the supermarket and exchange an awkward hello, neither of us expecting to meet each other in this liminal environs and unsure how the context of our relationship can adapt to this happenstance congregation",
							"pursue me to the ends of the earth, constantly thwarted by inconsequential setbacks, and when they catch up and I ask in an exasperated voice why they respond 'you owe me a dollar'",
							"call me just to 'chat' but actually mention they are moving and, obviously, since I'm the ONLY guy they know with a truck it would be great if I could help out, they said they'd buy me pizza but that doesn't really cover it",
							"shuffle uncomfortably as we continue to sit in near-total silence having exhausted all topics of conversation hours ago but neither of us having worked up the spirit to suggest that we part ways and go home",
							"methodically place brick after agonising brick in the wall they are constructing to forever entomb me in the basement which they claimed contained a case of Amontillado wine"
						)

	//time to actually generate the slogan
	//50% chance of it just being a basic women/fish combo
	if(prob(50))
		slogan = "Women [pick(feelings)], fish [pick(feelings)]"
	else //we generate something more complex
		if(prob(90)) //USUALLY one of the short simple phrases
			slogan = "[pick("Women", "Fish")] [pick(feelings)]"
		else
			slogan = "[pick("Women", "Fish")] [pick(verylongfeelings)]"
			hatsize += 2

		//second line
		if(prob(90)) //USUALLY one of the short simple phrases
			slogan = "[slogan], [pick("Women", "Fish")] [pick(feelings)]"
		else
			slogan = "[slogan], [pick("Women", "Fish")] [pick(verylongfeelings)]"
			hatsize += 2
		//chance of a third line
		if(prob(50))
			if(prob(50)) //if a third line is rolled it's way more likely to be a long one
				slogan = "[slogan], [pick("Women", "Fish", "Men", "Beasts")] [pick(feelings)]"
				hatsize += 1
			else
				slogan = "[slogan], [pick("Women", "Fish", "Men", "Beasts")] [pick(verylongfeelings)]"
				hatsize += 3
			//you can even get a fourth
			if(prob(25))
				if(prob(25)) //if a fourth line is rolled it's way WAY more likely to be a long one
					slogan = "[slogan], [pick("Women", "Fish", "Men", "Beasts")] [pick(feelings)]"
					hatsize += 1
				else
					slogan = "[slogan], [pick("Women", "Fish", "Men", "Beasts")] [pick(verylongfeelings)]"
					hatsize += 3


	//now we have the slogan, apply this to the description and name
	desc = "A peaked cap with text reading '[slogan]'."
	name = "\improper '[slogan]' hat"

	//finally, take our hat size and pick the icon accordingly
	icon_state = "greensoft[hatsize]"
	item_state_slots = list(slot_r_hand_str = "greensoft", slot_l_hand_str = "greensoft", slot_head_str = "greensoft[hatsize]")