/obj/item/tool/transforming
	name = "transforming tool"
	desc = "You should never see this..."
	var/list/possible_tooltypes = list()
	var/current_tooltype = 1
	var/obj/item/weldingtool/welder
	var/weldertype = /obj/item/weldingtool/dummy

/obj/item/tool/transforming/New(newloc, no_counterpart = TRUE)
	..(newloc)
	if(TOOL_WELDER in possible_tooltypes)
		welder = new weldertype(src)
	on_tool_switch()

/obj/item/tool/transforming/Destroy()
	if(welder)
		QDEL_NULL(welder)
	..()

/obj/item/tool/transforming/get_welder()
	return welder

/obj/item/tool/transforming/attack_self(mob/user)
	if(!possible_tooltypes.len || possible_tooltypes.len < 2)
		return
	if(current_tooltype == possible_tooltypes.len)
		current_tooltype = 1
	else
		current_tooltype++

	on_tool_switch(user)

/obj/item/tool/transforming/proc/on_tool_switch(var/mob/user)
	return

/obj/item/tool/transforming/jawsoflife
	name = "jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science."
	icon = 'icons/obj/tools.dmi'
	icon_state = "jaws_pry"
	item_state = "jawsoflife"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MAT_METAL=150, MAT_SILVER=50)
	usesound = 'sound/items/jaws_pry.ogg'
	force = 15
	toolspeed = 0.25
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked", "pinched", "nipped")
	possible_tooltypes = list(TOOL_CROWBAR,TOOL_WIRECUTTER)

/obj/item/tool/transforming/jawsoflife/on_tool_switch(var/mob/user)
	switch(possible_tooltypes[current_tooltype])
		if(TOOL_CROWBAR)
			desc = initial(desc) + " It's fitted with a prying head."
			icon_state = "jaws_pry"
			usesound = 'sound/items/jaws_pry.ogg'
			pry = 1
			tool_qualities = list(TOOL_CROWBAR)
			if(user)
				playsound(src, 'sound/items/change_jaws.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You attach the pry jaws to [src].</span>")
		if(TOOL_WIRECUTTER)
			desc = initial(desc) + " It's fitted with a cutting head."
			icon_state = "jaws_cutter"
			usesound = 'sound/items/jaws_cut.ogg'
			pry = 0
			tool_qualities = list(TOOL_WIRECUTTER)
			if(user)
				playsound(src, 'sound/items/change_jaws.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You attach the cutting jaws to [src].</span>")

/obj/item/tool/transforming/powerdrill
	name = "hand drill"
	desc = "A simple powered hand drill."
	icon = 'icons/obj/tools.dmi'
	icon_state = "drill_bolt"
	item_state = "drill"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MAT_STEEL = 150, MAT_SILVER = 50)
	hitsound = 'sound/items/drill_hit.ogg'
	usesound = 'sound/items/drill_use.ogg'
	force = 8
	throwforce = 8
	toolspeed = 0.25
	sharp = FALSE
	edge = FALSE
	attack_verb = list("drilled", "screwed", "jabbed", "whacked")
	possible_tooltypes = list(TOOL_WRENCH,TOOL_SCREWDRIVER)

/obj/item/tool/transforming/powerdrill/on_tool_switch(var/mob/user)
	switch(possible_tooltypes[current_tooltype])
		if(TOOL_WRENCH)
			desc = initial(desc) + " It's fitted with a bolt driver."
			icon_state = "drill_bolt"
			sharp = FALSE
			tool_qualities = list(TOOL_WRENCH)
			if(user)
				playsound(src,'sound/items/change_drill.ogg',50,1)
				to_chat(user, "<span class='notice'>You attach the bolt driver to [src].</span>")
		if(TOOL_SCREWDRIVER)
			desc = initial(desc) + " It's fitted with a screw driver."
			icon_state = "drill_screw"
			sharp = TRUE
			tool_qualities = list(TOOL_SCREWDRIVER)
			if(user)
				playsound(src,'sound/items/change_drill.ogg',50,1)
				to_chat(user, "<span class='notice'>You attach the screw driver to [src].</span>")

/obj/item/tool/transforming/altevian
	name = "Hull Systems Omni-Tool"
	desc = "A big and bulky tool, used by Altevians for engineering duties. It's able to do the job of any regular tool while scaled up to a comically large size. It seems nanites are in play to help with adjusting the tip and handling some of the heavy lifting when in use."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "altevian-wrench"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
		)
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_HUGE
	force = 25
	throwforce = 15
	toolspeed = 0.25
	sharp = FALSE
	edge = FALSE
	attack_verb = list("whacked", "slammed", "bashed", "wrenched", "fixed", "bolted", "clonked", "bonked")
	hitsound = 'sound/weapons/smash.ogg'
	possible_tooltypes = list(TOOL_WRENCH,TOOL_CROWBAR,TOOL_WIRECUTTER,TOOL_SCREWDRIVER,TOOL_MULTITOOL,TOOL_WELDER)
	weldertype = /obj/item/weldingtool/dummy/altevian

