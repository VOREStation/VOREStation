/obj/item/weapon/gun/magnetic/railgun
	name = "railgun"
	desc = "The Mars Military Industries MI-76 Thunderclap. A man-portable mass driver for squad support anti-armour and destruction of fortifications and emplacements."
	gun_unreliable = 0
	icon_state = "railgun"
	removable_components = FALSE
	load_type = /obj/item/weapon/rcd_ammo
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	projectile_type = /obj/item/projectile/bullet/magnetic/slug
	power_cost = 300
	w_class = ITEMSIZE_HUGE
	slot_flags = SLOT_BELT
	loaded = /obj/item/weapon/rcd_ammo/large
	slowdown = 1	// Slowdown equals slowdown_worn, until we decide to import the system to differentiate between held and worn items
	fire_delay = 1

	var/initial_cell_type = /obj/item/weapon/cell/hyper
	var/initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/adv
	var/slowdown_held = 2
	var/slowdown_worn = 1
	var/empty_sound = 'sound/machines/twobeep.ogg'

/obj/item/weapon/gun/magnetic/railgun/New()
	capacitor = new initial_capacitor_type(src)
	capacitor.charge = capacitor.max_charge

	cell = new initial_cell_type(src)
	if (ispath(loaded))
		loaded = new loaded
	. = ..()

// Not going to check type repeatedly, if you code or varedit
// load_type and get runtime errors, don't come crying to me.
/obj/item/weapon/gun/magnetic/railgun/show_ammo(var/mob/user)
	var/obj/item/weapon/rcd_ammo/ammo = loaded
	if (ammo)
		to_chat(user, "<span class='notice'>There are [ammo.remaining] shot\s remaining in \the [loaded].</span>")
	else
		to_chat(user, "<span class='notice'>There is nothing loaded.</span>")

/obj/item/weapon/gun/magnetic/railgun/check_ammo()
	var/obj/item/weapon/rcd_ammo/ammo = loaded
	return ammo && ammo.remaining

/obj/item/weapon/gun/magnetic/railgun/use_ammo()
	var/obj/item/weapon/rcd_ammo/ammo = loaded
	ammo.remaining--
	if(ammo.remaining <= 0)
		out_of_ammo()

/obj/item/weapon/gun/magnetic/railgun/proc/out_of_ammo()
	loaded.forceMove(get_turf(src))
	loaded = null
	visible_message("<span class='warning'>\The [src] beeps and ejects its empty cartridge.</span>","<span class='warning'>There's a beeping sound!</span>")
	playsound(get_turf(src), empty_sound, 40, 1)

