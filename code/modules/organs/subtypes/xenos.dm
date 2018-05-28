//XENOMORPH ORGANS
/obj/item/organ/internal/xenos
	name = "xeno organ"
	icon = 'icons/obj/surgery.dmi'
	desc = "It smells like an accident in a chemical factory."

/obj/item/organ/internal/xenos/eggsac
	name = "egg sac"
	parent_organ = BP_GROIN
	icon_state = "sac"
	organ_tag = O_EGG

/obj/item/organ/internal/xenos/eggsac/grey
	icon_state = "sac_grey"

/obj/item/organ/internal/xenos/eggsac/grey/colormatch/New()
	..()
	var/mob/living/carbon/human/H = null
	spawn(15)
		if(ishuman(owner))
			H = owner
			color = H.species.blood_color

/obj/item/organ/internal/xenos/plasmavessel
	name = "plasma vessel"
	parent_organ = BP_TORSO
	icon_state = "plasma"
	organ_tag = O_PLASMA
	var/stored_plasma = 0
	var/max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/grey
	icon_state = "plasma_grey"
	stored_plasma = 200

/obj/item/organ/internal/xenos/plasmavessel/grey/colormatch/New()
	..()
	var/mob/living/carbon/human/H = null
	spawn(15)
		if(ishuman(owner))
			H = owner
			color = H.species.blood_color

/obj/item/organ/internal/xenos/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/obj/item/organ/internal/xenos/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/obj/item/organ/internal/xenos/acidgland
	name = "acid gland"
	parent_organ = BP_HEAD
	icon_state = "acidgland"
	organ_tag = O_ACID

/obj/item/organ/internal/xenos/acidgland/grey
	icon_state = "acidgland_grey"

/obj/item/organ/internal/xenos/acidgland/grey/colormatch/New()
	..()
	var/mob/living/carbon/human/H = null
	spawn(15)
		if(ishuman(owner))
			H = owner
			color = H.species.blood_color

/obj/item/organ/internal/xenos/hivenode
	name = "hive node"
	parent_organ = BP_TORSO
	icon_state = "xenode"
	organ_tag = O_HIVE

/obj/item/organ/internal/xenos/hivenode/grey
	icon_state = "xenode_grey"

/obj/item/organ/internal/xenos/hivenode/grey/colormatch/New()
	..()
	var/mob/living/carbon/human/H = null
	spawn(15)
		if(ishuman(owner))
			H = owner
			color = H.species.blood_color

/obj/item/organ/internal/xenos/resinspinner
	name = "resin spinner"
	parent_organ = BP_HEAD
	icon_state = "xenode"
	organ_tag = O_RESIN


/obj/item/organ/internal/xenos/resinspinner/grey
	icon_state = "xenode_grey"

/obj/item/organ/internal/xenos/resinspinner/grey/colormatch/New()
	..()
	var/mob/living/carbon/human/H = null
	spawn(15)
		if(ishuman(owner))
			H = owner
			color = H.species.blood_color
