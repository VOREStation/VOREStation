/*
Remote scene tools! These, in effects, serve 2 purposes:

* Forward emotes from wearer of one to wearer of its partner
* Provide simple feedback - is your partner dead, SSD, did they log out? - some are more explicit.

why aren't these accessories?
	They easily could be! I'm just lazy and don't wanna forward the "see emote" from wearables to all the accessories

*/


/obj/item/remote_scene_tool
	var/obj/item/remote_scene_tool/linked
	icon = 'code/modules/maint_recycler/icons/goodies/remote_scene_tools.dmi'
	icon_override = 'code/modules/maint_recycler/icons/goodies/remote_scene_tools.dmi'
	item_state = "InvalidState" //so it defaults to the empty icon
	var/icon_root = "sticker"
	icon_state = "sticker_inactive"
	name = "Bluespace Sticker"
	desc = "A stretchable, flexible sticker that induces a quasi-stable 4th dimensional bluespace buzzword rift, enabling moderate levels of touch between the two."
	description_info = "These stickers act as remote scene tools - any sort of emotes or subtles that the wearer does will go DIRECTLY to the other sticker! It's vague, so use it how you want in RP! Just remember bystander consent!"
	slot_flags = (SLOT_OCLOTHING | SLOT_ICLOTHING | SLOT_GLOVES | SLOT_MASK | SLOT_HEAD | SLOT_FEET | SLOT_ID | SLOT_BELT | SLOT_BACK | SLOT_POCKET)
	w_class = ITEMSIZE_SMALL
	var/mob/worn_mob = null
	var/last_loc
	var/can_summon = TRUE
	var/can_replace = TRUE

	var/replacementType = /obj/item/remote_scene_tool

/obj/item/remote_scene_tool/proc/link_to(var/obj/item/remote_scene_tool/to_link)
	//link to a remote scene tool
	if(linked)
		return

	linked = to_link
	linked.linked = src

/obj/item/remote_scene_tool/proc/register_to_mob(var/mob)
	if(worn_mob == mob)
		return

	if(worn_mob)
		unregister_from_mob(worn_mob)

	worn_mob = mob

	RegisterSignal(mob, COMSIG_MOB_LOGIN, PROC_REF(worn_mob_logged_in))
	RegisterSignal(mob, COMSIG_MOB_LOGOUT, PROC_REF(worn_mob_logged_out))
	transmit_emote(src, span_notice("\The [src] has been put on by [mob]!"))

/obj/item/remote_scene_tool/proc/unregister_from_mob(var/mob)
	if(worn_mob == null) return
	UnregisterSignal(worn_mob, COMSIG_MOB_LOGIN)
	UnregisterSignal(worn_mob, COMSIG_MOB_LOGOUT)
	worn_mob = null
	transmit_emote(src, span_warning("\The [src]'s wearer has removed it!"))


//called when the mob wearing this item logs out
/obj/item/remote_scene_tool/proc/worn_mob_logged_out()
	SIGNAL_HANDLER
	if(!linked)
		return
	transmit_emote(src, span_warning("\The [src]'s wearer has gone SSD!"))
	linked?.linked_updated()


/obj/item/remote_scene_tool/proc/worn_mob_logged_in()
	SIGNAL_HANDLER
	//called when the mob wearing this item logs in
	if(!linked)
		return
	transmit_emote(src, "\The [src]'s wearer has returned from SSD!")
	linked?.linked_updated()

/obj/item/remote_scene_tool/see_emote(var/mob/M as mob, var/text, var/emote_type)
	//to_world_log("emote: [text] from [M] to [linked]")
	if(M == getWearer())
		//we're the one doing the emote
		transmit_emote(src, text,emote_type)

/obj/item/remote_scene_tool/proc/transmit_emote(var/mob/M as mob, var/text, var/emote_type)
	if(linked == null) return
	if(ismob(linked.getWearer()))
		var/mob/m = linked.getWearer()
		if(!m.client) return;
		to_chat(linked.loc, icon2html(src,m.client) + text)

	//transmit the emote to the other side


/obj/item/remote_scene_tool/proc/sanity_check()
	//check if the other side is still valid
	. = TRUE
	if(!linked)
		return FALSE
	if(linked.linked != src)
		return FALSE

	var/mob/m = linked.getWearer()
	if(!ismob(m))
		return FALSE
	if(!m.client) //no scene partner? whoopsie!
		return FALSE

