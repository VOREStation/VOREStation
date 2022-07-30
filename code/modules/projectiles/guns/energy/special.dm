/obj/item/gun/energy/ionrifle
	name = "ion rifle"
	desc = "The RayZar Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. Not the best of its type."
	description_fluff = "RayZar is Ward-Takahashi’s main consumer weapons brand, known for producing and licensing a wide variety of specialist energy weapons of various types and quality primarily for the civilian market."
	icon_state = "ionrifle"
	item_state = "ionrifle"
	wielded_item_state = "ionrifle-wielded"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)
	w_class = ITEMSIZE_LARGE
	force = 10
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/ion

/obj/item/gun/energy/ionrifle/emp_act(severity)
	..(max(severity, 4)) //so it doesn't EMP itself, I guess

/obj/item/gun/energy/ionrifle/empty
	cell_type = null

/obj/item/gun/energy/ionrifle/pistol
	name = "ion pistol"
	desc = "The RayZar Mk63 EW Pan is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. This model sacrifices capacity for portability."
	icon_state = "ionpistol"
	item_state = null
	w_class = ITEMSIZE_NORMAL
	force = 5
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	charge_cost = 480
	projectile_type = /obj/item/projectile/ion/pistol

/obj/item/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	item_state = "decloner"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_POWER = 3)
	projectile_type = /obj/item/projectile/energy/declone

/obj/item/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	description_fluff = "The floral somatoray is a relatively recent invention of the NanoTrasen corporation, turning a process that once involved transferring plants to massive mutating racks, into a remote interface. Do not look directly into the transmission end."
	icon_state = "floramut100"
	item_state = "floramut"
	projectile_type = /obj/item/projectile/energy/floramut
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	modifystate = "floramut"
	cell_type = /obj/item/cell/device/weapon/recharge
	battery_lock = 1

	var/decl/plantgene/gene = null
	var/obj/item/stock_parts/micro_laser/emitter

	firemodes = list(
		list(mode_name="induce mutations", projectile_type=/obj/item/projectile/energy/floramut, modifystate="floramut"),
		list(mode_name="increase yield", projectile_type=/obj/item/projectile/energy/florayield, modifystate="florayield"),
		list(mode_name="induce specific mutations", projectile_type=/obj/item/projectile/energy/floramut/gene, modifystate="floramut"),
		)

/obj/item/gun/energy/floragun/Initialize()
	. = ..()
	emitter = new(src)

/obj/item/gun/energy/floragun/examine(var/mob/user)
	. = ..()
	if(Adjacent(user))
		. += "It has [emitter ? emitter : "no micro laser"] installed."

/obj/item/gun/energy/floragun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stock_parts/micro_laser))
		if(!emitter)
			user.drop_item()
			W.loc = src
			emitter = W
			to_chat(user, "<span class='notice'>You install a [emitter.name] in [src].</span>")
		else
			to_chat(user, "<span class='notice'>[src] already has a laser.</span>")

	else if(W.is_screwdriver())
		if(emitter)
			to_chat(user, "<span class='notice'>You remove the [emitter.name] from the [src].</span>")
			emitter.loc = get_turf(src.loc)
			playsound(src, W.usesound, 50, 1)
			emitter = null
			return
		else
			to_chat(user, "<span class='notice'>There is no micro laser in this [src].</span>")
			return

