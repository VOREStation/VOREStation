/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		Wrapping Paper
 */

/*
 * Gifts
 */
/obj/item/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/gifts.dmi'
	icon_state = "gift"
	item_state = "gift1"
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/a_gift/Initialize(mapload)
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	if(w_class > 0 && w_class < ITEMSIZE_LARGE)
		icon_state = "gift[w_class]" + "_[pick("g","r","b","y","p")]"
	else
		icon_state = "gift[pick(1, 2, 3)]" + "_[pick("g","r","b","y","p")]"

/obj/item/gift/attack_self(mob/user as mob)
	user.drop_item()
	playsound(src, 'sound/items/package_unwrap.ogg', 50,1)
	if(gift)
		user.put_in_active_hand(gift)
		gift.add_fingerprint(user)
	else
		to_chat(user, span_warning("The gift was empty!"))
	qdel(src)
	return

/obj/item/a_gift/ex_act()
	qdel(src)
	return

/obj/effect/spresent/relaymove(mob/user as mob)
	if(user.stat)
		return
	to_chat(user, span_warning("You can't move."))

/obj/effect/spresent/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if (!W.has_tool_quality(TOOL_WIRECUTTER))
		to_chat(user, span_warning("I need wirecutters for that."))
		return

	to_chat(user, span_notice("You cut open the present."))

	for(var/mob/M in src) //Should only be one but whatever.
		M.forceMove(src.loc)

	qdel(src)

/obj/item/a_gift/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/storage/wallet,
		/obj/item/storage/photo_album,
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/backpack/holding,
		/obj/item/storage/belt/champion,
		/obj/item/soap/deluxe,
		/obj/item/pickaxe/silver,
		/obj/item/pen/invisible,
		/obj/item/lipstick/random,
		/obj/item/grenade/smokebomb,
		/obj/item/corncob,
		/obj/item/poster/custom,
		/obj/item/book/manual/barman_recipes,
		/obj/item/book/manual/chef_recipes,
		/obj/item/bikehorn,
		/obj/item/beach_ball,
		/obj/item/beach_ball/holoball,
		/obj/item/toy/balloon,
		/obj/item/toy/blink,
		/obj/item/gun/projectile/revolver/toy/crossbow,
		/obj/item/storage/box/capguntoy,
		/obj/item/toy/katana,
		/obj/item/toy/mecha/deathripley,
		/obj/item/toy/mecha/durand,
		/obj/item/toy/mecha/fireripley,
		/obj/item/toy/mecha/gygax,
		/obj/item/toy/mecha/honk,
		/obj/item/toy/mecha/marauder,
		/obj/item/toy/mecha/mauler,
		/obj/item/toy/mecha/odysseus,
		/obj/item/toy/mecha/phazon,
		/obj/item/toy/mecha/ripley,
		/obj/item/toy/mecha/seraph,
		/obj/item/toy/spinningtoy,
		/obj/item/toy/sword,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris,
		/obj/item/paicard,
		/obj/item/instrument/violin,
		/obj/item/storage/belt/utility/full,
		/obj/item/clothing/accessory/tie/horrible)

	if(!ispath(gift_type,/obj/item))	return

	var/obj/item/I = new gift_type(M)
	M.remove_from_mob(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)
	return

/*
 * Wrapping Paper
 */
/obj/item/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrap_paper"
	var/amount = 20.0
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

/obj/item/wrapping_paper/attackby(obj/item/W as obj, mob/living/user as mob)
	..()
	if (!( locate(/obj/structure/table, src.loc) ))
		to_chat(user, span_warning("You MUST put the paper on a table!"))
	if (W.w_class < ITEMSIZE_LARGE)
		var/obj/item/I = user.get_inactive_hand()
		if(I && I.has_tool_quality(TOOL_WIRECUTTER))
			var/a_used = 2 ** (src.w_class - 1)
			if (src.amount < a_used)
				to_chat(user, span_warning("You need more paper!"))
				return
			else
				if(istype(W, /obj/item/smallDelivery) || istype(W, /obj/item/gift)) //No gift wrapping gifts!
					to_chat(user, span_warning("You can't wrap something that's already wrapped!"))
					return

				src.amount -= a_used
				user.drop_item()
				var/obj/item/gift/G = new /obj/item/gift( src.loc )
				G.size = W.w_class
				G.w_class = G.size + 1
				G.icon_state = text("gift[]", G.size)
				G.gift = W
				W.loc = G
				G.add_fingerprint(user)
				W.add_fingerprint(user)
				src.add_fingerprint(user)
			if (src.amount <= 0)
				new /obj/item/c_tube( src.loc )
				qdel(src)
				return
		else
			to_chat(user, span_warning("You need scissors!"))
	else
		to_chat(user, span_warning("The object is FAR too large!"))
	return


/obj/item/wrapping_paper/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "There is about [src.amount] square units of paper left!"

