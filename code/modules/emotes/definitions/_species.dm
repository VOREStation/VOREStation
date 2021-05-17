/datum/species
	var/list/default_emotes = list()

/mob/living/carbon/update_emotes(var/skip_sort)
	. = ..(skip_sort = TRUE)
	if(species)
		for(var/emote in species.default_emotes)
			var/decl/emote/emote_datum = decls_repository.get_decl(emote)
			if(emote_datum.check_user(src))
				usable_emotes[emote_datum.key] = emote_datum
	usable_emotes = sortAssoc(usable_emotes)
