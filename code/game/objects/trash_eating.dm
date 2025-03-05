// checks for when items are consumed by trash/ore eater
/obj/item/proc/on_trash_eaten(var/mob/living/user)
	SHOULD_CALL_PARENT(TRUE)
	if(is_type_in_list(src,item_vore_blacklist) && !user.adminbus_trash) //If someone has adminbus, they can eat whatever they want.
		to_chat(user, span_warning("You are not allowed to eat this."))
		return FALSE
	if(!trash_eatable) //OOC pref. This /IS/ respected, even if adminbus_trash is enabled
		to_chat(user, span_warning("You can't eat that so casually!"))
		return FALSE
	if(hidden_uplink)
		to_chat(user, span_warning("You really should not be eating this."))
		message_admins("[key_name(user)] has attempted to ingest an uplink item. ([user ? ADMIN_JMP(user) : "null"])")
		return FALSE
	return TRUE

/obj/item/proc/after_trash_eaten(var/mob/living/user) // Override for post-swallow messages
	to_chat(src, span_notice("You can taste the flavor of garbage. Delicious."))

// PAI
/obj/item/paicard/on_trash_eaten(var/mob/living/user)
	if(!..())
		return FALSE
	var/mob/living/silicon/pai/pocketpal = pai
	if(pocketpal && (!pocketpal.devourable))
		to_chat(user, span_warning("\The [pocketpal] doesn't allow you to eat it."))
		return FALSE
	return TRUE

/obj/item/paicard/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the sweet flavor of digital friendship."))
	if(pai && pai.client && isbelly(loc))
		var/obj/belly/B = loc
		to_chat(pai, span_boldnotice("[B.desc]"))

// Book
/obj/item/book/on_trash_eaten(var/mob/living/user)
	if(!..())
		return FALSE
	if(carved)
		to_chat(user, span_warning("\The [src] is not worth eating without the filling."))
		return FALSE
	return TRUE

/obj/item/book/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the dry flavor of knowledge."))

// PDA
/obj/item/pda/on_trash_eaten(var/mob/living/user)
	if(!..())
		return FALSE
	if(owner)
		var/watching = FALSE
		for(var/mob/living/carbon/human/H in view(user))
			if(H.real_name == owner && H.client)
				watching = TRUE
				break
		if(!watching)
			return FALSE
		else
			visible_message(span_warning("[user] is threatening to make [src] disappear!"))
			if(id)
				var/confirm = tgui_alert(user, "The PDA you're holding contains a vulnerable ID card. Will you risk it?", "Confirmation", list("Definitely", "Cancel"))
				if(confirm != "Definitely")
					return FALSE
			if(!do_after(user, 100, src))
				return FALSE
			visible_message(span_warning("[user] successfully makes [src] disappear!"))
	return TRUE

/obj/item/pda/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the sweet flavor of delicious technology."))

// Shoes
/obj/item/clothing/shoes/on_trash_eaten(var/mob/living/user)
	if(!..())
		return FALSE
	if(holding)
		to_chat(user, span_warning("There's something inside!"))
		return FALSE
	return TRUE

// Capture crystal
/obj/item/capture_crystal/on_trash_eaten(var/mob/living/user)
	if(!..())
		return FALSE
	if(!bound_mob.devourable)
		to_chat(user, span_warning("That doesn't seem like a good idea. (\The [bound_mob]'s prefs don't allow it.)"))
		return FALSE
	return TRUE

/obj/item/capture_crystal/after_trash_eaten(var/mob/living/user)
	if(bound_mob && (bound_mob in contents))
		if(isbelly(loc))
			var/obj/belly/B = loc
			to_chat(bound_mob, span_notice("Outside of your crystal, you can see; " + span_notice("[B.desc]")))
			to_chat(user, span_notice("You can taste the the power of command."))

// Most trash has no special check, so the rest of these are just after_trash_eaten()
/obj/item/flashlight/flare/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the flavor of spicy cardboard."))

/obj/item/flame/match/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the flavor of spicy cardboard."))

/obj/item/storage/box/matches/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the flavor of spicy cardboard."))

/obj/item/flashlight/glowstick/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You found out the glowy juice only tastes like regret."))

/obj/item/trash/cigbutt/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the flavor of bitter ash. Classy."))

/obj/item/clothing/mask/smokable/after_trash_eaten(var/mob/living/user)
	if(lit)
		to_chat(user, span_notice("You can taste the flavor of burning ash. Spicy!"))
	else
		to_chat(user, span_notice("You can taste the flavor of aromatic rolling paper and funny looks."))

/obj/item/paper/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the dry flavor of bureaucracy."))

/obj/item/dice/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the bitter flavor of cheating."))

/obj/item/roulette_ball/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the bitter flavor of cheating."))

/obj/item/lipstick/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the flavor of couture and style. Toddler at the make-up bag style."))

/obj/item/soap/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the bitter flavor of verbal purification."))

/obj/item/spacecash/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the flavor of wealth and reckless waste."))

/obj/item/storage/wallet/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the flavor of wealth and reckless waste."))

/obj/item/broken_bottle/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the flavor of pain. This can't possibly be healthy for your guts."))

/obj/item/material/shard/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the flavor of pain. This can't possibly be healthy for your guts."))

/obj/item/light/after_trash_eaten(var/mob/living/user)
	if(status == LIGHT_BROKEN)
		to_chat(user, span_notice("You can taste the flavor of pain. This can't possibly be healthy for your guts."))
	else
		to_chat(user, span_notice("You can taste the flavor of really bad ideas."))

/obj/item/bikehorn/tinytether/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You feel a rush of power swallowing such a large, err, tiny structure."))

/obj/item/mmi/digital/posibrain/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the sweet flavor of digital friendship. Or maybe it is something else."))

/obj/item/aicard/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the sweet flavor of digital friendship. Or maybe it is something else."))

/obj/item/reagent_containers/food/after_trash_eaten(var/mob/living/user)
	if(!reagents.total_volume)
		to_chat(user, span_notice("You can taste the flavor of garbage and leftovers. Delicious?"))
	else
		to_chat(user, span_notice("You can taste the flavor of gluttonous waste of food."))

/obj/item/clothing/accessory/collar/after_trash_eaten(var/mob/living/user)
	to_chat(user, span_notice("You can taste the submissiveness in the wearer of [src]!"))
