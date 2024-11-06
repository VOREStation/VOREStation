
// Special AI/pAI PDAs that cannot explode.
/obj/item/pda/ai
	icon_state = "NONE"
	ttone = "data"
	detonate = 0
	touch_silent = TRUE
	programs = list(
		new/datum/data/pda/app/main_menu,
		new/datum/data/pda/app/notekeeper,
		new/datum/data/pda/app/news,
		new/datum/data/pda/app/messenger)

/obj/item/pda/ai/proc/set_name_and_job(newname as text, newjob as text, newrank as null|text)
	owner = newname
	ownjob = newjob
	if(newrank)
		ownrank = newrank
	else
		ownrank = ownjob
	name = newname + " (" + ownjob + ")"

//AI verb and proc for sending PDA messages.
/obj/item/pda/ai/verb/cmd_pda_open_ui()
	set category = "Abilities.AI"
	set name = "Use PDA"
	set src in usr

	if(!can_use(usr))
		return
	tgui_interact(usr)

/obj/item/pda/ai/can_use()
	return 1

/obj/item/pda/ai/attack_self(mob/user as mob)
	if ((honkamt > 0) && (prob(60)))//For clown virus.
		honkamt--
		playsound(src, 'sound/items/bikehorn.ogg', 30, 1)
	return


/obj/item/pda/ai/pai
	ttone = "assist"
	var/our_owner = null // Ref to a pAI

/obj/item/pda/ai/pai/New(mob/living/silicon/pai/P)
	if(istype(P))
		our_owner = REF(P)
	return ..()

/obj/item/pda/ai/pai/tgui_status(mob/living/silicon/pai/user, datum/tgui_state/state)
	if(!istype(user) || REF(user) != our_owner) // Only allow our pAI to interface with us
		return STATUS_CLOSE
	return ..()

/obj/item/pda/ai/shell
	spam_proof = TRUE // Since empty shells get a functional PDA.