/obj/item/wrapping_paper/attack(mob/target as mob, mob/user as mob)
	if(!ishuman(target)) return
	var/mob/living/carbon/human/H = target

	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket) || istype(H.wear_suit, /obj/item/clothing/suit/shibari) || H.stat)
		if (src.amount > 2)
			var/obj/effect/spresent/present = new /obj/effect/spresent (H.loc)
			src.amount -= 2

			H.forceMove(present)

			add_attack_logs(user,H,"Wrapped with [src]")
		else
			to_chat(user, span_warning("You need more paper."))
	else
		to_chat(user, "They are moving around too much. A straightjacket would help.")


/obj/item/a_gift/advanced
	name = "present"
	desc = "Its a Christmas present! It has a tag on it that says: 'Chomp staff thank you all for the year that has passed and wish you a merry Christmas and a happy new year. May the new year be good and well for you with many achievements and happy times!'"
	icon_state = "chomp_present"
	item_state = "chomp_present"
	plane = ABOVE_MOB_PLANE
	var/chaos

/obj/item/a_gift/advanced/Initialize(mapload)
	. = ..()
	if(prob(1))
		icon_state = "chomp_present_chaos"
		chaos = TRUE
		name = "chaotic present"
		desc = "The casino dev messed up and gave you the wrong present! This one pulses with potential for good or evil!"

