// File is unticked because this is entirely untested old code


/*
 * Combitool
 */
/obj/item/combitool
	name = "combi-tool"
	desc = "It even has one of those nubbins for doing the thingy."
	icon = 'icons/obj/items.dmi'
	icon_state = "combitool"
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/multitool.ogg'
	pickup_sound = 'sound/items/pickup/multitool.ogg'

	var/list/spawn_tools = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/tool/wirecutters,
		/obj/item/material/knife,
		/obj/item/material/kitchen/utensil/fork,
		/obj/item/material/knife/machete/hatchet
		)
	var/list/tools = list()
	var/current_tool = 1

/obj/item/combitool/examine(mob/user)
	. = ..()
	if(loc == user && tools.len)
		. += "It has the following fittings:"
		for(var/obj/item/tool in tools)
			. += "\icon[tool][bicon(tool)] - [tool.name][tools[current_tool]==tool?" (selected)":""]")

<<<<<<< HEAD
/obj/item/weapon/combitool/New()
	..()
=======
/obj/item/combitool/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	for(var/type in spawn_tools)
		tools |= new type(src)

/obj/item/combitool/attack_self(mob/user as mob)
	if(++current_tool > tools.len) current_tool = 1
	var/obj/item/tool = tools[current_tool]
	if(!tool)
		to_chat(user, "You can't seem to find any fittings in \the [src].")
	else
		to_chat(user, "You switch \the [src] to the [tool.name] fitting.")
	return 1

/obj/item/combitool/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!M.Adjacent(user))
		return 0
	var/obj/item/tool = tools[current_tool]
	if(!tool) return 0
	return (tool ? tool.attack(M,user) : 0)

/obj/item/combitool/afterattack(var/atom/target, var/mob/living/user, proximity, params)
	if(!proximity)
		return 0
	var/obj/item/tool = tools[current_tool]
	if(!tool) return 0
	tool.loc = user
	var/resolved = target.attackby(tool,user)
	if(!resolved && tool && target)
		tool.afterattack(target,user,1)
	if(tool)
		tool.loc = src
