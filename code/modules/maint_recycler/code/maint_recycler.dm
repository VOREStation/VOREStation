#define RECYCLER_ALLOWED 1
#define RECYCLER_FORBIDDEN 2
#define RECYCLER_EVIL 3 //no scugs, cats, etc


/obj/machinery/maint_recycler //fresh outta 2288 baby
	name = "Decrepit Machine"

	//icon etc are self contained because it's dumb that they not to begin with.
	//it's not a MODULE if everything required for it to work is thrown everywhere. grr.
	icon = 'code/modules/maint_recycler/icons/maint_recycler.dmi'
	icon_state = "default"

	desc = "A long since abandoned recycling kiosk. Now featuring a state of the art, monochrome holographic tube display!"
	description_info = "This machine allows you to recycle a limited amount of objects per round, the points you get from it can be used for goodies from another machine somewhere in maint!"
	description_fluff = "While the original owners stopped their partnership with NT after a data theft scandal, the machine itself has been adopted by endless hoardes of vintage hardware enthusiasts to \"Keep Maint Clean™️\" and facilitate what has to be the galaxy's most neurodivergent black market "

	anchored = TRUE
	density = TRUE
	unacidable = TRUE

	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	active_power_usage = 300
	clicksound = 'code/modules/maint_recycler/sfx/typing.ogg'

	light_color = "#0f8f0f"

	var/door_open = FALSE
	var/door_moving = FALSE
	var/door_locked = FALSE

	var/obj/effect/overlay/recycler/hatch
	var/obj/effect/overlay/recycler/monitor_screen
	var/obj/effect/overlay/recycler/item_overlay

	var/item_offset_x = -7
	var/item_offset_y = 0
	var/item_overlay_scale = 0.4


	var/obj/item/inserted_item

	var/list/hostile_towards = list() //we remember mean people. do NOT recycle scugs. list of user keys
	var/list/granted_points = list() //assoc list. key to points given



	var/is_on = FALSE
	var/light_range_on = 2
	var/light_power_on = 1

	//the tldr:
	//if we can get infinite of it easily, it's worth 1.
	//if we can get a fair amount but it wouldn't be worth the effort, it's worth 10
	// if it's an overt scene tool and kinda rare, we can't recycle it. Ae, compliance disk.
	// if it's technically a scene tool but mostly for shitposting (borg-os, bait toys, etc) we can recycle 'em for 10.
	// we can get them back cheaply via the vendor anyway

	var/point_cap = 150; //with the "baseline" for a scene item being about 50, this is 3 scene items per round. fair enough for me I think
	var/default_value = 5 //if something doesn't have a value, it's put to this. considering we use the whitelist to figure this out, it SHOULD never happen, but you never know.

	var/list/item_whitelist = list(
		/obj/item/holder/mouse = 1, //easy to get, and mostly just for comedic effect/justified mouse murder anyway
		/mob/living = 1, //default for all mobs tbh
		/obj/item/holder/micro = 1,
		/obj/item/holder/bird = 1, //fuck u poly
		/obj/item/trash = 5,
		/obj/item/trash/material = 10, //different price scheme
		/obj/item/clothing/head/cone = 10,
		/obj/item/toy/plushie = 5, //begone foul beasts
		/obj/item/toy/plushie/ipc = 20, //heating coils are worth more
		/obj/item/toy/tennis = 5,
		/obj/item/toy/figure = 5,
		/obj/item/toy/monster_bait = 10,
		/obj/item/flashlight/glowstick = 7,
		/obj/item/flashlight/flare = 7,
		/obj/item/soap = 7,
		/obj/item/aliencoin = 20,
		/obj/item/card/emag_broken = 15,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_sight = 15,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_heart = 15,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_sleep = 15,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_shock = 15,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_fast = 15,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_high = 15,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_shrink = 15,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_grow = 15, //nukies is epic but rare enough to warrant being recyclable.
		/obj/item/material/fishing_net/butterfly_net = 10
	)

	var/list/item_blacklist_general = list(
		/obj/item/card/id,

	) //anything that's passively blacklisted - even if they're part of the above, they'll be denied. this is in case you want to say, allow mice getting recycled, but not brown mice because that's racist

	var/list/item_blacklist_hostile = list(
		/obj/item/holder/catslug, //no scugs
		/obj/item/holder/cat, //no murdering jones or runtime
		/obj/item/organ/internal/brain, //posibrain murder
		/obj/item/card/id/centcom, //ERT id. won't ever come up but in 0.000% chance it does, it'd be funny.
		/obj/item/card/id/gold/captain, //probably will come up.
		/obj/item/disk/nuclear, //won't come up at all, but just in case.
		/obj/item/holder/possum/poppy, //poppy my beloved
		/obj/item/perfect_tele
	) //an active list of things that'll make the machine mad at you. Will refuse service, make an annoucement over sec comms (akin to the tipped medibot over med comms), and blast with a stun or two. no recycling scugs. Think of this as a super high priority no-touchy list.


	var/list/success_sounds = list(
		'code/modules/maint_recycler/sfx/voice/thankyou/reduce-reuse-recycle.ogg',
		'code/modules/maint_recycler/sfx/voice/thankyou/thankyouforkeepingclean.ogg',
		'code/modules/maint_recycler/sfx/voice/thankyou/the-ecosystem-thanks-you.ogg'
	)

	var/list/angry_sounds = list(
		'code/modules/maint_recycler/sfx/voice/mad/denied.ogg',
		'code/modules/maint_recycler/sfx/voice/mad/die die die die.ogg',
		'code/modules/maint_recycler/sfx/voice/mad/this will not stand.ogg'
	)

	///voice audio files filted via audacity:
	/// * Rectifier distort @ 39
	/// filter curve EQ w/ telephone preset



