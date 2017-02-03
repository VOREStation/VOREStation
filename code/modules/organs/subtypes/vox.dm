/obj/item/organ/external/head/vox
	eye_icon = "vox_eyes_s"

//vox got different organs within. This will also help with regular surgeons knowing the organs within an alien as alien as vox.
/obj/item/organ/internal/brain/vox
	icon_state = "brain_prosthetic"
	dead_icon = null

/obj/item/organ/internal/heart/vox
	icon_state = "vox_heart"
	dead_icon = null
	parent_organ = BP_GROIN

/obj/item/organ/internal/lungs/vox
	name = "air capillary sack" //Like birds, Vox absorb gas via air capillaries.
	icon_state = "vox_lung"

/obj/item/organ/internal/kidneys/vox
	name = "filtration bladder"
	icon_state = "lungs" //wow are vox kidneys fat.
	color = "#99ccff"
	parent_organ = BP_TORSO

/obj/item/organ/internal/liver/vox
	name = "waste tract"
	parent_organ = BP_TORSO
	color = "#0033cc"

/obj/item/organ/external/groin/vox //vox have an extended ribcage for extra protection.
	encased = "lower ribcage"