/obj/item/remote_scene_tool/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_ENTERING, PROC_REF(check_loc))

/obj/item/remote_scene_tool/proc/check_loc(atom/movable/mover, atom/old_loc, atom/new_loc)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(delayed_loc_check)), 1)

/obj/item/remote_scene_tool/proc/delayed_loc_check()
//why is this delayed? because when moving stuff between slots, it considers it in a different spot, and calls the commsig multiple times - so the end
//user just gets the shit spammed out of them
	if(last_loc == loc)
		return
	last_loc = loc
	linked?.linked_updated()
	linked_updated()

	var/mob/m = getWearer()


	if(ismob(m))
		register_to_mob(m) //handles any caching
	else
		if(worn_mob)
			unregister_from_mob(worn_mob) //unregister from the mob if we aren't on it anymore

/obj/item/remote_scene_tool/proc/linked_updated()
	update_icon()

/obj/item/remote_scene_tool/update_icon()
	if(sanity_check())
		icon_state = icon_root
	else
		icon_state = icon_root + "_inactive"


/obj/item/remote_scene_tool/Destroy()
	. = ..()
	if(linked)
		linked.linked = null //clear out the other side
		linked = null
	UnregisterSignal(src, COMSIG_ATOM_ENTERING)
	unregister_from_mob(worn_mob)

/obj/item/remote_scene_tool/examine(mob/user)
	. = ..()
	var/mob/living/carbon/human/lw = linked?.getWearer()

	if(lw)
		. += span_notice("This is linked to [lw]'s [linked.name].")
		if(!lw.client || lw.stat == UNCONSCIOUS || lw.stat == DEAD)
			. += span_warning("The wearer of \the [src]'s counterpart doesn't appear to be conscious!")
	else
		. += span_notice("Its counterpart seems to be in \the [get_area(linked).name]")

	if(!linked)
		. += span_warning("This is not linked to anything!")

	if(!ismob(linked.loc))
		. += span_warning("\The [src]'s counterpart isn't being worn or carried by anyone!")


/obj/item/storage/box/remote_scene_tools
	icon = 'code/modules/maint_recycler/icons/goodies/remote_scene_tools.dmi'
	icon_state = "stickerbox"
	name = "box of bluespace stickers"
	desc = "A box containing a few bluespace stickers. Moderately obsolete, limited range dimensional bypass technology that enables remote \"things\" and \"stuff\" as if there were no distance at all between them!"
	var/primary = /obj/item/remote_scene_tool
	var/secondary = /obj/item/remote_scene_tool
	description_info = "These allow you to send emotes (and subtles!) over to the person wearing the other end of it! the only person that'll ever see the emotes is the person wearing it, and you need to be wearing (or holding/in a pocket) it for them to see your emotes!"
	description_fluff = "A long since discarded prototype of a bag of holding - turns out it's hard to store things securely when the other end's open. too bad NOBODY has EVER found a practical use for them!"

/obj/item/storage/box/remote_scene_tools/Initialize(mapload)
	. = ..()
	//set the contents to be a few remote scene tools
	var/obj/item/remote_scene_tool/RST = new primary(loc = src)
	var/obj/item/remote_scene_tool/RST2 = new secondary(loc = src)
	RST.link_to(RST2)
	RST2.link_to(RST)
	contents += RST
	contents += RST2
	calibrate_size()

/obj/item/remote_scene_tool/proc/getWearer()
	if(ismob(loc))
		return loc
	if(istype(loc,/obj/item/clothing))
		if(ismob(loc.loc))
			return loc.loc
	return null

/obj/item/remote_scene_tool/verb/summon_counterpart()
	set name = "Summon Counterpart"
	set desc = "Forcibly moves the linked object over to you - or, if it doesn't exist, spawn a new one."
	if(can_summon || (linked == null && can_replace))
		if(linked == null)
			create_counterpart()
			to_chat(usr,span_notice("\The [src] forms a new [linked]!"))
		else
			var/mob/counterpart = linked.getWearer()
			if(counterpart)
				counterpart.remove_from_mob(linked,get_turf(src))
			else
				linked.forceMove(get_turf(src))
			to_chat(usr,span_notice("\The [linked] materializes in front of you!"))
	else
		to_chat(usr,span_notice("Nothing seems to happen!"))

/obj/item/remote_scene_tool/proc/create_counterpart()
	var/obj/item/remote_scene_tool/newrst = new replacementType(get_turf(src))
	link_to(newrst)
	newrst.link_to(src)
