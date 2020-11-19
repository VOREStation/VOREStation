//Hooded teshari cloaks
/obj/item/clothing/suit/storage/hooded/teshari
	name = "Hooded Teshari Cloak"
	desc = "A soft teshari cloak with an added hood."
	icon_override = 'icons/mob/species/seromi/teshari_hood_vr.dmi'
	icon = 'icons/mob/species/seromi/teshari_hood_vr.dmi'
	icon_state = "tesh_hcloak_bo"
	item_state_slots = list(slot_r_hand_str = "tesh_hcloak_bo", slot_l_hand_str = "tesh_hcloak_bo")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEHOLSTER|HIDETIE
	//hooded = 1 Variable no longer exists, hood is now handled by code/modules/clothing/suit/storage/hooded.dm
	action_button_name = "Toggle Cloak Hood"
	hoodtype = /obj/item/clothing/head/tesh_hood
	allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)

/obj/item/clothing/head/tesh_hood
	name = "Cloak Hood"
	desc = "A hood attached to a teshari cloak."
	icon_override = 'icons/mob/species/seromi/teshari_hood_vr.dmi'
	icon = 'icons/mob/species/seromi/teshari_hood_vr.dmi'
	icon_state = "tesh_hood_bo"
	item_state_slots = list(slot_r_hand_str = "tesh_hood_bo", slot_l_hand_str = "tesh_hood_bo")
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_orange
	name = "black and orange hooded cloak"
	icon_state = "tesh_hcloak_bo"
	item_state = "tesh_hcloak_bo"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_orange

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_grey
	name = "black and grey hooded cloak"
	icon_state = "tesh_hcloak_bg"
	item_state = "tesh_hcloak_bg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_grey

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_midgrey
	name = "black and medium grey hooded cloak"
	icon_state = "tesh_hcloak_bmg"
	item_state = "tesh_hcloak_bmg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_midgrey

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_lightgrey
	name = "black and light grey hooded cloak"
	icon_state = "tesh_hcloak_blg"
	item_state = "tesh_hcloak_blg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_lightgrey

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_white
	name = "black and white hooded cloak"
	icon_state = "tesh_hcloak_bw"
	item_state = "tesh_hcloak_bw"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_white

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_red
	name = "black and red hooded cloak"
	icon_state = "tesh_hcloak_br"
	item_state = "tesh_hcloak_br"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_red

/obj/item/clothing/suit/storage/hooded/teshari/standard/black
	name = "black hooded cloak"
	icon_state = "tesh_hcloak_bn"
	item_state = "tesh_hcloak_bn"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_yellow
	name = "black and yellow hooded cloak"
	icon_state = "tesh_hcloak_by"
	item_state = "tesh_hcloak_by"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_yellow

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_green
	name = "black and green hooded cloak"
	icon_state = "tesh_hcloak_bgr"
	item_state = "tesh_hcloak_bgr"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_green

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_blue
	name = "black and blue hooded cloak"
	icon_state = "tesh_hcloak_bbl"
	item_state = "tesh_hcloak_bbl"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_blue

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_purple
	name = "black and purple hooded cloak"
	icon_state = "tesh_hcloak_bp"
	item_state = "tesh_hcloak_bp"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_purple

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_pink
	name = "black and pink hooded cloak"
	icon_state = "tesh_hcloak_bpi"
	item_state = "tesh_hcloak_bpi"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_pink

/obj/item/clothing/suit/storage/hooded/teshari/standard/black_brown
	name = "black and brown hooded cloak"
	icon_state = "tesh_hcloak_bbr"
	item_state = "tesh_hcloak_bbr"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/black_brown

/obj/item/clothing/suit/storage/hooded/teshari/standard/orange_grey
	name = "orange and grey hooded cloak"
	icon_state = "tesh_hcloak_og"
	item_state = "tesh_hcloak_og"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/orange_grey

