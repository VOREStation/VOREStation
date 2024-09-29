/*
 * Laser Rifle
 */
/obj/item/gun/energy/laser
	name = "laser rifle"
	desc = "A Hephaestus Industries G40E rifle, designed to kill with concentrated energy blasts.  This variant has the ability to \
	switch between standard fire and a more efficent but weaker 'suppressive' fire."
	description_fluff = "The leading arms producer in the SCG, Hephaestus typically only uses its 'top level' branding for its military-grade equipment used by armed forces across human space."
	icon_state = "laser"
	item_state = "laser"
	wielded_item_state = "laser-wielded"
	fire_delay = 8
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(MAT_STEEL = 2000)
	projectile_type = /obj/item/projectile/beam/midlaser
	one_handed_penalty = 30

	firemodes = list(
		list(mode_name="normal", fire_delay=8, projectile_type=/obj/item/projectile/beam/midlaser, charge_cost = 240),
		list(mode_name="suppressive", fire_delay=5, projectile_type=/obj/item/projectile/beam/weaklaser, charge_cost = 60),
		)

/obj/item/gun/energy/laser/empty
	cell_type = null

/obj/item/gun/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1
	one_handed_penalty = 0 // Not sure if two-handing gets checked for mounted weapons, but better safe than sorry.

/obj/item/gun/energy/laser/mounted/augment
	name = "arm-laser"
	desc = "A cruel malformation of a Hephaestus Industries G40E rifle, designed to kill with concentrated energy blasts, all while being stowable in the arm. This variant has the ability to \
	switch between standard fire and a more efficent but weaker 'suppressive' fire."
	use_external_power = FALSE
	use_organic_power = TRUE
	wielded_item_state = null
	item_state = "augment_laser"
	canremove = FALSE
	one_handed_penalty = 5
	battery_lock = 1

/obj/item/gun/energy/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice
	charge_cost = 48

	cell_type = /obj/item/cell/device

	firemodes = list(
		list(mode_name="normal", projectile_type=/obj/item/projectile/beam/practice, charge_cost = 48),
		list(mode_name="suppressive", projectile_type=/obj/item/projectile/beam/practice, charge_cost = 12),
		)

/*
 * Sleek Laser Rifle
 */
/obj/item/gun/energy/laser/sleek
	name = "\improper LR1 \"Shishi\""
	desc = "A Bishamonten Company LR1 \"Shishi\" rifle, a rare early 23rd century futurist design with a nonetheless timeless ability to kill."
	description_fluff = "Bisamonten was arms company that operated from roughly 2150-2280 - the height of the first extrasolar colonisation boom - before filing for \
	bankruptcy and selling off its assets to various companies that would go on to become today’s TSCs. Focused on sleek ‘futurist’ designs which have largely \
	fallen out of fashion but remain popular with collectors and people hoping to make some quick thalers from replica weapons. Their weapons tended to be form \
	over function - despite their flashy looks, most were completely unremarkable one way or another as weapons and used very standard firing mechanisms."
	icon_state = "lrifle"
	item_state = "lrifle"
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)

/*
 * Retro Laser Rifle
 */
/obj/item/gun/energy/retro
	name = "retro laser"
	icon_state = "retro"
	item_state = "retro"
	desc = "A 23rd century model of the basic lasergun. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	projectile_type = /obj/item/projectile/beam
	fire_delay = 10 //old technology

/obj/item/gun/energy/retro/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/gun/energy/retro/empty
	icon_state = "retro"
	cell_type = null

/*
 * Alien Pistol
 */
/obj/item/gun/energy/alien
	name = "alien pistol"
	desc = "A weapon that works very similarly to a traditional energy weapon. How this came to be will likely be a mystery for the ages."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_pistol)
	icon_state = "alienpistol"
	item_state = "alienpistol"
	fire_delay = 10 // Handguns should be inferior to two-handed weapons. Even alien ones I suppose.
	charge_cost = 480 // Five shots.

	projectile_type = /obj/item/projectile/beam/cyan
	cell_type = /obj/item/cell/device/weapon/recharge/alien // Self charges.
	origin_tech = list(TECH_COMBAT = 8, TECH_MAGNET = 7)
	modifystate = "alienpistol"

