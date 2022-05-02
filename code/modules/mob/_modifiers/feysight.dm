/datum/modifier/feysight
	name = "feysight"
	desc = "You are filled with an inner peace, and widened sight."
	client_color = "#42e6ca"

	on_created_text = "<span class='alien'>You feel an inner peace as your mind's eye expands!</span>"
	on_expired_text = "<span class='notice'>Your sight returns to what it once was.</span>"
	stacks = MODIFIER_STACK_EXTEND

	accuracy = -15
	accuracy_dispersion = 1

/datum/modifier/feysight/on_applied()
	holder.see_invisible = 60
	holder.see_invisible_default = 60

/datum/modifier/feysight/on_expire()
	holder.see_invisible_default = initial(holder.see_invisible_default)
	holder.see_invisible = holder.see_invisible_default

/datum/modifier/feysight/can_apply(var/mob/living/L)
	if(L.stat)
		to_chat(L, "<span class='warning'>You can't be unconscious or dead to experience tranquility.</span>")
		return FALSE

	if(!L.is_sentient())
		return FALSE // Drones don't feel anything.

	if(ishuman(L))
		var/mob/living/human/H = L
		if(H.species.name == "Diona")
			to_chat(L, "<span class='warning'>You feel strange for a moment, but it passes.</span>")
			return FALSE // Happy trees aren't affected by tranquility.

	return ..()

/datum/modifier/feysight/tick()
	..()

	if(ishuman(holder))
		var/mob/living/human/H = holder
		H.druggy = min(15, H.druggy + 4)
