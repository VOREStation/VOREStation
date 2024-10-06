/*

Miscellaneous traitor devices

BATTERER


*/

/*

The Batterer, like a flashbang but 50% chance to knock people over. Can be either very
effective or pretty fucking useless.

*/

/obj/item/batterer
	name = "mind batterer"
	desc = "A strange device with twin antennas."
	icon = 'icons/obj/device.dmi'
	icon_state = "batterer"
	throwforce = 5
	w_class = ITEMSIZE_TINY
	throw_speed = 4
	throw_range = 10
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 3, TECH_ILLEGAL = 3)

	var/times_used = 0 //Number of times it's been used.
	var/max_uses = 2

/obj/item/batterer/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user) 	return
	if(times_used >= max_uses)
		to_chat(user, span_warning("The mind batterer has been burnt out!"))
		return

	var/list/affected = list()
	for(var/mob/living/carbon/human/M in orange(10, user))
		affected += M
		spawn()
			if(prob(50))

				M.Weaken(rand(10,20))
				if(prob(25))
					M.Stun(rand(5,10))
				to_chat(M, span_danger("You feel a tremendous, paralyzing wave flood your mind."))

			else
				to_chat(M, span_danger("You feel a sudden, electric jolt travel through your head."))

	add_attack_logs(user,affected,"Used a [name]")

	playsound(src, 'sound/misc/interference.ogg', 50, 1)
	to_chat(user, span_notice("You trigger [src]."))
	times_used += 1
	if(times_used >= max_uses)
		icon_state = "battererburnt"
