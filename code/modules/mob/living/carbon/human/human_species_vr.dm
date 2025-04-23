/mob/living/carbon/human/dummy
	no_vore = TRUE //Dummies don't need bellies.

/mob/living/carbon/human/sergal/Initialize(mapload)
	h_style = "Sergal Plain"
	. = ..(mapload, SPECIES_SERGAL)

/mob/living/carbon/human/akula/Initialize(mapload)
	. = ..(mapload, SPECIES_AKULA)

/mob/living/carbon/human/nevrean/Initialize(mapload)
	. = ..(mapload, SPECIES_NEVREAN)

/mob/living/carbon/human/xenochimera/Initialize(mapload)
	. = ..(mapload, SPECIES_XENOCHIMERA)

/mob/living/carbon/human/spider/Initialize(mapload)
	. = ..(mapload, SPECIES_VASILISSAN)

/mob/living/carbon/human/vulpkanin/Initialize(mapload)
	. = ..(mapload, SPECIES_VULPKANIN)

/mob/living/carbon/human/protean/Initialize(mapload)
	. = ..(mapload, SPECIES_PROTEAN)

/mob/living/carbon/human/alraune/Initialize(mapload)
	. = ..(mapload, SPECIES_ALRAUNE)

/mob/living/carbon/human/shadekin/Initialize(mapload)
	. = ..(mapload, SPECIES_SHADEKIN)

/mob/living/carbon/human/altevian/Initialize(mapload)
	. = ..(mapload, SPECIES_ALTEVIAN)

/mob/living/carbon/human/lleill/Initialize(mapload)
	. = ..(mapload, SPECIES_LLEILL)

/mob/living/carbon/human/hanner/Initialize(mapload)
	. = ..(mapload, SPECIES_HANNER)

/mob/living/carbon/human/sparkledog/Initialize(mapload)
	. = ..(mapload, SPECIES_SPARKLE)
