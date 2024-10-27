/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cracker Pack
 *		Cigarette Pack
 *		Cigar Box
 *		Extra Tobacco Bits
 *		Vial Box
 *		Box of Chocolates
 */

/obj/item/storage/fancy/
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	var/icon_type = "donut"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	var/open = 0
	var/open_state
	var/closed_state

/obj/item/storage/fancy/update_icon(var/itemremoved = 0)
	var/total_contents = contents.len - itemremoved
	icon_state = "[icon_type]box[total_contents]"
	return

/obj/item/storage/fancy/examine(mob/user)
	. = ..()

	if(Adjacent(user))
		if(!contents.len)
			. += "There are no [icon_type]s left in the box."
		else if(contents.len == 1)
			. += "There is one [icon_type] left in the box."
		else
			. += "There are [contents.len] [icon_type]s in the box."

/*
 * Egg Box
 */
/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	center_of_mass = list("x" = 16,"y" = 7)
	storage_slots = 12
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/boiledegg
		)
	starts_with = list(/obj/item/reagent_containers/food/snacks/egg = 12)

/obj/item/storage/fancy/egg_box/New()
	if(!open_state)
		open_state = "[initial(icon_state)]0"
	if(!closed_state)
		closed_state = "[initial(icon_state)]"
	..()

/obj/item/storage/fancy/egg_box/update_icon()
	cut_overlays()
	if(open)
		icon_state = open_state
		if(contents.len >= 1)
			add_overlay("eggbox[contents.len]")
	else
		icon_state = closed_state

/obj/item/storage/fancy/egg_box/open(mob/user as mob)
	if(open)
		return
	if (isobserver(usr))
		return
	open = TRUE
	update_icon()
	..()

/obj/item/storage/fancy/egg_box/close(mob/user as mob)
	open = FALSE
	update_icon()
	..()

/*
 * Candle Boxes
 */
/obj/item/storage/fancy/candle_box
	name = "red candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	throwforce = 2
	slot_flags = SLOT_BELT
	max_storage_space = ITEMSIZE_COST_TINY * 5
	can_hold = list(/obj/item/flame/candle)
	starts_with = list(/obj/item/flame/candle = 5)

/obj/item/storage/fancy/whitecandle_box
	name = "white candle pack"
	desc = "A pack of white candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "whitecandlebox5"
	icon_type = "whitecandle"
	item_state = "whitecandlebox5"
	throwforce = 2
	slot_flags = SLOT_BELT
	max_storage_space = ITEMSIZE_COST_TINY * 5
	can_hold = list(/obj/item/flame/candle)
	starts_with = list(/obj/item/flame/candle/white = 5)

/obj/item/storage/fancy/blackcandle_box
	name = "black candle pack"
	desc = "A pack of black candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "blackcandlebox5"
	icon_type = "blackcandle"
	item_state = "blackcandlebox5"
	throwforce = 2
	slot_flags = SLOT_BELT
	max_storage_space = ITEMSIZE_COST_TINY * 5
	can_hold = list(/obj/item/flame/candle)
	starts_with = list(/obj/item/flame/candle/black = 5)


/*
 * Crayon Box
 */
/obj/item/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = ITEMSIZE_SMALL
	icon_type = "crayon"
	can_hold = list(
		/obj/item/pen/crayon
	)
	starts_with = list(
		/obj/item/pen/crayon/red,
		/obj/item/pen/crayon/orange,
		/obj/item/pen/crayon/yellow,
		/obj/item/pen/crayon/green,
		/obj/item/pen/crayon/blue,
		/obj/item/pen/crayon/purple
	)

/obj/item/storage/fancy/crayons/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/fancy/crayons/update_icon()
	var/mutable_appearance/ma = new(src)
	ma.cut_overlays()
	for(var/obj/item/pen/crayon/crayon in contents)
		add_overlay(image('icons/obj/crayons.dmi',crayon.colourName))
	appearance = ma

/obj/item/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pen/crayon))
		switch(W:colourName)
			if("mime")
				to_chat(user, "This crayon is too sad to be contained in this box.")
				return
			if("rainbow")
				to_chat(user, "This crayon is too powerful to be contained in this box.")
				return
	..()

