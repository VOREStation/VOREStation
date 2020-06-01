/*
CONTAINS:
RPF

*/

/obj/item/weapon/rpf
	name = "\improper Rapid-Paperwork-Fabricator"
	desc = "A device used to rapidly deploy office utilities."
	icon = 'icons/obj/tools_vr.dmi' //VOREStation Edit
	icon_state = "rpf" //VOREStation Edit
	opacity = 0
	density = 0
	anchored = 0.0
	var/stored_matter = 30
	var/mode = 1

	w_class = ITEMSIZE_NORMAL

/obj/item/weapon/rpf/examine(mob/user)
	. = ..()
	if(get_dist(user, src) == 0)
		. += "<span class='notice'>It currently holds [stored_matter]/30 fabrication-units.</span>"

/obj/item/weapon/rpf/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/rcd_ammo))

		if ((stored_matter + 10) > 30)
			to_chat(user, "<span class='warning'>The RPF can't hold any more matter.</span>")
			return

		qdel(W)

		stored_matter += 10
		playsound(src, 'sound/machines/click.ogg', 10, 1)
		to_chat(user,"<span class='notice'>The RPF now holds [stored_matter]/30 fabrication-units.</span>")
		return

/obj/item/weapon/rpf/attack_self(mob/user as mob)
	playsound(src, 'sound/effects/pop.ogg', 50, 0)
	if (mode == 1)
		mode = 2
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Carbon Paper'.</span>")
		return
	if (mode == 2)
		mode = 3
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Paper'</span>")
		return
	if (mode == 3)
		mode = 4
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Coffee'</span>")
		return
	if (mode == 4)
		mode = 5
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Clipboard'</span>")
		return
	if (mode == 5)
		mode = 1
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Folder'</span>")
		return

/obj/item/weapon/rpf/afterattack(atom/A, mob/user as mob, proximity)

	if(!proximity) return

	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			return
	else
		if(stored_matter <= 0)
			return

	if(!istype(A, /obj/structure/table) && !istype(A, /turf/simulated/floor))
		return

	playsound(src, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 0
	var/obj/product

	switch(mode)
		if(1)
			product = new /obj/item/weapon/folder/yellow()
			used_energy = 50
		if(2)
			product = new /obj/item/weapon/paper/carbon()
			used_energy = 10
		if(3)
			product = new /obj/item/weapon/paper()
			used_energy = 10
		if(4)
			product = new /obj/item/weapon/reagent_containers/food/drinks/coffee()
			used_energy = 150
		if(5)
			product = new /obj/item/weapon/clipboard
			used_energy = 50

	to_chat(user,"<span class='notice'>Dispensing [product ? product : "product"]...</span>")
	product.loc = get_turf(A)

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
	else
		stored_matter--
		to_chat(user,"<span class='notice'>The RPF now holds [stored_matter]/30 fabrication-units.</span>")
