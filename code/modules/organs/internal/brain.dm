GLOBAL_LIST_BOILERPLATE(all_brain_organs, /obj/item/organ/internal/brain)

/obj/item/organ/internal/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs. Is this even used by organ code anymore?
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = "brain"
	parent_organ = BP_HEAD
	vital = 1
	icon_state = "brain2"
	force = 1.0
	w_class = ITEMSIZE_SMALL
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	var/clone_source = FALSE
	var/mob/living/carbon/brain/brainmob = null
	var/can_assist = TRUE
	var/defib_timer = -1

/obj/item/organ/internal/brain/process()
	..()
	if(owner && owner.stat != DEAD) // So there's a lower risk of ticking twice.
		tick_defib_timer()

// This is called by `process()` when the owner is alive, or brain is not in a body, and by `Life()` directly when dead.
/obj/item/organ/internal/brain/proc/tick_defib_timer()
	if(preserved) // In an MMI/ice box/etc.
		return

	if(!owner || owner.stat == DEAD)
		defib_timer = max(--defib_timer, 0)
	else
		defib_timer = min(++defib_timer, (config.defib_timer MINUTES) / 20)		// Time vars measure things in ticks. Life tick happens every ~2 seconds, therefore dividing by 20

/obj/item/organ/internal/brain/proc/can_assist()
	return can_assist

/obj/item/organ/internal/brain/proc/implant_assist(var/targ_icon_state = null)
	name = "[owner.real_name]'s assisted [initial(name)]"
	if(targ_icon_state)
		icon_state = targ_icon_state
		if(dead_icon)
			dead_icon = "[targ_icon_state]_dead"
	else
		icon_state = "[initial(icon_state)]_assisted"
	if(dead_icon)
		dead_icon = "[initial(dead_icon)]_assisted"

/obj/item/organ/internal/brain/robotize()
	replace_self_with(/obj/item/organ/internal/mmi_holder/posibrain)

/obj/item/organ/internal/brain/mechassist()
	replace_self_with(/obj/item/organ/internal/mmi_holder)

/obj/item/organ/internal/brain/digitize()
	replace_self_with(/obj/item/organ/internal/mmi_holder/robot)