/obj/item/tool/transforming/altevian/on_tool_switch(var/mob/user)
	switch(possible_tooltypes[current_tooltype])
		if(TOOL_WRENCH)
			desc = initial(desc) + " It's currently in bolting mode."
			icon_state = "altevian-wrench"
			usesound = 'sound/items/ratchet.ogg'
			tool_qualities = list(TOOL_WRENCH)
			if(user)
				playsound(src,'sound/items/ratchet.ogg',50,1)
				to_chat(user, "<span class='notice'>You reconfigure [src] into bolting mode.</span>")
		if(TOOL_CROWBAR)
			desc = initial(desc) + " It's currently in prying mode."
			icon_state = "altevian-crowbar"
			usesound = 'sound/items/crowbar.ogg'
			tool_qualities = list(TOOL_CROWBAR)
			if(user)
				playsound(src,'sound/items/ratchet.ogg',50,1)
				to_chat(user, "<span class='notice'>You reconfigure [src] into prying mode.</span>")
		if(TOOL_WIRECUTTER)
			desc = initial(desc) + " It's currently in cutting mode."
			icon_state = "altevian-wirecutter"
			usesound = 'sound/items/wirecutter.ogg'
			tool_qualities = list(TOOL_WIRECUTTER)
			if(user)
				playsound(src,'sound/items/ratchet.ogg',50,1)
				to_chat(user, "<span class='notice'>You reconfigure [src] into cutting mode.</span>")
		if(TOOL_SCREWDRIVER)
			desc = initial(desc) + " It's currently in screwing mode."
			icon_state = "altevian-screwdriver"
			usesound = 'sound/items/screwdriver.ogg'
			tool_qualities = list(TOOL_SCREWDRIVER)
			if(user)
				playsound(src,'sound/items/ratchet.ogg',50,1)
				to_chat(user, "<span class='notice'>You reconfigure [src] into screwing mode.</span>")
		if(TOOL_MULTITOOL)
			desc = initial(desc) + " It's currently in pulsing mode."
			icon_state = "altevian-pulser"
			usesound = 'sound/items/screwdriver.ogg'
			tool_qualities = list(TOOL_MULTITOOL)
			if(user)
				playsound(src,'sound/items/ratchet.ogg',50,1)
				to_chat(user, "<span class='notice'>You reconfigure [src] into pulsing mode.</span>")
		if(TOOL_WELDER)
			desc = initial(desc) + " It's currently in welding mode."
			icon_state = "altevian-welder-on"
			welder.usesound = 'sound/items/Welder2.ogg'
			usesound = 'sound/items/Welder2.ogg'
			tool_qualities = list(TOOL_WELDER)
			if(user)
				playsound(src,'sound/items/ratchet.ogg',50,1)
				to_chat(user, "<span class='notice'>You reconfigure [src] into welding mode.</span>")

/obj/item/weldingtool/dummy/altevian
	toolspeed = 0.25
