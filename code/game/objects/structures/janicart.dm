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
	var/obj/item/weapon/storage/bag/trash/mybag	= null
	var/obj/item/weapon/mop/mymop = null
	var/obj/item/weapon/reagent_containers/spray/myspray = null
	var/obj/item/device/lightreplacer/myreplacer = null
	var/obj/structure/mopbucket/mybucket = null
	var/has_items = FALSE
	var/dismantled = TRUE
	var/signs = 0	//maximum capacity hardcoded below
	var/list/tgui_icons = list()

	var/static/list/equippable_item_whitelist

/obj/structure/janitorialcart/proc/equip_janicart_item(mob/user, obj/item/I)
	if(!equippable_item_whitelist)
		equippable_item_whitelist = typecacheof(list(
			/obj/item/weapon/storage/bag/trash,
			/obj/item/weapon/mop,
			/obj/item/weapon/reagent_containers/spray,
			/obj/item/device/lightreplacer,
			/obj/item/clothing/suit/caution,
		))

	if(!is_type_in_typecache(I, equippable_item_whitelist))
		to_chat(user, "<span class='warning'>There's no room in [src] for [I].</span>")
		return FALSE

	if(!user.canUnEquip(I))
		to_chat(user, "<span class='warning'>[I] is stuck to your hand.</span>")
		return FALSE

	if(istype(I, /obj/item/weapon/storage/bag/trash))
		if(mybag)
			to_chat(user, "<span class='warning'>[src] already has \an [I].</span>")
			return FALSE
		mybag = I
		setTguiIcon("mybag", mybag)

	else if(istype(I, /obj/item/weapon/mop))
		if(mymop)
			to_chat(user, "<span class='warning'>[src] already has \an [I].</span>")
			return FALSE
		mymop = I
		setTguiIcon("mymop", mymop)

	else if(istype(I, /obj/item/weapon/reagent_containers/spray))
		if(myspray)
			to_chat(user, "<span class='warning'>[src] already has \an [I].</span>")
			return FALSE
		myspray = I
		setTguiIcon("myspray", myspray)

	else if(istype(I, /obj/item/device/lightreplacer))
		if(myreplacer)
			to_chat(user, "<span class='warning'>[src] already has \an [I].</span>")
			return FALSE
		myreplacer = I
		setTguiIcon("myreplacer", myreplacer)

	else if(istype(I, /obj/item/clothing/suit/caution))
		if(signs < 4)
			signs++
			setTguiIcon("signs", I)
		else
			to_chat(user, "<span class='notice'>[src] can't hold any more signs.</span>")
			return FALSE
	else
		// This may look like duplicate code, but it's important that we don't call unEquip *and* warn the user if
		// something horrible goes wrong. (this else is never supposed to happen)
		to_chat(user, "<span class='warning'>There's no room in [src] for [I].</span>")
		return FALSE

	user.drop_from_inventory(I, src)
	update_icon()
	to_chat(user, "<span class='notice'>You put [I] into [src].</span>")
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
		. += "\icon[src][bicon(src)] The bucket contains [contains] unit\s of liquid!"
	else
		. += "\icon[src][bicon(src)] There is no bucket mounted on it!"

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
	if(istype(I, /obj/item/weapon/mop) || istype(I, /obj/item/weapon/reagent_containers/glass/rag) || istype(I, /obj/item/weapon/soap))
		if (mybucket)
			if(I.reagents.total_volume < I.reagents.maximum_volume)
				if(mybucket.reagents.total_volume < 1)
					to_chat(user, "<span class='notice'>[mybucket] is empty!</span>")
				else
					mybucket.reagents.trans_to_obj(I, 5)	//
					to_chat(user, "<span class='notice'>You wet [I] in [mybucket].</span>")
					playsound(src, 'sound/effects/slosh.ogg', 25, 1)
			else
				to_chat(user, "<span class='notice'>[I] can't absorb anymore liquid!</span>")
		else
			to_chat(user, "<span class='notice'>There is no bucket mounted here to dip [I] into!</span>")
		return 1

	else if (istype(I, /obj/item/weapon/reagent_containers/glass/bucket) && mybucket)
		I.afterattack(mybucket, usr, 1)
		update_icon()
		return 1

	else if(istype(I, /obj/item/weapon/reagent_containers/spray) && !myspray)
		equip_janicart_item(user, I)
		return 1

	else if(istype(I, /obj/item/device/lightreplacer) && !myreplacer)
		equip_janicart_item(user, I)
		return 1

	else if(istype(I, /obj/item/weapon/storage/bag/trash) && !mybag)
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
		if (I.is_wrench())
			if (do_after(user, 5 SECONDS, src))
				dismantle(user)
			return
	..()


