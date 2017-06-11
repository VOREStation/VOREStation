//////////////////
// AR HUD Overlays
/datum/nifsoft/ar_civ
	name = "AR Overlay (Civ)"
	desc = "Provides a general identification and health status overlay on your vision with no frills."
	list_pos = NIF_CIVILIAN_AR
	cost = 500
	a_drain = 0.05

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_MEDICAL_AR,NIF_SECURITY_AR,NIF_ENGINE_AR,NIF_SCIENCE_AR,NIF_OMNI_AR)
			nif.set_flag(NIF_V_AR_CIVILIAN,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_AR_CIVILIAN,NIF_FLAGS_VISION)

/datum/nifsoft/ar_med
	name = "AR Overlay (Med)"
	desc = "Like the civilian model, but provides medical records access and virus database lookup."
	list_pos = NIF_MEDICAL_AR
	cost = 750
	access = access_medical
	a_drain = 0.05

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_CIVILIAN_AR,NIF_SECURITY_AR,NIF_ENGINE_AR,NIF_SCIENCE_AR,NIF_OMNI_AR)
			nif.set_flag(NIF_V_AR_MEDICAL,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_AR_MEDICAL,NIF_FLAGS_VISION)

/datum/nifsoft/ar_sec
	name = "AR Overlay (Sec)"
	desc = "Like the civilian model, but provides access to arrest status and security records."
	list_pos = NIF_SECURITY_AR
	cost = 750
	access = access_security
	a_drain = 0.05

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_CIVILIAN_AR,NIF_MEDICAL_AR,NIF_ENGINE_AR,NIF_SCIENCE_AR,NIF_OMNI_AR)
			nif.set_flag(NIF_V_AR_SECURITY,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_AR_SECURITY,NIF_FLAGS_VISION)

/datum/nifsoft/ar_eng
	name = "AR Overlay (Eng)"
	desc = "Like the civilian model, but provides station alert notices."
	list_pos = NIF_ENGINE_AR
	cost = 750
	access = access_engine
	a_drain = 0.05

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_CIVILIAN_AR,NIF_MEDICAL_AR,NIF_SECURITY_AR,NIF_SCIENCE_AR,NIF_OMNI_AR)
			nif.set_flag(NIF_V_AR_ENGINE,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_AR_ENGINE,NIF_FLAGS_VISION)

/datum/nifsoft/ar_science
	name = "AR Overlay (Sci)"
	desc = "Like the civilian model, but provides ... well, nothing. For now."
	list_pos = NIF_SCIENCE_AR
	cost = 750
	access = access_research
	a_drain = 0.05

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_CIVILIAN_AR,NIF_MEDICAL_AR,NIF_SECURITY_AR,NIF_ENGINE_AR,NIF_OMNI_AR)
			nif.set_flag(NIF_V_AR_SCIENCE,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_AR_SCIENCE,NIF_FLAGS_VISION)

/datum/nifsoft/ar_omni
	name = "AR Overlay (Omni)"
	desc = "Like the civilian model, but provides most of the features of the medical and security overlays as well."
	list_pos = NIF_OMNI_AR
	cost = 750
	access = access_captain
	a_drain = 0.05

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_CIVILIAN_AR,NIF_MEDICAL_AR,NIF_SECURITY_AR,NIF_ENGINE_AR,NIF_SCIENCE_AR)
			nif.set_flag(NIF_V_AR_OMNI,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_AR_OMNI,NIF_FLAGS_VISION)

//////////////
// Misc Vision
/datum/nifsoft/corrective
	name = "Corrective AR"
	desc = "Subtly alters perception to compensate for cataracts and retinal misalignment, among other common disabilities."
	list_pos = NIF_CORRECTIVE_GLASS
	cost = 200
	a_drain = 0.025

	activate()
		if((. = ..()))
			nif.set_flag(NIF_V_CORRECTIVE,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_CORRECTIVE,NIF_FLAGS_VISION)

/datum/nifsoft/uvblocker
	name = "Nictating Membrane"
	desc = "A synthetic nictating membrane (aka 'third eyelid') that protects the eyes from UV or hostile atmospheres. Does not protect from photonic stun weapons."
	list_pos = NIF_UVFILTER
	cost = 450
	a_drain = 0.2

	activate()
		if((. = ..()))
			nif.set_flag(NIF_V_UVFILTER,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_UVFILTER,NIF_FLAGS_VISION)

/datum/nifsoft/flashprot
	name = "Responsive Filter"
	desc = "Enables a high-speed shielding response to intense light, such as flashes, to block them."
	list_pos = NIF_FLASHPROT
	cost = 600
	access = access_security
	a_drain = 0.05

	activate()
		if((. = ..()))
			nif.set_flag(NIF_V_FLASHPROT,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_FLASHPROT,NIF_FLAGS_VISION)

////////////////
// Goggle-alikes
/datum/nifsoft/mesons
	name = "Meson Scanner"
	desc = "Similar to the worn Optical Meson Scanner Goggles, these allow you to see the base structure and terrain through walls."
	list_pos = NIF_MESONS
	cost = 1000
	a_drain = 0.1
	access = access_engine
	tick_flags = NIF_ACTIVETICK

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_MATERIAL,NIF_THERMALS,NIF_NIGHTVIS)
			nif.set_flag(NIF_V_MESONS,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_MESONS,NIF_FLAGS_VISION)

	life()
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			H.sight |= SEE_TURFS
			if(H.client)
				H.client.screen |= global_hud.meson

/datum/nifsoft/material
	name = "Material Scanner"
	desc = "Similar to the worn Optical Material Scanner Goggles, these allow you to see objects through walls."
	list_pos = NIF_MATERIAL
	cost = 1000
	a_drain = 0.1
	access = access_research
	tick_flags = NIF_ACTIVETICK

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_MESONS,NIF_THERMALS,NIF_NIGHTVIS)
			nif.set_flag(NIF_V_MATERIAL,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_MATERIAL,NIF_FLAGS_VISION)

	life()
		if((. = ..()))
			nif.human.sight |= SEE_OBJS

/datum/nifsoft/thermals
	name = "Thermal Scanner"
	desc = "Similar to the worn Thermal Goggles, these allow you to see heat-emitting creatures through walls."
	list_pos = NIF_THERMALS
	cost = 1000
	a_drain = 0.1
	access = access_captain
	tick_flags = NIF_ACTIVETICK

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_MESONS,NIF_MATERIAL,NIF_NIGHTVIS)
			nif.set_flag(NIF_V_THERMALS,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_THERMALS,NIF_FLAGS_VISION)

	life()
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			H.sight |= SEE_MOBS
			H.see_invisible = SEE_INVISIBLE_NOLIGHTING
			if(H.client)
				H.client.screen |= global_hud.thermal

/datum/nifsoft/nightvis
	name = "Low-Light Amp"
	desc = "Similar to the worn Night Vision Goggles, these allow you to see in complete darkness."
	list_pos = NIF_NIGHTVIS
	cost = 1000
	a_drain = 0.1
	access = access_security
	tick_flags = NIF_ACTIVETICK

	activate()
		if((. = ..()))
			nif.deactivate_these(NIF_MESONS,NIF_MATERIAL,NIF_THERMALS)
			nif.set_flag(NIF_V_NIGHTVIS,NIF_FLAGS_VISION)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_V_NIGHTVIS,NIF_FLAGS_VISION)

	life()
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			H.see_in_dark += 7
			H.see_invisible = SEE_INVISIBLE_NOLIGHTING
			if(H.client)
				H.client.screen |= global_hud.nvg

