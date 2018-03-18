#define PER_LIMB_STEEL_COST SHEET_MATERIAL_AMOUNT
////
//  One-part Refactor
////
/mob/living/carbon/human/proc/nano_partswap()
	set name = "Ref - Single Limb"
	set desc = "Allows you to replace and reshape your limbs as you see fit."
	set category = "Abilities"
	set hidden = TRUE

	if(stat)
		to_chat(src,"<span class='warning'>You must be awake and standing to perform this action!</span>")
		return

	var/obj/item/organ/internal/nano/refactory/refactory = locate() in internal_organs
	if(!refactory || refactory.status & ORGAN_DEAD)
		to_chat(src,"<span class='warning'>You don't have a refactory module!</span>")
		return

	var/choice = input(src,"Pick the bodypart to change:", "Refactor - One Bodypart") as null|anything in species.has_limbs
	if(!choice)
		return

	//Organ is missing, needs restoring
	if(!organs_by_name[choice])
		if(refactory.get_stored_material(DEFAULT_WALL_MATERIAL) < PER_LIMB_STEEL_COST)
			to_chat(src,"<span class='warning'>You're missing that limb, and need to store at least [PER_LIMB_STEEL_COST] steel to regenerate it.</span>")
			return
		var/regen = alert(src,"That limb is missing, do you want to regenerate it in exchange for [PER_LIMB_STEEL_COST] steel?","Regenerate limb?","Yes","No")
		if(regen != "Yes")
			return
		if(!refactory.use_stored_material(DEFAULT_WALL_MATERIAL,PER_LIMB_STEEL_COST))
			return

		var/mob/living/simple_animal/protean_blob/blob = nano_intoblob()
		active_regen = TRUE
		if(do_after(blob,5 SECONDS))
			var/list/limblist = species.has_limbs[choice]
			var/limbpath = limblist["path"]
			var/obj/item/organ/external/new_eo = new limbpath(src)
			organs_by_name[choice] = new_eo
			new_eo.robotize(synthetic ? synthetic.company : null) //Use the base we started with
			regenerate_icons()
		active_regen = FALSE
		nano_outofblob(blob)
		return

	//Organ exists, let's reshape it
	var/list/usable_manufacturers = list()
	for(var/company in chargen_robolimbs)
		var/datum/robolimb/M = chargen_robolimbs[company]
		if(!(choice in M.parts))
			continue
		if(species.name in M.species_cannot_use)
			continue
		if(M.whitelisted_to && !(ckey in M.whitelisted_to))
			continue
		usable_manufacturers[company] = M
	if(!usable_manufacturers.len)
		return
	var/manu_choice = input(src, "Which manufacturer do you wish to mimmic for this limb?", "Manufacturer for [choice]") as null|anything in usable_manufacturers

	if(!manu_choice)
		return //Changed mind

	var/obj/item/organ/external/eo = organs_by_name[choice]
	if(!eo)
		return //Lost it meanwhile

	eo.robotize(manu_choice)
	visible_message("<B>[src]</B>'s ")
	update_icons_body()
#undef PER_LIMB_STEEL_COST

////
//  Full Refactor
////
/mob/living/carbon/human/proc/nano_regenerate()
	set name = "Ref - Whole Body"
	set desc = "Allows you to regrow limbs and replace organs, given you have enough materials."
	set category = "Abilities"
	set hidden = TRUE

	if(stat)
		to_chat(src,"<span class='warning'>You must be awake and standing to perform this action!</span>")
		return

	var/obj/item/organ/internal/nano/refactory/refactory = locate() in internal_organs
	//Missing the organ that does this
	if(!istype(refactory))
		to_chat(src,"<span class='warning'>You don't have a refactory module!</span>")
		return

	//Already regenerating
	if(active_regen)
		to_chat(src, "<span class='warning'>You are already refactoring!</span>")
		return

	var/swap_not_rebuild = alert(src,"Do you want to rebuild, or reshape?","Rebuild or Reshape","Rebuild","Cancel","Reshape")
	if(swap_not_rebuild == "Cancel")
		return
	if(swap_not_rebuild == "Reshape")
		var/list/usable_manufacturers = list()
		for(var/company in chargen_robolimbs)
			var/datum/robolimb/M = chargen_robolimbs[company]
			if(!(BP_TORSO in M.parts))
				continue
			if(species.name in M.species_cannot_use)
				continue
			if(M.whitelisted_to && !(ckey in M.whitelisted_to))
				continue
			usable_manufacturers[company] = M
		if(!usable_manufacturers.len)
			return
		var/manu_choice = input(src, "Which manufacturer do you wish to mimmic?", "Manufacturer") as null|anything in usable_manufacturers

		if(!manu_choice)
			return //Changed mind
		if(!organs_by_name[BP_TORSO])
			return //Ain't got a torso!

		var/obj/item/organ/external/torso = organs_by_name[BP_TORSO]
		to_chat(src, "<span class='danger'>Remain still while the process takes place! It will take 5 seconds.</span>")
		visible_message("<B>[src]</B>'s form collapses into an amorphous blob of black ichor...")
		
		var/mob/living/simple_animal/protean_blob/blob = nano_intoblob()
		active_regen = TRUE
		if(do_after(blob,5 SECONDS))
			synthetic = usable_manufacturers[manu_choice]
			torso.robotize(manu_choice) //Will cascade to all other organs.
			regenerate_icons()
			visible_message("<B>[src]</B>'s form reshapes into a new one...")
		active_regen = FALSE
		nano_outofblob(blob)
		return

	//Not enough resources (AND spends the resources, should be the last check)
	if(!refactory.use_stored_material(DEFAULT_WALL_MATERIAL,refactory.max_storage))
		to_chat(src, "<span class='warning'>You need to be maxed out on normal metal to do this!</span>")
		return

	var/delay_length = round(active_regen_delay * species.active_regen_mult)
	to_chat(src, "<span class='danger'>Remain still while the process takes place! It will take [delay_length/10] seconds.</span>")
	visible_message("<B>[src]</B>'s form begins to shift and ripple as if made of oil...")
	active_regen = TRUE

	nano_intoblob()
	if(do_after(src,delay_length))
		if(stat != DEAD && refactory)
			var/list/holder = refactory.materials
			species.create_organs(src)
			var/obj/item/organ/external/torso = organs_by_name[BP_TORSO]
			torso.robotize(synthetic.company)
			LAZYCLEARLIST(blood_DNA)
			LAZYCLEARLIST(feet_blood_DNA)
			blood_color = null
			feet_blood_color = null
			regenerate_icons() //Probably worth it, yeah.
			var/obj/item/organ/internal/nano/refactory/new_refactory = locate() in internal_organs
			if(!new_refactory)
				log_debug("[src] protean-regen'd but lacked a refactory when done.")
			else
				new_refactory.materials = holder
			to_chat(src, "<span class='notice'>Your refactoring is complete!</span>")
	else
		to_chat(src, "<span class='critical'>Your refactoring is interrupted!</span>")
	nano_outofblob()


