/*
 * Pulse Rifle
 */
/obj/item/gun/energy/pulse_rifle
	name = "\improper LP1 Locust Rifle"
	desc = "The Bishamonten LP1 is a weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. \
	Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	slot_flags = SLOT_BELT|SLOT_BACK
	force = 10
	projectile_type = /obj/item/projectile/beam
	charge_cost = 120
	fire_delay = 8
	sel_mode = 2

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_delay=null, charge_cost = 120),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_delay=null, charge_cost = 120),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_delay=null, charge_cost = 240),
		)

/obj/item/gun/energy/pulse_rifle/mounted
	self_recharge = 1
	use_external_power = 1

/*
 * Pulse Destroyer
 */
/obj/item/gun/energy/pulse_rifle/destroyer
	name = "\improper LP1 MkII"
	desc = "A more heavy-duty version of the Bishamonten LP1. It's had all its safety functions ripped out to facilitate the perfect killing machine."
	icon_state = "pulsedest"
	projectile_type=/obj/item/projectile/beam/pulse
	charge_cost = 120
	fire_delay = 12

/obj/item/gun/energy/pulse_rifle/destroyer/attack_self(mob/living/user as mob)
	to_chat(user, "<span class='warning'>[src.name] has three settings, and they are all DESTROY.</span>")

/*
 * Pulse Carbine
 */
/obj/item/gun/energy/pulse_rifle/carbine
	name = "\improper LP2 Grasshopper Carbine"
	desc = "The Bishamonten LP2 is a sleek, compact version of the LP1. Because of its smaller design it takes less time to charge a shot."
	icon_state = "pulsecarbine"
	charge_cost = 480
	fire_delay = 2

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_delay=null, charge_cost = 120),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_delay=null, charge_cost = 120),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_delay=null, charge_cost = 240),
		)

/*
 * Pulse Pistol
 */
/obj/item/gun/energy/pulse_rifle/compact
	name = "\improper LP4 Mantis Compact"
	desc = "The Bishamonten LP4 was once the weapon of choice for military officers during the Hegemony War. Today it is little more than a collectors item."
	description_fluff = "The Bishamonten Company operated from roughly 2150-2280 - the height of the first extrasolar colonisation boom - before filing for \
	bankruptcy and selling off its assets to various companies that would go on to become today’s TSCs. Focused on sleek ‘futurist’ designs which have \
	largely fallen out of fashion but remain popular with collectors and people hoping to make some quick thalers from replica weapons. Bishamonten weapons \
	tended to be form over function - despite their flashy looks, most were completely unremarkable one way or another as weapons and used very standard \
	firing mechanisms.The Grasshopper remains one of the smallest production laser pistols ever produced that is still capable of causing significant \
	damage to organic tissue."
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon_state = "pulsepistol"
	charge_cost = 480

/obj/item/gun/energy/pulse_rifle/compact/admin
	name = "\improper LP4 Mantis Deluxe"
	desc = "It's not the size of the gun, it's the size of the hole it puts through people."
	charge_cost = 240

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_delay=null, charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_delay=null, charge_cost = 240),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_delay=null, charge_cost = 480),
		)
