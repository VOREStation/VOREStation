////////////////////////////////
//			Vox Pirates
////////////////////////////////
//Classifying these as Mercs, due to the general power level I want them at.

/datum/category_item/catalogue/fauna/mercenary/vox
	name = "Mercenaries - Vox"
	desc = "For centuries the Vox have inflicted their way of life upon the \
	Galaxy. Regarded with distrust due to their tendency to engage in piracy \
	and violence, the Vox are equally feared for their robust physiology and \
	curiously advanced xenotech. Due to ancient compacts, Vox pirates try to \
	avoid bloodshed, but will react to violence in kind."
	value = CATALOGUER_REWARD_MEDIUM
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/mercenary/vox)

/mob/living/simple_mob/humanoid/merc/voxpirate	//Don't use this one.
	name = "vox mannequin"
	desc = "You shouldn't be seeing this one."
	icon_state = "voxpirate"
	icon_living = "voxpirate"
	icon_dead = "voxpirate_dead"

	faction = "voxpirate"
	movement_cooldown = 4

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 20		//Vox Hunting rifle blade damage
	melee_damage_upper = 20
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 100)	// Matching Merc voidsuit stats to represent toughness.

	min_oxy = 0 //Vox are spaceproof.
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	corpse = /obj/effect/landmark/mobcorpse/vox/pirate
	loot_list = list(/obj/item/gun/projectile/shotgun/pump/rifle/vox_hunting = 100,
					/obj/item/ammo_magazine/clip/c762 = 30,
					/obj/item/ammo_magazine/clip/c762 = 30
					)

	ai_holder_type = /datum/ai_holder/simple_mob/merc
	say_list_type = /datum/say_list/merc/voxpirate

/mob/living/simple_mob/humanoid/merc/voxpirate/pirate
	name = "vox pirate"
	desc = "A desperate looking Vox. Get your gun."

	projectiletype = /obj/item/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/riflebolt.ogg'
	needs_reload = TRUE
	reload_max = 20

////////////////////////////////
//			Vox Melee
////////////////////////////////

/datum/category_item/catalogue/fauna/mercenary/vox/boarder
	name = "Mercenaries - Vox Boarder"
	desc = "Vox are squat creatures, with powerful muscles and tough, scaly \
	hides. Their dense bones and sharp talons make them a formidable threat in \
	close quarters combat. Low level Vox weaponry generally emphasizes closing \
	the distance to exploit these facts."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/humanoid/merc/voxpirate/boarder
	name = "vox melee boarder"
	desc = "A howling Vox with a sword. Run."
	icon_state = "voxboarder_m"
	icon_living = "voxboarder_m"
	icon_dead = "voxboarder_m_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mercenary/vox/boarder)

	melee_damage_lower = 30		//Energy sword damage
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive
	corpse = /obj/effect/landmark/mobcorpse/vox/boarder_m
	loot_list = list(/obj/item/melee/energy/sword = 100)

// They're good with the swords? I dunno. I like the idea they can deflect.
/mob/living/simple_mob/humanoid/merc/voxpirate/boarder/attackby(var/obj/item/O, var/mob/user)
	if(O.force)
		if(prob(20))
			visible_message(span_danger("\The [src] blocks \the [O] with its sword!"))
			if(user)
				ai_holder.react_to_attack(user)
			return
		else
			..()
	else
		to_chat(user, span_warning("This weapon is ineffective, it does no damage."))
		visible_message(span_warning("\The [user] gently taps [src] with \the [O]."))

/mob/living/simple_mob/humanoid/merc/voxpirate/boarder/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if(prob(35))
		visible_message(span_warning("[src] blocks [Proj] with its sword!"))
		if(Proj.firer)
			ai_holder.react_to_attack(Proj.firer)
		return
	else
		..()

////////////////////////////////
//			Vox Ranged
////////////////////////////////

/mob/living/simple_mob/humanoid/merc/voxpirate/boarder
	name = "vox ranged boarder"
	desc = "A howling Vox with a shotgun. Get to cover!"
	icon_state = "voxboarder_r"
	icon_living = "voxboarder_r"
	icon_dead = "voxboarder_r_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mercenary/vox/boarder)

	projectiletype = /obj/item/projectile/bullet/pellet/shotgun
	projectilesound = 'sound/weapons/Gunshot_shotgun.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive
	corpse = /obj/effect/landmark/mobcorpse/vox/boarder_r
	loot_list = list(/obj/item/gun/projectile/shotgun/pump/combat = 100,
					/obj/item/ammo_magazine/m12gdrum = 30,
					/obj/item/ammo_magazine/m12gdrum = 30
					)

	needs_reload = TRUE
	reload_max = 10