/obj/machinery/maint_recycler/fall_apart(var/severity = 3, var/scatter = TRUE)
	return FALSE //don't fall apart

/obj/machinery/maint_recycler/dismantle()
	return FALSE //we don't want something as important as this to be able to be disassembled. it's a scene tool, technically.

/obj/machinery/maint_recycler/Destroy()
	if(inserted_item)
		inserted_item.forceMove(get_turf(src))
		inserted_item = null

	if(hatch)
		QDEL_NULL(hatch)

	if(monitor_screen)
		QDEL_NULL(monitor_screen)

	if(item_overlay)
		QDEL_NULL(item_overlay)

	. = ..()


/obj/machinery/maint_recycler/Initialize(mapload)
	. = ..()
	//init hatch
	hatch = new
	hatch.icon = 'code/modules/maint_recycler/icons/maint_recycler.dmi'
	hatch.icon_state = "door closed"
	hatch.layer = src.layer+0.1
	src.vis_contents |= hatch

	var/image/underlay = image('code/modules/maint_recycler/icons/maint_recycler.dmi',src,"underlay")
	underlay.layer = src.layer-0.2 //we need the underlay as a kind of inbetween, we sandwich the item overlay between it and us
	//so even the big boy chunky items don't clip.
	//at least for 32x32 stuff!
	src.underlays |= underlay

	monitor_screen = new
	monitor_screen.plane = PLANE_LIGHTING_ABOVE
	monitor_screen.layer = src.layer + 0.1
	monitor_screen.icon = src.icon
	monitor_screen.icon_state = "screen_off"

	src.vis_contents |= monitor_screen

	item_overlay = new
	item_overlay.layer = src.layer-0.1
	src.vis_contents |= item_overlay

	if(mapload)
		return INITIALIZE_HINT_LATELOAD

	//ditto for the monitor and door. sure, these COULD be overlays, but that is way more effort

/obj/machinery/maint_recycler/LateInitialize()
	move_to_marker()

/obj/machinery/maint_recycler/proc/move_to_marker()
	if(GLOB.recycler_locations.len > 0)
		var/turf/spot = pick(GLOB.recycler_locations)
		forceMove(spot)
		dir = SOUTH
		log_admin("[src] has been placed at [loc], [x],[y],[z]")
		testing("[src] has been placed at [loc], [x],[y],[z]")
	else
		log_and_message_admins("[src] tried to move itself, but there was nowhere for it to go! (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)", null)

/obj/machinery/maint_recycler/attackby(obj/item/O, mob/user)
	if(!door_open)
		if(O.has_tool_quality(TOOL_CROWBAR))
			if(stat & (BROKEN|NOPOWER))
				to_chat(user, span_warning("you lever \The [src]'s door open!"))
				open_door(user)
				eject_item(user) //also kick out the item they're looking for
				playsound(src,"sound/machines/door/airlock_creaking.ogg",4,FALSE)

			else
				to_chat(user, span_warning("\The [src]'s door won't budge!"))
		else
			to_chat(user, span_warning("\The [src] doesn't have it's door open!"))
		return

	if(inserted_item)
		to_chat(user, span_warning("\The [src] already has [inserted_item] in it's recycling compartment!"))
		return

	switch(get_item_whitelist(O))
		if(RECYCLER_FORBIDDEN) //the usual stuff.
			deny_act(O,user)
			return

		if(RECYCLER_EVIL)
			evil_act(O,user)
			return

	to_chat(user, span_notice("you put \The [O] into \The [src]'s processing compartment!"))
	if(istype(O,/obj/item/holder))
		var/obj/item/holder/h = O
		var/mob/m = h.held_mob
		if(mob_consent_check(m))
			if(user in range(1,src))
				user.drop_item() //mobs need to be properly handled, can't just move the holder into the thing
				m.dir = SOUTH //the disposal bins do that and it simply doesn't work.
				m.forceMove(src)
				inserted_item = m
			else
				return //too far away, dumbass.
		else
			deny_act(O,user)
	else
		user.drop_item()
		O.forceMove(src)
		inserted_item = O

	update_icon()
	. = ..()



