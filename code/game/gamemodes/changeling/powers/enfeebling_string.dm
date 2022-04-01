/datum/power/changeling/enfeebling_string
	name = "Enfeebling String" /// String????
	desc = "We sting a biological with a potent toxin that will greatly weaken them for a short period of time."
	helptext = "Lowers the maximum health of the victim for a few minutes, as well as making them more frail and weak.  This sting will also warn them of this."
	enhancedtext = "Maximum health and outgoing melee damage is lowered further.  Incoming damage is increased."
	ability_icon_state = "ling_sting_enfeeble"
	genomecost = 1
	power_category = CHANGELING_POWER_STINGS
	verbpath = /mob/proc/changeling_enfeebling_string

/datum/modifier/enfeeble
	name = "enfeebled"
	desc = "You feel really weak and frail for some reason."

	stacks = MODIFIER_STACK_EXTEND
	max_health_percent = 0.7
	outgoing_melee_damage_percent = 0.75
	incoming_damage_percent = 1.1
	on_created_text = "<span class='danger'>You feel a small prick and you feel extremly weak!</span>"
	on_expired_text = "<span class='notice'>You no longer feel extremly weak.</span>"

// Now YOU'RE the Teshari!
/datum/modifier/enfeeble/strong
	max_health_percent = 0.5
	outgoing_melee_damage_percent = 0.5
	incoming_damage_percent = 1.35

/mob/proc/changeling_enfeebling_string()
	set category = "Changeling"
	set name = "Enfeebling Sting (30)"
	set desc = "Reduces the maximum health of a victim for a few minutes.."

	var/mob/living/carbon/T = changeling_sting(30,/mob/proc/changeling_enfeebling_string)
	if(!T)
		return 0
	if(ishuman(T))
		var/mob/living/carbon/human/H = T

		add_attack_logs(src,T,"Enfeebling sting (changeling)")

		var/type_to_give = /datum/modifier/enfeeble
		if(src.mind.changeling.recursive_enhancement)
			type_to_give = /datum/modifier/enfeeble/strong
			to_chat(src, "<span class='notice'>We make them extremely weak.</span>")
		H.add_modifier(type_to_give, 2 MINUTES)
	feedback_add_details("changeling_powers","ES")
	return 1