/obj/item/gun/energy/floragun/afterattack(obj/target, mob/user, adjacent_flag)
	//allow shooting into adjacent hydrotrays regardless of intent
	if(!emitter)
		to_chat(user, "<span class='notice'>The [src] has no laser! </span>")
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		return
	if(adjacent_flag && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		user.visible_message("<span class='danger'>\The [user] fires \the [src] into \the [target]!</span>")
		Fire(target,user)
		return
	..()

/obj/item/gun/energy/floragun/verb/select_gene()
	set name = "Select Gene"
	set category = "Object"
	set src in view(1)

	var/genemask = tgui_input_list(usr, "Choose a gene to modify.", "Gene Choice", SSplants.plant_gene_datums)

	if(!genemask)
		return

	gene = SSplants.plant_gene_datums[genemask]

	to_chat(usr, "<span class='info'>You set the [src]'s targeted genetic area to [genemask].</span>")

	return

/obj/item/gun/energy/floragun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/energy/floramut/gene/G = .
	var/obj/item/projectile/energy/florayield/GY = .
	var/obj/item/projectile/energy/floramut/GM = .
	// Inserting the upgrade level of the gun to the projectile as there isn't a better way to do this.
	if(istype(G))
		G.gene = gene
		G.lasermod = emitter.rating
	else if(istype(GY))
		GY.lasermod = emitter.rating
	else if(istype(GM))
		GM.lasermod = emitter.rating

/obj/item/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "riotgun"
	item_state = "c20r"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	projectile_type = /obj/item/projectile/meteor
	cell_type = /obj/item/cell/potato
	charge_cost = 100
	self_recharge = 1
	recharge_time = 5 //Time it takes for shots to recharge (in ticks)
	charge_meter = 0

/obj/item/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_BELT


/obj/item/gun/energy/mindflayer
	name = "mind flayer"
	desc = "A custom-built weapon of some kind."
	icon_state = "xray"
	projectile_type = /obj/item/projectile/beam/mindflayer

/obj/item/gun/energy/toxgun
	name = "phoron pistol"
	desc = "A specialized firearm designed to fire lethal bolts of phoron."
	icon_state = "toxgun"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	projectile_type = /obj/item/projectile/energy/phoron

/* Staves */

/obj/item/gun/energy/staff
	name = "staff of change"
	desc = "An artifact that spits bolts of coruscating energy which cause the target's very form to reshape itself."
	icon = 'icons/obj/gun.dmi'
	item_icons = null
	icon_state = "staffofchange"
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	charge_cost = 480
	projectile_type = /obj/item/projectile/change
	origin_tech = null
	cell_type = /obj/item/cell/device/weapon/recharge
	battery_lock = 1
	charge_meter = 0

/obj/item/gun/energy/staff/special_check(var/mob/user)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		to_chat(usr, "<span class='warning'>You focus your mind on \the [src], but nothing happens!</span>")
		return 0

	return ..()

/obj/item/gun/energy/staff/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src, 'sound/effects/sparks1.ogg', 100, 1)
/*
/obj/item/gun/energy/staff/animate
	name = "staff of animation"
	desc = "An artifact that spits bolts of life force, which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	projectile_type = /obj/item/projectile/animate
	charge_cost = 240
*/
/obj/item/gun/energy/staff/focus
	name = "mental focus"
	desc = "An artifact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "focus"
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/forcebolt
	/*
	attack_self(mob/living/user as mob)
		if(projectile_type == "/obj/item/projectile/forcebolt")
			charge_cost = 400
			to_chat(user, "<span class='warning'>The [src.name] will now strike a small area.</span>")
			projectile_type = "/obj/item/projectile/forcebolt/strong"
		else
			charge_cost = 200
			to_chat(user, "<span class='warning'>The [src.name] will now strike only a single person.</span>")
			projectile_type = "/obj/item/projectile/forcebolt"
	*/

/obj/item/gun/energy/dakkalaser
	name = "suppression gun"
	desc = "A massive weapon designed to pressure the opposition by raining down a torrent of energy pellets."
	icon_state = "dakkalaser"
	item_state = "dakkalaser"
	wielded_item_state = "dakkalaser-wielded"
	w_class = ITEMSIZE_HUGE
	charge_cost = 24 // 100 shots, it's a spray and pray (to RNGesus) weapon.
	projectile_type = /obj/item/projectile/energy/blue_pellet
	cell_type = /obj/item/cell/device/weapon/recharge
	battery_lock = 1
	accuracy = 75 // Suppressive weapons don't work too well if there's no risk of being hit.
	burst_delay = 1 // Burst faster than average.
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 6, TECH_ILLEGAL = 6)

	firemodes = list(
		list(mode_name="single shot", burst = 1, burst_accuracy = list(75), dispersion = list(0), charge_cost = 24),
		list(mode_name="five shot burst", burst = 5, burst_accuracy = list(75,75,75,75,75), dispersion = list(1,1,1,1,1)),
		list(mode_name="ten shot burst", burst = 10, burst_accuracy = list(75,75,75,75,75,75,75,75,75,75), dispersion = list(2,2,2,2,2,2,2,2,2,2)),
		)