/datum/category_item/catalogue/anomalous/precursor_a/alien_pistol
	name = "Precursor Alpha Weapon - Appendageheld Laser"
	desc = "This object strongly resembles a weapon, and if one were to pull the \
	trigger located on the handle of the object, it would fire a deadly \
	laser at whatever it was pointed at. The beam fired appears to cause too \
	much damage to whatever it would hit to have served as a long ranged repair tool, \
	therefore this object was most likely designed to be a deadly weapon. If so, this \
	has several implications towards its creators;\
	<br><br>\
	Firstly, it implies that these precursors, at some point during their development, \
	had needed to defend themselves, or otherwise had a need to utilize violence, and \
	as such created better tools to do so. It is unclear if violence was employed against \
	themselves as a form of in-fighting, or if violence was exclusive to outside species.\
	<br><br>\
	Secondly, the shape and design of the weapon implies that the creators of this \
	weapon were able to grasp objects, and be able to manipulate the trigger independently \
	from merely holding onto the weapon, making certain types of appendages like tentacles be \
	unlikely.\
	<br><br>\
	An interesting note about this weapon, when compared to contemporary energy weapons, is \
	that this gun appears to be inferior to modern laser weapons. The beam fired has less \
	of an ability to harm, and the power consumption appears to be higher than average for \
	a human-made energy side-arm. One possible explaination is that the creators of this \
	weapon, in their later years, had less of a need to optimize their capability for war, \
	and instead focused on other endeavors. Another explaination is that vast age of the weapon \
	may have caused it to degrade, yet still remain functional at a reduced capability."
	value = CATALOGUER_REWARD_MEDIUM

/*
 * Antique Laser Gun
 */
/obj/item/gun/energy/captain
	name = "antique laser gun"
	icon_state = "caplaser"
	item_state = "caplaser"
	desc = "A rare weapon, produced by the Lunar Arms Company around 2105 - one of humanity's first wholly extra-terrestrial weapon designs. It's certainly aged well."
	description_fluff = "The Lunar Arms Company was founded to provide home-grown arms to the Selene Federation from 2101-2108 during the Second Cold War, the conflict that sparked the \
	formation of the SCG. The LAC produced the first weapons wholly designed and produced outside of Earth. Post-war, the company relocated and rebranded as MarsTech, which survives \
	to this day as a major subsidiary of Hephaestus Industries."
	force = 5
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	unacidable = TRUE
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	fire_delay = 10		//Old pistol
	charge_cost = 480	//to compensate a bit for self-recharging
	cell_type = /obj/item/cell/device/weapon/recharge/captain
	battery_lock = 1
	var/remainingshots = 0 //you may get a limited number of shots regardless of the charge
	var/failurechance = 0 //chance per shot of something going awry

/obj/item/gun/energy/captain/Initialize()
	//it's an antique and it's been sitting in a case, unmaintained, for who the hell knows how long - who knows what'll happen when you pull it out?
	..()
	//first, we decide, does it have a different type of beam? 75% of just being a 40-damage laser, 15% of being less or 0, 10% of being better
	projectile_type = pick(prob(1);/obj/item/projectile/beam/pulse,
						prob(2);/obj/item/projectile/beam/heavylaser/cannon,
						prob(2);/obj/item/projectile/beam/heavylaser,
						prob(5);/obj/item/projectile/beam/sniper,
						prob(45);/obj/item/projectile/beam,
						prob(10);/obj/item/projectile/beam/cyan,
						prob(10);/obj/item/projectile/beam/eluger,
						prob(10);/obj/item/projectile/beam/imperial,
						prob(10);/obj/item/projectile/beam/weaklaser,
						prob(5);/obj/item/projectile/beam/practice)
	//now, decide whether it has a shot limit and if so how many
	if(prob(50))
		remainingshots = rand(1,40)
	if(prob(50))
		failurechance = rand(1,5)

	//finally, update the description so it has a tell if it's gonna burn out on you
	if(remainingshots || failurechance)
		desc = "A rare weapon, produced by the Lunar Arms Company around 2105 - one of humanity's first wholly extra-terrestrial weapon designs. It's been reasonably well-preserved."

/obj/item/gun/energy/captain/special_check(var/mob/user)
	if(remainingshots)
		remainingshots -= 1
		if(!remainingshots) //you've shot your load, sonny
			burnout(user)
			return 0
	else if(prob(failurechance))
		malfunction(user)
		return 0
	return ..()

/obj/item/gun/energy/captain/proc/burnout(var/mob/user)
	//your gun is now rendered useless
	projectile_type = /obj/item/projectile/beam/practice //just in case you somehow manage to get it to fire again, its beam type is set to one that sucks
	power_supply.charge = 0
	power_supply.maxcharge = 1 //just to avoid div/0 runtimes
	desc = "A rare weapon, produced by the Lunar Arms Company around 2105 - one of humanity's first wholly extra-terrestrial weapon designs. It looks to have completely burned out."
	user.visible_message("<span class='warning'>\The [src] erupts in a shower of sparks!</span>", "<span class='danger'>\the [src] bursts into a shower of sparks!</span>")
	var/turf/T = get_turf(src)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(2, 1, T)
	sparks.start()
	update_icon()

