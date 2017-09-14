/obj/effect/spider/spiderling/grub
	name = "grub larva"
	desc = "It never stays still for long."
	//M.icon = 'grub_vr.dmi'
	icon_state = "spiderling"

obj/effect/spider/spiderling/grub/process()
	if(amount_grown >= 100)
		var/spawn_type = /mob/living/simple_animal/retaliate/solargrub
		new spawn_type(src.loc, src)
		qdel(src)
	else
		..()