/obj/item/gun/energy/maghowitzer
	name = "portable MHD howitzer"
	desc = "A massive weapon designed to destroy fortifications with a stream of molten tungsten."
	description_fluff = "A weapon designed by joint cooperation of NanoTrasen, Hephaestus, and SCG scientists. Everything else is red tape and black highlighters."
	description_info = "This weapon requires a wind-up period before being able to fire. Clicking on a target will create a beam between you and its turf, starting the timer. Upon completion, it will fire at the designated location."
	icon_state = "mhdhowitzer"
	item_state = "mhdhowitzer"
	wielded_item_state = "mhdhowitzer-wielded"
	w_class = ITEMSIZE_HUGE

	charge_cost = 10000 // Uses large cells, can at max have 3 shots.
	projectile_type = /obj/item/projectile/beam/tungsten
	cell_type = /obj/item/cell/high
	accept_cell_type = /obj/item/cell

	accuracy = 75
	charge_meter = 0
	one_handed_penalty = 30

	var/power_cycle = FALSE

/obj/item/gun/energy/maghowitzer/proc/pick_random_target(var/turf/T)
	var/foundmob = FALSE
	var/foundmobs = list()
	for(var/mob/living/L in T.contents)
		foundmob = TRUE
		foundmobs += L
	if(foundmob)
		var/return_target = pick(foundmobs)
		return return_target
	return FALSE

/obj/item/gun/energy/maghowitzer/attack(atom/A, mob/living/user, def_zone)
	if(power_cycle)
		to_chat(user, "<span class='notice'>\The [src] is already powering up!</span>")
		return 0
	var/turf/target_turf = get_turf(A)
	var/beameffect = user.Beam(target_turf,icon_state="sat_beam",icon='icons/effects/beam.dmi',time=31, maxdistance=10,beam_type=/obj/effect/ebeam,beam_sleep_time=3)
	if(beameffect)
		user.visible_message("<span class='cult'>[user] aims \the [src] at \the [A].</span>")
	if(power_supply && power_supply.charge >= charge_cost) //Do a delay for pointblanking too.
		power_cycle = TRUE
		if(do_after(user, 30))
			if(A.loc == target_turf)
				..(A, user, def_zone)
			else
				var/rand_target = pick_random_target(target_turf)
				if(rand_target)
					..(rand_target, user, def_zone)
				else
					..(target_turf, user, def_zone)
		else
			if(beameffect)
				qdel(beameffect)
		power_cycle = FALSE
	else
		..(A, user, def_zone) //If it can't fire, just bash with no delay.

/obj/item/gun/energy/maghowitzer/afterattack(atom/A, mob/living/user, adjacent, params)
	if(power_cycle)
		to_chat(user, "<span class='notice'>\The [src] is already powering up!</span>")
		return 0

	var/turf/target_turf = get_turf(A)

	var/beameffect = user.Beam(target_turf,icon_state="sat_beam",icon='icons/effects/beam.dmi',time=31, maxdistance=10,beam_type=/obj/effect/ebeam,beam_sleep_time=3)

	if(beameffect)
		user.visible_message("<span class='cult'>[user] aims \the [src] at \the [A].</span>")

	if(!power_cycle)
		power_cycle = TRUE
		if(do_after(user, 30))
			if(A.loc == target_turf)
				..(A, user, adjacent, params)
			else
				var/rand_target = pick_random_target(target_turf)
				if(rand_target)
					..(rand_target, user, adjacent, params)
				else
					..(target_turf, user, adjacent, params)
		else
			if(beameffect)
				qdel(beameffect)
			handle_click_empty(user)
		power_cycle = FALSE
	else
		to_chat(user, "<span class='notice'>\The [src] is already powering up!</span>")
