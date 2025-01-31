#define RECYCLER_ALLOWED 1
#define RECYCLER_FORBIDDEN 2
#define RECYCLER_EVIL 3 //no scugs, cats, etc


/obj/machinery/MaintRecycler //fresh outta 2288 baby
	name = "Decrepit Machine"

	//icon etc are self contained because it's dumb that they not to begin with.
	//it's not a MODULE if everything required for it to work is thrown everywhere. grr.
	icon = 'code/modules/maint_recycler/icons/maint_recycler.dmi'
	icon_state = "default"

	desc = "A long since abandoned recycling kiosk. Now featuring a state of the art, monochrome holographic tube display!"
	description_info = "This machine allows you to recycle a limited amount of objects per round, the points you get from it can be used for goodies from another machine somewhere in maint!"
	description_fluff = "While the original owners stopped their partnership with NT after a data theft scandal, the machine itself has been adopted by endless hoardes of vintage hardware enthusiasts to Keep Maint Clean™️"

	anchored = TRUE
	density = TRUE
	unacidable = TRUE

	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	active_power_usage = 300
	clicksound = 'code/modules/maint_recycler/sfx/typing.ogg'

	var/door_open = FALSE
	var/door_moving = FALSE

	var/monitor_state = "off" //appearance of the monitor.

	var/obj/effect/overlay/recycler/hatch
	var/obj/effect/overlay/recycler/monitorScreen

	var/item_offset_x = -7
	var/item_offset_y = 0
	var/item_overlay_scale = 0.4

	var/obj/effect/overlay/recycler/item_overlay
	var/obj/item/inserted_item

	var/list/hostile_towards = list() //we remember mean people. do NOT recycle scugs. list of user keys


	//the tldr:
	//if we can get infinite of it easily, it's worth 1.
	//if we can get a fair amount but it wouldn't be worth the effort, it's worth 10
	// if it's an overt scene tool and kinda rare, we can't recycle it. Ae, compliance disk.
	// if it's technically a scene tool but mostly for shitposting (borg-os, bait toys, etc) we can recycle 'em for 10.
	// we can get them back cheaply via the vendor anyway


	var/list/item_whitelist = list(
		/obj/item/holder/mouse,
		/obj/item/holder/human,
		/obj/item/trash,
		/obj/item/clothing/head/cone,
		/obj/item/toy/plushie, //begone foul beasts
		/obj/item/flashlight/glowstick,
		/obj/item/trash/material, //different price scheme
		/obj/item/soap,
		/obj/item/toy/tennis,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_sight,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_heart,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_sleep,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_shock,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_fast,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_high,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_shrink,
		/obj/item/reagent_containers/food/drinks/cans/nukie_mega_grow, //nukies is epic but rare enough to warrant being recyclable.
		/obj/item/toy/monster_bait,
		/obj/item/material/fishing_net/butterfly_net,
		/obj/item/flashlight/flare) //anything that's a type of, or a subtype of these can be put in the machine. associated list

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

/obj/machinery/MaintRecycler/fall_apart(var/severity = 3, var/scatter = TRUE)
	return FALSE //don't fall apart

/obj/machinery/MaintRecycler/dismantle()
	return FALSE //we don't want something as important as this to be able to be disassembled. it's a scene tool, technically.

/obj/machinery/MaintRecycler/Initialize(mapload)
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

	item_overlay = new
	item_overlay.layer = src.layer-0.1
	src.vis_contents |= item_overlay

	//ditto for the monitor and door. sure, these COULD be overlays, but that is way more effort
	. = ..()

/obj/machinery/MaintRecycler/proc/whitelistCheck(var/obj/whitelistCandidate)

	. = RECYCLER_FORBIDDEN //default state

	for(var/t in item_blacklist_hostile)
		if(istype(whitelistCandidate,t))
			return RECYCLER_EVIL

	for(var/t in item_whitelist)
		if(istype(whitelistCandidate,t))
			return RECYCLER_ALLOWED

	return .

/obj/machinery/MaintRecycler/attackby(obj/item/O, mob/user)
	if(!door_open)
		to_chat(user, span_warning("\The [src] doesn't have it's door open!"))
		return

	if(inserted_item)
		to_chat(user, span_warning("\The [src] already has [inserted_item] in it's recycling compartment!"))
		return
	//TODO: check against whitelist....

	switch(whitelistCheck(O))
		if(RECYCLER_FORBIDDEN) //the usual stuff.
			deny_act(O,user)
			return

		if(RECYCLER_EVIL)
			evil_act(O,user)
			return

		if(RECYCLER_ALLOWED)
			to_chat(user, span_notice("you put \The [O] into \The [src]'s processing department!"))

	if(istype(O,/obj/item/holder))
		var/obj/item/holder/h = O
		var/mob/m = h.held_mob //TODO: Client check.
		user.drop_item()
		m.forceMove(src)
		inserted_item = m

	else
		user.drop_item()
		O.forceMove(src)
		inserted_item = O

	update_icon()
	. = ..()

//todo: throw code. look @ disposals.
/obj/machinery/MaintRecycler/proc/IsHostileToUser(var/mob/user) //negative points modifier for getting more.
	return (user.key in hostile_towards)

/obj/machinery/MaintRecycler/proc/deny_act(var/obj/item/O,var/mob/user)
	to_chat(user, span_warning("\The [src] rejects \The [O]!"))
	if(prob(99))
		playsound(src, 'code/modules/maint_recycler/sfx/generaldeny.ogg', 75, 1)
		return //todo
	else
		playsound(src, 'code/modules/maint_recycler/sfx/voice/mad/denied.ogg', 75)

