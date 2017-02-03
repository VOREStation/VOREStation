/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes.
 *
 *		For syndicate call-ins see uplink_kits.dm
 */

/obj/item/weapon/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon_state = "box"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")
	var/foldable = /obj/item/stack/material/cardboard	// BubbleWrap - if set, can be folded (when empty) into a sheet of cardboard
	max_w_class = ITEMSIZE_SMALL
	max_storage_space = INVENTORY_BOX_SPACE

// BubbleWrap - A box can be folded up to make card
/obj/item/weapon/storage/box/attack_self(mob/user as mob)
	if(..()) return

	//try to fold it.
	if ( contents.len )
		return

	if ( !ispath(foldable) )
		return
	var/found = 0
	// Close any open UI windows first
	for(var/mob/M in range(1))
		if (M.s_active == src)
			close(M)
		if ( M == user )
			found = 1
	if ( !found )	// User is too far away
		return
	// Now make the cardboard
	user << "<span class='notice'>You fold [src] flat.</span>"
	new foldable(get_turf(src))
	qdel(src)

/obj/item/weapon/storage/box/survival/New()
	..()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency/oxygen(src)

/obj/item/weapon/storage/box/vox/New()
	..()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency/phoron(src)

/obj/item/weapon/storage/box/engineer/New()
	..()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/tank/emergency/oxygen/engi(src)

/obj/item/weapon/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains white gloves."
	icon_state = "latex"

/obj/item/weapon/storage/box/gloves/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/clothing/gloves/latex(src)

/obj/item/weapon/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"

/obj/item/weapon/storage/box/masks/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/clothing/mask/surgical(src)

/obj/item/weapon/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	icon_state = "syringe"

/obj/item/weapon/storage/box/syringes/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/syringe(src)

/obj/item/weapon/storage/box/syringegun
	name = "box of syringe gun cartridges"
	desc = "A box full of compressed gas cartridges."
	icon_state = "syringe"

/obj/item/weapon/storage/box/syringegun/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/syringe_cartridge(src)

/obj/item/weapon/storage/box/beakers
	name = "box of beakers"
	icon_state = "beaker"

/obj/item/weapon/storage/box/beakers/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/glass/beaker(src)

/obj/item/weapon/storage/box/injectors
	name = "box of DNA injectors"
	desc = "This box contains injectors it seems."

/obj/item/weapon/storage/box/injectors/New()
	..()
	for(var/i = 1 to 3)
		new /obj/item/weapon/dnainjector/h2m(src)
	for(var/i = 1 to 3)
		new /obj/item/weapon/dnainjector/m2h(src)

/obj/item/weapon/storage/box/blanks
	name = "box of blank shells"
	desc = "It has a picture of a gun and several warning symbols on the front."
	icon_state = "blankshot_box"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/blanks/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/blank(src)

/obj/item/weapon/storage/box/blanks/large/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/blank(src)

/obj/item/weapon/storage/box/beanbags
	name = "box of beanbag shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "beanshot_box"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/beanbags/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/weapon/storage/box/beanbags/large/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/beanbag(src)

/obj/item/weapon/storage/box/shotgunammo
	name = "box of shotgun slugs"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "lethalshellshot_box"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/shotgunammo/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun(src)

/obj/item/weapon/storage/box/shotgunammo/large/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun(src)

/obj/item/weapon/storage/box/shotgunshells
	name = "box of shotgun shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "lethalslug_box"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/shotgunshells/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/pellet(src)

/obj/item/weapon/storage/box/shotgunshells/large/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/pellet(src)

/obj/item/weapon/storage/box/flashshells
	name = "box of illumination shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "illumshot_box"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/flashshells/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/flash(src)

/obj/item/weapon/storage/box/flashshells/large/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/flash(src)

/obj/item/weapon/storage/box/stunshells
	name = "box of stun shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "stunshot_box"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/stunshells/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/stunshell(src)

/obj/item/weapon/storage/box/stunshells/large/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/stunshell(src)

/obj/item/weapon/storage/box/practiceshells
	name = "box of practice shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "blankshot_box"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/practiceshells/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/practice(src)

/obj/item/weapon/storage/box/practiceshells/large/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/practice(src)

/obj/item/weapon/storage/box/empshells
	name = "box of emp shells"
	desc = "It has a picture of a gun and several warning symbols on the front."
	icon_state = "empshot_box"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/empshells/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/emp(src)

/obj/item/weapon/storage/box/empshells/large/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/ammo_casing/shotgun/emp(src)

