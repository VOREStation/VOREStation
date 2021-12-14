/datum/event/aurora_caelus
	has_skybox_image = TRUE
	announceWhen = 1
	startWhen = 60
	endWhen = 126

/datum/event/aurora_caelus/announce()
	command_announcement.Announce("[station_name()]: A harmless cloud of ions is approaching your [using_map.facility_type], and will exhaust their energy battering the hull. \
	Nanotrasen has approved a short break for all employees to relax and observe this very rare event. \
	During this time, starlight will be bright but gentle, shifting between quiet green and blue colors. \
	Any staff who would like to view these lights for themselves may proceed to the area nearest to them with viewing ports to open space. \
	You will have approximately two minutes before the ions begin to reach the hull. \
	We hope you enjoy the lights.", "Nanotrasen Meteorology Division", new_sound = 'sound/AI/aurora.ogg') //VOREStation Edit

/datum/event/aurora_caelus/start()
	affecting_z -= global.using_map.sealed_levels // Space levels only please!
	for(var/mob/M in player_list)
		if(M.z in affecting_z)
			M.playsound_local(null, 'sound/ambience/space/aurora_caelus.ogg', 100, FALSE, pressure_affected = FALSE)
	..()

/datum/event/aurora_caelus/get_skybox_image()
	var/image/res = image('icons/skybox/caelus.dmi', "aurora")
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	return res

/datum/event/aurora_caelus/end()
	command_announcement.Announce("The Aurora Caelus event is now ending. Starlight conditions have returned to normal, and the cloud has dissipated. \
Please return to your workplace and continue work as normal. \
Have a pleasant shift, [station_name()], and thank you for watching with us.",
"Nanotrasen Meteorology Division", new_sound = 'sound/AI/aurora_end.ogg') //VOREStation Edit
	..()

/datum/event/aurora_caelus/overmap/announce()
	return