///obj/item/clothing/suit/storage/hooded/teshari/standard/rainbow
//	name = "rainbow hooded cloak"
//	icon_state = "tesh_hcloak_rainbow"
//	item_state = "tesh_hcloak_rainbow"
//	hoodtype = /obj/item/clothing/head/tesh_hood/standard/rainbow

/obj/item/clothing/suit/storage/hooded/teshari/standard/lightgrey_grey
	name = "light grey and grey hooded cloak"
	icon_state = "tesh_hcloak_lgg"
	item_state = "tesh_hcloak_lgg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/lightgrey_grey

/obj/item/clothing/suit/storage/hooded/teshari/standard/white_grey
	name = "white and grey hooded cloak"
	icon_state = "tesh_hcloak_wg"
	item_state = "tesh_hcloak_wg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/white_grey

/obj/item/clothing/suit/storage/hooded/teshari/standard/red_grey
	name = "red and grey hooded cloak"
	icon_state = "tesh_hcloak_rg"
	item_state = "tesh_hcloak_rg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/red_grey

/obj/item/clothing/suit/storage/hooded/teshari/standard/orange
	name = "orange hooded cloak"
	icon_state = "tesh_hcloak_on"
	item_state = "tesh_hcloak_on"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/orange

/obj/item/clothing/suit/storage/hooded/teshari/standard/yellow_grey
	name = "yellow and grey hooded cloak"
	icon_state = "tesh_hcloak_yg"
	item_state = "tesh_hcloak_yg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/yellow_grey

/obj/item/clothing/suit/storage/hooded/teshari/standard/green_grey
	name = "green and grey hooded cloak"
	icon_state = "tesh_hcloak_gg"
	item_state = "tesh_hcloak_gg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/green_grey

/obj/item/clothing/suit/storage/hooded/teshari/standard/blue_grey
	name = "blue and grey hooded cloak"
	icon_state = "tesh_hcloak_blug"
	item_state = "tesh_hcloak_blug"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/blue_grey

/obj/item/clothing/suit/storage/hooded/teshari/standard/purple_grey
	name = "purple and grey hooded cloak"
	icon_state = "tesh_hcloak_pg"
	item_state = "tesh_hcloak_pg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/purple_grey

/obj/item/clothing/suit/storage/hooded/teshari/standard/pink_grey
	name = "pink and grey hooded cloak"
	icon_state = "tesh_hcloak_pig"
	item_state = "tesh_hcloak_pig"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/pink_grey

/obj/item/clothing/suit/storage/hooded/teshari/standard/brown_grey
	name = "brown and grey hooded cloak"
	icon_state = "tesh_hcloak_brg"
	item_state = "tesh_hcloak_brg"
	hoodtype = /obj/item/clothing/head/tesh_hood/standard/brown_grey

//The actual hoods
/obj/item/clothing/head/tesh_hood/standard/black_orange
	name = "black and orange cloak hood"
	icon_state = "tesh_hood_bo"
	item_state = "tesh_hood_bo"

/obj/item/clothing/head/tesh_hood/standard/black_grey
	name = "black and grey cloak hood"
	icon_state = "tesh_hood_bg"
	item_state = "tesh_hood_bg"

/obj/item/clothing/head/tesh_hood/standard/black_midgrey
	name = "black and medium grey cloak hood"
	icon_state = "tesh_hood_bmg"
	item_state = "tesh_hood_bmg"

/obj/item/clothing/head/tesh_hood/standard/black_lightgrey
	name = "black and light grey cloak hood"
	icon_state = "tesh_hood_blg"
	item_state = "tesh_hood_blg"

/obj/item/clothing/head/tesh_hood/standard/black_white
	name = "black and white cloak hood"
	icon_state = "tesh_hood_bw"
	item_state = "tesh_hood_bw"

/obj/item/clothing/head/tesh_hood/standard/black_red
	name = "black and red cloak hood"
	icon_state = "tesh_hood_br"
	item_state = "tesh_hood_br"

