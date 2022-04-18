<<<<<<< HEAD
/*
 * Spaceball collectable cards
 */
/obj/item/weapon/pack/spaceball
=======
/obj/item/pack/spaceball
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	name = "spaceball booster pack"
	desc = "Officially licensed to take your money."
	icon_state = "card_pack_spaceball"
	parentdeck = "spaceball"

<<<<<<< HEAD
/obj/item/weapon/pack/spaceball/New()
	..()
=======
/obj/item/pack/spaceball/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	var/datum/playingcard/P
	var/i
	var/year = 300 + text2num(time2text(world.timeofday, "YYYY")) //VOREStation Edit
	for(i=0;i<5;i++)
		P = new()
		if(prob(1))
			P.name = "Spaceball Jones, [year] Brickburn Galaxy Trekers"
			P.card_icon = "spaceball_jones"
		else
			var/language_type = pick(/datum/language/human,/datum/language/diona_local,/datum/language/tajaran,/datum/language/unathi)
			var/datum/language/L = new language_type()
			var/team = pick("Brickburn Galaxy Trekers","Mars Rovers", "Qerrbalak Saints", "Moghes Rockets", "Meralar Lightning", "[using_map.starsys_name] Vixens", "Euphoric-Earth Alligators")
			P.name = "[L.get_random_name(pick(MALE,FEMALE))], [year - rand(0,50)] [team]"
			P.card_icon = "spaceball_standard"
		P.back_icon = "card_back_spaceball"

		cards += P