/obj/item/organ/internal/brain/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Bacterial meningitis (more of a spine thing but 'brain infection' isn't a common thing)
	if (. >= 1)
		if(prob(1))
			owner.custom_pain("Your neck aches, and feels very stiff!",0)
	if (. >= 2)
		if(prob(1))
			owner.custom_pain("Your feel very dizzy for a moment!",0)
			owner.Confuse(2)

/obj/item/organ/internal/brain/proc/replace_self_with(replace_path)
	var/mob/living/carbon/human/tmp_owner = owner
	qdel(src)
	if(tmp_owner)
		tmp_owner.internal_organs_by_name[organ_tag] = new replace_path(tmp_owner, 1)
		tmp_owner = null

/obj/item/organ/internal/brain/New()
	..()
	health = config.default_brain_health
	defib_timer = (config.defib_timer MINUTES) / 20				// Time vars measure things in ticks. Life tick happens every ~2 seconds, therefore dividing by 20
	spawn(5)
		if(brainmob)
			butcherable = FALSE

			if(brainmob.client)
				brainmob.client.screen.len = null //clear the hud

/obj/item/organ/internal/brain/Destroy()
	QDEL_NULL(brainmob)
	. = ..()

/obj/item/organ/internal/brain/proc/transfer_identity(var/mob/living/carbon/H)

	if(!brainmob)
		brainmob = new(src)
		brainmob.name = H.real_name
		brainmob.real_name = H.real_name

		if(istype(H))
			brainmob.dna = H.dna.Clone()
			brainmob.timeofhostdeath = H.timeofdeath
			brainmob.ooc_notes = H.ooc_notes //VOREStation Edit

		// Copy modifiers.
		for(var/datum/modifier/M in H.modifiers)
			if(M.flags & MODIFIER_GENETIC)
				brainmob.add_modifier(M.type)

	if(H.mind)
		H.mind.transfer_to(brainmob)

	brainmob.languages = H.languages

	to_chat(brainmob, "<span class='notice'>You feel slightly disoriented. That's normal when you're just \a [initial(src.name)].</span>")
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/brain/examine(mob/user) // -- TLE
	. = ..()
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		. += "You can feel the small spark of life still left in this one."
	else
		. += "This one seems particularly lifeless. Perhaps it will regain some of its luster later..."

/obj/item/organ/internal/brain/removed(var/mob/living/user)

	if(name == initial(name))
		name = "\the [owner.real_name]'s [initial(name)]"

	var/mob/living/simple_mob/animal/borer/borer = owner?.has_brain_worms()

	if(borer)
		borer.detatch() //Should remove borer if the brain is removed - RR

	var/obj/item/organ/internal/brain/B = src
	if(istype(B) && owner)
		if(istype(owner, /mob/living/carbon))
			B.transfer_identity(owner)

	..()

/obj/item/organ/internal/brain/replaced(var/mob/living/target)

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key
	..()

/obj/item/organ/internal/brain/proc/get_control_efficiency()
	. = max(0, 1 - (round(damage / max_damage * 10) / 10))

	return .

/obj/item/organ/internal/brain/pariah_brain
	name = "brain remnants"
	desc = "Did someone tread on this? It looks useless for cloning or cyborgification."
	organ_tag = "brain"
	parent_organ = BP_HEAD
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	vital = 1
	can_assist = FALSE

/obj/item/organ/internal/brain/xeno
	name = "thinkpan"
	desc = "It looks kind of like an enormous wad of purple bubblegum."
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	can_assist = FALSE

/obj/item/organ/internal/brain/slime
	icon = 'icons/obj/surgery_vr.dmi' // Vorestation edit
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	icon_state = "core"
	decays = FALSE
	parent_organ = BP_TORSO
	clone_source = TRUE
	atom_flags = ATOM_REAGENTS_IS_OPEN
	var/list/owner_flavor_text = list()

/obj/item/organ/internal/brain/slime/is_open_container()
	return 1

/obj/item/organ/internal/brain/slime/New()
	..()
	create_reagents(50)
	var/mob/living/carbon/human/H = null
	spawn(15) //Match the core to the Promethean's starting color.
		if(ishuman(owner))
			H = owner
			color = rgb(min(H.r_skin + 40, 255), min(H.g_skin + 40, 255), min(H.b_skin + 40, 255))

/obj/item/organ/internal/brain/slime/removed(var/mob/living/user)
	if(istype(owner))
		owner_flavor_text = owner.flavor_texts.Copy()
	..()

/obj/item/organ/internal/brain/slime/proc/reviveBody()
	var/datum/dna2/record/R = new /datum/dna2/record()
	R.dna = brainmob.dna
	R.ckey = brainmob.ckey
	R.id = copytext(md5(brainmob.real_name), 2, 6)
	R.name = R.dna.real_name
	R.types = DNA2_BUF_UI|DNA2_BUF_UE|DNA2_BUF_SE
	R.languages = brainmob.languages
	R.flavor = list()
	if(islist(owner_flavor_text))
		R.flavor = owner_flavor_text.Copy()
	for(var/datum/modifier/mod in brainmob.modifiers)
		if(mod.flags & MODIFIER_GENETIC)
			R.genetic_modifiers.Add(mod.type)

	var/datum/mind/clonemind = brainmob.mind

	if(!istype(clonemind, /datum/mind))	//not a mind
		return 0
	if(clonemind.current && clonemind.current.stat != DEAD)	//mind is associated with a non-dead body
		return 0
	if(clonemind.active)	//somebody is using that mind
		if(ckey(clonemind.key) != R.ckey)
			return 0
	else
		for(var/mob/observer/dead/G in player_list)
			if(G.ckey == R.ckey)
				if(G.can_reenter_corpse)
					break
				else
					return 0

	for(var/modifier_type in R.genetic_modifiers)	//Can't be revived. Probably won't happen...?
		if(ispath(modifier_type, /datum/modifier/no_clone))
			return 0

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(get_turf(src), R.dna.species)

	if(!R.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	else
		H.dna = R.dna

	H.UpdateAppearance()
	H.sync_organ_dna()
	if(!R.dna.real_name)	//to prevent null names
		R.dna.real_name = "promethean ([rand(0,999)])"
	H.real_name = R.dna.real_name
	H.ooc_notes = brainmob.ooc_notes // VOREStation Edit

	H.nutrition = 260 //Enough to try to regenerate ONCE.
	H.adjustBruteLoss(40)
	H.adjustFireLoss(40)
	H.Paralyse(4)
	H.updatehealth()
	for(var/obj/item/organ/external/E in H.organs) //They've still gotta congeal, but it's faster than the clone sickness they'd normally get.
		if(E && E.organ_tag == BP_L_ARM || E.organ_tag == BP_R_ARM || E.organ_tag == BP_L_LEG || E.organ_tag == BP_R_LEG)
			E.removed()
			qdel(E)
			E = null
	H.regenerate_icons()
	clonemind.transfer_to(H)
	for(var/modifier_type in R.genetic_modifiers)
		H.add_modifier(modifier_type)

	for(var/datum/language/L in R.languages)
		H.add_language(L.name)
	H.flavor_texts = R.flavor.Copy()
	qdel(src)
	return 1

/decl/chemical_reaction/instant/promethean_brain_revival
	name = "Promethean Revival"
	id = "prom_revival"
	result = null
	required_reagents = list("phoron" = 40)
	result_amount = 1

/decl/chemical_reaction/instant/promethean_brain_revival/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/organ/internal/brain/slime))
		return ..()
	return FALSE

/decl/chemical_reaction/instant/promethean_brain_revival/on_reaction(var/datum/reagents/holder)
	var/obj/item/organ/internal/brain/slime/brain = holder.my_atom
	if(brain.reviveBody())
		brain.visible_message("<span class='notice'>[brain] bubbles, surrounding itself with a rapidly expanding mass of slime!</span>")
	else
		brain.visible_message("<span class='warning'>[brain] shifts strangely, but falls still.</span>")

/obj/item/organ/internal/brain/golem
	name = "chem"
	desc = "A tightly furled roll of paper, covered with indecipherable runes."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	can_assist = FALSE

/obj/item/organ/internal/brain/grey
	desc = "A piece of juicy meat found in a person's head. This one is strange."
	icon_state = "brain_grey"

/obj/item/organ/internal/brain/grey/colormatch/New()
	..()
	var/mob/living/carbon/human/H = null
	spawn(15)
		if(ishuman(owner))
			H = owner
			color = H.species.blood_color