/obj/item/clothing/head/tesh_hood/standard/black
	name = "black cloak hood"
	icon_state = "tesh_hood_bn"
	item_state = "tesh_hood_bn"

/obj/item/clothing/head/tesh_hood/standard/black_yellow
	name = "black and yellow cloak hood"
	icon_state = "tesh_hood_by"
	item_state = "tesh_hood_by"

/obj/item/clothing/head/tesh_hood/standard/black_green
	name = "black and green cloak hood"
	icon_state = "tesh_hood_bgr"
	item_state = "tesh_hood_bgr"

/obj/item/clothing/head/tesh_hood/standard/black_blue
	name = "black and blue cloak hood"
	icon_state = "tesh_hood_bbl"
	item_state = "tesh_hood_bbl"

/obj/item/clothing/head/tesh_hood/standard/black_purple
	name = "black and purple cloak hood"
	icon_state = "tesh_hood_bp"
	item_state = "tesh_hood_bp"

/obj/item/clothing/head/tesh_hood/standard/black_pink
	name = "black and pink cloak hood"
	icon_state = "tesh_hood_bpi"
	item_state = "tesh_hood_bpi"

/obj/item/clothing/head/tesh_hood/standard/black_brown
	name = "black and brown cloak hood"
	icon_state = "tesh_hood_bbr"
	item_state = "tesh_hood_bbr"

/obj/item/clothing/head/tesh_hood/standard/orange_grey
	name = "orange and grey cloak hood"
	icon_state = "tesh_hood_og"
	item_state = "tesh_hood_og"

/obj/item/clothing/head/tesh_hood/standard/rainbow
	name = "rainbow cloak hood"
	icon_state = "tesh_hood_rainbow"
	item_state = "tesh_hood_rainbow"

/obj/item/clothing/head/tesh_hood/standard/lightgrey_grey
	name = "light grey and grey cloak hood"
	icon_state = "tesh_hood_lgg"
	item_state = "tesh_hood_lgg"

/obj/item/clothing/head/tesh_hood/standard/white_grey
	name = "white and grey cloak hood"
	icon_state = "tesh_hood_wg"
	item_state = "tesh_hood_wg"

/obj/item/clothing/head/tesh_hood/standard/red_grey
	name = "red and grey cloak hood"
	icon_state = "tesh_hood_rg"
	item_state = "tesh_hood_rg"

/obj/item/clothing/head/tesh_hood/standard/orange
	name = "orange cloak hood"
	icon_state = "tesh_hood_on"
	item_state = "tesh_hood_on"

/obj/item/clothing/head/tesh_hood/standard/yellow_grey
	name = "yellow and grey cloak hood"
	icon_state = "tesh_hood_yg"
	item_state = "tesh_hood_yg"

/obj/item/clothing/head/tesh_hood/standard/green_grey
	name = "green and grey cloak hood"
	icon_state = "tesh_hood_gg"
	item_state = "tesh_hood_gg"

/obj/item/clothing/head/tesh_hood/standard/blue_grey
	name = "blue and grey cloak hood"
	icon_state = "tesh_hood_blug"
	item_state = "tesh_hood_blug"

/obj/item/clothing/head/tesh_hood/standard/purple_grey
	name = "purple and grey cloak hood"
	icon_state = "tesh_hood_pg"
	item_state = "tesh_hood_pg"

/obj/item/clothing/head/tesh_hood/standard/pink_grey
	name = "pink and grey cloak hood"
	icon_state = "tesh_hood_pig"
	item_state = "tesh_hood_pig"

/obj/item/clothing/head/tesh_hood/standard/brown_grey
	name = "brown and grey cloak hood"
	icon_state = "tesh_hood_brg"
	item_state = "tesh_hood_brg"