/obj/item/gun/energy/captain/proc/malfunction(var/mob/user)
	var/screwup = rand(1,10)
	switch(screwup)
		if(1 to 5) //50% of just draining the battery and making future malfunctions more likely
			power_supply.charge = 0
			var/turf/T = get_turf(src)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(2, 1, T)
			sparks.start()
			update_icon()
			user.visible_message("<span class='warning'>\The [src] shorts out!</span>", "<span class='danger'>\the [src] shorts out!</span>")
			failurechance += rand(1,5)
			return
		if(6 to 7) //20% chance of weakening the beam type, possibly to uselessness
			var/obj/item/projectile/beam/B = new projectile_type
			switch(B.damage)
				if(0)
					return //can't weaken it any further
				if(1 to 15) //weaklaser becomes practice
					projectile_type = /obj/item/projectile/beam/practice
				if(16 to 40) //regular becomes weaklaser
					projectile_type = /obj/item/projectile/beam/weaklaser
				if(41 to 50) //sniper becomes regular
					projectile_type = /obj/item/projectile/beam
				if(51 to 60) //heavy becomes sniper
					projectile_type = /obj/item/projectile/beam/sniper
				if(61 to 80) //cannon becomes heavy
					projectile_type = /obj/item/projectile/beam/heavylaser
				if(81 to 100) //pulse becomes cannon
					projectile_type = /obj/item/projectile/beam/heavylaser/cannon
			user.visible_message("<span class='warning'>\The [src] dims slightly!</span>", "<span class='danger'>\the [src] dims slightly!</span>")
			return
		if(8) //10% chance of reducing the number of shots you have left, or giving you a limit if there isn't one
			if(!remainingshots)
				remainingshots = rand(1,40)
			else
				remainingshots = min(1, round(remainingshots/2))
			user.visible_message("<span class='warning'>\The [src] lets out a faint pop.</span>", "<span class='danger'>\the [src] lets out a faint pop.</span>")
		if(9) //10% chance of permanently reducing the cell's max charge
			power_supply.maxcharge = power_supply.maxcharge/2
			power_supply.charge = min(power_supply.charge, power_supply.maxcharge)
			user.visible_message("<span class='warning'>\The [src] sparks,letting off a puff of smoke!</span>", "<span class='danger'>\the [src] sparks,letting off a puff of smoke!</span>")
			var/turf/T = get_turf(src)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(2, 1, T)
			sparks.start()
			update_icon()
		if(10) //10% chance of just straight-up breaking on the spot
			burnout(user)
			return


/*
 * Laser Cannon
 */
/obj/item/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron \
	flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	item_state = null
	wielded_item_state = "mhdhowitzer-wielded" //Placeholder
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	slot_flags = SLOT_BELT|SLOT_BACK
	projectile_type = /obj/item/projectile/beam/heavylaser/cannon
	battery_lock = 1
	fire_delay = 20
	w_class = ITEMSIZE_LARGE
	one_handed_penalty = 90 // The thing's heavy and huge.
	accuracy = 45
	charge_cost = 600

/obj/item/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	accuracy = 0 // Mounted cannons are just fine the way they are.
	one_handed_penalty = 0 // Not sure if two-handing gets checked for mounted weapons, but better safe than sorry.
	projectile_type = /obj/item/projectile/beam/heavylaser
	charge_cost = 400
	fire_delay = 20

/*
 * X-ray
 */
/obj/item/gun/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts, which are able to penetrate matter easier than \
	standard photonic beams, resulting in an effective 'anti-armor' energy weapon."
	icon_state = "xray"
	item_state = "xray"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/beam/xray
	charge_cost = 200

/*
 * Marksman Rifle
 */
/obj/item/gun/energy/sniperrifle
	name = "marksman energy rifle"
	desc = "The HI DMR 9E is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful \
	ionized beams, this is a weapon to kill from a distance."
	description_fluff = "The leading arms producer in the SCG, Hephaestus typically only uses its 'top level' branding for its military-grade equipment used by armed forces across human space."
	icon_state = "sniper"
	item_state = "sniper"
	item_state_slots = list(slot_r_hand_str = "lsniper", slot_l_hand_str = "lsniper")
	wielded_item_state = "lsniper-wielded"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	action_button_name = "Use Scope"
	battery_lock = 1
	charge_cost = 600
	fire_delay = 35
	force = 10
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	accuracy = -45 //shooting at the hip
	scoped_accuracy = 50
	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.

