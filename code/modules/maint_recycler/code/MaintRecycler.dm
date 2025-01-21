/obj/machinery/MaintRecycler //fresh outta 2298 baby
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

	var/list/hostile_towards //we remember mean people. do NOT recycle scugs.

	///radial

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

/obj/machinery/MaintRecycler/attackby(obj/item/O, mob/user)
	if(!door_open)
		to_chat(user, span_warning("\The [src] doesn't have it's door open!"))
		return

	if(inserted_item)
		to_chat(user, span_warning("\The [src] already has [inserted_item] in it's recycling compartment!"))
		return
	//TODO: check against whitelist....

	if(istype(O,/obj/item/holder))
		var/obj/item/holder/h = O
		var/mob/m = h.held_mob
		user.drop_item()
		m.forceMove(src)
		inserted_item = m

	else
		user.drop_item()
		O.forceMove(src)
		inserted_item = O

	update_icon()
	. = ..()


/obj/machinery/MaintRecycler/proc/closeDoor()
	if(!door_open) return
	door_moving = TRUE
	flick("door closing",hatch)
	playsound(src, 'sound/effects/blobattack.ogg', 40, 1)
	spawn(10) //wait a second. TODO: refactor to repo standards.
	hatch.icon_state = "door closed"
	door_open = FALSE
	door_moving = FALSE

/obj/machinery/MaintRecycler/proc/openDoor()
	if(door_open) return
	door_moving = TRUE
	flick("door opening",hatch)
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

		if(istype(inserted_item,/mob/))
			item_overlay.icon = src.icon
			item_overlay.icon_state = "hepme"

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

	var/icon/display
	if(inserted_item)
		display = getFlatIcon(inserted_item) //dogshit! fix this! grr!
	else
		display = icon('html/images/no_image32.png')

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
//custom tgui theme with crt effect https://aleclownes.com/2017/02/01/crt-display.html
//
//fix eject not resetting icon appearance
//fix layering for
/datum/asset/simple/maintRecycler
	assets = list(
		"recycle.gif" = 'code/modules/maint_recycler/tgui/recycle.gif',
	)
