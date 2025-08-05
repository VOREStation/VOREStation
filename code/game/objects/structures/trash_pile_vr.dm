/obj/structure/trash_pile
	name = "trash pile"
	desc = "A heap of garbage, but maybe there's something interesting inside?"
	icon = 'icons/obj/trash_piles.dmi'
	icon_state = "randompile"
	density = TRUE
	anchored = TRUE

	var/busy = FALSE				// Used so you can't spamclick to loot.
	var/list/searchedby	= list()// Characters that have searched this trashpile, with values of searched time.
	var/mob/living/hider		// A simple animal that might be hiding in the pile
	var/obj/structure/mob_spawner/mouse_nest/mouse_nest = null

/obj/structure/trash_pile/Initialize(mapload)
	. = ..()
	icon_state = pick(
		"pile1",
		"pile2",
		"pilechair",
		"piletable",
		"pilevending",
		"brtrashpile",
		"microwavepile",
		"rackpile",
		"boxfort",
		"trashbag",
		"brokecomp")
	mouse_nest = new(src)
	AddElement(/datum/element/lootable/trash_pile)
	AddElement(/datum/element/climbable)

/obj/structure/trash_pile/Destroy()
	qdel(mouse_nest)
	mouse_nest = null
	return ..()

/obj/structure/trash_pile/attackby(obj/item/W as obj, mob/user as mob)
	var/w_type = W.type
	if(w_type in GLOB.allocated_gamma_loot)
		to_chat(user,span_notice("You feel \the [W] slip from your hand, and disappear into the trash pile."))
		user.unEquip(W)
		W.forceMove(src)
		restore_gamma_loot(w_type)
		qdel(W)
	else
		return ..()

/obj/structure/trash_pile/attack_generic(mob/user)
	//Simple Animal
	if(isanimal(user))
		var/mob/living/L = user
		//They're in it, and want to get out.
		if(L.loc == src)
			var/choice = tgui_alert(user, "Do you want to exit \the [src]?","Un-Hide?",list("Exit","Stay"))
			if(choice == "Exit")
				if(L == hider)
					hider = null
				L.forceMove(get_turf(src))
		else if(!hider)
			var/choice = tgui_alert(user, "Do you want to hide in \the [src]?","Un-Hide?",list("Hide","Stay"))
			if(choice == "Hide" && !hider) //Check again because PROMPT
				L.forceMove(src)
				hider = L
	else
		return ..()

/obj/structure/trash_pile/attack_ghost(mob/observer/user as mob)
	if(CONFIG_GET(flag/disable_player_mice))
		to_chat(user, span_warning("Spawning as a mouse is currently disabled."))
		return

	if(jobban_isbanned(user, JOB_GHOSTROLES))
		to_chat(user, span_warning("You cannot become a mouse because you are banned from playing ghost roles."))
		return

	if(!user.MayRespawn(1))
		return

	var/turf/T = get_turf(src)
	if(!T || (T.z in using_map.admin_levels))
		to_chat(user, span_warning("You may not spawn as a mouse on this Z-level."))
		return

	var/timedifference = world.time - user.client.time_died_as_mouse
	if(user.client.time_died_as_mouse && timedifference <= CONFIG_GET(number/mouse_respawn_time) MINUTES)
		var/timedifference_text
		timedifference_text = time2text(CONFIG_GET(number/mouse_respawn_time) MINUTES - timedifference,"mm:ss")
		to_chat(user, span_warning("You may only spawn again as a mouse more than [CONFIG_GET(number/mouse_respawn_time)] minutes after your death. You have [timedifference_text] left."))
		return

	var/response = tgui_alert(user, "Are you -sure- you want to become a mouse?","Are you sure you want to squeek?",list("Squeek!","Nope!"))
	if(response != "Squeek!") return  //Hit the wrong key...again.

	var/mob/living/simple_mob/animal/passive/mouse/host
	host = new /mob/living/simple_mob/animal/passive/mouse(get_turf(src))

	if(host)
		if(CONFIG_GET(flag/uneducated_mice))
			host.universal_understand = 0
		announce_ghost_joinleave(src, 0, "They are now a mouse.")
		host.ckey = user.ckey
		to_chat(host, span_info("You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent."))

	var/atom/A = get_holder_at_turf_level(src)
	A.visible_message("[host] crawls out of \the [src].")
	return

/obj/structure/trash_pile/attack_hand(mob/user)
	//Human mob
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(busy)
			to_chat(H, span_warning("\The [src] is already being searched."))
			return

		H.visible_message("[user] searches through \the [src].",span_notice("You search through \the [src]."))
		if(hider)
			to_chat(hider,span_warning("[user] is searching the trash pile you're in!"))

		//Do the searching
		busy = TRUE
		if(do_after(user,rand(4 SECONDS,6 SECONDS),src))
			if(hider && prob(50))
				//If there was a hider, chance to reveal them
				to_chat(hider,span_danger("You've been discovered!"))
				hider.forceMove(get_turf(src))
				hider = null
				to_chat(user,span_danger("Some sort of creature leaps out of \the [src]!"))
			else
				SEND_SIGNAL(src,COMSIG_LOOT_REWARD,user,searchedby, 5)
		busy = FALSE
	else
		return ..()

/obj/structure/mob_spawner/mouse_nest
	name = "trash"
	desc = "A small heap of trash, perfect for mice and other pests to nest in."
	icon = 'icons/obj/trash_piles.dmi'
	icon_state = "randompile"
	spawn_types = list(
	/mob/living/simple_mob/animal/passive/mouse= 100,
	/mob/living/simple_mob/animal/passive/cockroach = 25)
	simultaneous_spawns = 1
	destructible = 1
	spawn_delay = 1 HOUR

/obj/structure/mob_spawner/mouse_nest/Initialize(mapload)
	. = ..()
	last_spawn = rand(world.time - spawn_delay, world.time)
	icon_state = pick(
		"pile1",
		"pile2",
		"pilechair",
		"piletable",
		"pilevending",
		"brtrashpile",
		"microwavepile",
		"rackpile",
		"boxfort",
		"trashbag",
		"brokecomp")

/obj/structure/mob_spawner/mouse_nest/do_spawn(var/mob_path)
	. = ..()
	var/atom/A = get_holder_at_turf_level(src)
	A.visible_message("[.] crawls out of \the [src].")

/obj/structure/mob_spawner/mouse_nest/get_death_report(var/mob/living/L)
	..()
	last_spawn = rand(world.time - spawn_delay, world.time)