//Belted cloaks
/obj/item/clothing/suit/storage/seromi/beltcloak
	name = "belted cloak"
	desc = "A more ridged and stylized Teshari cloak."
	icon = 'icons/mob/species/seromi/teshari_cloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/teshari_cloak_vr.dmi'
	icon_state = "tesh_beltcloak_bo"
	item_state = "tesh_beltcloak_bo"
	species_restricted = list(SPECIES_TESHARI)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_orange
	name = "black belted cloak (orange)"
	icon_state = "tesh_beltcloak_bo"
	item_state = "tesh_beltcloak_bo"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_grey
	name = "black belted cloak"
	icon_state = "tesh_beltcloak_bg"
	item_state = "tesh_beltcloak_bg"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_midgrey
	name = "black belted cloak (medium grey)"
	icon_state = "tesh_beltcloak_bmg"
	item_state = "tesh_beltcloak_bmg"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_lightgrey
	name = "black belted cloak (light grey)"
	icon_state = "tesh_beltcloak_blg"
	item_state = "tesh_beltcloak_blg"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_white
	name = "black belted cloak (white)"
	icon_state = "tesh_beltcloak_bw"
	item_state = "tesh_beltcloak_bw"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_red
	name = "black belted cloak (red)"
	icon_state = "tesh_beltcloak_br"
	item_state = "tesh_beltcloak_br"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black
	name = "black simple belted cloak"
	icon_state = "tesh_beltcloak_bn"
	item_state = "tesh_beltcloak_bn"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_yellow
	name = "black belted cloak (yellow)"
	icon_state = "tesh_beltcloak_by"
	item_state = "tesh_beltcloak_by"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_green
	name = "black belted cloak (green)"
	icon_state = "tesh_beltcloak_bgr"
	item_state = "tesh_beltcloak_bgr"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_blue
	name = "black belted cloak (blue)"
	icon_state = "tesh_beltcloak_bbl"
	item_state = "tesh_beltcloak_bbl"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_purple
	name = "black belted cloak (purple)"
	icon_state = "tesh_beltcloak_bp"
	item_state = "tesh_beltcloak_bp"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_pink
	name = "black belted cloak (pink)"
	icon_state = "tesh_beltcloak_bpi"
	item_state = "tesh_beltcloak_bpi"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/black_brown
	name = "black belted cloak (brown)"
	icon_state = "tesh_beltcloak_bbr"
	item_state = "tesh_beltcloak_bbr"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/orange_grey
	name = "orange belted cloak"
	icon_state = "tesh_beltcloak_og"
	item_state = "tesh_beltcloak_og"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/rainbow
	name = "rainbow belted cloak"
	icon_state = "tesh_beltcloak_rainbow"
	item_state = "tesh_beltcloak_rainbow"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/lightgrey_grey
	name = "light grey belted cloak"
	icon_state = "tesh_beltcloak_lgg"
	item_state = "tesh_beltcloak_lgg"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/white_grey
	name = "white belted cloak"
	icon_state = "tesh_beltcloak_wg"
	item_state = "tesh_beltcloak_wg"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/red_grey
	name = "red belted cloak"
	icon_state = "tesh_beltcloak_rg"
	item_state = "tesh_beltcloak_rg"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/orange
	name = "orange simple belted cloak"
	icon_state = "tesh_beltcloak_on"
	item_state = "tesh_beltcloak_on"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/yellow_grey
	name = "yellow belted cloak"
	icon_state = "tesh_beltcloak_yg"
	item_state = "tesh_beltcloak_yg"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/green_grey
	name = "green belted cloak"
	icon_state = "tesh_beltcloak_gg"
	item_state = "tesh_beltcloak_gg"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/blue_grey
	name = "blue belted cloak"
	icon_state = "tesh_beltcloak_blug"
	item_state = "tesh_beltcloak_blug"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/purple_grey
	name = "purple belted cloak"
	icon_state = "tesh_beltcloak_pg"
	item_state = "tesh_beltcloak_pg"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/pink_grey
	name = "pink belted cloak"
	icon_state = "tesh_beltcloak_pig"
	item_state = "tesh_beltcloak_pig"

