/datum/asset/spritesheet_batched/chat
	name = "chat"
	load_immediately = TRUE

/datum/asset/spritesheet_batched/chat/create_spritesheets()
	insert_all_icons("", GLOB.text_tag_icons, prefix_with_dirs = FALSE) // OOC, LOOC ect icons
