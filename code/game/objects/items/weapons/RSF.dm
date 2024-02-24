/*
CONTAINS:
RSF

*/

/obj/item/weapon/rsf
	name = "\improper Rapid-Service-Fabricator"
	desc = "A device used to rapidly deploy service items."
	description_info = "Control Clicking on the device will allow you to choose the glass it dispenses when in the proper mode."
	icon = 'icons/obj/tools_vr.dmi' //VOREStation Edit
	icon_state = "rsf" //VOREStation Edit
	opacity = 0
	density = FALSE
	anchored = FALSE
	matter = list(DEFAULT_WALL_MATERIAL = 25000)
	var/stored_matter = 30
	var/mode = 1
	var/obj/item/weapon/reagent_containers/glasstype = /obj/item/weapon/reagent_containers/food/drinks/metaglass

	var/list/container_types = list(
		"metamorphic glass" = /obj/item/weapon/reagent_containers/food/drinks/metaglass,
		"metamorphic pint glass" = /obj/item/weapon/reagent_containers/food/drinks/metaglass/metapint,
		"half-pint glass" = /obj/item/weapon/reagent_containers/food/drinks/glass2/square,
		"rocks glass" = /obj/item/weapon/reagent_containers/food/drinks/glass2/rocks,
		"milkshake glass" = /obj/item/weapon/reagent_containers/food/drinks/glass2/shake,
		"cocktail glass" = /obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail,
		"shot glass" = /obj/item/weapon/reagent_containers/food/drinks/glass2/shot,
		"pint glass" = /obj/item/weapon/reagent_containers/food/drinks/glass2/pint,
		"mug" = /obj/item/weapon/reagent_containers/food/drinks/glass2/mug,
		"wine glass" = /obj/item/weapon/reagent_containers/food/drinks/glass2/wine,
		"condiment bottle" = /obj/item/weapon/reagent_containers/food/condiment
		)

	w_class = ITEMSIZE_NORMAL

/obj/item/weapon/rsf/examine(mob/user)
	. = ..()
	if(get_dist(user, src) == 0)
		. += "<span class='notice'>It currently holds [stored_matter]/30 fabrication-units.</span>"

/obj/item/weapon/rsf/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/rcd_ammo))

		if ((stored_matter + 10) > 30)
			to_chat(user, "<span class='warning'>The RSF can't hold any more matter.</span>")
			return

		qdel(W)

		stored_matter += 10
		playsound(src, 'sound/machines/click.ogg', 10, 1)
		to_chat(user,"<span class='notice'>The RSF now holds [stored_matter]/30 fabrication-units.</span>")
		return

/obj/item/weapon/rsf/CtrlClick(mob/living/user)
	if(!Adjacent(user) || !istype(user))
		to_chat(user,"<span class='notice'>You are too far away.</span>")
		return
	var/glass_choice = tgui_input_list(user, "Please choose which type of glass you would like to produce.", "Glass Choice", container_types)

	if(glass_choice)
		glasstype = container_types[glass_choice]
	else
		glasstype = /obj/item/weapon/reagent_containers/food/drinks/metaglass

/obj/item/weapon/rsf/attack_self(mob/user as mob)
	playsound(src, 'sound/effects/pop.ogg', 50, 0)
	if (mode == 1)
		mode = 2
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Container'.</span>")
		return
	if (mode == 2)
		mode = 3
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Paper'</span>")
		return
	if (mode == 3)
		mode = 4
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Pen'</span>")
		return
	if (mode == 4)
		mode = 5
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Dice Pack'</span>")
		return
	if (mode == 5)
		mode = 1
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Cigarette'</span>")
		return

/obj/item/weapon/rsf/afterattack(atom/A, mob/user as mob, proximity)

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
			product = new /obj/item/clothing/mask/smokable/cigarette()
			used_energy = 10
		if(2)
			product = new glasstype()
			used_energy = 50
		if(3)
			product = new /obj/item/weapon/paper()
			used_energy = 10
		if(4)
			product = new /obj/item/weapon/pen()
			used_energy = 50
		if(5)
			product = new /obj/item/weapon/storage/pill_bottle/dice()
			used_energy = 200

	to_chat(user,"<span class='notice'>Dispensing [product ? product : "product"]...</span>")
	product.loc = get_turf(A)

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
	else
		stored_matter--
		to_chat(user,"<span class='notice'>The RSF now holds [stored_matter]/30 fabrication-units.</span>")