/obj/item/clothing/suit/storage/seromi/beltcloak/standard/brown_grey
	name = "brown belted cloak"
	icon_state = "tesh_beltcloak_brg"
	item_state = "tesh_beltcloak_brg"

//Belted job cloaks
/obj/item/clothing/suit/storage/seromi/beltcloak/jobs
	icon = 'icons/mob/species/seromi/teshari_cloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/teshari_cloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/cargo
	name = "cargo belted cloak"
	desc = "A soft Teshari cloak made for the Cargo department"
	icon_state = "tesh_beltcloak_car"
	item_state = "tesh_beltcloak_car"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/mining
	name = "mining belted cloak"
	desc = "A soft Teshari cloak made for Mining"
	icon_state = "tesh_beltcloak_mine"
	item_state = "tesh_beltcloak_mine"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/command
	name = "command belted cloak"
	desc = "A soft Teshari cloak made for the Command department"
	icon_state = "tesh_beltcloak_comm"
	item_state = "tesh_beltcloak_comm"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/ce
	name = "chief engineer belted cloak"
	desc = "A soft Teshari cloak made the Chief Engineer"
	icon_state = "tesh_beltcloak_ce"
	item_state = "tesh_beltcloak_ce"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/engineer
	name = "engineering belted cloak"
	desc = "A soft Teshari cloak made for the Engineering department"
	icon_state = "tesh_beltcloak_engie"
	item_state = "tesh_beltcloak_engie"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/atmos
	name = "atmospherics belted cloak"
	desc = "A soft Teshari cloak made for the Atmospheric Technician"
	icon_state = "tesh_beltcloak_atmos"
	item_state = "tesh_beltcloak_atmos"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/cmo
	name = "chief medical officer belted  cloak"
	desc = "A soft Teshari cloak made the Chief Medical Officer"
	icon_state = "tesh_beltcloak_cmo"
	item_state = "tesh_beltcloak_cmo"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/medical
	name = "medical belted cloak"
	desc = "A soft Teshari cloak made for the Medical department"
	icon_state = "tesh_beltcloak_doc"
	item_state = "tesh_beltcloak_doc"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/chemistry
	name = "chemist belted cloak"
	desc = "A soft Teshari cloak made for the Chemist"
	icon_state = "tesh_beltcloak_vrem"
	item_state = "tesh_beltcloak_vrem"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/viro
	name = "virologist belted cloak"
	desc = "A soft Teshari cloak made for the Virologist"
	icon_state = "tesh_beltcloak_viro"
	item_state = "tesh_beltcloak_viro"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/para
	name = "paramedic belted cloak"
	desc = "A soft Teshari cloak made for the Paramedic"
	icon_state = "tesh_beltcloak_para"
	item_state = "tesh_beltcloak_para"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/sci
	name = "scientist belted cloak"
	desc = "A soft Teshari cloak made for the Science department"
	icon_state = "tesh_beltcloak_sci"
	item_state = "tesh_beltcloak_sci"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/robo
	name = "roboticist belted cloak"
	desc = "A soft Teshari cloak made for the Roboticist"
	icon_state = "tesh_beltcloak_robo"
	item_state = "tesh_beltcloak_robo"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/sec
	name = "security belted cloak"
	desc = "A soft Teshari cloak made for the Security department"
	icon_state = "tesh_beltcloak_sec"
	item_state = "tesh_beltcloak_sec"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/qm
	name = "quartermaster belted cloak"
	desc = "A soft Teshari cloak made for the Quartermaster"
	icon_state = "tesh_beltcloak_qm"
	item_state = "tesh_beltcloak_qm"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/service
	name = "service belted cloak"
	desc = "A soft Teshari cloak made for the Service department"
	icon_state = "tesh_beltcloak_serv"
	item_state = "tesh_beltcloak_serv"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/iaa
	name = "internal affairs belted cloak"
	desc = "A soft Teshari cloak made for the Internal Affairs Agent"
	icon_state = "tesh_beltcloak_iaa"
	item_state = "tesh_beltcloak_iaa"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/wrdn
	name = "warden belted cloak"
	desc = "A soft Teshari cloak made for the Warden"
	icon_state = "tesh_beltcloak_wrdn"
	item_state = "tesh_beltcloak_wrdn"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/hos
	name = "security chief belted cloak"
	desc = "A soft Teshari cloak made for the Head of Security"
	icon_state = "tesh_beltcloak_hos"
	item_state = "tesh_beltcloak_hos"

