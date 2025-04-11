//remote stuff! like uhhhh
// the funny stickers
// the funny voodoo doll


/obj/item/remote_scene_tool
	var/obj/item/remote_scene_tool/linked
	icon = 'code/modules/maint_recycler/icons/goodies/remote_scene_tools.dmi'
	icon_override = 'code/modules/maint_recycler/icons/goodies/remote_scene_tools.dmi'
	item_state = "InvalidState" //so it defaults to the empty icon
	var/icon_root = "sticker"
	icon_state = "sticker_inactive"
	name = "Bluespace Sticker"
	desc = "A stretchable, flexible sticker that induces a quasi-stable 4th dimensional bluespace buzzword rift, enabling moderate levels of touch between the two."
	description_info = "These stickers act as remote scene tools - any sort of emotes or subtles that the wearer does will go DIRECTLY to the other sticker! It's vauge, so use it how you want in RP! Just remember bystander consent!"
	slot_flags = (SLOT_OCLOTHING | SLOT_ICLOTHING | SLOT_GLOVES | SLOT_MASK | SLOT_HEAD | SLOT_FEET | SLOT_ID | SLOT_BELT | SLOT_BACK | SLOT_POCKET)

	var/mob/worn_mob = null
	var/last_loc

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
	transmit_emote(src, span_notice("The [src]\'s has been put on by [mob]!"))



/obj/item/remote_scene_tool/proc/unregister_from_mob(var/mob)
	if(worn_mob == null) return
	UnregisterSignal(worn_mob, COMSIG_MOB_LOGIN)
	UnregisterSignal(worn_mob, COMSIG_MOB_LOGOUT)
	worn_mob = null
	transmit_emote(src, span_warning("The [src]\'s wearer has removed it!"))

/obj/item/remote_scene_tool/proc/worn_mob_logged_out()
	SIGNAL_HANDLER
	if(!linked)
		return
	transmit_emote(src, span_warning("The [src]\'s wearer has gone SSD!"))
	linked?.linked_updated()

	//called when the mob wearing this item logs out

/obj/item/remote_scene_tool/proc/worn_mob_logged_in()
	SIGNAL_HANDLER
	//called when the mob wearing this item logs in
	if(!linked)
		return
	transmit_emote(src, "The [src]\'s wearer has returned from SSD!")
	linked?.linked_updated()

/obj/item/remote_scene_tool/see_emote(var/mob/M as mob, var/text, var/emote_type)
	//to_world_log("emote: [text] from [M] to [linked]")
	if(M == loc)
		//we're the one doing the emote
		transmit_emote(src, text,emote_type)

/obj/item/remote_scene_tool/proc/transmit_emote(var/mob/M as mob, var/text, var/emote_type)
	if(ismob(linked.loc))
		var/mob/m = linked.loc
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
	if(!ismob(linked.loc))
		return FALSE
	var/mob/m = linked.loc
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

	if(ismob(loc))
		register_to_mob(loc) //handles any caching
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
	if(linked && ismob(linked.loc))
		. += span_notice("This is linked to [linked.loc]\'s [linked.name].")
		var/mob/m = linked.loc
		if(!m.client)
			. += span_warning("The wearer of \The [src]'s counterpart doesn't appear to be all there!")
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

/obj/item/remote_scene_tool/voodoo_doll
	name = "voodoo doll"
	desc = "A dubiously-cursed-esq Voodoo doll that mimics whoever is wearing it's matching necklace via built in hardlight projection."
	icon = 'code/modules/maint_recycler/icons/goodies/remote_scene_tools.dmi'
	icon_state = "voodoo_doll_inactive"
	icon_root = "voodoo_doll"
	description_info = "The Doll acts as a remote scene tool - any sort of emotes or subtles that the wearer does will go DIRECTLY to the necklace! It's vauge, so use it how you want in RP! Just remember bystander consent!"
	//this is just a copy of the remote scene tool, but with a different icon
	//and a different name

	var/last_loc_update = null

/obj/item/remote_scene_tool/voodoo_doll/update_icon()
	. = ..()

	last_loc_update = linked.loc

	overlays.Cut()

	dir = SOUTH
	src.alpha = 255

	name = initial(name)
	desc = initial(desc)

	if(!linked)
		return
	if(!ismob(linked.loc))
		return
	if(!ismob(loc)) //only show the person's icon if we're holding it. makes "found in the hall" interactions less weird
		return

	var/mob/M = linked.loc
	if(ismob(M))
		src.alpha = 190 //make it a bit transparent so it doesn't look like a mob holder.
		name = "Voodoo doll of " + M.name
		desc = "A small, marketable doll that looks suspiciously like [M]... "
		overlays |= M.overlays

/obj/item/remote_scene_tool/voodoo_necklace
	name = "Gem-Encruseted Necklace"
	desc = "A bitingly cold metal necklace with a swirling gem in the center. haters will say it's not magical"
	icon_state = "necklace_inactive"
	icon_root = "necklace"
	slot_flags = SLOT_MASK
	description_info = "The necklace and the associated doll act as remote scene tools - any sort of emotes or subtles that the wearer does will go DIRECTLY to the other! It's vauge, so use it how you want in RP! Just remember bystander consent!"

/obj/item/storage/box/remote_scene_tools/voodoo
	icon_state = "voodoobox"
	name = "Voodoo Supplies Box"
	desc = "a horribly dusty box from 'magici-corp' with a ludicrously corny image of a voodoo doll on the front. marketed as part of a DIY magician routine, they stopped making them after someone broke their nose when the doll was dropped."
	primary = /obj/item/remote_scene_tool/voodoo_doll
	secondary = /obj/item/remote_scene_tool/voodoo_necklace
