/*****************************Survival Pod********************************/
/area/survivalpod
	name = "\improper Emergency Shelter"
	icon_state = "away"
	dynamic_lighting = TRUE
	requires_power = FALSE
	has_gravity = TRUE

//Survival Capsule
/obj/item/device/survivalcapsule
	name = "surfluid shelter capsule"
	desc = "An emergency shelter programmed into construction nanomachines. It has a license for use printed on the bottom."
	icon_state = "houseball"
	icon = 'icons/obj/device_alt.dmi'
	w_class = ITEMSIZE_TINY
	var/template_id = "shelter_alpha"
	var/datum/map_template/shelter/template
	var/used = FALSE

/obj/item/device/survivalcapsule/proc/get_template()
	if(template)
		return
	template = SSmapping.shelter_templates[template_id]
	if(!template)
		throw EXCEPTION("Shelter template ([template_id]) not found!")
		qdel(src)

/obj/item/device/survivalcapsule/Destroy()
	template = null // without this, capsules would be one use. per round.
	. = ..()

/obj/item/device/survivalcapsule/examine(mob/user)
	. = ..()
	get_template()
	to_chat(user, "This capsule has the [template.name] stored.")
	to_chat(user, template.description)

/obj/item/device/survivalcapsule/attack_self()
	//Can't grab when capsule is New() because templates aren't loaded then
	get_template()
	if(!used)
		loc.visible_message("<span class='warning'>\The [src] begins to shake. Stand back!</span>")
		used = TRUE

		sleep(5 SECONDS)

		var/turf/deploy_location = get_turf(src)
		var/status = template.check_deploy(deploy_location)
		var/turf/above_location = GetAbove(deploy_location)

		switch(status)
			//Not allowed due to /area technical reasons
			if(SHELTER_DEPLOY_BAD_AREA)
				src.loc.visible_message("<span class='warning'>\The [src] will not function in this area.</span>")

			//Anchored objects or no space
			if(SHELTER_DEPLOY_BAD_TURFS, SHELTER_DEPLOY_ANCHORED_OBJECTS)
				var/width = template.width
				var/height = template.height
				src.loc.visible_message("<span class='warning'>\The [src] doesn't have room to deploy! You need to clear a [width]x[height] area!</span>")

		if(status != SHELTER_DEPLOY_ALLOWED)
			used = FALSE
			return

		var/turf/T = deploy_location
		var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
		smoke.attach(T)
		smoke.set_up(10, 0, T)
		smoke.start()
		sleep(4 SECONDS)

		playsound(get_turf(src), 'sound/effects/phasein.ogg', 100, 1)

		log_and_message_admins("[key_name_admin(usr)] activated a bluespace capsule at [get_area(T)]!")
		if(above_location)
			template.add_roof(above_location)
		template.annihilate_plants(deploy_location)
		template.load(deploy_location, centered = TRUE)
		template.update_lighting(deploy_location)
		qdel(src)

/obj/item/device/survivalcapsule/luxury
	name = "luxury surfluid shelter capsule"
	desc = "An exorbitantly expensive luxury suite programmed into construction nanomachines. There's a license for use printed on the bottom."
	template_id = "shelter_beta"

/obj/item/device/survivalcapsule/luxurybar
	name = "luxury surfluid bar capsule"
	desc = "A luxury bar in a capsule. Bartender required and not included. There's a license for use printed on the bottom."
	template_id = "shelter_gamma"

/obj/item/device/survivalcapsule/military
	name = "military surfluid shelter capsule"
	desc = "A prefabricated firebase in a capsule. Contains basic weapons, building materials, and combat suits. There's a license for use printed on the bottom."
	template_id = "shelter_delta"

//Custom Shelter Capsules
/obj/item/device/survivalcapsule/tabiranth
	name = "silver-trimmed surfluid shelter capsule"
	desc = "An exorbitantly expensive luxury suite programmed into construction nanomachines. This one is a particularly rare and expensive model. There's a license for use printed on the bottom."
	template_id = "shelter_phi"

//Pod objects
//Walls
/turf/simulated/shuttle/wall/voidcraft/survival
	name = "survival shelter"
	stripe_color = "#efbc3b"

/turf/simulated/shuttle/wall/voidcraft/survival/hard_corner
	hard_corner = 1

//Doors
/obj/machinery/door/airlock/voidcraft/survival_pod
	name = "survival airlock"
	block_air_zones = 1

//Door access setter button
/obj/machinery/button/remote/airlock/survival_pod
	name = "shelter privacy control"
	desc = "You can secure yourself inside the shelter here."
	specialfunctions = 4 // 4 is bolts
	id = "placeholder_id_do_not_use" //This has to be this way, otherwise it will control ALL doors if left blank.
	var/obj/machinery/door/airlock/voidcraft/survival_pod/door

/obj/machinery/button/remote/airlock/survival_pod/attack_hand(obj/item/weapon/W, mob/user as mob)
	if(..()) return 1 //1 is failure on machines (for whatever reason)
	if(!door)
		var/turf/dT = get_step(src,dir)
		door = locate() in dT
	if(door)
		door.glass = !door.glass
		door.opacity = !door.opacity

