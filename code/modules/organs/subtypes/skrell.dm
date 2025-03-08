/obj/item/organ/internal/eyes/skrell
	icon_state = "skrell_eyes"

/obj/item/organ/internal/heart/skrell
	icon_state = "skrell_heart-on"
	dead_icon = "skrell_heart-off"

/obj/item/organ/internal/lungs/skrell
	icon_state = "skrell_lungs"

/obj/item/organ/internal/liver/skrell
	icon_state = "skrell_liver"

/obj/item/organ/internal/brain/skrell
	icon_state = "brain_skrell"

/obj/item/organ/internal/stomach/skrell
	icon_state = "skrell_stomach"

/obj/item/organ/internal/kidneys/skrell
	icon_state = "skrell_kidney"

/obj/item/organ/internal/intestine/skrell
	icon_state = "skrell_intestine"

/obj/item/organ/internal/voicebox/skrell
	icon_state = "skrell_larynx"
	will_assist_languages = list(LANGUAGE_SKRELLIAN)

/obj/item/organ/internal/appendix/skrell
	icon_state = "skrell_appendix"

/obj/item/organ/internal/spleen/skrell
	name = "lymphatic hub"
	icon_state = "skrell_spleen"
	parent_organ = BP_HEAD
	spleen_efficiency = 0.5

/obj/item/organ/internal/spleen/skrell/Initialize(mapload)
	. = ..()
	adjust_scale(0.8,0.7)
