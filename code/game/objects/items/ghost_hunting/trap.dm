/obj/item/ghost_trap
	name = "spectral trap"
	desc = "A mechanically activated ghost trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	description_fluff = "A 'ghost trap' created by K.E's Spectral-Division. Used by ghost-hunters and \
	paranormal investigators to supposedly capture spirits and specters."
	throw_speed = 5
	throw_range = 7
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "beartrap0" //placeholder
	randpixel = 0
	center_of_mass_x = 0
	center_of_mass_y = 0
	throwforce = 0
	w_class = ITEMSIZE_NORMAL
	var/deployed = FALSE
	var/datum/weakref/captured_entity
	var/obj/item/radio/intercom/ghost_reporter

/obj/item/ghost_trap/verb/release_occupant()
	set src in oview(1)
	set category = "Object"
	set name = "Relase Entity"
	release_entity(usr)

/obj/item/ghost_trap/proc/release_entity(mob/living/user)
	if(!isliving(user)) //no ghosts
		return

	if((user in src.contents))
		to_chat(user, span_warning("You need to be outside \the [src] to do this."))
		return

/obj/item/ghost_trap/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(captured_entity)
		var/mob/our_entity = captured_entity.resolve()
		if(our_entity)
			REMOVE_TRAIT(our_entity, TRAIT_NO_TRANSFORM, src)
		captured_entity = null
	QDEL_NULL(ghost_reporter)
	. = ..()

//placeholder, give new sprites.
/obj/item/ghost_trap/update_icon()
	..()

	if(!deployed)
		icon_state = "beartrap0"
	else
		icon_state = "beartrap1"


/obj/item/ghost_trap/start_active
	deployed = TRUE

/obj/item/ghost_trap/Initialize(mapload)
	. = ..()
	if(mapload && deployed)
		update_icon()
	ghost_reporter = new /obj/item/radio/intercom{channels=list("Science")}(null)
	START_PROCESSING(SSobj, src)

/obj/item/ghost_trap/process()
	if(captured_entity)
		var/mob/our_entity = captured_entity.resolve()
		if(our_entity && our_entity.loc != src)
			REMOVE_TRAIT(our_entity, TRAIT_NO_TRANSFORM, src)
			captured_entity = null
			announce_escape(our_entity)

/obj/item/ghost_trap/proc/announce_escape(mob/our_entity)
	var/area/our_area = get_area(src)
	log_and_message_admins("[our_entity] escaped \the [name] at \the [our_area]", our_entity)
	ghost_reporter.autosay("Attention: Spectral event detected. Captured entity at [our_area] has breached containment.", "Spectral Trap", "Science", using_map.get_map_levels(z))

/obj/item/ghost_trap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/ghost_trap/attack_self(mob/user as mob)
	..()
	if(captured_entity)
		var/mob/our_entity = captured_entity.resolve()
		if(our_entity)
			to_chat(user, "You are unable to use \the [src]! It beeps that it an entity contained inside!")
			return
	if(!deployed && can_use(user))
		user.visible_message(
			span_danger("[user] starts to deploy \the [src]."),
			span_danger("You begin deploying \the [src]!")
			)

		if (do_after(user, 6 SECONDS, target = src))
			user.visible_message(
				span_danger("[user] has deployed \the [src]."),
				span_danger("You have deployed \the [src]!")
				)
			playsound(src, 'sound/machines/click.ogg',70, 1)

			deployed = TRUE
			user.drop_from_inventory(src)
			update_icon()
			anchored = TRUE
			log_and_message_admins("has set up a [name] at \the [get_area(loc)]", user)

/obj/item/ghost_trap/container_resist(mob/living/escapee)
	if(!ismob(escapee))
		return
	visible_message(span_danger("Lights flicker and buzzers beep from \the [src], alerting that a containment breach is imminent!"))
	if(do_after(escapee, 2 MINUTES, target = src)) //Escape!
		REMOVE_TRAIT(escapee, TRAIT_NO_TRANSFORM, src)
		captured_entity = null
		escapee.forceMove(get_turf(src))
		announce_escape(escapee)
		visible_message(span_danger("A loud buzzer rings out as \the [src] suddenly opens, alerting that a containment breach has ocurred!"))


/obj/item/ghost_trap/attack_hand(mob/user as mob)
	if(has_buckled_mobs() && can_use(user))
		var/victim = english_list(buckled_mobs)
		user.visible_message(
			span_notice("[user] begins freeing [victim] from \the [src]."),
			span_notice("You carefully begin to free [victim] from \the [src]."),
			)
		if(do_after(user, 6 SECONDS, target = src))
			user.visible_message(span_notice("[victim] has been freed from \the [src] by [user]."))
			for(var/A in buckled_mobs)
				unbuckle_mob(A)
			anchored = FALSE
	else if(deployed && can_use(user))
		user.visible_message(
			span_danger("[user] starts to deactivate \the [src]."),
			span_notice("You begin deactivate \the [src]!")
			)
		playsound(src, 'sound/machines/click.ogg', 50, 1)

		if(do_after(user, 6 SECONDS, target = src))
			user.visible_message(
				span_danger("[user] has deactivated \the [src]."),
				span_notice("You have deactivated \the [src]!")
				)
			deployed = FALSE
			anchored = FALSE
			update_icon()
	else
		..()

/obj/item/ghost_trap/proc/catch_ghost(mob/passing_entity)
	if(!ismob(passing_entity)) //wtf did you do
		return
	captured_entity = WEAKREF(passing_entity)
	if(isliving(passing_entity))
		var/mob/living/living_entity = passing_entity
		var/datum/component/shadekin/SK = living_entity.get_shadekin_component()
		living_entity.phase_in(get_turf(src), SK)
	passing_entity.forceMove(src)
	var/area/our_area = get_area(src)
	ghost_reporter.autosay("Attention: Spectral event detected. Trap activated at [our_area.name]", "Spectral Trap", "Science", using_map.get_map_levels(z))
	ADD_TRAIT(passing_entity, TRAIT_NO_TRANSFORM, src)

	to_chat(passing_entity, span_danger("You feel a sudden sensation pulling you into \the [src]!"))
	if(isobserver(passing_entity))
		to_chat(passing_entity, span_info("((You are incapable of moving or 'jumping' to turf by clicking, but can still escape via teleport or orbit!))"))

/obj/item/ghost_trap/Crossed(atom/movable/AM)
	if(!ismob(AM)) //Only affects mobs!
		return
	var/mob/passing_entity = AM
	if(isobserver(passing_entity))
		var/mob/observer/dead/ghost = AM
		if(ghost.admin_ghosted || !ghost.interact_with_world)
			return
	if(!passing_entity.is_incorporeal())
		return
	if(deployed)
		visible_message(span_danger("A flurry of beams shoot into the air from \the [src]!"))
		SSmotiontracker.ping(src,100) // Clunk!
		catch_ghost(passing_entity)
		deployed = FALSE
		anchored = FALSE
		update_icon()
		log_and_message_admins("has been captured at \the [get_area(loc)] by the [name], last touched by [forensic_data?.get_lastprint()]", passing_entity)
