//The base core object, worn on the wizard's back.
/obj/item/weapon/technomancer_core
	name = "manipulation core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats."
	icon_state = "technomancer_core"
	item_state = "technomancer_core"
	w_class = 5
	slot_flags = SLOT_BACK
	unacidable = 1
	var/energy = 10000
	var/max_energy = 10000
	var/regen_rate = 50 //200 seconds to full

/obj/item/weapon/technomancer_core/New()
	..()
	processing_objects |= src

/obj/item/weapon/technomancer_core/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/technomancer_core/proc/pay_energy(amount)
	if(amount <= energy)
		energy = max(energy - amount, 0)
		return 1
	return 0

/obj/item/weapon/technomancer_core/process()
	regenerate()

/obj/item/weapon/technomancer_core/proc/regenerate()
	energy += min(energy + regen_rate, max_energy)
//Resonance Aperture

//Variants which the wizard can buy.

//For those wanting to look like a classic wizard.
/obj/item/weapon/technomancer_core/classic
	name = "wizard's cloak"
	desc = "It appears to be a simple cloak, however it is actually a deceptively hidden manipulation core.  For those who wish to \
	fool the Lessers into believing that you are a real magician."
	icon_state = "wizard_cloak"
	item_state = "wizard_cloak"

//High risk, high reward core.
/obj/item/weapon/technomancer_core/unstable
	name = "unstable core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This one is rather unstable, \
	and could prove dangerous to the user, as it feeds off unstable energies that can occur with overuse of this machine."
	icon_state = "backpack"
	item_state = null
	energy = 13000
	max_energy = 13000
	regen_rate = 35 //~371 seconds to full, 118 seconds to full at 50 instability (rate of 110)

/obj/item/weapon/technomancer_core/unstable/regenerate()
	var/instability_bonus = 0
	if(loc && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		instability_bonus = H.instability * 1.5
	energy += min(energy + regen_rate + instability_bonus, max_energy)

//Lower capacity but safer core.
/obj/item/weapon/technomancer_core/rapid
	name = "rapid core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This one has a superior \
	recharge rate, at the price of storage capacity."
	icon_state = "backpack"
	item_state = null
	energy = 7000
	max_energy = 7000
	regen_rate = 70 //100 seconds to full

//Big batteries but slow regen, buying energy spells is highly recommended.
/obj/item/weapon/technomancer_core/bulky
	name = "bulky core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This variant is more \
	cumbersome and bulky, due to the additional energy capacitors installed.  It also comes at a price of a subpar fractal \
	reactor."
	icon_state = "backpack"
	item_state = null
	energy = 15000
	max_energy = 15000
	regen_rate = 25 //600 seconds to full

