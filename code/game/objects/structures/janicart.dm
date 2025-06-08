GLOBAL_LIST_BOILERPLATE(all_janitorial_carts, /obj/structure/janitorialcart)

/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "The ultimate in janitorial carts! Has space for water, mops, signs, trash bags, and more!"
	description_info = "You can use alt-click while holding a mop to stow the mop. Alt-click holding a reagent container will empty the contents into the bucket without trying to put the container in any attached trash bag."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	flags = OPENCONTAINER
	climbable = TRUE
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag	= null
	var/obj/item/mop/mymop = null
	var/obj/item/reagent_containers/spray/myspray = null
	var/obj/item/lightreplacer/myreplacer = null
	var/obj/structure/mopbucket/mybucket = null
	var/has_items = FALSE
	var/dismantled = TRUE
	var/signs = 0	//maximum capacity hardcoded below
	var/list/tgui_icons = list()

	var/static/list/equippable_item_whitelist

/obj/structure/janitorialcart/proc/equip_janicart_item(mob/user, obj/item/I)
	if(!equippable_item_whitelist)
		equippable_item_whitelist = typecacheof(list(
			/obj/item/storage/bag/trash,
			/obj/item/mop,
			/obj/item/mop/advanced,
			/obj/item/reagent_containers/spray,
			/obj/item/lightreplacer,
			/obj/item/clothing/suit/caution,
		))

	if(!is_type_in_typecache(I, equippable_item_whitelist))
		to_chat(user, span_warning("There's no room in [src] for [I]."))
		return FALSE

	if(!user.canUnEquip(I))
		to_chat(user, span_warning("[I] is stuck to your hand."))
		return FALSE

	if(istype(I, /obj/item/storage/bag/trash))
		if(mybag)
			to_chat(user, span_warning("[src] already has \an [I]."))
			return FALSE
		mybag = I
		setTguiIcon("mybag", mybag)

	else if(istype(I, /obj/item/mop) || istype(I, /obj/item/mop/advanced))
		if(mymop)
			to_chat(user, span_warning("[src] already has \an [I]."))
			return FALSE
		mymop = I
		setTguiIcon("mymop", mymop)

	else if(istype(I, /obj/item/reagent_containers/spray))
		if(myspray)
			to_chat(user, span_warning("[src] already has \an [I]."))
			return FALSE
		myspray = I
		setTguiIcon("myspray", myspray)

	else if(istype(I, /obj/item/lightreplacer))
		if(myreplacer)
			to_chat(user, span_warning("[src] already has \an [I]."))
			return FALSE
		myreplacer = I
		setTguiIcon("myreplacer", myreplacer)

	else if(istype(I, /obj/item/clothing/suit/caution))
		if(signs < 4)
			signs++
			setTguiIcon("signs", I)
		else
			to_chat(user, span_notice("[src] can't hold any more signs."))
			return FALSE
	else
		// This may look like duplicate code, but it's important that we don't call unEquip *and* warn the user if
		// something horrible goes wrong. (this else is never supposed to happen)
		to_chat(user, span_warning("There's no room in [src] for [I]."))
		return FALSE

	user.drop_from_inventory(I, src)
	update_icon()
	to_chat(user, span_notice("You put [I] into [src]."))
	return TRUE

/obj/structure/janitorialcart/proc/setTguiIcon(key, atom/A)
	if(!istype(A) || !key)
		return

	var/icon/F = getFlatIcon(A, defdir = SOUTH, no_anim = TRUE)
	tgui_icons["[key]"] = "'data:image/png;base64,[icon2base64(F)]'"
	SStgui.update_uis(src)

/obj/structure/janitorialcart/proc/nullTguiIcon(key)
	if(!key)
		return
	tgui_icons.Remove(key)
	SStgui.update_uis(src)

/obj/structure/janitorialcart/proc/clearTguiIcons()
	tgui_icons.Cut()
	SStgui.update_uis(src)

/obj/structure/janitorialcart/Destroy()
	QDEL_NULL(mybag)
	QDEL_NULL(mymop)
	QDEL_NULL(myspray)
	QDEL_NULL(myreplacer)
	QDEL_NULL(mybucket)
	clearTguiIcons()
	return ..()