/obj/item/a_gift/advanced/attack_self(mob/M) //WIP - ALWAYS add more items to list! - Jack
	var/gift_type_advanced = pick(
		/obj/item/binoculars/spyglass,
		/obj/item/bodysnatcher,
		/obj/item/cataloguer/advanced,
		/obj/item/flashlight/slime,
		/obj/item/lightreplacer,
		/obj/item/book/tome,
		/obj/item/cell/device/weapon/recharge/alien/hybrid,
		/obj/item/disk/nifsoft/compliance,
		/obj/item/implanter/adrenalin,
		/obj/item/moneybag,
		/obj/item/pickaxe/diamonddrill,
		/obj/item/rcd/advanced/loaded,
		/obj/item/bluespace_harpoon,
		/obj/item/storage/backpack/dufflebag/syndie,
		/obj/item/storage/belt/medical/alien,
		/obj/item/storage/toolbox/syndicate/powertools,
		/obj/item/surgical/FixOVein/alien,
		/obj/item/surgical/bone_clamp/alien,
		/obj/item/surgical/cautery/alien,
		/obj/item/surgical/circular_saw/alien,
		/obj/item/surgical/hemostat/alien,
		/obj/item/surgical/retractor/alien,
		/obj/item/surgical/scalpel/alien,
		/obj/item/surgical/surgicaldrill/alien,
		/obj/item/sword/fluff/joanaria/scisword,
		/obj/item/tool/wrench/alien,
		/obj/item/tool/wirecutters/alien,
		/obj/item/tool/screwdriver/alien,
		/obj/item/tool/crowbar/alien,
		/obj/item/weldingtool/alien,
		/obj/item/twohanded/fireaxe/fluff/mjollnir,
		/obj/item/gun/launcher/confetti_cannon/overdrive,
		/obj/item/gun/energy/sizegun,
		/obj/item/gun/energy/netgun,
		/obj/item/storage/belt/utility/alien,
		/obj/item/clothing/suit/armor/alien,
		/obj/item/reagent_containers/spray/chemsprayer,
		/obj/item/reagent_containers/glass/beaker/bluespace,
		/obj/item/reagent_containers/glass/beaker/noreact,
		/obj/item/storage/box/casino/costume_wizard,
		/obj/item/storage/box/casino/costume_pirate,
		/obj/item/storage/box/casino/costume_commie,
		/obj/item/storage/box/casino/costume_plaguedoctor,
		/obj/item/grenade/spawnergrenade/casino,
		/obj/item/grenade/spawnergrenade/casino/chicken,
		/obj/item/grenade/spawnergrenade/casino/cow,
		/obj/item/grenade/spawnergrenade/casino/corgi,
		/obj/item/grenade/spawnergrenade/casino/fox,
		/obj/item/grenade/spawnergrenade/casino/penguin,
		/obj/item/grenade/spawnergrenade/casino/snake,
		/obj/item/grenade/spawnergrenade/casino/fennec,
		/obj/item/grenade/spawnergrenade/casino/redpanda,
		/obj/item/grenade/spawnergrenade/casino/otie,
		/obj/item/dnainjector/set_trait/nobreathe,
		/obj/item/dnainjector/set_trait/regenerate,
		/obj/item/dnainjector/set_trait/remoteview,
		/obj/item/dnainjector/set_trait/haste,
		/obj/item/dnainjector/set_trait/tk,
		/obj/item/instrument/accordion,
		/obj/item/instrument/banjo,
		/obj/item/instrument/bikehorn,
		/obj/item/instrument/eguitar,
		/obj/item/instrument/glockenspiel,
		/obj/item/instrument/guitar,
		/obj/item/instrument/harmonica,
		/obj/item/instrument/musicalmoth,
		/obj/item/instrument/piano_synth,
		/obj/item/instrument/recorder,
		/obj/item/instrument/saxophone,
		/obj/item/instrument/saxophone/spectral,
		/obj/item/instrument/trombone,
		/obj/item/instrument/trombone/spectral,
		/obj/item/instrument/trumpet,
		/obj/item/instrument/trumpet/spectral,
		/obj/item/instrument/violin,
		/obj/item/instrument/violin/golden,
		/obj/item/instrument/xylophone,
		/obj/item/implantcase/adrenalin,
		/obj/item/implantcase/analyzer,
		/obj/item/implantcase/armblade,
		/obj/item/implantcase/dart,
		/obj/item/implantcase/freedom,
		/obj/item/implantcase/handblade,
		/obj/item/implantcase/language/eal,
		/obj/item/implantcase/laser,
		/obj/item/implantcase/loyalty,
		/obj/item/implantcase/medkit,
		/obj/item/implantcase/restrainingbolt,
		/obj/item/implantcase/shades,
		/obj/item/implantcase/sprinter,
		/obj/item/implantcase/surge,
		/obj/item/implantcase/sword,
		/obj/item/implantcase/taser,
		/obj/item/implantcase/toolkit,
		/obj/item/implantcase/vrlanguage,
		/obj/item/implanter/sizecontrol,
		/obj/item/grenade/spawnergrenade/casino/gygax/mining,
		/obj/item/grenade/spawnergrenade/casino/gygax/firefighter,
		/obj/item/grenade/spawnergrenade/casino/gygax/Odysseus,
		/obj/item/rig/bayeng,
		/obj/item/rig/baymed,
		/obj/item/rig/ce,
		/obj/item/rig/combat,
		/obj/item/rig/ert/janitor,
		/obj/item/rig/industrial,
		/obj/item/rig/internalaffairs,
		/obj/item/rig/medical) //Below here is items that need to be upported.
		/*
		/obj/item/lego,
		/obj/item/clothing/glasses/monocoole,
		/obj/item/rig/ch/pursuit,
		/obj/item/instrument/keytar,
		/obj/item/grenade/spawnergrenade/casino/gygax/shuttlecraft,
		/obj/item/grenade/spawnergrenade/casino/gygax/scree,
		/obj/item/grenade/spawnergrenade/casino/gygax/janus,
		/obj/item/grenade/spawnergrenade/casino/gygax/scarab,
		/obj/item/grenade/spawnergrenade/casino/gygax/shuttlepod,
		/obj/item/grenade/spawnergrenade/casino/gygax/serenity,
		/obj/item/dnainjector/set_trait/xray,
		/obj/item/lego,
		/obj/item/grenade/spawnergrenade/casino/otie/chubby,
		/obj/item/grenade/spawnergrenade/casino/zorgoia,
		/obj/item/grenade/spawnergrenade/casino/gygax,
		/obj/item/grenade/spawnergrenade/casino/horse,
		/obj/item/grenade/spawnergrenade/casino/yithian,
		/obj/item/grenade/spawnergrenade/casino/tindalos,
		/obj/item/grenade/spawnergrenade/casino/lizard,
		/obj/item/grenade/spawnergrenade/casino/goat,
		/obj/item/grenade/spawnergrenade/casino/armadillo,
		/obj/item/grenade/spawnergrenade/casino/cat,
		/obj/item/storage/box/casino/costume_cutewitch,
		/obj/item/storage/box/casino/costume_imperiummonk,
		/obj/item/storage/box/casino/costume_chicken,
		/obj/item/storage/box/casino/costume_gladiator,
		/obj/item/storage/box/casino/costume_whitebunny,
		/obj/item/storage/box/casino/costume_blackbunny,
		/obj/item/storage/box/casino/costume_sexymime,
		/obj/item/storage/box/casino/costume_sexyclown,
		/obj/item/storage/box/casino/costume_nyangirl)
		*/


	var/gift_type_chaos = pick(
		/obj/item/dnainjector/set_trait/hulk,
		/obj/item/spellbook,
		/obj/item/book/tome/imbued) //Below here is items that need to be upported.
	/*
		/obj/item/grenade/spawnergrenade/casino/infinitycake,
		/obj/item/grenade/spawnergrenade/casino/universal_technomancer,
		/obj/item/grenade/spawnergrenade/casino/gygax/gorilla,
	*/

	var/obj/item/I = null


	if(chaos)
		if(!ispath(gift_type_chaos,/obj/item))	return
		I = new gift_type_chaos(M)

	else
		if(!ispath(gift_type_advanced,/obj/item))	return
		I = new gift_type_advanced(M)

	M.remove_from_mob(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)

	qdel(src)
	return