/obj/item/storage/fancy/markers
	name = "box of markers"
	desc = "A very professional looking box of permanent markers."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "markerbox"
	w_class = ITEMSIZE_SMALL
	icon_type = "marker"
	can_hold = list(
		/obj/item/pen/crayon/marker
	)
	starts_with = list(
		/obj/item/pen/crayon/marker/black,
		/obj/item/pen/crayon/marker/red,
		/obj/item/pen/crayon/marker/orange,
		/obj/item/pen/crayon/marker/yellow,
		/obj/item/pen/crayon/marker/green,
		/obj/item/pen/crayon/marker/blue,
		/obj/item/pen/crayon/marker/purple
	)

/obj/item/storage/fancy/markers/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/fancy/markers/update_icon()
	var/mutable_appearance/ma = new(src)
	ma.cut_overlays()
	for(var/obj/item/pen/crayon/marker/marker in contents)
		ma.add_overlay(image('icons/obj/crayons.dmi',"m"+marker.colourName))
	appearance = ma

/obj/item/storage/fancy/markers/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pen/crayon/marker))
		switch(W:colourName)
			if("mime")
				to_chat(user, "This marker is too depressing to be contained in this box.")
				return
			if("rainbow")
				to_chat(user, "This marker is too childish to be contained in this box.")
				return
	..()

/*
 * Cracker Pack
 */
/obj/item/storage/fancy/crackers
	name = "\improper Getmore Crackers"
	icon = 'icons/obj/food.dmi'
	icon_state = "crackerbox"
	icon_type = "cracker"
	max_storage_space = ITEMSIZE_COST_TINY * 6
	max_w_class = ITEMSIZE_TINY
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/food/snacks/cracker)
	starts_with = list(/obj/item/reagent_containers/food/snacks/cracker = 6)

/*
 * Cigarette Pack
 */
/obj/item/storage/fancy/cigarettes
	name = "\improper pack of Trans-Stellar Duty-frees"
	desc = "A ubiquitous brand of cigarettes, found in every major spacefaring corporation in the universe. As mild and flavorless as it gets."
	description_fluff = "The Trans-Stellar Duty-Free Cigarette Company was created as an imprint of NanoTrasen.  They are the most boring, tasteless, dry cigarettes on the market, but due to just how unremarkable (not to mention cheap to produce) they are, they sold in vending machines in almost every corner of the galaxy."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state_slots = list(slot_r_hand_str = "cigpacket", slot_l_hand_str = "cigpacket")
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/flame/lighter, /obj/item/trash/cigbutt)
	icon_type = "cigarette"
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette = 6)
	var/brand = "\improper Trans-Stellar Duty-free"

/obj/item/storage/fancy/cigarettes/Initialize()
	. = ..()
	flags |= NOREACT
	create_reagents(15 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	flags |= OPENCONTAINER
	if(brand)
		for(var/obj/item/clothing/mask/smokable/cigarette/C in src)
			C.brand = brand
			C.desc += " This one is \a [brand]."

/obj/item/storage/fancy/cigarettes/New()
	if(!open_state)
		open_state = "[initial(icon_state)]_open"
	if(!closed_state)
		closed_state = "[initial(icon_state)]"
	..()

/obj/item/storage/fancy/cigarettes/update_icon()
	cut_overlays()
	if(open)
		icon_state = open_state
		if(contents.len >= 1)
			add_overlay("cig[contents.len]")
	else
		icon_state = closed_state

/obj/item/storage/fancy/cigarettes/open(mob/user as mob)
	if(open)
		return
	open = TRUE
	if(contents.len == 0)
		icon_state = "[initial(icon_state)]_empty"
	else
		update_icon()
	..()

/obj/item/storage/fancy/cigarettes/close(mob/user as mob)
	open = FALSE
	if(contents.len == 0)
		icon_state = "[initial(icon_state)]_empty"
	else
		update_icon()
	..()

/obj/item/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette))
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	return ..()

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(M == user && user.zone_sel.selecting == O_MOUTH)
		// Find ourselves a cig. Note that we could be full of lighters.
		var/obj/item/clothing/mask/smokable/cigarette/cig = locate() in src

		if(cig == null)
			to_chat(user, span_notice("Looks like the packet is out of cigarettes."))
			return

		// Instead of running equip_to_slot_if_possible() we check here first,
		// to avoid dousing cig with reagents if we're not going to equip it
		if(!cig.mob_can_equip(user, slot_wear_mask))
			return

		// We call remove_from_storage first to manage the reagent transfer and
		// UI updates.
		remove_from_storage(cig, null)
		user.equip_to_slot(cig, slot_wear_mask)

		reagents.maximum_volume = 15 * contents.len
		to_chat(user, span_notice("You take a cigarette out of the pack."))
		update_icon()
	else
		..()

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six Earth-export DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	description_fluff = "DromedaryCo is one of Sol's oldest cigarette brands, and takes pride in having sourced tobcacco from the same Indian plantations since 2044. Popular with those willing to pay extra for a little nostalgia."
	icon_state = "Dpacket"
	brand = "\improper Dromedary Co. cigarette"

