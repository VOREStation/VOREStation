/datum/event/anomaly
	startWhen = 15
	announceWhen = 1
	var/area/impact_area
	var/datum/anomaly_placer/placer = new()
	var/obj/effect/anomaly/anomaly_path = /obj/effect/anomaly/flux

/datum/event/anomaly/setup()
	impact_area = placer.find_valid_area()

/datum/event/anomaly/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Energetic flux wave detected on [ANOMALY_ANNOUNCE_DANGEROUS_TEXT] [impact_area.name].", "Anomaly Alert")

/datum/event/anomaly/start()
	var/turf/anomaly_turf
	anomaly_turf = placer.find_valid_turf(impact_area)

	var/newAnomaly
	if(anomaly_turf)
		newAnomaly = new anomaly_path(anomaly_turf)
	if(newAnomaly)
		apply_anomaly_properties(newAnomaly)

/datum/event/anomaly/proc/apply_anomaly_properties(obj/effect/anomaly/new_anomaly)
	return

// Bioscrambler
/datum/event/anomaly/bioscrambler
	startWhen = 3
	announceWhen = 1
	anomaly_path = /obj/effect/anomaly/bioscrambler

/datum/event/anomaly/bioscrambler/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Biologic trait swapping agent detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Anomaly Alert")

// Bluespace
/datum/event/anomaly/bluespace
	startWhen = 3
	announceWhen = 1
	anomaly_path = /obj/effect/anomaly/bluespace

/datum/event/anomaly/bluespace/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Bluespace instability detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Anomaly Alert")

// Dimensional
/datum/event/anomaly/dimensional
	startWhen = 3
	announceWhen = 1
	anomaly_path = /obj/effect/anomaly/dimensional
	var/anomaly_theme

/datum/event/anomaly/dimensional/apply_anomaly_properties(obj/effect/anomaly/new_anomaly)
	if(!anomaly_theme)
		return
	var/obj/effect/anomaly/dimensional/anomaly = new_anomaly
	anomaly.prepare_area(new_theme_path = anomaly_theme)

/datum/event/anomaly/dimensional/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Dimensional instability detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Anomaly Alert")

// Flux

/datum/event/anomaly/flux
	startWhen = 15
	announceWhen = 1
	anomaly_path = /obj/effect/anomaly/flux

/datum/event/anomaly/flux/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Hyper-energetic flux wave detected on [ANOMALY_ANNOUNCE_DANGEROUS_TEXT] [impact_area.name].", "Anomaly Alert")

// Gravitational
/datum/event/anomaly/grav
	startWhen = 3
	announceWhen = 1
	anomaly_path = /obj/effect/anomaly/grav

/datum/event/anomaly/grav/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Gravitational anomaly detected on [ANOMALY_ANNOUNCE_HARMFUL_TEXT] [impact_area.name].", "Anomaly Alert")

// Hallucination
/datum/event/anomaly/hallucination
	startWhen = 3
	announceWhen = 1
	anomaly_path = /obj/effect/anomaly/hallucination

/datum/event/anomaly/hallucination/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Hallucinatory event detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Anomaly Alert")

// Pyroclastic
/datum/event/anomaly/pyro
	startWhen = 15
	announceWhen = 1
	anomaly_path = /obj/effect/anomaly/pyro

/datum/event/anomaly/pyro/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Pyroclastic anomaly detected on [ANOMALY_ANNOUNCE_HARMFUL_TEXT] [impact_area.name].", "Anomaly Alert")

// Weather
/datum/event/anomaly/weather
	startWhen = 3
	announceWhen = 1
	anomaly_path = /obj/effect/anomaly/weather

/datum/event/anomaly/weather/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Metereologic anomaly detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Anomaly Alert")

// Dust
/datum/event/anomaly/dust
	startWhen = 3
	announceWhen = 15
	anomaly_path = /obj/effect/anomaly/dust

/datum/event/anomaly/dust/announce()
	if(isnull(impact_area))
		impact_area = placer.find_valid_area()
	command_announcement.Announce("Anomalous dust particles detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name].", "Anomaly Alert")