/obj/machinery/maint_recycler/hitby(atom/movable/AM)
	. = ..()
	if(istype(AM, /obj/item) && !istype(AM, /obj/item/projectile)) //no mob throwing.
		if(prob(75))
			if(get_item_whitelist(AM) == RECYCLER_ALLOWED)
				if(inserted_item == null)
					visible_message("\The [AM] lands in \the [src].")
					AM.forceMove(src)
					inserted_item = AM
					update_icon()
					playsound(src, 'code/modules/maint_recycler/sfx/voice/a wonderful throw.ogg', 75)
					set_screen_state("screen_happy",10)
					return
			else
				deny_act(AM,null)

		visible_message("\The [AM] bounces off of the rim of \the [src]'s processing compartment!")

/obj/machinery/maint_recycler/proc/deny_act(var/obj/item/O,var/mob/user)
	set_screen_state("screen_deny",10)
	to_chat(user, span_warning("\The [src] rejects \The [O]!"))
	if(prob(99))
		playsound(src, 'code/modules/maint_recycler/sfx/generaldeny.ogg', 75, 1)
		return
	else
		playsound(src, 'code/modules/maint_recycler/sfx/voice/mad/denied.ogg', 75)

//add people to the evil list, and be mean to them
/obj/machinery/maint_recycler/proc/evil_act(var/obj/item/O,var/mob/user)
	var/isRepeat = is_user_hostile(user)
	if(!isRepeat && user.key)
		hostile_towards |= user.key

	if(istype(O,/obj/item/holder) || istype(O,/mob/)) //just in case.
		var/obj/item/holder/h = O
		if(!isRepeat) GLOB.global_announcer.autosay("HARM ALERT: Crewmember [user] recorded displaying murderous tendencies towards innocent creatures in [get_area(src)]. Please schedule psych evaluation and ensure the wellbeing of recorded victim: [h.held_mob]", "[src]", "Security")
		audible_message("[src] states, \"AMORAL INTENT DETECTED.\" ", "\The [src]'s screen briefly flashes to an angry red graphic!" , runemessage = ">:(")
	else
		if(!isRepeat) GLOB.global_announcer.autosay("PROPERTY DESTRUCTION ALERT: Crewmember [user] has been recorded attempting to destroy high priority station equipment in [get_area(src)]. Please ensure the integrity of \The [O].", "[src]", "Security")
		audible_message("[src] states, \"CRIMINAL INTENT DETECTED.\" ", "\The [src]'s screen briefly flashes to an angry red graphic!" , runemessage = ">:(")

	playsound(src,pick(angry_sounds),80)
	set_screen_state("screen_mad",30)

	addtimer(CALLBACK(src, PROC_REF(shoot_at), user), 0.3 SECONDS)


	credit_user(user,-10) //get fucked

/obj/machinery/maint_recycler/proc/close_door(var/mob/user)
	if(!door_open || door_locked) return
	door_moving = TRUE
	flick("door closing",hatch)
	playsound(src, 'code/modules/maint_recycler/sfx/hatchclose.ogg', 40, 1)
	addtimer(CALLBACK(src, PROC_REF(door_finished_moving), FALSE), 1 SECOND)


/obj/machinery/maint_recycler/proc/open_door(var/mob/user)
	if(door_open || door_locked) return
	door_moving = TRUE
	flick("door opening",hatch)
	playsound(src, 'code/modules/maint_recycler/sfx/hatchopen.ogg', 40, 1)
	addtimer(CALLBACK(src, PROC_REF(door_finished_moving), TRUE), 1 SECOND)


/obj/machinery/maint_recycler/proc/door_finished_moving(var/open)
	door_moving = FALSE
	door_open = open
	if(open)
		hatch.icon_state = "door open"
	else
		hatch.icon_state = "door closed"


