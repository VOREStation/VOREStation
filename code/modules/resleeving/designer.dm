// Little define makes it cleaner to read the tripple color values out of mobs.
#define MENU_MAIN "Main"
#define MENU_BODYRECORDS "Body Records"
#define MENU_STOCKRECORDS "Stock Records"
#define MENU_SPECIFICRECORD "Specific Record"
#define MENU_OOCNOTES "OOC Notes"

/obj/machinery/computer/transhuman/designer
	name = "body design console"
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "explosive"
	light_color = "#315ab4"
	circuit = /obj/item/circuitboard/body_designer
	req_access = list(access_medical) // Used for loading people's designs
	var/datum/tgui_module/appearance_changer/body_designer/designer_gui
	var/obj/item/disk/body_record/disk = null
	var/selected_record = FALSE

	// Resleeving database this machine interacts with. Blank for default database
	// Needs a matching /datum/transcore_db with key defined in code
	var/db_key
	var/datum/transcore_db/our_db // These persist all round and are never destroyed, just keep a hard ref

/obj/machinery/computer/transhuman/designer/Initialize()
	. = ..()
	our_db = SStranscore.db_by_key(db_key)

/obj/machinery/computer/transhuman/designer/Destroy()
	if(disk)
		disk.forceMove(get_turf(src))
		disk = null
	. = ..()

/obj/machinery/computer/transhuman/designer/dismantle()
	if(disk)
		disk.forceMove(get_turf(src))
		disk = null
	. = ..()

/obj/machinery/computer/transhuman/designer/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/disk/body_record))
		user.unEquip(W)
		disk = W
		disk.forceMove(src)
		to_chat(user, span_notice("You insert \the [W] into \the [src]."))
		SStgui.update_uis(src)
	else
		. = ..()

/obj/machinery/computer/transhuman/designer/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/computer/transhuman/designer/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(inoperable())
		return
	if(!designer_gui)
		designer_gui = new(src, null)
		designer_gui.linked_body_design_console = WEAKREF(src)
	if(!designer_gui.owner)
		designer_gui.make_fake_owner()
		selected_record = FALSE
	designer_gui.tgui_interact(user)

// Disk for manually moving body records between the designer and sleever console etc.
/obj/item/disk/body_record
	name = "Body Design Disk"
	desc = "It has a small label: \n\
	\"Portable Body Record Storage Disk. \n\
	Insert into resleeving control console\""
	icon = 'icons/obj/discs_vr.dmi'
	icon_state = "data-green"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	var/datum/transhuman/body_record/stored = null

/*
 *	Diskette Box
 */

/obj/item/storage/box/body_record_disk
	name = "body record disk box"
	desc = "A box of body record disks, apparently."
	icon_state = "disk_kit"

/obj/item/storage/box/body_record_disk/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/disk/body_record(src)

#undef MENU_MAIN
#undef MENU_BODYRECORDS
#undef MENU_STOCKRECORDS
#undef MENU_SPECIFICRECORD
#undef MENU_OOCNOTES
