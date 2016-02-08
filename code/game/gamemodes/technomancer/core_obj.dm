//The base core object, worn on the wizard's back.
/obj/item/weapon/technomancer_core
	name = "manipulation core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats."
	icon = 'icons/obj/technomancer.dmi'
	icon_state = "technomancer_core"
	item_state = "technomancer_core"
	w_class = 5
	slot_flags = SLOT_BACK
	unacidable = 1
	origin_tech = list(
		TECH_MATERIAL = 8, TECH_ENGINEERING = 8, TECH_POWER = 8, TECH_BLUESPACE = 10,
		TECH_COMBAT = 7, TECH_MAGNET = 9, TECH_DATA = 5
		)
	var/energy = 10000
	var/max_energy = 10000
	var/regen_rate = 50 //200 seconds to full
	var/mob/living/wearer = null
	var/list/spells = list()

/obj/item/weapon/technomancer_core/New()
	..()
	processing_objects |= src

/obj/item/weapon/technomancer_core/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/technomancer_core/equipped(mob/user)
	wearer = user
	..()

/obj/item/weapon/technomancer_core/dropped(mob/user)
	wearer = null
	..()

/obj/item/weapon/technomancer_core/proc/pay_energy(amount)
	if(amount <= energy)
		energy = max(energy - amount, 0)
		return 1
	return 0

/obj/item/weapon/technomancer_core/proc/give_energy(amount)
	energy = max(energy + amount, max_energy)
	return 1

/obj/item/weapon/technomancer_core/process()
	regenerate()

/obj/item/weapon/technomancer_core/proc/regenerate()
	energy = min(max(energy + regen_rate, 0), max_energy)
	if(wearer && ishuman(wearer))
		var/mob/living/carbon/human/H = wearer
		H.wiz_energy_update_hud()

/obj/spellbutton
	name = "generic spellbutton"
	var/spellpath = null
	var/was_bought_by_preset = 0

/obj/spellbutton/New(loc, var/path, var/new_name)
	if(!path || !ispath(path))
		message_admins("ERROR: /obj/spellbutton/New() was not given a proper path!")
		qdel(src)
	src.name = new_name
	src.spellpath = path
	src.loc = loc

/obj/spellbutton/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.place_spell_in_hand(spellpath)

/obj/spellbutton/DblClick()
	return Click()

/mob/living/carbon/human/Stat()
	. = ..()

	if(. && istype(back,/obj/item/weapon/technomancer_core))
		var/obj/item/weapon/technomancer_core/core = back
		setup_technomancer_stat(core)

/mob/living/carbon/human/proc/setup_technomancer_stat(var/obj/item/weapon/technomancer_core/core)
	if(core && statpanel("Spell Core"))
		var/charge_status = "[core.energy]/[core.max_energy] ([round( (core.energy / core.max_energy) * 100)]%)"
		var/instability_status = "[src.instability]"
		stat("Core charge", charge_status)
		stat("User instability", instability_status)
		for(var/obj/spellbutton/button in core.spells)
			stat(button)

/obj/item/weapon/technomancer_core/proc/add_spell(var/path, var/new_name)
	if(!path || !ispath(path))
		message_admins("/obj/item/weapon/technomancer_core/add_spell() was not given a proper path!  The path supplied was [path].")
		return
	var/obj/spellbutton/spell = new(src, path, new_name)
	spells.Add(spell)

/obj/item/weapon/technomancer_core/proc/remove_spell(var/obj/spellbutton/spell_to_remove)
	if(spell_to_remove in spells)
		spells.Remove(spell_to_remove)
		qdel(spell_to_remove)

/obj/item/weapon/technomancer_core/proc/remove_all_spells()
	for(var/obj/spellbutton/spell in spells)
		spells.Remove(spell)
		qdel(spell)

/obj/item/weapon/technomancer_core/proc/has_spell(var/datum/technomancer/spell_to_check)
	for(var/obj/spellbutton/spell in spells)
		if(spell.spellpath == spell_to_check.obj_path)
			return 1
	return 0

/mob
	var/obj/screen/wizard/energy/wiz_energy_display = null //Unfortunately, this needs to be a mob var due to HUD code.

/mob/living/carbon/human/proc/wiz_energy_update_hud()
	if(client && hud_used)
		if(istype(back, /obj/item/weapon/technomancer_core)) //I reckon there's a better way of doing this.
			var/obj/item/weapon/technomancer_core/core = back
			wiz_energy_display.invisibility = 0
			var/ratio = core.energy / core.max_energy
			ratio = max(round(ratio, 0.05) * 100, 5)
			wiz_energy_display.icon_state = "wiz_energy[ratio]"
		else
			wiz_energy_display.invisibility = 101

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
	energy = 13000
	max_energy = 13000
	regen_rate = 35 //~371 seconds to full, 118 seconds to full at 50 instability (rate of 110)

/obj/item/weapon/technomancer_core/unstable/regenerate()
	var/instability_bonus = 0
	if(loc && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		instability_bonus = H.instability * 1.5
	energy = min(energy + regen_rate + instability_bonus, max_energy)
	if(loc && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.wiz_energy_update_hud()

//Lower capacity but safer core.
/obj/item/weapon/technomancer_core/rapid
	name = "rapid core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This one has a superior \
	recharge rate, at the price of storage capacity."
	energy = 7000
	max_energy = 7000
	regen_rate = 70 //100 seconds to full

//Big batteries but slow regen, buying energy spells is highly recommended.
/obj/item/weapon/technomancer_core/bulky
	name = "bulky core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This variant is more \
	cumbersome and bulky, due to the additional energy capacitors installed.  It also comes at a price of a subpar fractal \
	reactor."
	energy = 20000
	max_energy = 20000
	regen_rate = 25 //800 seconds to full