/obj/machinery/maint_recycler/proc/shoot_at(var/mob/victim, var/burst = 3)
	if(victim == null) return
	for(var/i = 1 to burst)
		addtimer(CALLBACK(src, PROC_REF(shoot), victim), (0.3 * i SECONDS))

/obj/machinery/maint_recycler/proc/shoot(var/mob/victim)
	var/projectile = /obj/item/projectile/beam/stun
	var/obj/item/projectile/P = new projectile(loc)
	playsound(src, 'sound/weapons/Taser.ogg', 30, 1)
	P.old_style_target(victim)
	P.fire()

/obj/machinery/maint_recycler/container_resist(var/mob/living)
	eject_item(living) //100% chance. don't sweat it.

/obj/machinery/maint_recycler/proc/eject_item(var/mob/user)
	if(inserted_item)
		if(!door_open)
			open_door(user)
			addtimer(CALLBACK(src, PROC_REF(eject_item_act), user), 1 SECOND)
		else
			eject_item_act(user)


/obj/machinery/maint_recycler/proc/eject_item_act(var/mob/user)
	inserted_item.forceMove(get_turf(src))
	visible_message(span_warning("[src] ejects \The [inserted_item] from it's recycling chamber!"))
	inserted_item.throw_at(get_step(src,SOUTH),5,1,src)
	inserted_item = null;
	update_icon()


/obj/machinery/maint_recycler/proc/start_recycling(var/mob/user)
	if(inserted_item)
		if(door_open)
			close_door(user)
			addtimer(CALLBACK(src, PROC_REF(recycle_act), user), 1 SECOND)
		else
			recycle_act(user)

/obj/machinery/maint_recycler/proc/recycle_act(var/mob/user)
	if(!inserted_item)
		to_chat(user, span_warning("\The [src] doesn't have anything to recycle!"))
		return //sanity check
	door_locked = TRUE
	playsound(src, 'code/modules/maint_recycler/sfx/recycle_act.ogg', 50)
	set_screen_state("screen_recycle",20)
	addtimer(CALLBACK(src, PROC_REF(post_recycle), user), 2 SECONDS)


/obj/machinery/maint_recycler/proc/post_recycle(var/mob/user)
	var/value = try_get_obj_value(inserted_item)
	credit_user(user,value)
	if(istype(inserted_item,/mob))
		var/mob/m = inserted_item
		m.gib() //do we want logs here, or in the mob consent?
	else
		qdel(inserted_item)
	set_screen_state("screen_cashout",10)
	inserted_item = null
	door_locked = FALSE
	open_door(user)
	update_icon()


/obj/machinery/maint_recycler/update_icon()
	if(inserted_item != null)
		item_overlay.appearance = inserted_item.appearance;
		//todo, assoc list for icon states from type
		if(istype(inserted_item,/mob/living/simple_mob/animal/passive/mouse))
			item_overlay.icon = src.icon
			item_overlay.icon_state = "hepme" //the creature deserves it's horrible end

		item_overlay.vis_flags = VIS_INHERIT_ID //gotta reapply
		item_overlay.appearance_flags = KEEP_TOGETHER | LONG_GLIDE | PASS_MOUSE

		item_overlay.plane = src.plane
		item_overlay.layer = src.layer - 0.1
		item_overlay.pixel_x = item_offset_x
		item_overlay.pixel_y = item_offset_y
		var/matrix/scaleMatrix = new()
		scaleMatrix.Scale(item_overlay_scale,item_overlay_scale)
		item_overlay.transform = scaleMatrix
	else //hide it
		item_overlay.icon = null
		item_overlay.icon_state = "fsdfsd"
		item_overlay.overlays = null
		item_overlay.underlays = null

	. = ..()

/obj/machinery/maint_recycler/attack_hand(mob/user)
	if(..(user))
		return

	add_fingerprint(user)
	tgui_interact(user)
	if(!is_on)
		set_on_state(TRUE)

/*
TGUI PROCS
*/
/obj/machinery/maint_recycler/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user,src,ui)
	if(!ui)
		ui = new(user,src,"RecyclerInterface")
		ui.open()

/obj/machinery/maint_recycler/tgui_data(mob/user)
	var/list/data = list()
	data["heldItemName"] = inserted_item?.name
	data["heldItemValue"] = try_get_obj_value(inserted_item)
	data["userName"] = user.name
	data["userBalance"] = user_balance(user)

	var/icon/display
	if(inserted_item)
		display = getFlatIcon(inserted_item) //dogshit! fix this! grr!
	else
		display = icon(src.icon,"NoItem")

	data["itemIcon"] = "'data:image/png;base64,[icon2base64(display)]'"
	return data