/obj/item/weapon/storage/box/sniperammo
	name = "box of 14.5mm shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

/obj/item/weapon/storage/box/sniperammo/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/ammo_casing/a145(src)

/obj/item/weapon/storage/box/flashbangs
	name = "box of flashbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use.</B>"
	icon_state = "flashbang"

/obj/item/weapon/storage/box/flashbangs/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/grenade/flashbang(src)

/obj/item/weapon/storage/box/emps
	name = "box of emp grenades"
	desc = "A box containing 5 military grade EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "emp"

/obj/item/weapon/storage/box/emps/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/grenade/empgrenade(src)

/obj/item/weapon/storage/box/empslite
	name = "box of low yield emp grenades"
	desc = "A box containing 5 low yield EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "emp"

/obj/item/weapon/storage/box/empslite/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/grenade/empgrenade/low_yield(src)

/obj/item/weapon/storage/box/smokes
	name = "box of smoke bombs"
	desc = "A box containing 7 smoke bombs."
	icon_state = "flashbang"

/obj/item/weapon/storage/box/smokes/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/grenade/smokebomb(src)

/obj/item/weapon/storage/box/anti_photons
	name = "box of anti-photon grenades"
	desc = "A box containing 7 experimental photon disruption grenades."
	icon_state = "flashbang"

/obj/item/weapon/storage/box/anti_photons/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/grenade/anti_photon(src)

/obj/item/weapon/storage/box/frags
	name = "box of fragmentation grenades (WARNING)"
	desc = "A box containing 7 military grade fragmentation grenades.<br> WARNING: These devices are extremely dangerous and can cause limb loss or death in repeated use."
	icon_state = "frag"

/obj/item/weapon/storage/box/frags/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/grenade/explosive(src)

/obj/item/weapon/storage/box/frags_half_box
	name = "box of fragmentation grenades (WARNING)"
	desc = "A box containing 4 military grade fragmentation grenades.<br> WARNING: These devices are extremely dangerous and can cause limb loss or death in repeated use."
	icon_state = "frag"

/obj/item/weapon/storage/box/frags_half_box/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/grenade/explosive(src)

/obj/item/weapon/storage/box/metalfoam
	name = "box of metal foam grenades."
	desc = "A box containing 7 metal foam grenades."
	icon_state = "flashbang"

/obj/item/weapon/storage/box/metalfoam/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/grenade/chem_grenade/metalfoam(src)

/obj/item/weapon/storage/box/teargas
	name = "box of teargas grenades"
	desc = "A box containing 7 teargas grenades."
	icon_state = "flashbang"

/obj/item/weapon/storage/box/teargas/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/grenade/chem_grenade/teargas(src)

/obj/item/weapon/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"

/obj/item/weapon/storage/box/trackimp/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/implantcase/tracking(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)
	new /obj/item/weapon/locator(src)

/obj/item/weapon/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"

/obj/item/weapon/storage/box/chemimp/New()
	..()
	for(var/i = 1 to 5)
		new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)

/obj/item/weapon/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"

/obj/item/weapon/storage/box/rxglasses/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/clothing/glasses/regular(src)

/obj/item/weapon/storage/box/cdeathalarm_kit
	name = "death alarm kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/cdeathalarm_kit/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/implantcase/death_alarm(src)
	new /obj/item/weapon/implanter(src)

/obj/item/weapon/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."

/obj/item/weapon/storage/box/condimentbottles/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/food/condiment(src)

/obj/item/weapon/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."

/obj/item/weapon/storage/box/cups/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src)

/obj/item/weapon/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"

/obj/item/weapon/storage/box/donkpockets/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/food/snacks/donkpocket(src)

/obj/item/weapon/storage/box/sinpockets
	name = "box of sin-pockets"
	desc = "<B>Instructions:</B> <I>Crush bottom of package to initiate chemical heating. Wait for 20 seconds before consumption. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"

/obj/item/weapon/storage/box/sinpockets/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket(src)

/obj/item/weapon/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube)

/obj/item/weapon/storage/box/monkeycubes/New()
	..()
	if(type == /obj/item/weapon/storage/box/monkeycubes)
		for(var/i = 1 to 4)
			new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped(src)

/obj/item/weapon/storage/box/monkeycubes/farwacubes
	name = "farwa cube box"
	desc = "Drymate brand farwa cubes, shipped from Meralar. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/farwacubes/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube(src)

/obj/item/weapon/storage/box/monkeycubes/stokcubes
	name = "stok cube box"
	desc = "Drymate brand stok cubes, shipped from Moghes. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/stokcubes/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube(src)