/obj/item/gun/energy/sniperrifle/ui_action_click()
	scope()

/obj/item/gun/energy/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

/*
 * Laser Scattergun (proof of concept)
 */
/obj/item/gun/energy/lasershotgun
	name = "laser scattergun"
	icon = 'icons/obj/energygun.dmi'
	item_state = "laser"
	icon_state = "scatter"
	desc = "A strange Almachi weapon, utilizing a refracting prism to turn a single laser blast into a diverging cluster."
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 1, TECH_MATERIAL = 4)

	projectile_type = /obj/item/projectile/scatter/laser

/*
 * Imperial Pistol
 */
/obj/item/gun/energy/imperial
	name = "imperial energy pistol"
	desc = "An elegant weapon developed by the Imperium Auream. Their weaponsmiths have cleverly found a way to make a gun that \
	is only about the size of an average energy pistol, yet with the fire power of a laser carbine."
	icon = 'icons/obj/gun_vr.dmi'
	icon_override = 'icons/obj/gun_vr.dmi'
	icon_state = "ge_pistol"
	item_state = "ge_pistol"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	force = 10
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2)
	matter = list(MAT_STEEL = 2000)
	fire_sound = 'sound/weapons/mandalorian.ogg'
	projectile_type = /obj/item/projectile/beam/imperial

/*
 * Mining-Laser Rifle
 */
/obj/item/gun/energy/mininglaser
	name = "mining-laser rifle"
	desc = "An industrial grade mining laser. Comes with a built-in 'stun' mode for encounters with local wildlife."
	icon = 'icons/obj/gun.dmi'
	icon_state = "mininglaser"
	item_state = "mininglaser"
	fire_delay = 8
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	force = 15
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(MAT_STEEL = 2000)
	projectile_type = /obj/item/projectile/beam/mininglaser

	firemodes = list(
		list(mode_name="mining", fire_delay=8, projectile_type=/obj/item/projectile/beam/mininglaser, charge_cost = 200),
		list(mode_name="deter", fire_delay=5, projectile_type=/obj/item/projectile/beam/weaklaser, charge_cost = 80),
		)

/*
 * Old Laser Rifle
 */
/obj/item/gun/energy/laser/old
	name = "vintage laser rifle"
	desc = "A Hephaestus Industries G32E rifle, designed to kill with concentrated energy blasts. This older model laser rifle only has one firemode."
	description_fluff = "The leading arms producer in the SCG, Hephaestus typically only uses its 'top level' branding for its military-grade \
	equipment used by armed forces across human space."
	icon_state = "oldlaser"
	item_state = "laser"
	fire_delay = 6
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	force = 8
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 1) //Older rifle - less tech
	matter = list(MAT_STEEL = 1500)
	projectile_type = /obj/item/projectile/beam/midlaser

/*
 * Mono-Rifle
 */
/obj/item/gun/energy/monorifle
	name = "antique mono-rifle"
	desc = "An old model laser rifle with a nice wood finish. This weapon was only designed to fire once before requiring a recharge."
	description_fluff = "Modeled after ancient hunting rifles designs, this rifle was dubbed the 'Rainy Day Special' by some, due to its use as the \
	choice \"fight-stopper\" of barkeeps. One shot is all it takes... so they say."
	icon_state = "mono"
	item_state = "shotgun"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_POWER = 3)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	action_button_name = "Aim Down Sights"
	charge_cost = 2400
	fire_delay = 20
	force = 8
	w_class = ITEMSIZE_LARGE
	accuracy = 10
	scoped_accuracy = 15
	charge_meter = FALSE
	var/scope_multiplier = 1.5

/obj/item/gun/energy/monorifle/ui_action_click()
	sights()

/obj/item/gun/energy/monorifle/verb/sights()
	set category = "Object"
	set name = "Aim Down Sights"
	set popup_menu = 1

	toggle_scope(scope_multiplier)

/obj/item/gun/energy/monorifle/combat
	name = "combat mono-rifle"
	desc = "A modernized version of the classic mono-rifle. This one has an optimized capacitor bank that allows the rifle to fire twice before requiring a recharge."
	description_fluff = "A modern design of a classic rifle produced by a small arms company operating out of Saint Columbia. It was based on the \
	antique mono-rifle design that was dubbed the 'Rainy Day Special' by many of its users."
	icon_state = "cmono"
	item_state = "cshotgun"
	charge_cost = 1200
	force = 12
	accuracy = 0
	scoped_accuracy = 20