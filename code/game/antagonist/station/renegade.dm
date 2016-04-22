var/datum/antagonist/renegade/renegades

/datum/antagonist/renegade
	role_text = "Renegade"
	role_text_plural = "Renegades"
	welcome_text = "Your own safety matters above all else, trust no one and kill anyone who gets in your way. However, armed as you are, now would be the perfect time to settle that score or grab that pair of yellow gloves you've been eyeing..."
	id = MODE_RENEGADE
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 5
	hard_cap_round = 7

	hard_cap = 8
	hard_cap_round = 12
	initial_spawn_req = 3
	initial_spawn_target = 6

	var/list/spawn_guns = list(
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/captain,
		/obj/item/weapon/gun/energy/lasercannon,
		/obj/item/weapon/gun/energy/xray,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/gun/energy/gun/burst,
		/obj/item/weapon/gun/energy/gun/nuclear,
		/obj/item/weapon/gun/energy/crossbow,
		/obj/item/weapon/gun/energy/crossbow/largecrossbow,
		/obj/item/weapon/gun/projectile/automatic,
		/obj/item/weapon/gun/projectile/automatic/mini_uzi,
		/obj/item/weapon/gun/projectile/automatic/c20r,
		/obj/item/weapon/gun/projectile/automatic/sts35,
		/obj/item/weapon/gun/projectile/automatic/wt550,
		/obj/item/weapon/gun/projectile/automatic/z8,
		/obj/item/weapon/gun/projectile/colt/detective,
		/obj/item/weapon/gun/projectile/sec/wood,
		/obj/item/weapon/gun/projectile/silenced,
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/weapon/gun/projectile/shotgun/pump,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat,
		list(/obj/item/weapon/gun/projectile/shotgun/doublebarrel, /obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet, /obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn),
		list(/obj/item/weapon/gun/projectile/deagle, /obj/item/weapon/gun/projectile/deagle/gold, /obj/item/weapon/gun/projectile/deagle/camo),
		list(/obj/item/weapon/gun/projectile/revolver/detective, /obj/item/weapon/gun/projectile/revolver/deckard)
		)

/datum/antagonist/renegade/New()
	..()
	renegades = src

/datum/antagonist/renegade/create_objectives(var/datum/mind/player)

	if(!..())
		return

	var/datum/objective/survive/survive = new
	survive.owner = player
	player.objectives |= survive

/datum/antagonist/renegade/equip(var/mob/living/carbon/human/player)

	if(!..())
		return

	var/gun_type = pick(spawn_guns)
	if(islist(gun_type))
		gun_type = pick(gun_type)

	var/obj/item/gun = new gun_type(get_turf(player))
	var/list/slots = list (
		"backpack" = slot_in_backpack,
		"left hand" = slot_l_hand,
		"right hand" = slot_r_hand,
		)
	for(var/slot in slots)
		player.equip_to_slot(gun, slot)
		if(gun.loc == player)
			break
	var/obj/item/weapon/storage/S = locate() in player.contents
	if(S && istype(S))
		gun.loc = S

/proc/rightandwrong()
	usr << "<B>You summoned guns!</B>"
	message_admins("[key_name_admin(usr, 1)] summoned guns!")
	for(var/mob/living/carbon/human/H in player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		renegades.add_antagonist(H.mind)