/obj/item/weapon/gun/magnetic/railgun/automatic // Adminspawn only, this shit is absurd.
	name = "\improper RHR accelerator"
	desc = "The Mars Military Industries MI-227 Meteor. Originally a vehicle-mounted turret weapon for heavy anti-vehicular and anti-structural fire, the fact that it was made man-portable is mindboggling in itself."
	icon_state = "heavy_railgun"

	initial_cell_type = /obj/item/weapon/cell/infinite
	initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/super
	fire_delay = 0

	slowdown = 2
	slowdown_held = 3
	slowdown_worn = 2

	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_NO_CONTAINER

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, one_handed_penalty=15, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, move_delay=5, one_handed_penalty=30, burst_accuracy=list(0,-15,-15), dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="long bursts", burst=6, fire_delay=null, move_delay=10, one_handed_penalty=30, burst_accuracy=list(0,-15,-15,-15,-30), dispersion=list(0.6, 0.6, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/magnetic/railgun/automatic/examine(var/mob/user)
	. = ..(user,1)
	if(.)
		to_chat(user, "<span class='notice'>Someone has scratched <i>Ultima Ratio Regum</i> onto the side of the barrel.</span>")

/obj/item/weapon/gun/magnetic/railgun/flechette
	name = "flechette gun"
	desc = "The MI-12 Skadi is a burst fire capable railgun that fires flechette rounds at high velocity. Deadly against armour, but much less effective against soft targets."
	icon_state = "flechette_gun"
	item_state = "z8carbine"

	initial_cell_type = /obj/item/weapon/cell/hyper
	initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/adv

	fire_delay = 0

	slot_flags = SLOT_BACK

	slowdown = 0
	slowdown_held = 0
	slowdown_worn = 0

	power_cost = 100
	load_type = /obj/item/weapon/magnetic_ammo
	projectile_type = /obj/item/projectile/bullet/magnetic/flechette
	loaded = /obj/item/weapon/magnetic_ammo
	empty_sound = 'sound/weapons/smg_empty_alarm.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, one_handed_penalty=15, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, move_delay=5, one_handed_penalty=30, burst_accuracy=list(0,-15,-15), dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/weapon/gun/magnetic/railgun/heater
	name = "coil rifle"
	desc = "A large rifle designed and produced after the Grey Hour."
	description_info = "The MI-51B is a Martian weapon designed in the days after the Grey Hour, in preparation for the need for updated equipment by Solar forces.<br>\
		The design is based upon a larger rail-type weapon design."
	icon_state = "railgun_sec"
	item_state = "cshotgun"

	removable_components = TRUE

	initial_cell_type = /obj/item/weapon/cell/device/weapon
	initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor

	fire_delay = 8

	slot_flags = SLOT_BACK

	slowdown = 0
	slowdown_held = 0.3
	slowdown_worn = 0

	power_cost = 400
	projectile_type = /obj/item/projectile/bullet/magnetic/heated
	loaded = null
	empty_sound = 'sound/weapons/smg_empty_alarm.ogg'

	firemodes = list(
		list(mode_name="high power", power_cost = 400, projectile_type = /obj/item/projectile/bullet/magnetic/heated, burst=1, fire_delay=8, move_delay=null, one_handed_penalty=15),
		list(mode_name="low power", power_cost = 150, projectile_type = /obj/item/projectile/bullet/magnetic/heated/weak, burst=1, fire_delay=5, move_delay=null, one_handed_penalty=15),
		)

/obj/item/weapon/gun/magnetic/railgun/heater/pistol
	name = "coil pistol"
	desc = "A large pistol designed and produced after the Grey Hour."
	description_info = "The MI-60D `Peacemaker` is a Martian weapon designed in the days after the Grey Hour, in preparation for the need for updated equipment by Solar forces.<br>\
		The design is based upon a larger rail-type hybrid weapon design, though much smaller in scale."
	icon_state = "peacemaker"
	item_state = "revolver"

	w_class = ITEMSIZE_NORMAL

	slowdown_held = 0

	initial_cell_type = /obj/item/weapon/cell/device/weapon
	initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor

	slot_flags = SLOT_BELT|SLOT_HOLSTER

	firemodes = list(
		list(mode_name="lethal", power_cost = 500, projectile_type = /obj/item/projectile/bullet/magnetic/heated, burst=1, fire_delay=10, move_delay=null, one_handed_penalty=0),
		list(mode_name="stun", power_cost = 350, projectile_type = /obj/item/projectile/energy/electrode/stunshot, burst=1, fire_delay=7, move_delay=null, one_handed_penalty=0),
		)

/obj/item/weapon/gun/magnetic/railgun/heater/pistol/hos
	name = "prototype peacemaker"

	dna_lock = TRUE

	description_antag = "This weapon starts with a DNA locking chip attached. Using an EMAG on the weapon will disarm it, and allow you to use the chip as your own."

	firemodes = list(
		list(mode_name="lethal", power_cost = 400, projectile_type = /obj/item/projectile/bullet/magnetic/heated, burst=1, fire_delay=8, move_delay=null, one_handed_penalty=0),
		list(mode_name="stun", power_cost = 300, projectile_type = /obj/item/projectile/energy/electrode/stunshot, burst=1, fire_delay=5, move_delay=null, one_handed_penalty=0),
		)

/obj/item/weapon/gun/magnetic/railgun/flechette/sif
	name = "shredder rifle"
	desc = "The MI-12B Kaldr is a burst fire capable coilgun that fires modified slugs intended for damaging soft targets."
	description_fluff = "The Kaldr is a weapon recently deployed to various outposts on Sif, as well as local hunting guilds for the rapid dispatching of invasive wildlife."
	icon_state = "railgun_sifguard"
	item_state = "z8carbine"

	initial_cell_type = /obj/item/weapon/cell/high
	initial_capacitor_type = /obj/item/weapon/stock_parts/capacitor/adv

	slot_flags = SLOT_BACK

	slowdown_held = 0.3

	power_cost = 300
	projectile_type = /obj/item/projectile/bullet/magnetic/flechette/hunting
	empty_sound = 'sound/weapons/smg_empty_alarm.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, one_handed_penalty=15, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, move_delay=5, one_handed_penalty=30, burst_accuracy=list(0,-15,-15), dispersion=list(0.0, 0.6, 1.0)),
		)