/obj/item/clothing/suit/storage/seromi/beltcloak/jobs/jani
	name = "janitor belted cloak"
	desc = "A soft Teshari cloak made for the Janitor"
	icon_state = "tesh_beltcloak_jani"
	item_state = "tesh_beltcloak_jani"

//Alternate standard & job cloaks.
/obj/item/clothing/suit/storage/teshari/cloak_vr
	name = "black cloak (VR)"
	desc = "It drapes over a Teshari's shoulders and closes at the neck with pockets convienently placed inside."
	icon = 'icons/mob/species/seromi/teshari_cloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/teshari_cloak_vr.dmi'
	icon_state = "tesh_cloak_bn"
	item_state = "tesh_cloak_bn"
	species_restricted = list(SPECIES_TESHARI)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_red
	name = "black and red cloak (VR)"
	icon_state = "tesh_cloak_br"
	item_state = "tesh_cloak_br"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_orange
	name = "black and orange cloak (VR)"
	icon_state = "tesh_cloak_bo"
	item_state = "tesh_cloak_bo"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_yellow
	name = "black and yellow cloak (VR)"
	icon_state = "tesh_cloak_by"
	item_state = "tesh_cloak_by"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_green
	name = "black and green cloak (VR)"
	icon_state = "tesh_cloak_bgr"
	item_state = "tesh_cloak_bgr"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_blue
	name = "black and blue cloak (VR)"
	icon_state = "tesh_cloak_bbl"
	item_state = "tesh_cloak_bbl"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_purple
	name = "black and purple cloak (VR)"
	icon_state = "tesh_cloak_bp"
	item_state = "tesh_cloak_bp"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_pink
	name = "black and pink cloak (VR)"
	icon_state = "tesh_cloak_bpi"
	item_state = "tesh_cloak_bpi"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_brown
	name = "black and brown cloak (VR)"
	icon_state = "tesh_cloak_bbr"
	item_state = "tesh_cloak_bbr"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_grey
	name = "black and grey cloak (VR)"
	icon_state = "tesh_cloak_bg"
	item_state = "tesh_cloak_bg"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_white
	name = "black and white cloak (VR)"
	icon_state = "tesh_cloak_bw"
	item_state = "tesh_cloak_bw"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/black_glow
	name = "black and glowing cloak (VR)"
	icon_state = "tesh_cloak_bglowing"
	item_state = "tesh_cloak_bglowing"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/dark_retrowave
	name = "dark aesthetic cloak (VR)"
	icon_state = "tesh_cloak_dretrowave"
	item_state = "tesh_cloak_dretrowave"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/white
	name = "white cloak (VR)"
	icon_state = "tesh_cloak_wn"
	item_state = "tesh_cloak_wn"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/white_grey
	name = "white and grey cloak (VR)"
	icon_state = "tesh_cloak_wg"
	item_state = "tesh_cloak_wg"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/red_grey
	name = "red and grey cloak (VR)"
	icon_state = "tesh_cloak_rg"
	item_state = "tesh_cloak_rg"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/orange_grey
	name = "orange and grey cloak (VR)"
	icon_state = "tesh_cloak_og"
	item_state = "tesh_cloak_og"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/yellow_grey
	name = "yellow and grey cloak (VR)"
	icon_state = "tesh_cloak_yg"
	item_state = "tesh_cloak_yg"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/green_grey
	name = "green and grey cloak (VR)"
	icon_state = "tesh_cloak_gg"
	item_state = "tesh_cloak_gg"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/blue_grey
	name = "blue and grey cloak (VR)"
	icon_state = "tesh_cloak_blug"
	item_state = "tesh_cloak_blug"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/purple_grey
	name = "purple and grey cloak (VR)"
	icon_state = "tesh_cloak_pg"
	item_state = "tesh_cloak_pg"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/pink_grey
	name = "pink and grey cloak (VR)"
	icon_state = "tesh_cloak_pig"
	item_state = "tesh_cloak_pig"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/brown_grey
	name = "brown and grey cloak (VR)"
	icon_state = "tesh_cloak_brg"
	item_state = "tesh_cloak_brg"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/rainbow
	name = "rainbow cloak (VR)"
	icon_state = "tesh_cloak_rainbow"
	item_state = "tesh_cloak_rainbow"