//Windows
/obj/structure/window/reinforced/survival_pod
	name = "pod window"
	icon = 'icons/obj/survival_pod.dmi'
	icon_state = "pwindow"
	basestate = "pwindow"

//The windows have diagonal versions, and will never be a full window
/obj/structure/window/reinforced/survival_pod/is_fulltile()
	return FALSE

/obj/structure/window/reinforced/survival_pod/update_icon()
	icon_state = basestate

//Windoor
/obj/machinery/door/window/survival_pod
	icon = 'icons/obj/survival_pod.dmi'
	icon_state = "windoor"
	base_state = "windoor"

//Table
/obj/structure/table/survival_pod
	name = "table"
	icon = 'icons/obj/survival_pod.dmi'
	icon_state = "table"
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/survival_pod/update_icon()
	icon_state = "table"

/obj/structure/table/survival_pod/New()
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	..()

/obj/structure/table/survival_pod/dismantle(obj/item/weapon/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return

//Sleeper
/obj/machinery/sleeper/survival_pod
	desc = "A limited functionality sleeper, all it can do is put patients into stasis. It lacks the medication and configuration of the larger units."
	icon = 'icons/obj/survival_pod.dmi'
	icon_state = "sleeper"
	stasis_level = 100 //Just one setting

/obj/machinery/sleeper/survival_pod/update_icon()
	if(occupant)
		add_overlay("sleeper_cover")
	else
		cut_overlays()

//Computer
/obj/item/device/gps/computer
	name = "pod computer"
	icon_state = "pod_computer"
	icon = 'icons/obj/survival_pod_comp.dmi'
	anchored = TRUE
	density = TRUE
	pixel_y = -32

/obj/item/device/gps/computer/attackby(obj/item/I, mob/living/user)
	if(I.is_wrench())
		user.visible_message("<span class='warning'>[user] disassembles [src].</span>",
			"<span class='notice'>You start to disassemble [src]...</span>", "You hear clanking and banging noises.")
		if(do_after(user,4 SECONDS,src))
			new /obj/item/device/gps(loc)
			qdel(src)
			return TRUE

	return FALSE

/obj/item/device/gps/computer/attack_hand(mob/user)
	attack_self(user)

//Bed
/obj/structure/bed/pod
	icon = 'icons/obj/survival_pod.dmi'
	icon_state = "bed"

/obj/structure/bed/pod/New(var/newloc)
	..(newloc,DEFAULT_WALL_MATERIAL,"cotton")

//Survival Storage Unit
/obj/machinery/smartfridge/survival_pod
	name = "survival pod storage"
	desc = "A heated storage unit."
	icon_state = "donkvendor"
	icon = 'icons/obj/survival_pod_vend.dmi'
	icon_on = "donkvendor"
	icon_off = "donkvendor"
	light_range = 5
	light_power = 1.2
	light_color = "#DDFFD3"
	pixel_y = -4
	max_n_of_items = 100

/obj/machinery/smartfridge/survival_pod/Initialize()
	. = ..()
	for(var/obj/item/O in loc)
		if(accept_check(O))
			stock(O)

/obj/machinery/smartfridge/survival_pod/accept_check(obj/item/O)
	return isitem(O)

/obj/machinery/smartfridge/survival_pod/empty
	name = "dusty survival pod storage"
	desc = "A heated storage unit. This one's seen better days."

//Fans
/obj/structure/fans
	icon = 'icons/obj/survival_pod.dmi'
	icon_state = "fans"
	name = "environmental regulation system"
	desc = "A large machine releasing a constant gust of air."
	anchored = TRUE
	density = TRUE
	can_atmos_pass = ATMOS_PASS_NO
	var/buildstacktype = /obj/item/stack/material/steel
	var/buildstackamount = 5

/obj/structure/fans/proc/deconstruct()
	new buildstacktype(loc,buildstackamount)
	qdel(src)

/obj/structure/fans/attackby(obj/item/I, mob/living/user)
	if(I.is_wrench())
		user.visible_message("<span class='warning'>[user] disassembles [src].</span>",
			"<span class='notice'>You start to disassemble [src]...</span>", "You hear clanking and banging noises.")
		if(do_after(user,4 SECONDS,src))
			deconstruct()
			return TRUE

	return TRUE

/obj/structure/fans/tiny
	name = "tiny fan"
	desc = "A tiny fan, releasing a thin gust of air."
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	density = FALSE
	icon_state = "fan_tiny"
	buildstackamount = 2

//Signs
/obj/structure/sign/mining
	name = "nanotrasen mining corps sign"
	desc = "A sign of relief for weary miners, and a warning for would-be competitors to Nanotrasen's mining claims."
	icon = 'icons/obj/survival_pod.dmi'
	icon_state = "ntpod"

/obj/structure/sign/mining/survival
	name = "shelter sign"
	desc = "A high visibility sign designating a safe shelter."
	icon = 'icons/obj/survival_pod.dmi'
	icon_state = "survival"

//Fluff
/obj/structure/tubes
	icon_state = "tubes"
	icon = 'icons/obj/survival_pod.dmi'
	name = "tubes"
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	density = FALSE
