/datum/gm_action/carp_migration/announce()
	var/announcement = "Unknown biological entities have been detected near the asteroid, please stand-by."
	command_announcement.Announce(announcement, "Lifesign Alert")