/obj/item/weapon/storage/box/monkeycubes/neaeracubes
	name = "neaera cube box"
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/neaeracubes/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube(src)

/obj/item/weapon/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"

/obj/item/weapon/storage/box/ids/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/card/id(src)

/obj/item/weapon/storage/box/seccarts
	name = "box of spare R.O.B.U.S.T. Cartridges"
	desc = "A box full of R.O.B.U.S.T. Cartridges, used by Security."
	icon_state = "pda"

/obj/item/weapon/storage/box/seccarts/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/cartridge/security(src)

/obj/item/weapon/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"

/obj/item/weapon/storage/box/handcuffs/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/handcuffs(src)

/obj/item/weapon/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"

/obj/item/weapon/storage/box/mousetraps/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/device/assembly/mousetrap(src)

/obj/item/weapon/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."

/obj/item/weapon/storage/box/pillbottles/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/storage/pill_bottle(src)

/obj/item/weapon/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	can_hold = list(/obj/item/toy/snappop)

/obj/item/weapon/storage/box/snappops/New()
	..()
	for(var/i = 1 to 8)
		new /obj/item/toy/snappop(src)

/obj/item/weapon/storage/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/weapon/flame/match)

/obj/item/weapon/storage/box/matches/New()
	..()
	for(var/i=1 to 10)
		new /obj/item/weapon/flame/match(src)

/obj/item/weapon/storage/box/matches/attackby(obj/item/weapon/flame/match/W as obj, mob/user as mob)
	if(istype(W) && !W.lit && !W.burnt)
		W.lit = 1
		W.damtype = "burn"
		W.icon_state = "match_lit"
		processing_objects.Add(W)
	W.update_icon()
	return

/obj/item/weapon/storage/box/autoinjectors
	name = "box of injectors"
	desc = "Contains autoinjectors."
	icon_state = "syringe"

/obj/item/weapon/storage/box/autoinjectors/New()
	..()
	for (var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector(src)

/obj/item/weapon/storage/box/lights
	name = "box of replacement bulbs"
	icon = 'icons/obj/storage.dmi'
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")
	storage_slots = 24
	can_hold = list(/obj/item/weapon/light/tube, /obj/item/weapon/light/bulb)
	max_storage_space = ITEMSIZE_COST_SMALL * 24 //holds 24 items of w_class 2
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/obj/item/weapon/storage/box/lights/bulbs/New()
	..()
	for(var/i = 1 to 24)
		new /obj/item/weapon/light/bulb(src)

/obj/item/weapon/storage/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"

/obj/item/weapon/storage/box/lights/tubes/New()
	..()
	for(var/i = 1 to 24)
		new /obj/item/weapon/light/tube(src)

/obj/item/weapon/storage/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"

/obj/item/weapon/storage/box/lights/mixed/New()
	..()
	for(var/i = 1 to 16)
		new /obj/item/weapon/light/tube(src)
	for(var/i = 1 to 8)
		new /obj/item/weapon/light/bulb(src)

/obj/item/weapon/storage/box/freezer
	name = "portable freezer"
	desc = "This nifty shock-resistant device will keep your 'groceries' nice and non-spoiled."
	icon = 'icons/obj/storage.dmi'
	icon_state = "portafreezer"
	item_state_slots = list(slot_r_hand_str = "medicalpack", slot_l_hand_str = "medicalpack")
	foldable = null
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/organ, /obj/item/weapon/reagent_containers/food, /obj/item/weapon/reagent_containers/glass)
	max_storage_space = ITEMSIZE_COST_NORMAL * 5 // Formally 21.  Odd numbers are bad.
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/obj/item/weapon/storage/box/freezer/Entered(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 1
		for(var/obj/item/organ/organ in O)
			organ.preserved = 1
	..()

/obj/item/weapon/storage/box/freezer/Exited(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 0
		for(var/obj/item/organ/organ in O)
			organ.preserved = 0
	..()

/obj/item/weapon/storage/box/ambrosia
	name = "ambrosia seeds box"
	desc = "Contains the seeds you need to get a little high."

/obj/item/weapon/storage/box/ambrosia/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/seeds/ambrosiavulgarisseed(src)

/obj/item/weapon/storage/box/ambrosiadeus
	name = "ambrosia deus seeds box"
	desc = "Contains the seeds you need to get a proper healthy high."

/obj/item/weapon/storage/box/ambrosiadeus/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/seeds/ambrosiadeusseed(src)
