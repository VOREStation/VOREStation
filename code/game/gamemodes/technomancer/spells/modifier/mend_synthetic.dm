/datum/technomancer/spell/mend_synthetic
	name = "Mend Synthetic"
	desc = "Repairs minor damages to robotic entities.  \
	Instability is split between the target and technomancer, if seperate.  The function will end prematurely \
	if the target is completely healthy, preventing further instability."
	spell_power_desc = "Healing amount increased."
	cost = 50
	obj_path = /obj/item/weapon/spell/modifier/mend_synthetic
	ability_icon_state = "tech_mendwounds"
	category = SUPPORT_SPELLS

/obj/item/weapon/spell/modifier/mend_synthetic
	name = "mend synthetic"
	desc = "You are the Robotics lab"
	icon_state = "mend_synthetic"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED // sorta??
	light_color = "#FF5C5C"
	modifier_type = /datum/modifier/technomancer/mend_synthetic
	modifier_duration = 10 SECONDS

/datum/modifier/technomancer/mend_synthetic
	name = "mend synthetic"
	desc = "Something seems to be repairing you."
	mob_overlay_state = "cyan_sparkles"

	on_created_text = "<span class='warning'>Sparkles begin to appear around you, and your systems report integrity rising.</span>"
	on_expired_text = "<span class='notice'>The sparkles have faded, although your systems seem to be better than before.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/technomancer/mend_synthetic/tick()
	if(!holder.isSynthetic()) // Don't heal biologicals!
		expire()
		return
	if(!holder.getBruteLoss() && !holder.getFireLoss()) // No point existing if the spell can't heal.
		expire()
		return
	holder.adjustBruteLoss(-4 * spell_power) // Should heal roughly 20 burn/brute over 10 seconds, as tick() is run every 2 seconds.
	holder.adjustFireLoss(-4 * spell_power) // Ditto.
	holder.adjust_instability(1)
	if(origin)
		var/mob/living/L = origin.resolve()
		if(istype(L))
			L.adjust_instability(1)