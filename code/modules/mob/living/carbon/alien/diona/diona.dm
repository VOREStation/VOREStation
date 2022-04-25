var/global/list/_nymph_default_emotes = list(
	/decl/emote/visible,
	/decl/emote/visible/scratch,
	/decl/emote/visible/drool,
	/decl/emote/visible/nod,
	/decl/emote/visible/sway,
	/decl/emote/visible/sulk,
	/decl/emote/visible/twitch,
	/decl/emote/visible/dance,
	/decl/emote/visible/roll,
	/decl/emote/visible/shake,
	/decl/emote/visible/jump,
	/decl/emote/visible/shiver,
	/decl/emote/visible/collapse,
	/decl/emote/visible/spin,
	/decl/emote/visible/sidestep,
	/decl/emote/audible/hiss,
	/decl/emote/audible,
	/decl/emote/audible/scretch,
	/decl/emote/audible/choke,
	/decl/emote/audible/gnarl,
	/decl/emote/audible/bug_hiss,
	/decl/emote/audible/bug_chitter,
	/decl/emote/audible/chirp
)

/mob/living/carbon/alien/diona
	name = "diona nymph"
	voice_name = "diona nymph"
	adult_form = /mob/living/carbon/human
	can_namepick_as_adult = 1
	adult_name = "diona gestalt"
	speak_emote = list("chirrups")
	icon_state = "nymph"
	item_state = "nymph"
	language = LANGUAGE_ROOTLOCAL
	species_language = LANGUAGE_ROOTLOCAL
	only_species_language = 1
	death_msg = "expires with a pitiful chirrup..."
	universal_understand = 0
	universal_speak = 0      // Dionaea do not need to speak to people other than other dionaea.

	can_pull_size = ITEMSIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	holder_type = /obj/item/weapon/holder/diona
	var/obj/item/hat

/mob/living/carbon/alien/diona/get_available_emotes()
	return global._nymph_default_emotes

/mob/living/carbon/alien/diona/Initialize()
	. = ..()
	species = GLOB.all_species[SPECIES_DIONA]
	add_language(LANGUAGE_ROOTGLOBAL)
	add_language(LANGUAGE_GALCOM)
	verbs += /mob/living/carbon/alien/diona/proc/merge

/mob/living/carbon/alien/diona/put_in_hands(var/obj/item/W) // No hands.
	W.loc = get_turf(src)
	return 1

/mob/living/carbon/alien/diona/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.loc = src
	update_icons()

/mob/living/carbon/alien/diona/proc/handle_npc(var/mob/living/carbon/alien/diona/D)
	if(D.stat != CONSCIOUS)
		return
	if(prob(33) && D.canmove && isturf(D.loc) && !D.pulledby) //won't move if being pulled
		step(D, pick(cardinal))
	if(prob(1))
		D.emote(pick("scratch","jump","chirp","roll"))
