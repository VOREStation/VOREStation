/mob/living/carbon/human/proc/promethean_select_opaqueness()

	set name = "Toggle Transparency"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	for(var/limb in src.organs)
		var/obj/item/organ/external/L = limb
		L.transparent = !L.transparent
	visible_message("<span class='notice'>\The [src]'s interal composition seems to change.</span>")
	update_icons_body()