/obj/machinery/maint_recycler/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/maint_recycler)
	)

/obj/machinery/maint_recycler/tgui_act(action,params,datum/tgui/ui)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	if(action == "eject")
		eject_item(ui.user)
		. = TRUE
	if(action == "recycle")
		if(canRecycle(ui.user))
			start_recycling(ui.user)
		else
			deny_act(inserted_item,ui.user)
			to_chat(ui.user,span_warning("You have reached your daily RecyclePoints(tm) Allowance!"))
		. = TRUE
	if(action == "close")
		close_door(ui.user)
		. = TRUE
	if(action == "open")
		open_door(ui.user)
		. = TRUE

/obj/machinery/maint_recycler/tgui_close(mob/user)
	. = ..()
	set_on_state(FALSE)


/*
UTILITY PROCS
*/

/obj/machinery/maint_recycler/proc/credit_user(var/mob/user, var/amount)
	if(!user || !user.client || !user.client.prefs) return
	var/currentValue = 	user.client?.prefs?.read_preference(/datum/preference/numeric/recycler_points)
	user.client?.prefs?.write_preference_by_type(/datum/preference/numeric/recycler_points, currentValue + amount)
	if(granted_points[user.key])
		granted_points[user.key] += amount
	else
		granted_points[user.key] = amount


/obj/machinery/maint_recycler/proc/user_balance(var/mob/user)
	return user.client?.prefs?.read_preference(/datum/preference/numeric/recycler_points)

/obj/machinery/maint_recycler/proc/canRecycle(var/mob/user, var/potentialValue)
	if(!user.key) return FALSE
	if(granted_points[user.key]+potentialValue > point_cap)  return FALSE
	return TRUE

/obj/machinery/maint_recycler/proc/mob_consent_check(var/mob/probable_victim)
	if(probable_victim.key)
		if(probable_victim.client) //sanity check to make sure they are alright with getting squished to death
			return (tgui_alert(usr,"Do you want to be put in \The [src]? Industrial machinery is pretty damn deadly, you'll probably die. to death. A fine paste.", "Welcome to the Hydralulic Press Prompt", list("OSHA is for chumps", "what the fuck? get me outta here!")) == "OSHA is for chumps")
		else return FALSE //no logged out users
	else return TRUE //mindless mobs that've never felt the gentle touch of a client are fine

/obj/machinery/maint_recycler/proc/is_user_hostile(var/mob/user) //negative points modifier for getting more.
	return (user.key in hostile_towards)

/obj/machinery/maint_recycler/proc/try_get_obj_value(var/obj/candidate)
	if(candidate == null) return null //default
	var/init_price = 0
	init_price = item_whitelist[candidate.type]
	if(init_price > 0) return init_price //exact type matching.

	for(var/type in item_whitelist)
		if(istype(candidate,type))
			var/potentialPrice = item_whitelist[type]
			if(potentialPrice > init_price)
				init_price = potentialPrice

	if(init_price == 0)
		init_price = default_value

	return init_price

/obj/machinery/maint_recycler/proc/get_item_whitelist(var/obj/whitelistCandidate)

	. = RECYCLER_FORBIDDEN //default state

	for(var/t in item_blacklist_hostile)
		if(istype(whitelistCandidate,t))
			return RECYCLER_EVIL

	for(var/t in item_whitelist)
		if(istype(whitelistCandidate,t))
			return RECYCLER_ALLOWED

	return .

/obj/machinery/maint_recycler/power_change()
	..()
	if(stat & NOPOWER)
		set_on_state(FALSE)

/obj/machinery/maint_recycler/proc/set_screen_state(var/state, var/duration = 10)
	if(!is_on) return
	monitor_screen.icon_state = state
	addtimer(CALLBACK(src, PROC_REF(reset_screen_state)), duration)



/obj/machinery/maint_recycler/proc/reset_screen_state()
	if(!is_on)
		monitor_screen.icon_state = "screen_off"
	else
		monitor_screen.icon_state = "screen_default"

/obj/machinery/maint_recycler/proc/set_on_state(var/state)
	if(is_on == state) return
	is_on = state
	if(is_on)
		playsound(src, 'code/modules/maint_recycler/sfx/initialBoot.ogg', 20, 1)
		set_light(light_range_on, light_power_on)
		monitor_screen.icon_state = "screen_default"
	else
		playsound(src, 'sound/machines/terminal_off.ogg', 50, 1)
		set_light(0)
		monitor_screen.icon_state = "screen_off"


#undef RECYCLER_ALLOWED
#undef RECYCLER_FORBIDDEN
#undef RECYCLER_EVIL
