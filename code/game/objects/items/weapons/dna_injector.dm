/obj/item/dnainjector
	name = "\improper DNA injector"
	desc = "This injects the person with DNA."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"
	var/block=0
	var/datum/dna2/record/buf=null
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/uses = 1
	var/nofail

	// USE ONLY IN PREMADE SYRINGES.  WILL NOT WORK OTHERWISE.
	var/datatype=0
	var/value=0

	// Traitgenes edit begin - Removed subtype, replaced with flag. Allows for safe injectors. Mostly for admin usage.
	var/has_radiation = TRUE
	// Traitgenes edit end

/obj/item/dnainjector/Initialize(mapload) // Traitgenes edit - Moved to init
	if(datatype && block)
		buf=new
		buf.dna=new
		buf.types = datatype
		buf.dna.ResetSE()
		//testing("[name]: DNA2 SE blocks prior to SetValue: [english_list(buf.dna.SE)]")
		SetValue(src.value)
		//testing("[name]: DNA2 SE blocks after SetValue: [english_list(buf.dna.SE)]")
	. = ..() // Traitgenes edit - Moved to init

/obj/item/dnainjector/proc/GetRealBlock(var/selblock)
	if(selblock==0)
		return block
	else
		return selblock

/obj/item/dnainjector/proc/GetState(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEState(real_block)
	else
		return buf.dna.GetUIState(real_block)

/obj/item/dnainjector/proc/SetState(var/on, var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEState(real_block,on)
	else
		return buf.dna.SetUIState(real_block,on)

/obj/item/dnainjector/proc/GetValue(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEValue(real_block)
	else
		return buf.dna.GetUIValue(real_block)

/obj/item/dnainjector/proc/SetValue(var/val,var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEValue(real_block,val)
	else
		return buf.dna.SetUIValue(real_block,val)

/obj/item/dnainjector/proc/inject(mob/M as mob, mob/user as mob)
	if(isliving(M) && has_radiation)
		var/mob/living/L = M
		L.apply_effect(rand(5,20), IRRADIATE, check_protection = 0)
		L.apply_damage(max(2,L.getCloneLoss()), CLONE)

	// Traitgenes edit begin - NO_DNA and Synthetics cannot be mutated
	var/allow = TRUE
	if(M.isSynthetic())
		allow = FALSE
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.species || H.species.flags & NO_DNA)
			allow = FALSE
	// Traitgenes edit end
	if (!(NOCLONE in M.mutations) && allow) // prevents drained people from having their DNA changed, Traitgenes edit - NO_DNA and Synthetics cannot be mutated
		if(buf)
			if (buf.types & DNA2_BUF_UI)
				if (!block) //isolated block?
					M.UpdateAppearance(buf.dna.UI.Copy())
					if (buf.types & DNA2_BUF_UE) //unique enzymes? yes
						M.real_name = buf.dna.real_name
						M.name = buf.dna.real_name
					uses--
				else
					M.dna.SetUIValue(block,src.GetValue())
					M.UpdateAppearance()
					uses--
			if (buf.types & DNA2_BUF_SE)
				if (!block) //isolated block?
					M.dna.SE = buf.dna.SE.Copy()
					M.dna.UpdateSE()
				else
					M.dna.SetSEValue(block,src.GetValue())
				uses--
				// Traitgenes edit - Moved gene checks to after side effects
				if(prob(5))
					trigger_side_effect(M)
			// Traitgenes edit begin - Do gene updates here, and more comprehensively
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				H.sync_dna_traits(FALSE,FALSE)
				H.sync_organ_dna()
			M.regenerate_icons()
			// Traitgenes edit end

	if (user)
		user.drop_from_inventory(src)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src)
	return uses

/obj/item/dnainjector/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob))
		return
	if (!user.IsAdvancedToolUser())
		return
	if (in_use)
		return

	user.visible_message(span_danger("\The [user] is trying to inject \the [M] with \the [src]!"))
	in_use = TRUE

	//addtimer(VARSET_CALLBACK(src, in_use , FALSE), 5 SECONDS, TIMER_DELETE_ME) //Leaving this for reference of how to do the timer here if do_after wasn't present.

	if(!do_after(user,50))
		in_use = FALSE
		return


	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	M.visible_message(span_danger("\The [M] has been injected with \the [src] by \the [user]."))

	var/mob/living/carbon/human/H = M
	if(!istype(H))
		to_chat(user, span_warning("Apparently it didn't work..."))
		return

	inject(M, user)
	return


// Traitgenes Injectors are randomized now due to no hardcoded genes. Split into good or bad, and then versions that specify what they do on the label.
// Otherwise scroll down further for how to make unique injectors
/obj/item/dnainjector/proc/pick_block(var/datum/gene/trait/G, var/labeled, var/allow_disable, var/force_disable = FALSE)
	if(G)
		block = G.block
		datatype = DNA2_BUF_SE
		if(!force_disable)
			value = 0xFFF
		else
			value = 0x000
		if(allow_disable)
			value = pick(0x000,0xFFF)
		if(labeled)
			name = initial(name) + " - [value == 0x000 ? "Removes" : ""] [G.get_name()]"

/obj/item/dnainjector/random
	name = "\improper DNA injector"
	desc = "This injects the person with DNA."

// Purely rando
/obj/item/dnainjector/random/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_good + GLOB.dna_genes_neutral + GLOB.dna_genes_bad), FALSE, TRUE)
	. = ..()

/obj/item/dnainjector/random_labeled/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_good + GLOB.dna_genes_neutral + GLOB.dna_genes_bad), TRUE, TRUE)
	. = ..()