//add people to the evil list, and be mean to them
/obj/machinery/MaintRecycler/proc/evil_act(var/obj/item/O,var/mob/user)
	var/isRepeat = IsHostileToUser(user)
	if(!isRepeat && user.key)
		hostile_towards |= user.key



	if(istype(O,/obj/item/holder) || istype(O,/mob/)) //just in case.
		var/obj/item/holder/h = O
		global_announcer.autosay("HARM ALERT: Crewmember [user] recorded displaying murderous tendencies towards innocent creatures in [get_area(src)]. Please schedule psych evaluation and ensure the wellbeing of recorded victim: [h.held_mob]", "[src]", "Security")
		audible_message("[src] states, \"AMORAL INTENT DETECTED.\" ", "\The [src]'s screen briefly flashes to an angry red graphic!" , runemessage = ">:(")
	else
		global_announcer.autosay("PROPERTY DESTRUCTION ALERT: Crewmember [user] has been recorded attempting to destroy high priority station equipment in [get_area(src)]. Please ensure the integrity of \The [O].", "[src]", "Security")
		audible_message("[src] states, \"CRIMINAL INTENT DETECTED.\" ", "\The [src]'s screen briefly flashes to an angry red graphic!" , runemessage = ">:(")

	playsound(src,pick(angry_sounds),80)

	var/projectile = /obj/item/projectile/beam/stun
	spawn(1)
		for(var/i = 1 to 3 )
		{
			var/obj/item/projectile/P = new projectile(loc)
			playsound(src, 'sound/weapons/Taser.ogg', 30, 1)
			P.firer = src
			P.old_style_target(user)
			P.fire()
			sleep(3)
		}

/obj/machinery/MaintRecycler/proc/mob_consent_check(var/mob/probable_victim)
	if(probable_victim.key)
		if(probable_victim.client) //sanity check to make sure they are alright with getting squished to death
			return (tgui_alert(usr,"Do you want to be put in \The [src]? Industrial machinery is generally considered pretty damn deadly at the best of the times, and this thing's ANCIENT, you'll probably die. to death, even. A fine paste.", "Welcome to the Hydralulic Press Prompt", list("OSHA is for chumps", "what the fuck? get me outta here!")) == "OSHA is for chumps")
		else return FALSE //no logged out users
	else return TRUE //mindless mobs that've never felt the gentle touch of a client are fine

/obj/machinery/MaintRecycler/proc/closeDoor()
	if(!door_open) return
	door_moving = TRUE
	flick("door closing",hatch)
	playsound(src, 'code/modules/maint_recycler/sfx/hatchclose.ogg', 40, 1)
	spawn(10) //wait a second. TODO: refactor to repo standards.
	hatch.icon_state = "door closed"
	door_open = FALSE
	door_moving = FALSE

/obj/machinery/MaintRecycler/proc/openDoor()
	if(door_open) return
	door_moving = TRUE
	flick("door opening",hatch)
	playsound(src, 'code/modules/maint_recycler/sfx/hatchopen.ogg', 40, 1)
	spawn(10) //wait a second. TODO: refactor to repo standards.
	hatch.icon_state = "door open"
	door_open = TRUE
	door_moving = FALSE

/obj/machinery/MaintRecycler/proc/ejectItem()
	if(inserted_item)
		inserted_item.forceMove(src.loc)
		visible_message(span_warning("[src] ejects \The [inserted_item] from it's recycling chamber!"))
		inserted_item = null;
		update_icon()

/obj/machinery/MaintRecycler/proc/recycleItem()
	return

/obj/machinery/MaintRecycler/update_icon()
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

	. = ..()

/obj/machinery/attack_hand(mob/user)
	if(..())
		return

	add_fingerprint(user)
	tgui_interact(user)



/obj/machinery/MaintRecycler/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user,src,ui)
	if(!ui)
		ui = new(user,src,"RecyclerInterface")
		ui.open()

/obj/machinery/MaintRecycler/tgui_data(mob/user)
	var/list/data = list()
	data["heldItemName"] = inserted_item?.name
	data["heldItemValue"] = 100 //TODO
	data["userName"] = user.name
	data["userBalance"] = user.client.recycle_points

	var/icon/display
	if(inserted_item)
		display = getFlatIcon(inserted_item) //dogshit! fix this! grr!
	else
		display = icon(src.icon,"NoItem")

	data["itemIcon"] = "'data:image/png;base64,[icon2base64(display)]'"
	return data

/obj/machinery/MaintRecycler/tgui_act(action,params)
	.=..()
	if(.)
		return
	if(action == "eject")
		ejectItem()
		. = TRUE
	if(action == "recycle")
		recycleItem()
		. = TRUE
	if(action == "close")
		closeDoor()
		. = TRUE
	if(action == "open")
		openDoor()
		. = TRUE

/obj/machinery/MaintRecycler/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/maintRecycler)
	)

/obj/effect/overlay/recycler
	anchored = TRUE
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER //over the inserted items.
	vis_flags = VIS_INHERIT_ID
	appearance_flags = KEEP_TOGETHER | LONG_GLIDE | PASS_MOUSE

//TODO:
//visual status for the monitor
//glow effect / lighting
//fix sounds for door shutter / add them
// add recycling sound
// UI interact sounds?

/datum/asset/simple/maintRecycler
	assets = list(
		"recycle.gif" = 'code/modules/maint_recycler/tgui/recycle.gif',
		"logo.png" = 'code/modules/maint_recycler/tgui/logo.png',
	)
