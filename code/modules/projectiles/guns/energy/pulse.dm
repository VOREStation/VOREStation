/obj/item/weapon/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	slot_flags = SLOT_BELT|SLOT_BACK
	force = 10
	projectile_type = /obj/item/projectile/beam
	charge_cost = 120
	sel_mode = 2

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_delay=null, charge_cost = 120),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_delay=null, charge_cost = 120),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_delay=null, charge_cost = 240),
		)

/obj/item/weapon/gun/energy/pulse_rifle/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/pulse_rifle/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, it is rarely seen in use except by specialists."
	projectile_type=/obj/item/projectile/beam/pulse
	charge_cost = 120

/obj/item/weapon/gun/energy/pulse_rifle/destroyer/attack_self(mob/living/user as mob)
	to_chat(user, "<span class='warning'>[src.name] has three settings, and they are all DESTROY.</span>")


//non-bus version because it looks adorable.
/obj/item/weapon/gun/energy/pulse_rifle/compact
	name = "\improper LP2 Grasshopper Compact"
	desc = "You feel like you're going to break the damn thing. The Bishamonten LP2 is a rare collectors item from the early 23rd century."
	description_fluff = "The Bishamonten Company operated from roughly 2150-2280 - the height of the first extrasolar colonisation boom - before filing for bankruptcy and selling off its assets to various companies that would go on to become today’s TSCs. \
	Focused on sleek ‘futurist’ designs which have largely fallen out of fashion but remain popular with collectors and people hoping to make some quick thalers from replica weapons. \
	Bishamonten weapons tended to be form over function - despite their flashy looks, most were completely unremarkable one way or another as weapons and used very standard firing mechanisms.\
	The Grasshopper remains one of the smallest production laser pistols ever produced that is still capable of causing significant damage to organic tissue."
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon_state = "lpistol"
	charge_cost = 480

/obj/item/weapon/gun/energy/pulse_rifle/compact/admin
	name = "\improper LP2 Grasshopper Deluxe"
	desc = "It's not the size of the gun, it's the size of the hole it puts through people."
	charge_cost = 240

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_delay=null, charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_delay=null, charge_cost = 240),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_delay=null, charge_cost = 480),
		)