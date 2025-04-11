/datum/asset/simple/maint_recycler
	assets = list(
		"recycle.gif" = 'code/modules/maint_recycler/tgui/recycle.gif',
		"logo.png" = 'code/modules/maint_recycler/tgui/logo.png',
	)

/obj/effect/overlay/recycler
	anchored = TRUE
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER //over the inserted items.
	vis_flags = VIS_INHERIT_ID
	appearance_flags = KEEP_TOGETHER | LONG_GLIDE | PASS_MOUSE


/datum/asset/spritesheet_batched/maint_vendor
	name = "MaintVendor"

/datum/asset/spritesheet_batched/maint_vendor/create_spritesheets()
	insert_all_icons("", 'code/modules/maint_recycler/icons/vendor_entries.dmi', prefix_with_dirs = FALSE) // OOC, LOOC ect icons