////
//  Storing metal
////
/mob/living/carbon/human/proc/nano_metalnom()
	set name = "Ref - Store Metals"
	set desc = "If you're holding a stack of material, you can consume some and store it for later."
	set category = "Abilities"
	set hidden = TRUE

	var/obj/item/organ/internal/nano/refactory/refactory = locate() in internal_organs
	//Missing the organ that does this
	if(!istype(refactory))
		to_chat(src,"<span class='warning'>You don't have a refactory module!</span>")
		return

	var/held = get_active_hand()
	if(!istype(held,/obj/item/stack/material))
		to_chat(src,"<span class='warning'>You aren't holding a stack of materials in your active hand...!</span>")
		return

	var/obj/item/stack/material/matstack = held
	var/howmuch = input(src,"How much do you want to store? (0-[matstack.amount])","Select amount") as null|num
	if(!howmuch || matstack != get_active_hand() || howmuch > matstack.amount)
		return //Quietly fail

	var/substance = matstack.material.name
	var/actually_added = refactory.add_stored_material(substance,howmuch*matstack.perunit)
	matstack.use(Ceiling(actually_added/matstack.perunit))
	if(actually_added < howmuch)
		to_chat(src,"<span class='warning'>Your refactory module is now full, so only [actually_added] units were stored.</span>")
	else
		to_chat(src,"<span class='notice'>You store [actually_added] units of [substance].</span>")

////
//  Blob Form
////
/mob/living/carbon/human/proc/nano_blobform()
	set name = "Become Amorphous"
	set desc = "Drop your shape and assume a more natural form."
	set category = "Abilities"
	set hidden = TRUE

	if(stat)
		to_chat(src,"<span class='warning'>You must be awake and standing to perform this action!</span>")
		return

	nano_intoblob()

////
//  Change fitting
////

/mob/living/carbon/human/proc/nano_change_fitting()
	set name = "Change Species Fit"
	set desc = "Tweak your shape to change what suits you fit into (and their sprites!)."
	set category = "Abilities"

	if(stat)
		to_chat(src,"<span class='warning'>You must be awake and standing to perform this action!</span>")
		return
	
	var/new_species = input("Please select a species to emulate.", "Shapeshifter Body") as null|anything in playable_species
	if(new_species)
		impersonate_bodytype = new_species
		regenerate_icons()

/// /// /// Ability objects for stat panel
/obj/effect/protean_ability
	name = "Activate"
	desc = ""
	icon = 'icons/mob/species/protean/protean_powers.dmi'
	var/ability_name
	var/to_call

/obj/effect/protean_ability/proc/atom_button_text()
	return src

/obj/effect/protean_ability/Click(var/location, var/control, var/params)
	var/list/clickprops = params2list(params)
	var/opts = clickprops["shift"]

	if(opts)
		to_chat(usr,"<span class='notice'><b>[ability_name]</b> - [desc]</span>")
	else
		do_ability(usr)

/obj/effect/protean_ability/proc/do_ability(var/mob/living/carbon/human/H)
	if(istype(H) && !H.stat)
		call(H,to_call)()
	return FALSE

/// The actual abilities
/obj/effect/protean_ability/into_blob
	ability_name = "Become Amorphous"
	desc = "Discard your shape entirely, changing to a low-energy blob that can fit into small spaces. You'll consume steel to repair yourself in this form."
	icon_state = "blob"
	to_call = /mob/living/carbon/human/proc/nano_blobform

/obj/effect/protean_ability/reform_limb
	ability_name = "Ref - Single Limb"
	desc = "Rebuild or replace a single limb, assuming you have 2000 steel."
	icon_state = "limb"
	to_call = /mob/living/carbon/human/proc/nano_partswap
	
/obj/effect/protean_ability/reform_body
	ability_name = "Ref - Whole Body"
	desc = "Rebuild your entire body into whatever design you want, assuming you have 10,000 metal."
	icon_state = "body"
	to_call = /mob/living/carbon/human/proc/nano_regenerate

/obj/effect/protean_ability/metal_nom
	ability_name = "Ref - Store Metals"
	desc = "Store the metal you're holding. Your refactory can only store steel, and all other metals will be converted into nanites ASAP for various effects."
	icon_state = "metal"
	to_call = /mob/living/carbon/human/proc/nano_metalnom
