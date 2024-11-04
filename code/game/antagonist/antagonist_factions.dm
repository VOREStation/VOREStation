/mob/living/proc/convert_to_rev(mob/M as mob in oview(src))
	set name = "Convert Bourgeoise"
	set category = "Abilities.Antag"
	if(!M.mind)
		return
	convert_to_faction(M.mind, revs)

/mob/living/proc/convert_to_faction(var/datum/mind/player, var/datum/antagonist/faction)

	if(!player || !faction || !player.current)
		return

	if(!faction.faction_verb || !faction.faction_descriptor || !faction.faction_verb)
		return

	if(faction.is_antagonist(player))
		to_chat(src, span_warning("\The [player.current] already serves the [faction.faction_descriptor]."))
		return

	if(player_is_antag(player))
		to_chat(src, span_warning("\The [player.current]'s loyalties seem to be elsewhere..."))
		return

	if(!faction.can_become_antag(player))
		to_chat(src, span_warning("\The [player.current] cannot be \a [faction.faction_role_text]!"))
		return

	if(world.time < player.rev_cooldown)
		to_chat(src, span_danger("You must wait five seconds between attempts."))
		return

	to_chat(src, span_danger("You are attempting to convert \the [player.current]..."))
	log_admin("[src]([src.ckey]) attempted to convert [player.current].")
	message_admins(span_danger("[src]([src.ckey]) attempted to convert [player.current]."))

	player.rev_cooldown = world.time+100
	var/choice = tgui_alert(player.current, "Asked by [src]: Do you want to join the [faction.faction_descriptor]?", "Join the [faction.faction_descriptor]?", list("No!","Yes!"))
	if(choice == "Yes!" && faction.add_antagonist_mind(player, 0, faction.faction_role_text, faction.faction_welcome))
		to_chat(src, span_notice("\The [player.current] joins the [faction.faction_descriptor]!"))
		return
	if(!choice || choice == "No!")
		to_chat(player, span_danger("You reject this traitorous cause!"))
	to_chat(src, span_danger("\The [player.current] does not support the [faction.faction_descriptor]!"))

/mob/living/proc/convert_to_loyalist(mob/M as mob in oview(src))
	set name = "Convert Recidivist"
	set category = "Abilities.Antag"
	if(!M.mind)
		return
	convert_to_faction(M.mind, loyalists)
