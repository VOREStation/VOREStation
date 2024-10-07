//This gateway type takes a special item that you will have to find on the map to activate, instead of using a multitool//

/obj/machinery/gateway/centeraway/mcguffin
	icon = 'icons/obj/machines/gateway_vr.dmi'
	calibrated = 0
	var/mcguffin_type = /obj/item/mcguffin/brass //you should be able to change the var to be whatever kind of path you like, so maybe you can use other things on it sometimes
	var/key //holds a ref to the key we spawned

/obj/machinery/gateway/centeraway/mcguffin/attackby(obj/item/W as obj, mob/user as mob)
	if(calibrated && stationgate)
		to_chat(user, span_info("The gate is already configured, you should be able to activate it."))
		return
	else if(!stationgate)
		to_chat(user, span_danger("Error: Configuration failed. No destination found... That can't be good."))
		return

	if(istype(W,mcguffin_type) && !calibrated)
		to_chat(user, span_npc_emote("As the device nears the gateway, mechanical clunks and whirrs can be heard. <br>[span_blue(span_bold("Configuration successful! "))]<br>This gate's systems have been fine tuned. Travel to this gate will now be on target."))
		calibrated = 1
		return
	else
		to_chat(user, span_danger("This device does not seem to interface correctly with the gateway. Perhaps you should try something else."))
		return

//If you use this kind of gateway you NEED one of these on the map or the players won't be able to leave//
//You should use the random spawner though so it won't always be in the same place//
/obj/item/mcguffin/brass
	name = "mysterious brass device"
	desc = "A curious object made of what appears to be brass and silver. Its purpose is unclear by looking at it. Perhaps it should be used with something of similar materials?"
	icon = 'icons/obj/machines/gateway_vr.dmi'
	icon_state = "mcguffin"
	drop_sound = 'sound/items/drop/wrench.ogg'
	pickup_sound = 'sound/items/pickup/wrench.ogg'

/obj/effect/landmark/mcguffin_spawner
	name = "gateway key spawner"
	icon = 'icons/mob/randomlandmarks.dmi'
	icon_state = "key"

/obj/machinery/gateway/centeraway/proc/entrydetect()
    return

/obj/machinery/gateway/centeraway/mcguffin/entrydetect()
    if(key)
        return

    var/list/spawners = list()
    for(var/obj/effect/landmark/mcguffin_spawner/sp in world)
        spawners += sp

    var/obj/effect/landmark/mcguffin_spawner/the_cool_one = pick(spawners)

    var/atom/destination = get_turf(the_cool_one)
    var/obj/structure/closet/CL = locate() in destination
    if(CL)
        destination = CL

    if(!destination)
        warning("A gateway is trying to spawn it's mcguffin but there are no mapped in spawner landmarks")
        destination = get_turf(src)

    key = new mcguffin_type(destination)

/obj/machinery/gateway/centeraway/mcguffin/Bumped(atom/movable/M as mob|obj)
	if(!ready)	return
	if(!active)	return
	M.forceMove(get_step(stationgate.loc, SOUTH))
	M.set_dir(SOUTH)
	M << 'sound/effects/swooshygate.ogg'
	playsound(src, 'sound/effects/swooshygate.ogg', 100, 1)

/obj/machinery/gateway/brass
	name = "mysterious brass gateway"
	desc = "A gateway of strange construction. It appears to be made primarily of materials resembling brass and silver."
	icon = 'icons/obj/machines/gateway_vr.dmi'

//No, you can't digest the key to leave the gateway.
/obj/item/mcguffin/digest_act(var/atom/movable/item_storage = null)
	return FALSE