/obj/structure/janitorialcart/examine(mob/user)
	. = ..(user)
	if(istype(mybucket))
		var/contains = mybucket.reagents.total_volume
		. += "[icon2html(src, user.client)] The bucket contains [contains] unit\s of liquid!"
	else
		. += "[icon2html(src, user.client)] There is no bucket mounted on it!"

/obj/structure/janitorialcart/MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
	if (istype(O, /obj/structure/mopbucket) && !mybucket)
		O.forceMove(src)
		mybucket = O
		setTguiIcon("mybucket", mybucket)
		to_chat(user, "You mount the [O] on the janicart.")
		update_icon()
	else
		..()

/obj/structure/janitorialcart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/reagent_containers/glass/rag) || istype(I, /obj/item/soap))
		if (mybucket)
			if(I.reagents.total_volume < I.reagents.maximum_volume)
				if(mybucket.reagents.total_volume < 1)
					to_chat(user, span_notice("[mybucket] is empty!"))
				else
					mybucket.reagents.trans_to_obj(I, 5)	//
					to_chat(user, span_notice("You wet [I] in [mybucket]."))
					playsound(src, 'sound/effects/slosh.ogg', 25, 1)
			else
				to_chat(user, span_notice("[I] can't absorb anymore liquid!"))
		else
			to_chat(user, span_notice("There is no bucket mounted here to dip [I] into!"))
		return 1

	else if (istype(I, /obj/item/reagent_containers/glass/bucket) && mybucket)
		I.afterattack(mybucket, user, 1)
		update_icon()
		return 1

	else if(istype(I, /obj/item/reagent_containers/spray) && !myspray)
		equip_janicart_item(user, I)
		return 1

	else if(istype(I, /obj/item/lightreplacer) && !myreplacer)
		equip_janicart_item(user, I)
		return 1

	else if(istype(I, /obj/item/storage/bag/trash) && !mybag)
		equip_janicart_item(user, I)
		return 1

	else if(istype(I, /obj/item/clothing/suit/caution))
		equip_janicart_item(user, I)
		return 1

	else if(mybag)
		return mybag.attackby(I, user)
		//This return will prevent afterattack from executing if the object goes into the trashbag,
		//This prevents dumb stuff like splashing the cart with the contents of a container, after putting said container into trash

	else if (!has_items)
		if (I.has_tool_quality(TOOL_WRENCH))
			if (do_after(user, 5 SECONDS, src))
				dismantle(user)
			return
	..()


//New Altclick functionality!
//Altclick the cart with a mop to stow the mop away
//Altclick the cart with a reagent container to pour things into the bucket without putting the bottle in trash
/obj/structure/janitorialcart/AltClick(mob/living/user)
	if(user.incapacitated() || !Adjacent(user))	return
	var/obj/I = user.get_active_hand()
	if(istype(I, /obj/item/mop))
		equip_janicart_item(user, I)
	else if(istype(I, /obj/item/reagent_containers) && mybucket)
		var/obj/item/reagent_containers/C = I
		C.afterattack(mybucket, user, 1)
		update_icon()


/obj/structure/janitorialcart/attack_hand(mob/user)
	tgui_interact(user)
	return

/obj/structure/janitorialcart/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "JanitorCart", name) // 240, 160
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/structure/janitorialcart/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["mybag"] = mybag ? capitalize(mybag.name) : null
	data["mybucket"] = mybucket ? capitalize(mybucket.name) : null
	data["mymop"] = mymop ? capitalize(mymop.name) : null
	data["myspray"] = myspray ? capitalize(myspray.name) : null
	data["myreplacer"] = myreplacer ? capitalize(myreplacer.name) : null
	data["signs"] = signs ? "[signs] sign\s" : null

	data["icons"] = tgui_icons
	return data