// Good/bad but also neutral genes mixed in, less OP selection of genes
/obj/item/dnainjector/random_good/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_good + GLOB.dna_genes_neutral ), FALSE, TRUE)
	. = ..()

/obj/item/dnainjector/random_good_labeled/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_good + GLOB.dna_genes_neutral ), TRUE, TRUE)
	. = ..()

/obj/item/dnainjector/random_bad/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_bad + GLOB.dna_genes_neutral ), FALSE, TRUE)
	. = ..()

/obj/item/dnainjector/random_bad_labeled/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_bad + GLOB.dna_genes_neutral ), TRUE, TRUE)
	. = ..()

// Purely good/bad genes, intended to be usually good rewards or punishments
/obj/item/dnainjector/random_verygood/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_good), FALSE, FALSE)
	. = ..()

/obj/item/dnainjector/random_verygood_labeled/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_good), TRUE, FALSE)
	. = ..()

/obj/item/dnainjector/random_verybad/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_bad), FALSE, FALSE)
	. = ..()

/obj/item/dnainjector/random_verybad_labeled/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_bad), TRUE, FALSE)
	. = ..()

// Random neutral traits
/obj/item/dnainjector/random_neutral/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_neutral ), FALSE, TRUE)
	. = ..()

/obj/item/dnainjector/random_neutral_labeled/Initialize(mapload)
	pick_block( pick(GLOB.dna_genes_neutral ), TRUE, TRUE)
	. = ..()

// If you want a unique injector, use a subtype of these
/obj/item/dnainjector/set_trait
	var/trait_path
	var/disabling = FALSE

/obj/item/dnainjector/set_trait/Initialize(mapload)
	var/G = get_gene_from_trait(trait_path)
	if(trait_path && G)
		pick_block( G, TRUE, FALSE, disabling)
	else
		qdel(src)
		return
	. = ..()

	disabling = TRUE

// Injectors for all original genes and some new ones
/obj/item/dnainjector/set_trait/anxiety	// stutter
	trait_path = /datum/trait/negative/disability_anxiety
/obj/item/dnainjector/set_trait/anxiety/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/noprints // noprints
	trait_path = /datum/trait/positive/superpower_noprints
/obj/item/dnainjector/set_trait/noprints/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/tourettes // tour
	trait_path = /datum/trait/negative/disability_tourettes
/obj/item/dnainjector/set_trait/tourettes/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/cough // cough
	trait_path = /datum/trait/negative/disability_cough
/obj/item/dnainjector/set_trait/cough/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/nearsighted // glasses
	trait_path = /datum/trait/negative/disability_nearsighted
/obj/item/dnainjector/set_trait/nearsighted/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/heatadapt // fire
	trait_path = /datum/trait/neutral/hotadapt
/obj/item/dnainjector/set_trait/heatadapt/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/epilepsy // epi
	trait_path = /datum/trait/negative/disability_epilepsy
/obj/item/dnainjector/set_trait/epilepsy/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/morph // morph
	trait_path = /datum/trait/positive/superpower_morph
/obj/item/dnainjector/set_trait/morph/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/regenerate // regenerate
	trait_path = /datum/trait/positive/superpower_regenerate
/obj/item/dnainjector/set_trait/regenerate/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/clumsy // clumsy
	trait_path = /datum/trait/negative/disability_clumsy
/obj/item/dnainjector/set_trait/clumsy/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/coldadapt // insulated
	trait_path = /datum/trait/neutral/coldadapt
/obj/item/dnainjector/set_trait/coldadapt/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/xray // xraymut
	trait_path = /datum/trait/positive/superpower_xray
/obj/item/dnainjector/set_trait/xray/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/deaf // deafmut
	trait_path = /datum/trait/negative/disability_deaf
/obj/item/dnainjector/set_trait/deaf/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/tk // telemut
	trait_path = /datum/trait/positive/superpower_tk
/obj/item/dnainjector/set_trait/tk/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/haste // runfast
	trait_path = /datum/trait/positive/speed_fast
/obj/item/dnainjector/set_trait/haste/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/blind // blindmut
	trait_path = /datum/trait/negative/blindness
/obj/item/dnainjector/set_trait/blind/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/nobreathe // nobreath
	trait_path = /datum/trait/positive/superpower_nobreathe
/obj/item/dnainjector/set_trait/nobreathe/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/remoteview // remoteview
	trait_path = /datum/trait/positive/superpower_remoteview
/obj/item/dnainjector/set_trait/remoteview/disable
	disabling = TRUE
/obj/item/dnainjector/set_trait/flashproof // flashproof
	trait_path = /datum/trait/positive/superpower_flashproof
/obj/item/dnainjector/set_trait/flashproof/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/hulk // hulk
	trait_path = /datum/trait/positive/superpower_hulk
/obj/item/dnainjector/set_trait/hulk/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/table_passer // midgit
	trait_path = /datum/trait/positive/table_passer
/obj/item/dnainjector/set_trait/table_passer/disable
	disabling = TRUE

/obj/item/dnainjector/set_trait/remotetalk // remotetalk
	trait_path = /datum/trait/positive/superpower_remotetalk
/obj/item/dnainjector/set_trait/remotetalk/disable
	disabling = TRUE
/*
/obj/item/dnainjector/set_trait/nonconduct // shock
	trait_path = /datum/trait/positive/nonconductive_plus
/obj/item/dnainjector/set_trait/nonconduct/disable
	disabling = TRUE
*/
/obj/item/dnainjector/set_trait/damagedspine // brokenspine
	trait_path = /datum/trait/negative/disability_damagedspine
/obj/item/dnainjector/set_trait/damagedspine/disable
	disabling = TRUE