/obj/item/storage/fancy/cigarettes/killthroat
	name = "\improper AcmeCo packet"
	desc = "A packet of six AcmeCo cigarettes. For those who want to obtain a record for the most cancerous tumors on a budget."
	description_fluff = "Available anywhere people breathe and want to breathe less, AcmeCo is the cheapest, most widespread cigarette brand in the galaxy. They taste like trash, but when you're keeping them inside your jumpsuit on a 16 hour shift, you're probably not too concerned with flavour."
	icon_state = "Apacket"
	brand = "\improper Acme Co. cigarette"

/obj/item/storage/fancy/cigarettes/luckystars
	name = "\improper pack of Lucky Stars"
	desc = "A mellow blend made from synthetic, pod-grown tobacco. The commercial jingle is guaranteed to get stuck in your head."
	description_fluff = "Lucky Stars are some of the most prolific advertisers in the business, with Gilthari Exports plastering the name and slogan on everything from workplace safety videos to racing bikes. 'Feel the gentle warmth of your Lucky Star'."
	icon_state = "LSpacket"
	brand = "\improper Lucky Star"

/obj/item/storage/fancy/cigarettes/jerichos
	name = "\improper pack of Jerichos"
	desc = "Typically seen dangling from the lips of Fleet veterans and border world hustlers. Tastes like hickory smoke, feels like warm liquid death down your lungs."
	description_fluff = "The Jericho brand has carefully cultivated its 'rugged' image ever since its completely accidental association with the SolGov-Hegemony war due to their sizable corporate presence in the region. Prior to the war, Jerichos were considered the realm of drunks and sad divorcees."
	icon_state = "Jpacket"
	brand = "\improper Jericho"

/obj/item/storage/fancy/cigarettes/menthols
	name = "\improper pack of Temperamento Menthols"
	desc = "With a sharp and natural organic menthol flavor, these Temperamentos are a favorite of science vessel crews. Hardly anyone knows they make 'em in non-menthol!"
	description_fluff = "Temperamento Menthols are a product of the Aether Atmospherics and Recycling company, and the 'smooth' menthol taste is rumoured to be the chemical by-product of some far more profitable industrial synthesis."
	icon_state = "TMpacket"
	brand = "\improper Temperamento Menthol"

/obj/item/storage/fancy/cigarettes/carcinomas
	name = "\improper pack of Carcinoma Angels"
	desc = "This previously unknown brand was slated for the chopping block, until they were publicly endorsed by an old Earthling gonzo journalist. The rest is history. They sell a variety for cats, too."
	description_fluff = "The bitter taste of a Carcinoma Angel is considered desirable by many equally bitter wash-ups who consider themselves to be 'hard-boiled'. The smell is practically inseparable from urban security offices, and old men with exonet radio shows."
	brand = "\improper Carcinoma Angel"

/obj/item/storage/fancy/cigarettes/professionals
	name = "\improper pack of Professional 120s"
	desc = "Let's face it - if you're smoking these, you're either trying to look upper-class or you're 80 years old. That's the only excuse. They are, however, very good quality."
	description_fluff = "Grown and rolled in a meticulously maintained biosphere orbitting Love, P120 tobacco is marketed as 'probably the best in the galaxy'. The premium price point, and the fact that the vast majority of consumers couldn't really tell the difference between this and the next leading brand."
	icon_state = "P100packet"
	brand = "\improper Professional 120"

/*
 * Cigar Box
 */