/obj/structure/janitorialcart/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	var/obj/item/I = ui.user.get_active_hand()

	switch(action)
		if("bag")
			if(mybag)
				ui.user.put_in_hands(mybag)
				to_chat(ui.user, span_notice("You take [mybag] from [src]."))
				mybag = null
				nullTguiIcon("mybag")
			else if(is_type_in_typecache(I, equippable_item_whitelist))
				equip_janicart_item(ui.user, I)
		if("mop")
			if(mymop)
				ui.user.put_in_hands(mymop)
				to_chat(ui.user, span_notice("You take [mymop] from [src]."))
				mymop = null
				nullTguiIcon("mymop")
			else if(is_type_in_typecache(I, equippable_item_whitelist))
				equip_janicart_item(ui.user, I)
		if("spray")
			if(myspray)
				ui.user.put_in_hands(myspray)
				to_chat(ui.user, span_notice("You take [myspray] from [src]."))
				myspray = null
				nullTguiIcon("myspray")
			else if(is_type_in_typecache(I, equippable_item_whitelist))
				equip_janicart_item(ui.user, I)
		if("replacer")
			if(myreplacer)
				ui.user.put_in_hands(myreplacer)
				to_chat(ui.user, span_notice("You take [myreplacer] from [src]."))
				myreplacer = null
				nullTguiIcon("myreplacer")
			else if(is_type_in_typecache(I, equippable_item_whitelist))
				equip_janicart_item(ui.user, I)
		if("sign")
			if(istype(I, /obj/item/clothing/suit/caution) && signs < 4)
				equip_janicart_item(ui.user, I)
			else if(signs)
				var/obj/item/clothing/suit/caution/sign = locate() in src
				if(sign)
					ui.user.put_in_hands(sign)
					to_chat(ui.user, span_notice("You take \a [sign] from [src]."))
					signs--
					if(!signs)
						nullTguiIcon("signs")
			else
				to_chat(ui.user, span_notice("[src] doesn't have any signs left."))
		if("bucket")
			if(mybucket)
				mybucket.forceMove(get_turf(ui.user))
				to_chat(ui.user, span_notice("You unmount [mybucket] from [src]."))
				mybucket = null
				nullTguiIcon("mybucket")
			else
				to_chat(ui.user, span_notice("((Drag and drop a mop bucket onto [src] to equip it.))"))
				return FALSE
		else
			return FALSE

	update_icon()
	return TRUE

/obj/structure/janitorialcart/update_icon()
	cut_overlays()

	if(mybucket)
		add_overlay("cart_bucket")
		if(mybucket.reagents.total_volume >= 1)
			add_overlay("water_cart")
	if(mybag)
		add_overlay("cart_garbage")
	if(mymop)
		add_overlay("cart_mop")
	if(myspray)
		add_overlay("cart_spray")
	if(myreplacer)
		add_overlay("cart_replacer")
	if(signs)
		add_overlay("cart_sign[signs]")

//This is called if the cart is caught in an explosion, or destroyed by weapon fire
/obj/structure/janitorialcart/proc/spill(var/chance = 100)
	var/turf/dropspot = get_turf(src)
	if (mymop && prob(chance))
		mymop.forceMove(dropspot)
		mymop.tumble(2)
		mymop = null

	if (myspray && prob(chance))
		myspray.forceMove(dropspot)
		myspray.tumble(3)
		myspray = null

	if (myreplacer && prob(chance))
		myreplacer.forceMove(dropspot)
		myreplacer.tumble(3)
		myreplacer = null

	if (mybucket && prob(chance*0.5))//bucket is heavier, harder to knock off
		mybucket.forceMove(dropspot)
		mybucket.tumble(1)
		mybucket = null

	if (signs)
		for (var/obj/item/clothing/suit/caution/Sign in src)
			if (prob(min((chance*2),100)))
				signs--
				Sign.forceMove(dropspot)
				Sign.tumble(3)
				if (signs < 0)//safety for something that shouldn't happen
					signs = 0
					update_icon()
					return

	if (mybag && prob(min((chance*2),100)))//Bag is flimsy
		mybag.forceMove(dropspot)
		mybag.tumble(1)
		mybag.spill()//trashbag spills its contents too
		mybag = null

	update_icon()
	clearTguiIcons()



/obj/structure/janitorialcart/proc/dismantle(var/mob/user = null)
	if (!dismantled)
		if (has_items)
			spill()

		new /obj/item/stack/material/steel(src.loc, 10)
		new /obj/item/stack/material/plastic(src.loc, 10)
		new /obj/item/stack/rods(src.loc, 20)
		dismantled = 1
		qdel(src)


/obj/structure/janitorialcart/ex_act(severity)
	spill(100 / severity)
	..()
