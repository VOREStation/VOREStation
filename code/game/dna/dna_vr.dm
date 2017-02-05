// This proc applies the DNA's information to the given head
/datum/dna/proc/write_head_attributes(obj/item/organ/external/head/head_organ)

	//Hair
	var/hair = GetUIValueRange(DNA_UI_HAIR_STYLE,hair_styles_list.len)
	if((hair > 0) && (hair <= hair_styles_list.len))
		head_organ.h_style = hair_styles_list[hair]

	head_organ.r_hair		= GetUIValueRange(DNA_UI_HAIR_R,	255)
	head_organ.g_hair		= GetUIValueRange(DNA_UI_HAIR_G,	255)
	head_organ.b_hair		= GetUIValueRange(DNA_UI_HAIR_B,	255)

	//Facial Hair
	var/beard = GetUIValueRange(DNA_UI_BEARD_STYLE,facial_hair_styles_list.len)
	if((beard > 0) && (beard <= facial_hair_styles_list.len))
		head_organ.f_style = facial_hair_styles_list[beard]

	head_organ.r_facial		= GetUIValueRange(DNA_UI_BEARD_R,	255)
	head_organ.g_facial		= GetUIValueRange(DNA_UI_BEARD_G,	255)
	head_organ.b_facial		= GetUIValueRange(DNA_UI_BEARD_B,	255)

	//Head Accessories
	var/headacc = GetUIValueRange(DNA_UI_HACC_STYLE,head_accessory_styles_list.len)
	if((headacc > 0) && (headacc <= head_accessory_styles_list.len))
		head_organ.ha_style = head_accessory_styles_list[headacc]

	head_organ.r_headacc		= GetUIValueRange(DNA_UI_HACC_R,	255)
	head_organ.g_headacc		= GetUIValueRange(DNA_UI_HACC_G,	255)
	head_organ.b_headacc		= GetUIValueRange(DNA_UI_HACC_B,	255)

/datum/dna/proc/head_traits_to_dna(obj/item/organ/external/head/H)
	if(!H)
		log_runtime(EXCEPTION("Attempting to reset DNA from a missing head!"), src)
		return
	if(!H.h_style)
		H.h_style = "Skinhead"
	var/hair = hair_styles_list.Find(H.h_style)

	// Facial Hair
	if(!H.f_style)
		H.f_style = "Shaved"
	var/beard	= facial_hair_styles_list.Find(H.f_style)

	// Head Accessory
	if(!H.ha_style)
		H.ha_style = "None"
	var/headacc	= head_accessory_styles_list.Find(H.ha_style)

	SetUIValueRange(DNA_UI_HAIR_R,	H.r_hair,				255,	1)
	SetUIValueRange(DNA_UI_HAIR_G,	H.g_hair,				255,	1)
	SetUIValueRange(DNA_UI_HAIR_B,	H.b_hair,				255,	1)

	SetUIValueRange(DNA_UI_BEARD_R,	H.r_facial,				255,	1)
	SetUIValueRange(DNA_UI_BEARD_G,	H.g_facial,				255,	1)
	SetUIValueRange(DNA_UI_BEARD_B,	H.b_facial,				255,	1)

	SetUIValueRange(DNA_UI_HACC_R,	H.r_headacc,			255,	1)
	SetUIValueRange(DNA_UI_HACC_G,	H.g_headacc,			255,	1)
	SetUIValueRange(DNA_UI_HACC_B,	H.b_headacc,			255,	1)

	SetUIValueRange(DNA_UI_HAIR_STYLE,	hair,		hair_styles_list.len,			1)
	SetUIValueRange(DNA_UI_BEARD_STYLE,	beard,		facial_hair_styles_list.len,	1)
	SetUIValueRange(DNA_UI_HACC_STYLE,	headacc,	head_accessory_styles_list.len,	1)