/obj/item/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	description_fluff = "The tasteful stained palm case tells you that these 'Palma Grande' premium \
	cigars are only sold on the luxury cruises and resorts of Oasis, though ten separate companies \
	produce them for that purpose galaxy-wide. The standard is however very high."
	icon_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 5
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar, /obj/item/trash/cigbutt/cigarbutt)
	icon_type = "cigar"
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette/cigar = 5)

/obj/item/storage/fancy/cigar/Initialize()
	. = ..()
	flags |= NOREACT
	create_reagents(15 * storage_slots)

/obj/item/storage/fancy/cigar/remove_from_storage(obj/item/W as obj, atom/new_location)
	var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
	if(!istype(C)) return
	reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	return ..()

/obj/item/storage/fancy/cigar/New()
	if(!open_state)
		open_state = "[initial(icon_state)]0"
	if(!closed_state)
		closed_state = "[initial(icon_state)]"
	..()

/obj/item/storage/fancy/cigar/update_icon()
	cut_overlays()
	if(open)
		icon_state = open_state
		if(contents.len >= 1)
			add_overlay("[initial(icon_state)][contents.len]")
	else
		icon_state = closed_state

/obj/item/storage/fancy/cigar/open(mob/user as mob)
	if(open)
		return
	open = TRUE
	update_icon()
	..()

/obj/item/storage/fancy/cigar/close(mob/user as mob)
	open = FALSE
	update_icon()
	..()

/obj/item/storage/fancy/cigar/choiba
	name = "/improper Choiba cigar case"
	desc = "A fancy case for holding your cigars when you are not smoking them."
	description_fluff = "The exquisite wooden case bears the markings of the \
	Choiba cigar company based out of Cuba. The perfectly humidized case keeps \
	the companies signature Cigars in premium condidtion even when traveling \
	long distances within a vacuume. The custom case itself can sell for quite \
	a lot in some places."
	icon_state = "cohibacase"
	icon = 'icons/obj/cigarettes.dmi'
	icon_type = "cigar"
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba = 5)

/obj/item/storage/fancy/cigar/havana
	name = "\improper Havana cigar case"
	desc = "A fancy case for holding your cigars when you are not smoking them."
	icon_state = "havanacase"
	icon = 'icons/obj/cigarettes.dmi'
	icon_type = "cigar"
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette/cigar/havana = 5)

/*
 * Tobacco Bits
 */
/obj/item/storage/rollingpapers
	name = "rolling paper pack"
	desc = "A small cardboard pack containing several folded rolling papers."
	icon_state = "paperbox"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 14
	can_hold = list(/obj/item/reagent_containers/rollingpaper)
	starts_with = list(/obj/item/reagent_containers/rollingpaper = 14)

/obj/item/storage/rollingpapers/blunt
	name = "blunt wrap pack"
	desc = "A small cardboard pack containing several folded blunt wraps."
	icon_state = "bluntbox"
	storage_slots = 7
	can_hold = list(/obj/item/reagent_containers/rollingpaper/blunt)
	starts_with = list(/obj/item/reagent_containers/rollingpaper/blunt = 7)

/*
 * Vial Box
 */
/obj/item/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	desc = "A helpful rack to hold test tubes."
	storage_slots = 6
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	starts_with = list(/obj/item/reagent_containers/glass/beaker/vial = 6)

/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")
	max_w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	max_storage_space = ITEMSIZE_COST_SMALL * 6 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/storage/lockbox/vials/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	var/total_contents = contents.len - itemremoved
	icon_state = "vialbox[total_contents]"
	cut_overlays()
	if (!broken)
		add_overlay("led[locked]")
		if(locked)
			add_overlay("cover")
	else
		add_overlay("ledb")

/obj/item/storage/lockbox/vials/attackby(obj/item/W as obj, mob/user as mob)
	..()
	update_icon()

/*
 * Box of Chocolates
 */
/obj/item/storage/fancy/heartbox
	icon_state = "heartbox"
	name = "box of chocolates"
	icon_type = "chocolate"

	var/startswith = 6
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/chocolatepiece,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/white,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/truffle
		)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/chocolatepiece,
		/obj/item/reagent_containers/food/snacks/chocolatepiece,
		/obj/item/reagent_containers/food/snacks/chocolatepiece,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/white,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/white,
		/obj/item/reagent_containers/food/snacks/chocolatepiece/truffle
	)

/obj/item/storage/fancy/heartbox/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/fancy/heartbox/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "heartbox_empty"