/obj/item/clothing/suit/storage/teshari/cloak_vr/standard/orange
	name = "orange cloak (VR)"
	icon_state = "tesh_cloak_on"
	item_state = "tesh_cloak_on"

//Alternate Job Cloaks - subpathed for ease of access in loadouts. If the path ends in _vr not /vr it's net-new.
/obj/item/clothing/suit/storage/seromi/cloak/jobs/cap_vr
	name = "facility director cloak (VR)"
	desc = "A soft Teshari cloak made for the Facility Director"
	icon_state = "tesh_cloak_cap"
	item_state = "tesh_cloak_cap"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

//Cargo

/obj/item/clothing/suit/storage/seromi/cloak/jobs/qm/vr
	name = "quartermaster cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/cargo/vr
	name = "cargo cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/mining/vr
	name = "mining cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/command/vr
	name = "command cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

//Engineering

/obj/item/clothing/suit/storage/seromi/cloak/jobs/ce/vr
	name = "chief engineer cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/eningeer/vr
	name = "engineering cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/atmos/vr
	name = "atmospherics cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

//Medical

/obj/item/clothing/suit/storage/seromi/cloak/jobs/cmo/vr
	name = "chief medical officer cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/medical/vr
	name = "medical cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/chemistry/vr
	name = "chemist cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/viro/vr
	name = "virologist cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/para/vr
	name = "paramedic cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/psych_vr
	name = "psychiatrist cloak (VR)"
	desc = "A soft Teshari cloak made for the Psychiatrist"
	icon_state = "tesh_cloak_psych"
	item_state = "tesh_cloak_psych"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

//Science

/obj/item/clothing/suit/storage/seromi/cloak/jobs/rd_vr
	name = "research director cloak (VR)"
	desc = "A soft Teshari cloak made for the Research Director"
	icon_state = "tesh_cloak_rd"
	item_state = "tesh_cloak_rd"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/sci/vr
	name = "scientist cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/robo/vr
	name = "roboticist cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

//Security

/obj/item/clothing/suit/storage/seromi/cloak/jobs/hos_vr
	name = "head of security cloak (VR)"
	desc = "A soft Teshari cloak made for the Head of Security"
	icon_state = "tesh_cloak_hos"
	item_state = "tesh_cloak_hos"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/sec/vr
	name = "security cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/iaa/vr
	name = "internal affairs cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

//Service

/obj/item/clothing/suit/storage/seromi/cloak/jobs/hop_vr
	name = "head of personnel cloak (VR)"
	desc = "A soft Teshari cloak made for the Head of Personnel"
	icon_state = "tesh_cloak_hop"
	item_state = "tesh_cloak_hop"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'

/obj/item/clothing/suit/storage/seromi/cloak/jobs/service/vr
	name = "service cloak (VR)"
	icon = 'icons/mob/species/seromi/deptcloak_vr.dmi'
	icon_override = 'icons/mob/species/seromi/deptcloak_vr.dmi'