//New Altclick functionality!
//Altclick the cart with a mop to stow the mop away
//Altclick the cart with a reagent container to pour things into the bucket without putting the bottle in trash
/obj/structure/janitorialcart/AltClick(mob/living/user)
	if(user.incapacitated() || !Adjacent(user))	return
	var/obj/I = usr.get_active_hand()
	if(istype(I, /obj/item/weapon/mop))
		equip_janicart_item(user, I)
	else if(istype(I, /obj/item/weapon/reagent_containers) && mybucket)
		var/obj/item/weapon/reagent_containers/C = I
		C.afterattack(mybucket, usr, 1)
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

	var/obj/item/I = usr.get_active_hand()

	switch(action)
		if("bag")
			if(mybag)
				usr.put_in_hands(mybag)
				to_chat(usr, "<span class='notice'>You take [mybag] from [src].</span>")
				mybag = null
				nullTguiIcon("mybag")
			else if(is_type_in_typecache(I, equippable_item_whitelist))
				equip_janicart_item(usr, I)
		if("mop")
			if(mymop)
				usr.put_in_hands(mymop)
				to_chat(usr, "<span class='notice'>You take [mymop] from [src].</span>")
				mymop = null
				nullTguiIcon("mymop")
			else if(is_type_in_typecache(I, equippable_item_whitelist))
				equip_janicart_item(usr, I)
		if("spray")
			if(myspray)
				usr.put_in_hands(myspray)
				to_chat(usr, "<span class='notice'>You take [myspray] from [src].</span>")
				myspray = null
				nullTguiIcon("myspray")
			else if(is_type_in_typecache(I, equippable_item_whitelist))
				equip_janicart_item(usr, I)
		if("replacer")
			if(myreplacer)
				usr.put_in_hands(myreplacer)
				to_chat(usr, "<span class='notice'>You take [myreplacer] from [src].</span>")
				myreplacer = null
				nullTguiIcon("myreplacer")
			else if(is_type_in_typecache(I, equippable_item_whitelist))
				equip_janicart_item(usr, I)
		if("sign")
			if(istype(I, /obj/item/clothing/suit/caution) && signs < 4)
				equip_janicart_item(usr, I)
			else if(signs)
				var/obj/item/clothing/suit/caution/sign = locate() in src
				if(sign)
					usr.put_in_hands(sign)
					to_chat(usr, "<span class='notice'>You take \a [sign] from [src].</span>")
					signs--
					if(!signs)
						nullTguiIcon("signs")
			else
				to_chat(usr, "<span class='notice'>[src] doesn't have any signs left.</span>")
		if("bucket")
			if(mybucket)
				mybucket.forceMove(get_turf(usr))
				to_chat(usr, "<span class='notice'>You unmount [mybucket] from [src].</span>")
				mybucket = null
				nullTguiIcon("mybucket")
			else
				to_chat(usr, "<span class='notice'>((Drag and drop a mop bucket onto [src] to equip it.))</span>")
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




//old style retardo-cart
/obj/structure/bed/chair/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon"
	anchored = TRUE
	density = TRUE
	flags = OPENCONTAINER
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/weapon/storage/bag/trash/mybag	= null
	var/callme = "pimpin' ride"	//how do people refer to it?


/obj/structure/bed/chair/janicart/New()
	create_reagents(300)
	update_layer()


/obj/structure/bed/chair/janicart/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "This [callme] contains [reagents.total_volume] unit\s of water!"
		if(mybag)
			. += "\A [mybag] is hanging on the [callme]."


/obj/structure/bed/chair/janicart/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mop))
		if(reagents.total_volume > 1)
			reagents.trans_to_obj(I, 2)
			to_chat(user, "<span class='notice'>You wet [I] in the [callme].</span>")
			playsound(src, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, "<span class='notice'>This [callme] is out of water!</span>")
	else if(istype(I, /obj/item/key))
		to_chat(user, "Hold [I] in one of your hands while you drive this [callme].")
	else if(istype(I, /obj/item/weapon/storage/bag/trash))
		to_chat(user, "<span class='notice'>You hook the trashbag onto the [callme].</span>")
		user.drop_item()
		I.loc = src
		mybag = I


/obj/structure/bed/chair/janicart/attack_hand(mob/user)
	if(mybag)
		mybag.loc = get_turf(user)
		user.put_in_hands(mybag)
		mybag = null
	else
		..()


/obj/structure/bed/chair/janicart/relaymove(mob/living/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unbuckle_mob()
	if(user.get_type_in_hands(/obj/item/key))
		step(src, direction)
		update_mob()
	else
		to_chat(user, "<span class='notice'>You'll need the keys in one of your hands to drive this [callme].</span>")


/obj/structure/bed/chair/janicart/post_buckle_mob(mob/living/M)
	update_mob()
	return ..()


/obj/structure/bed/chair/janicart/update_layer()
	if(dir == SOUTH)
		layer = FLY_LAYER
	else
		layer = OBJ_LAYER


/obj/structure/bed/chair/janicart/unbuckle_mob()
	var/mob/living/M = ..()
	if(M)
		M.pixel_x = 0
		M.pixel_y = 0
	return M


/obj/structure/bed/chair/janicart/set_dir()
	..()
	update_layer()
	if(has_buckled_mobs())
		for(var/mob/living/L as anything in buckled_mobs)
			if(L.loc != loc)
				L.buckled = null //Temporary, so Move() succeeds.
				L.buckled = src //Restoring

	update_mob()


/obj/structure/bed/chair/janicart/proc/update_mob()
	if(has_buckled_mobs())
		for(var/mob/living/L as anything in buckled_mobs)
			L.set_dir(dir)
			switch(dir)
				if(SOUTH)
					L.pixel_x = 0
					L.pixel_y = 7
				if(WEST)
					L.pixel_x = 13
					L.pixel_y = 7
				if(NORTH)
					L.pixel_x = 0
					L.pixel_y = 4
				if(EAST)
					L.pixel_x = -13
					L.pixel_y = 7


/obj/structure/bed/chair/janicart/bullet_act(var/obj/item/projectile/Proj)
	if(has_buckled_mobs())
		if(prob(85))
			var/mob/living/L = pick(buckled_mobs)
			return L.bullet_act(Proj)
	visible_message("<span class='warning'>[Proj] ricochets off the [callme]!</span>")


/obj/item/key
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = ITEMSIZE_TINY