/datum/category_item/catalogue/fauna/mercenary/vox/technician
	name = "Mercenaries - Vox Technician"
	desc = "The belief that Vox are unintelligent comes largely from a kind \
	of anthrochauvanism. Due to their difficulty speaking GalCom and their tendency \
	to resort to underhanded methods, the Galaxy sees Vox as brutal, unintelligent \
	aliens. In reality, Vox are just as intelligent as everyone else, as the state \
	of their technology shows. Vox Technicians maintain ancient vessels and tools \
	with scraps and odd bits, often recieving no external recognition for their work."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/humanoid/merc/voxpirate/technician
	name = "vox salvage technician"
	desc = "A screeching Vox with an ion rifle. Usually sent on scrapping operations."
	icon_state = "voxboarder_t"
	icon_living = "voxboarder_t"
	icon_dead = "voxboarder_t_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mercenary/vox/technician)

	projectiletype = /obj/item/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting
	corpse = /obj/effect/landmark/mobcorpse/vox/boarder_t
	loot_list = list(/obj/item/gun/energy/ionrifle)

	needs_reload = TRUE
	reload_max = 25 //Suppressive tech weapon.

/datum/category_item/catalogue/fauna/mercenary/vox/suppressor
	name = "Mercenaries - Vox Suppressor"
	desc = "Among Vox bands, Suppressors are an even more motley crew. \
	Staying true to the name, Suppressors are veteran Vox pirates who have \
	faced hundreds of engagements. Tough and well suited for violence, these \
	Vox wear bright, mismatching colors into battle to draw attention. Serving \
	as a beacon to draw eyes away from their companions, Suppressors wield the \
	fearsome Sonic Cannon - a booming directed frequency device capable of \
	wreaking havoc all its own. It doesn't sound half bad either, when it isn't \
	pointed at you."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/humanoid/merc/voxpirate/ranged/suppressor
	name = "vox suppressor"
	desc = "Come on, feel the noise!"
	icon_state = "voxsuppressor"
	icon_living = "voxsuppressor"
	icon_dead = "voxsuppresor_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mercenary/vox/suppressor)

	armor = list(melee = 30, bullet = 50, laser = 60, energy = 30, bomb = 35, bio = 100, rad = 100)	// Boosted armor to represent Tank role.

	projectiletype = /obj/item/projectile/sonic/weak
	projectilesound = 'sound/effects/basscannon.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/destructive
	corpse = /obj/effect/landmark/mobcorpse/vox/suppressor
	loot_list = list(/obj/item/gun/energy/sonic = 100)

	base_attack_cooldown = 5 // Two attacks a second or so.
	needs_reload = TRUE
	reload_max = 30 //Gotta lay down that fire, son.

/datum/category_item/catalogue/fauna/mercenary/vox/captain
	name = "Mercenaries - Vox Captain"
	desc = "Accomplished Vox who bring in scrap reliably eventually become the \
	'Quills' of their own expeditions. This Vox term is considered analagous to \
	the word 'Captain'. As such, any Vox who has attained this rank has certainly \
	earned the powerful equipment they carry into combat: Dark Matter cannons, \
	advanced armor, proper Hunting Rifles - the list goes on. The Vox Captain \
	is a formidable opponent, honed by years of hard living and harder fighting. \
	If you are unable to negotiate, expect to face their entire crew head on."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/humanoid/merc/voxpirate/ranged/captain
	name = "vox pirate captain"
	desc = "Walkings the plank, dustlung! Yayaya."
	icon_state = "voxcaptain"
	icon_living = "voxcaptain"
	icon_dead = "voxcaptain_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mercenary/vox/captain)

	armor = list(melee = 60, bullet = 50, laser = 40, energy = 15, bomb = 30, bio = 100, rad = 100)	// Vox RIG armor values.

	projectiletype = /obj/item/projectile/beam/darkmatter
	projectilesound = 'sound/weapons/eLuger.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/destructive
	corpse = /obj/effect/landmark/mobcorpse/vox/captain
	loot_list = list(/obj/item/gun/energy/darkmatter = 100)

	needs_reload = TRUE
	reload_max = 15 //Other Vox should be carrying ammo.
