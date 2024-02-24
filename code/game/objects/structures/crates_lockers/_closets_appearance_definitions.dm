/obj/structure/closet/debug/Initialize(var/maploading, var/newappearance)
	closet_appearance = newappearance
	. = ..()

/decl/closet_appearance
	var/color = COLOR_GRAY40
	var/decals = list(
		"upper_vent",
		"lower_vent"
	)
	var/list/extra_decals
	var/icon/icon
	var/base_icon =  'icons/obj/closets/bases/closet.dmi'
	var/decal_icon = 'icons/obj/closets/decals/closet.dmi'
	var/can_lock = FALSE

	/// Length of time (ds) to animate the door transform
	var/door_anim_time = 2.0
	/// Amount to 'squish' the full width of the door by
	var/door_anim_squish = 0.30
	/// Virtual angle at which the door is opened to (136 by default, so not a full 180)
	var/door_anim_angle = 136
	/// Offset for the door hinge location from centerline
	var/door_hinge = -6.5

/decl/closet_appearance/New()
	// Build our colour and decal lists.
	if(LAZYLEN(extra_decals))
		if(!decals)
			decals = list()
		for(var/thing in extra_decals)
			decals[thing] = extra_decals[thing]
	for(var/thing in decals)
		if(isnull(decals[thing]))
			decals[thing] = color

	// Declare storage vars for icons.
	var/icon/open_icon
	var/icon/closed_emagged_icon
	var/icon/closed_emagged_welded_icon
	var/icon/closed_locked_icon
	var/icon/closed_locked_welded_icon
	var/icon/closed_unlocked_icon
	var/icon/closed_unlocked_welded_icon
	var/icon/door_front_icon
	var/icon/door_back_icon

	// Create open icon.
	var/icon/new_icon = new
	open_icon = icon(base_icon, "base")
	open_icon.Blend(icon(base_icon, "open"), ICON_OVERLAY)
	open_icon.Blend(color, BLEND_ADD)
	open_icon.Blend(icon(base_icon, "interior"), ICON_OVERLAY)

	door_back_icon = icon(base_icon, "door_back")
	door_back_icon.Blend(color, BLEND_ADD)

	if(decal_icon)
		for(var/thing in decals)
			var/icon/this_decal_icon = icon(decal_icon, "[thing]_open")
			this_decal_icon.Blend(decals[thing], BLEND_ADD)
			open_icon.Blend(this_decal_icon, ICON_OVERLAY)

	// Generate basic closed icons.
	door_front_icon = icon(base_icon, "door_front")
	door_front_icon.Blend(color, BLEND_ADD)
	closed_emagged_icon = icon(base_icon, "base")
	if(can_lock)
		closed_emagged_icon.Blend(icon(base_icon, "lock"), ICON_OVERLAY)
	closed_emagged_icon.Blend(color, BLEND_ADD)
	if(decal_icon)
		for(var/thing in decals)
			var/icon/this_decal_icon = icon(decal_icon, thing)
			this_decal_icon.Blend(decals[thing], BLEND_ADD)
			closed_emagged_icon.Blend(this_decal_icon, ICON_OVERLAY)
			door_front_icon.Blend(this_decal_icon, ICON_OVERLAY)

	door_front_icon.AddAlphaMask(icon(base_icon, "door_front")) // Remove pesky 'more than just door' decals

	closed_locked_icon =   icon(closed_emagged_icon)
	closed_unlocked_icon = icon(closed_emagged_icon)

	// Add lock lights.
	if(can_lock)
		var/icon/light = icon(base_icon, "light")
		light.Blend(COLOR_RED, BLEND_ADD)
		closed_locked_icon.Blend(light, ICON_OVERLAY)
		light = icon(base_icon, "light")
		light.Blend(COLOR_LIME, BLEND_ADD)
		closed_unlocked_icon.Blend(light, ICON_OVERLAY)

	// Add welded states.
	var/icon/welded = icon(base_icon, "welded")
	closed_locked_welded_icon =   icon(closed_locked_icon)
	closed_unlocked_welded_icon = icon(closed_unlocked_icon)
	closed_emagged_welded_icon =  icon(closed_emagged_icon)
	closed_locked_welded_icon.Blend(welded, ICON_OVERLAY)
	closed_unlocked_welded_icon.Blend(welded, ICON_OVERLAY)
	closed_emagged_welded_icon.Blend(welded, ICON_OVERLAY)

	// Finish up emagged icons.
	var/icon/sparks = icon(base_icon, "sparks")
	closed_emagged_icon.Blend(sparks, ICON_OVERLAY)
	closed_emagged_welded_icon.Blend(sparks, ICON_OVERLAY)

	// Insert our bevy of icons into the final icon file.
	new_icon.Insert(open_icon,						"open")
	new_icon.Insert(closed_emagged_icon,			"closed_emagged")
	new_icon.Insert(closed_emagged_welded_icon,		"closed_emagged_welded")
	new_icon.Insert(closed_locked_icon,				"closed_locked")
	new_icon.Insert(closed_locked_welded_icon,		"closed_locked_welded")
	new_icon.Insert(closed_unlocked_icon,			"closed_unlocked")
	new_icon.Insert(closed_unlocked_welded_icon,	"closed_unlocked_welded")
	new_icon.Insert(door_front_icon,				"door_front")
	new_icon.Insert(door_back_icon,					"door_back")

	// Set icon!
	icon = new_icon

/decl/closet_appearance/tactical
	color = COLOR_RED_GRAY
	extra_decals = list(
		"inset" = COLOR_GRAY
	)

/decl/closet_appearance/thunderdomered
	color = COLOR_LIGHT_RED

/decl/closet_appearance/thunderdomegreen
	color = COLOR_LIGHT_GREEN

/decl/closet_appearance/tactical/alt
	color = COLOR_PALE_BTL_GREEN

/decl/closet_appearance/wardrobe
	extra_decals = list(
		"stripe_horizontal" = COLOR_PALE_BLUE_GRAY,
		"stripe_w" = COLOR_GRAY
	)

/decl/closet_appearance/wardrobe/blue
	extra_decals = list(
		"stripe_horizontal" = COLOR_TEAL,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/purple
	extra_decals = list(
		"stripe_horizontal" = COLOR_VIOLET,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/mixed
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_VIOLET,
		"stripe_horizontal_lower" = COLOR_PALE_PINK,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/orange
	extra_decals = list(
		"stripe_horizontal" = COLOR_ORANGE,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/green
	extra_decals = list(
		"stripe_horizontal" = COLOR_GREEN,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/grey
	extra_decals = list(
		"stripe_horizontal" = COLOR_GRAY,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/pink
	extra_decals = list(
		"stripe_horizontal" = COLOR_LIGHT_PINK,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/black
	extra_decals = list(
		"stripe_horizontal" = COLOR_GRAY20,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/yellow
	extra_decals = list(
		"stripe_horizontal" = COLOR_YELLOW,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/red
	extra_decals = list(
		"stripe_horizontal" = COLOR_LIGHT_RED,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/white
	extra_decals = list(
		"stripe_horizontal" = COLOR_GRAY,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/suit
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_OFF_WHITE,
		"stripe_horizontal_lower" = COLOR_GRAY,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/janitor
	extra_decals = list(
		"stripe_horizontal" = COLOR_PURPLE,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/medical
	color = COLOR_OFF_WHITE

/decl/closet_appearance/wardrobe/medical/patient
	extra_decals = list(
		"stripe_horizontal" = COLOR_GRAY,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/medical/white
	extra_decals = list(
		"stripe_horizontal" = COLOR_OFF_WHITE,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/medical/chemistry
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_OFF_WHITE,
		"stripe_horizontal_lower" = COLOR_ORANGE,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/medical/genetics
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_OFF_WHITE,
		"stripe_horizontal_lower" = COLOR_BABY_BLUE,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/medical/virology
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_OFF_WHITE,
		"stripe_horizontal_lower" = COLOR_LIME,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/robotics
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_GRAY20,
		"stripe_horizontal_lower" = COLOR_PALE_MAROON,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/science
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_horizontal" = COLOR_PURPLE,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/wardrobe/pjs
	extra_decals = list(
		"stripe_horizontal" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/white
	extra_decals = list(
		"stripe_horizontal" = COLOR_OFF_WHITE,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/engineer
	extra_decals = list(
		"stripe_horizontal" = COLOR_PALE_ORANGE,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/engineer/atmos
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_PALE_ORANGE,
		"stripe_horizontal_lower" = COLOR_TEAL,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/chapel
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_PALE_YELLOW,
		"stripe_horizontal_lower" = COLOR_GRAY20,
		"stripe_w" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/wardrobe/xenos
	extra_decals = list(
		"stripe_horizontal_upper" = COLOR_GREEN,
		"stripe_horizontal_lower" = COLOR_GOLD,
		"stripe_w" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/ert
	color = COLOR_RED_GRAY

/decl/closet_appearance/bio
	color = COLOR_PALE_ORANGE
	decals = list(
		"l3" = COLOR_OFF_WHITE,
		"stripe_horizontal_narrow" = COLOR_ORANGE
	)
	extra_decals = list(
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/command
	extra_decals = list(
		"lower_half_solid" = COLOR_BLUE_GRAY,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/medical
	extra_decals = list(
		"lower_half_solid" = COLOR_PALE_BLUE_GRAY,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/science
	extra_decals = list(
		"lower_half_solid" = COLOR_PALE_PINK,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/security
	extra_decals = list(
		"lower_half_solid" = COLOR_RED_GRAY,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/janitor
	color = COLOR_PURPLE
	decals = list(
		"l3" = COLOR_OFF_WHITE,
	)
	extra_decals = list(
		"stripe_horizontal_broad" = COLOR_ORANGE,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/bio/virology
	extra_decals = list(
		"lower_half_solid" = COLOR_GREEN_GRAY,
		"biohazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet
	can_lock = TRUE

/decl/closet_appearance/secure_closet/patient
	color = COLOR_OFF_WHITE

/decl/closet_appearance/secure_closet/engineering
	can_lock = TRUE
	color = COLOR_YELLOW_GRAY
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_BEASTY_BROWN,
		"stripe_vertical_left_partial" = COLOR_BEASTY_BROWN,
		"eng" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/electrical
	decals = list(
		"lower_vent"
	)
	extra_decals = list(
		"electric" = COLOR_BEASTY_BROWN,
		"vertical_stripe_simple" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/atmos
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_DARK_TEAL,
		"stripe_vertical_mid_partial" = COLOR_DARK_TEAL,
		"atmos" = COLOR_DARK_TEAL
	)

/decl/closet_appearance/secure_closet/engineering/welding
	decals = list(
		"lower_vent"
	)
	extra_decals = list(
		"fire" = COLOR_BEASTY_BROWN,
		"vertical_stripe_simple" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/tools
	can_lock = FALSE
	decals = list(
		"lower_vent"
	)
	extra_decals = list(
		"tool" = COLOR_BEASTY_BROWN,
		"vertical_stripe_simple" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/tools/xenoarch
	extra_decals = list(
		"pick" = COLOR_BEASTY_BROWN,
		"vertical_stripe_simple" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/tools/radiation
	extra_decals = list(
		"l2" = COLOR_BEASTY_BROWN,
		"rads" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/engineering/ce
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_DARK_GOLD,
		"stripe_vertical_mid_partial" = COLOR_DARK_GOLD,
		"eng_narrow" = COLOR_DARK_GOLD
	)

/decl/closet_appearance/secure_closet/mining
	color = COLOR_WARM_YELLOW
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_mid_partial" = COLOR_BEASTY_BROWN,
		"stripe_vertical_left_partial" = COLOR_BEASTY_BROWN,
		"mining" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/mining/sec
	decals = list(
		"stripe_vertical_mid_partial" = COLOR_NT_RED,
		"stripe_vertical_left_partial" = COLOR_NT_RED,
		"mining" = COLOR_NT_RED
	)

/decl/closet_appearance/secure_closet/command
	color = COLOR_BLUE_GRAY
	decals = list(
		"lower_holes",
		"upper_holes"
	)
	extra_decals = list(
		"stripe_vertical_left_partial" = COLOR_GOLD,
		"stripe_vertical_right_partial" = COLOR_GOLD,
		"captain" = COLOR_GOLD
	)

/decl/closet_appearance/secure_closet/command/hop
	color = COLOR_PALE_BLUE_GRAY
	extra_decals = list(
		"stripe_vertical_mid_partial" = COLOR_GOLD,
		"hop" = COLOR_GOLD
	)

/decl/closet_appearance/secure_closet/cmo
	color = COLOR_BABY_BLUE
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"medcircle" = COLOR_GOLD,
		"stripe_vertical_right_partial" = COLOR_GOLD,
		"stripe_vertical_mid_partial" = COLOR_GOLD
	)

/decl/closet_appearance/secure_closet/medical
	color = COLOR_OFF_WHITE
	decals = null
	extra_decals = list(
		"circle" = COLOR_BLUE_GRAY,
		"stripes_horizontal" = COLOR_BLUE_GRAY
	)

/decl/closet_appearance/secure_closet/medical/virology
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_BOTTLE_GREEN,
		"stripe_vertical_mid_partial" = COLOR_BOTTLE_GREEN,
		"viro" = COLOR_BOTTLE_GREEN
	)

/decl/closet_appearance/secure_closet/medical/alt
	extra_decals = list(
		"medcircle" =COLOR_BLUE_GRAY,
		"stripe_vertical_right_partial" = COLOR_BLUE_GRAY,
		"stripe_vertical_mid_partial" = COLOR_BLUE_GRAY
	)

/decl/closet_appearance/secure_closet/medical/chemistry
	extra_decals = list(
		"medcircle" = COLOR_ORANGE,
		"stripe_vertical_right_partial" = COLOR_ORANGE,
		"stripe_vertical_mid_partial" = COLOR_ORANGE
	)

/decl/closet_appearance/secure_closet/medical/paramedic
	decals = list(
		"lower_side_vent"
	)
	extra_decals = list(
		"medical" = COLOR_BLUE_GRAY,
		"stripe_vertical_mid_full" = COLOR_BLUE_GRAY
	)

/decl/closet_appearance/secure_closet/medical/doctor
	decals = list(
		"lower_side_vent"
	)
	extra_decals = list(
		"medical" = COLOR_BLUE_GRAY,
		"stripe_vertical_right_full" = COLOR_BLUE_GRAY,
		"stripe_vertical_left_full" = COLOR_BLUE_GRAY
	)

/decl/closet_appearance/secure_closet/cargo
	color = COLOR_WARM_YELLOW
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"cargo" = COLOR_BEASTY_BROWN,
		"stripe_vertical_left_partial" = COLOR_BEASTY_BROWN,
		"stripe_vertical_mid_partial" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/cargo/qm
	extra_decals = list(
		"cargo" = COLOR_SILVER,
		"stripe_vertical_left_partial" = COLOR_SILVER,
		"stripe_vertical_mid_partial" = COLOR_SILVER
	)

/decl/closet_appearance/secure_closet/courtroom
	decals = list(
		"lower_holes",
		"upper_holes"
	)

/decl/closet_appearance/secure_closet/brig
	color = COLOR_DARK_ORANGE
	extra_decals = list(
		"inset" = COLOR_GRAY40
	)

/decl/closet_appearance/secure_closet/security
	color = COLOR_NT_RED
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_WARM_YELLOW,
		"security" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/security/warden
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"security" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/security/hos
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_WARM_YELLOW,
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_mid_full" =  COLOR_GOLD,
		"security" = COLOR_GOLD
	)

/decl/closet_appearance/bomb
	color = COLOR_DARK_GREEN_GRAY
	decals = list(
		"l4" = COLOR_OFF_WHITE
	)
	extra_decals = list(
		"lower_half_solid" = COLOR_PALE_PINK
	)

/decl/closet_appearance/bomb/security
	extra_decals = list(
		"lower_half_solid" = COLOR_RED_GRAY
	)

/decl/closet_appearance/oxygen
	color = COLOR_LIGHT_CYAN
	decals = list(
		"lower_vent"
	)
	extra_decals = list(
		"oxy" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/oxygen/fire
	color = COLOR_RED_LIGHT
	extra_decals = list(
		"extinguisher" = COLOR_OFF_WHITE,
		"vertical_stripe_simple" = COLOR_OFF_WHITE,
	)

/decl/closet_appearance/oxygen/fire/atmos
	color = COLOR_YELLOW_GRAY
	extra_decals = list(
		"extinguisher" = COLOR_TEAL,
		"vertical_stripe_simple" = COLOR_TEAL,
	)

/decl/closet_appearance/alien
	color = COLOR_PURPLE

/decl/closet_appearance/secure_closet/expedition
	color = COLOR_BLUE_GRAY
	decals = list(
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_PURPLE,
		"security" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/expedition/pathfinder
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"security" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/science
	color = COLOR_OFF_WHITE
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_PURPLE,
		"research" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/science/xenoarch
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"research" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/science/rd
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_GOLD,
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"research" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/corporate
	color = COLOR_GREEN_GRAY
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_GRAY80,
		"research" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/hydroponics
	color = COLOR_SALAD_GREEN
	decals = list(
		"lower_side_vent",
		"upper_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_GREEN,
		"stripe_vertical_mid_partial" = COLOR_GREEN,
		"hydro" = COLOR_GREEN
	)

/decl/closet_appearance/secure_closet/hydroponics/xenoflora
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_PURPLE,
		"stripe_vertical_mid_partial" = COLOR_PURPLE,
		"hydro" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/chaplain
	decals = list(
		"lower_side_vent",
		"upper_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_right_full" = COLOR_GRAY20,
		"stripe_vertical_mid_full" = COLOR_GRAY20
	)

/decl/closet_appearance/secure_closet/sol
	color = COLOR_BABY_BLUE
	decals = list(
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BOTTLE_GREEN,
		"security" = COLOR_BOTTLE_GREEN
	)

/decl/closet_appearance/secure_closet/sol/two
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BOTTLE_GREEN,
		"stripe_vertical_right_full" = COLOR_BOTTLE_GREEN,
		"security" = COLOR_BOTTLE_GREEN
	)

/decl/closet_appearance/secure_closet/sol/two/dark
	color = COLOR_DARK_BLUE_GRAY

// Crates.
/decl/closet_appearance/crate
	decals = null
	extra_decals = null
	base_icon =  'icons/obj/closets/bases/crate.dmi'
	decal_icon = 'icons/obj/closets/decals/crate.dmi'
	color = COLOR_GRAY40
	door_anim_time = 0

/decl/closet_appearance/crate/plastic
	color = COLOR_GRAY80

/decl/closet_appearance/crate/oxygen
	color = COLOR_CYAN_BLUE
	decals = list(
		"crate_stripes" = COLOR_OFF_WHITE,
		"crate_oxy" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/medical
	color = COLOR_GRAY80
	decals = list(
		"crate_stripe" = COLOR_WARM_YELLOW,
		"crate_cross" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/medical/trauma
	decals = list(
		"crate_stripe" = COLOR_NT_RED,
		"crate_cross" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/medical/oxygen
	decals = list(
		"crate_stripe" = COLOR_BABY_BLUE,
		"crate_cross" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/medical/toxins
	decals = list(
		"crate_stripe" = COLOR_GREEN_GRAY,
		"crate_cross" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/hydroponics
	decals = list(
		"crate_stripe_left" = COLOR_GREEN_GRAY,
		"crate_stripe_right" = COLOR_GREEN_GRAY
	)

/decl/closet_appearance/crate/radiation
	color = COLOR_BROWN_ORANGE
	extra_decals = list(
		"crate_radiation_left" = COLOR_WARM_YELLOW,
		"crate_radiation_right" = COLOR_WARM_YELLOW,
		"lid_stripes" = COLOR_NT_RED
	)

// Freezers

/decl/closet_appearance/crate/freezer
	color = COLOR_OFF_WHITE

/decl/closet_appearance/crate/freezer/centauri
	color = COLOR_BABY_BLUE
	extra_decals = list(
		"centauri" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/freezer/nanotrasen
	color = COLOR_BABY_BLUE
	extra_decals = list(
		"nano" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/freezer/veymed
	color = COLOR_BABY_BLUE
	extra_decals = list(
		"lid_stripes" = COLOR_RED,
		"crate_cross" = COLOR_GREEN
	)

/decl/closet_appearance/crate/freezer/zenghu
	color = COLOR_BABY_BLUE
	extra_decals = list(
		"zenghu" = COLOR_OFF_WHITE
	)

// Corporate Branding

/decl/closet_appearance/crate/aether
	color = COLOR_YELLOW_GRAY
	decals = list(
		"crate_stripes" = COLOR_BLUE_LIGHT,
		"aether" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/allico
	color = COLOR_LIGHT_VIOLET
	decals = list(
		"crate_stripe" = COLOR_AMBER
	)

/decl/closet_appearance/crate/carp
	color = COLOR_PURPLE
	decals = list(
		"toptext" = COLOR_OFF_WHITE,
		"crate_reticle" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/centauri
	color = COLOR_BABY_BLUE
	decals = list(
		"crate_stripe" = COLOR_LUMINOL
	)
	extra_decals = list(
		"centauri" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/cybersolutions
	color = COLOR_ALUMINIUM
	extra_decals = list(
		"hazard" = COLOR_DARK_GOLD,
		"toptext" = COLOR_DARK_GOLD
	)

/decl/closet_appearance/crate/einstein
	color = COLOR_DARK_BLUE_GRAY
	extra_decals = list(
		"crate_stripe_left" = COLOR_BEIGE,
		"crate_stripe_right" = COLOR_BEIGE,
		"einstein" = COLOR_OFF_WHITE,
		"hazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/focalpoint
	color = COLOR_GOLD
	extra_decals = list(
		"crate_stripe_left" = COLOR_NAVY_BLUE,
		"crate_stripe_right" = COLOR_NAVY_BLUE,
		"focal" = COLOR_OFF_WHITE,
		"hazard" = COLOR_NAVY_BLUE
	)

/decl/closet_appearance/crate/galaksi
	color = COLOR_OFF_WHITE
	decals = list(
		"lid_stripes" = COLOR_HULL,
		"galaksi" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/gilthari
	color = COLOR_GRAY20
	extra_decals = list(
		"crate_stripe_left" = COLOR_GOLD,
		"crate_stripe_right" = COLOR_GOLD,
		"gilthari" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/grayson
	color = COLOR_STEEL
	extra_decals = list(
		"crate_stripe_left" = COLOR_MAROON,
		"crate_stripe_right" = COLOR_MAROON,
		"grayson" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/heph
	color = COLOR_GRAY20
	extra_decals = list(
		"crate_stripe_left" = COLOR_NT_RED,
		"crate_stripe_right" = COLOR_NT_RED,
		"heph" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/morpheus
	color = COLOR_ALUMINIUM
	extra_decals = list(
		"hazard" = COLOR_GUNMETAL,
		"toptext" = COLOR_GUNMETAL
	)

/decl/closet_appearance/crate/nanotrasen
	color = COLOR_NT_RED
	extra_decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripe_right" = COLOR_OFF_WHITE,
		"nano" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/nanotrasenclothing
	color = COLOR_NT_RED
	extra_decals = list(
		"crate_stripe_left" = COLOR_SEDONA,
		"crate_stripe_right" = COLOR_SEDONA,
		"nano" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/nanotrasenmedical
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"crate_stripe" = COLOR_NT_RED,
		"nano" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/oculum
	color = COLOR_SURGERY_BLUE
	decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripe_right" = COLOR_OFF_WHITE,
		"oculum" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/saare
	color = COLOR_ALUMINIUM
	extra_decals = list(
		"hazard" = COLOR_RED,
		"xion" = COLOR_GRAY40
	)

/decl/closet_appearance/crate/thinktronic
	color = COLOR_PALE_PURPLE_GRAY
	decals = list(
		"toptext" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/ummarcar
	color = COLOR_BEIGE
	decals = list(
		"crate_stripes" = COLOR_OFF_WHITE,
		"toptext" = COLOR_GRAY20
	)

/decl/closet_appearance/crate/unathiimport
	color = COLOR_SILVER
	decals = list(
		"crate_stripe" = COLOR_RED,
		"crate_reticle" = COLOR_RED_GRAY
	)

/decl/closet_appearance/crate/veymed
	color = COLOR_OFF_WHITE
	decals = list(
		"crate_stripe" = COLOR_PALE_BTL_GREEN
	)
	extra_decals = list(
		"lid_stripes" = COLOR_RED,
		"crate_cross" = COLOR_GREEN
	)

/decl/closet_appearance/crate/ward
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"crate_stripe_left" = COLOR_COMMAND_BLUE,
		"crate_stripe_right" = COLOR_COMMAND_BLUE,
		"hazard" = COLOR_OFF_WHITE,
		"wt" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/xion
	color = COLOR_ORANGE
	extra_decals = list(
		"crate_stripes" = COLOR_OFF_WHITE,
		"xion" = COLOR_OFF_WHITE,
		"hazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/zenghu
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"crate_stripes" = COLOR_RED,
		"zenghu" = COLOR_OFF_WHITE
	)

// Secure Crates

/decl/closet_appearance/crate/secure
	can_lock = TRUE

/decl/closet_appearance/crate/secure/hazard
	color = COLOR_NT_RED
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripe_right" = COLOR_OFF_WHITE,
		"toxin" = COLOR_OFF_WHITE,
		"nano" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/weapon
	color = COLOR_GREEN_GRAY
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripe_right" = COLOR_OFF_WHITE,
		"hazard" = COLOR_OFF_WHITE
	)

// Secure corporate branding

/decl/closet_appearance/crate/secure/aether
	color = COLOR_YELLOW_GRAY
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripes" = COLOR_BLUE_LIGHT,
		"aether" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/bishop
	color = COLOR_OFF_WHITE
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_SKY_BLUE,
		"crate_stripe_right" = COLOR_SKY_BLUE,
		"bishop" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/cybersolutions
	color = COLOR_ALUMINIUM
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"hazard" = COLOR_DARK_GOLD,
		"toptext" = COLOR_DARK_GOLD
	)

/decl/closet_appearance/crate/secure/einstein
	color = COLOR_DARK_BLUE_GRAY
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_BEIGE,
		"crate_stripe_right" = COLOR_BEIGE,
		"einstein" = COLOR_OFF_WHITE,
		"hazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/focalpoint
	color = COLOR_GOLD
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_NAVY_BLUE,
		"crate_stripe_right" = COLOR_NAVY_BLUE,
		"focal" = COLOR_OFF_WHITE,
		"hazard" = COLOR_NAVY_BLUE
	)

/decl/closet_appearance/crate/secure/gilthari
	color = COLOR_GRAY20
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_GOLD,
		"crate_stripe_right" = COLOR_GOLD,
		"hazard" = COLOR_OFF_WHITE,
		"gilthari" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/grayson
	color = COLOR_STEEL
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_MAROON,
		"crate_stripe_right" = COLOR_MAROON,
		"grayson" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/hedberg
	color = COLOR_GREEN_GRAY
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripe_right" = COLOR_OFF_WHITE,
		"hazard" = COLOR_OFF_WHITE,
		"hedberg" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/heph
	color = COLOR_GRAY20
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_NT_RED,
		"crate_stripe_right" = COLOR_NT_RED,
		"hazard" = COLOR_OFF_WHITE,
		"heph" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/lawson
	color = COLOR_SAN_MARINO_BLUE
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripe_right" = COLOR_OFF_WHITE,
		"hazard" = COLOR_OFF_WHITE,
		"lawson" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/morpheus
	color = COLOR_ALUMINIUM
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"hazard" = COLOR_GUNMETAL,
		"toptext" = COLOR_GUNMETAL
	)

/decl/closet_appearance/crate/secure/nanotrasen
	color = COLOR_NT_RED
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripe_right" = COLOR_OFF_WHITE,
		"nano" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/nanotrasenmedical
	color = COLOR_OFF_WHITE
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe" = COLOR_NT_RED,
		"nano" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/saare
	color = COLOR_ALUMINIUM
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"hazard" = COLOR_RED,
		"xion" = COLOR_GRAY40
	)

/decl/closet_appearance/crate/secure/solgov
	color = COLOR_SAN_MARINO_BLUE
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_OFF_WHITE,
		"crate_stripes" = COLOR_OFF_WHITE,
		"hazard" = COLOR_OFF_WHITE,
		"scg" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/veymed
	color = COLOR_OFF_WHITE
	decals = list(
		"crate_bracing",
		"crate_stripe" = COLOR_PALE_BTL_GREEN
	)
	extra_decals = list(
		"lid_stripes" = COLOR_RED,
		"crate_cross" = COLOR_GREEN
	)

/decl/closet_appearance/crate/secure/ward
	color = COLOR_OFF_WHITE
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripe_left" = COLOR_COMMAND_BLUE,
		"crate_stripe_right" = COLOR_COMMAND_BLUE,
		"hazard" = COLOR_OFF_WHITE,
		"wt" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/xion
	color = COLOR_ORANGE
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripes" = COLOR_OFF_WHITE,
		"xion" = COLOR_OFF_WHITE,
		"hazard" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/zenghu
	color = COLOR_OFF_WHITE
	decals = list(
		"crate_bracing"
	)
	extra_decals = list(
		"crate_stripes" = COLOR_RED,
		"zenghu" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/crate/secure/hydroponics
	extra_decals = list(
		"crate_stripe_left" = COLOR_GREEN_GRAY,
		"crate_stripe_right" = COLOR_GREEN_GRAY
	)

/decl/closet_appearance/crate/secure/shuttle
	extra_decals = list(
		"crate_stripe_left" = COLOR_YELLOW_GRAY,
		"crate_stripe_right" = COLOR_YELLOW_GRAY
	)

// Large crates.
/decl/closet_appearance/large_crate
	base_icon =  'icons/obj/closets/bases/large_crate.dmi'
	decal_icon = 'icons/obj/closets/decals/large_crate.dmi'
	decals = null
	extra_decals = null
	door_anim_time = 0

/decl/closet_appearance/large_crate/critter
	color = COLOR_BEIGE
	decals = list(
		"airholes"
	)
	extra_decals = list(
		"oxy" = COLOR_WHITE
	)

/decl/closet_appearance/large_crate/hydroponics
	extra_decals = list(
		"stripes" = COLOR_GREEN_GRAY,
		"text" = COLOR_GREEN_GRAY
	)

/decl/closet_appearance/large_crate/aether
	color = COLOR_YELLOW_GRAY
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"text" = COLOR_BLUE_LIGHT
	)

/decl/closet_appearance/large_crate/einstein
	color = COLOR_DARK_BLUE_GRAY
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"text" = COLOR_BEIGE
	)

/decl/closet_appearance/large_crate/nanotrasen
	color = COLOR_NT_RED
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"text" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/large_crate/xion
	color = COLOR_ORANGE
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"text" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/large_crate/secure
	can_lock = TRUE

/decl/closet_appearance/large_crate/secure/hazard
	color = COLOR_NT_RED
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"marking" = COLOR_OFF_WHITE,
		"text_upper" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/large_crate/secure/aether
	color = COLOR_YELLOW_GRAY
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"marking" = COLOR_OFF_WHITE,
		"text_upper" = COLOR_BLUE_LIGHT
	)

/decl/closet_appearance/large_crate/secure/einstein
	color = COLOR_DARK_BLUE_GRAY
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"marking" = COLOR_OFF_WHITE,
		"text_upper" = COLOR_BEIGE
	)

/decl/closet_appearance/large_crate/secure/heph
	color = COLOR_GRAY20
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"marking" = COLOR_NT_RED,
		"text_upper" = COLOR_NT_RED
	)

/decl/closet_appearance/large_crate/secure/xion
	color = COLOR_ORANGE
	decals = list(
		"crate_bracing"
	 )
	extra_decals = list(
		"marking" = COLOR_OFF_WHITE,
		"text_upper" = COLOR_OFF_WHITE
	)

// Cabinets.
/decl/closet_appearance/cabinet
	base_icon =  'icons/obj/closets/bases/cabinet.dmi'
	decal_icon = null
	color = WOOD_COLOR_RICH
	decals = null
	extra_decals = null
	door_anim_time = 0

/decl/closet_appearance/cabinet/secure
	can_lock = TRUE

// Wall lockers.
/decl/closet_appearance/wall
	base_icon =  'icons/obj/closets/bases/wall.dmi'
	decal_icon = 'icons/obj/closets/decals/wall.dmi'
	decals = list(
		"vent"
	)
	extra_decals = null
	door_anim_time = 0

/decl/closet_appearance/wall/emergency
	color = COLOR_LIGHT_CYAN
	decals = null
	extra_decals = list(
		"glass" = COLOR_WHITE
	)

/decl/closet_appearance/wall/medical
	decals = null
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_outer" = COLOR_BLUE_GRAY,
		"stripe_inner" = COLOR_OFF_WHITE,
		"cross" = COLOR_BLUE_GRAY
	)

/decl/closet_appearance/wall/shipping
	color = COLOR_WARM_YELLOW
	decals = null
	extra_decals = list(
		"stripes" = COLOR_BEASTY_BROWN,
		"glass" = COLOR_WHITE
	)

/decl/closet_appearance/wall/hydrant
	color = COLOR_RED_LIGHT
	decals = null
	extra_decals = list(
		"stripes" = COLOR_OFF_WHITE,
		"glass" = COLOR_WHITE
	)

// Wall cabinets
/decl/closet_appearance/wall_double
	base_icon =  'icons/obj/closets/bases/wall_double.dmi'
	decal_icon = 'icons/obj/closets/decals/wall_double.dmi'
	decals = list(
		"vent"
	)
	extra_decals = null
	door_anim_time = 0

/decl/closet_appearance/wall_double/kitchen
	decals = null
	color = COLOR_OFF_WHITE

/decl/closet_appearance/wall_double/wooden
	decals = null
	color = WOOD_COLOR_RICH

/decl/closet_appearance/wall_double/medical
	decals = null
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_outer" = COLOR_BLUE_GRAY,
		"stripe_inner" = COLOR_OFF_WHITE,
		"cross" = COLOR_BLUE_GRAY
	)

/decl/closet_appearance/wall_double/fire_safety
	color = COLOR_RED_LIGHT
	decals = null
	extra_decals = list(
		"stripes" = COLOR_OFF_WHITE,
		"glass" = COLOR_WHITE
	)

/decl/closet_appearance/wall_double/survival
	color = COLOR_CYAN_BLUE
	decals = null
	extra_decals = list(
		"stripe_outer" = COLOR_WHITE
	)

/decl/closet_appearance/wall_double/emergency_engi
	color = COLOR_YELLOW_GRAY
	decals = null
	extra_decals = list(
		"stripe_inner" = COLOR_ORANGE,
		"stripe_outer" = COLOR_OFF_WHITE,
		"glass" = COLOR_WHITE
	)

/decl/closet_appearance/wall_double/security
	color = COLOR_NT_RED
	decals = null
	extra_decals = list(
		"vertical_stripe_left_l" = COLOR_WARM_YELLOW,
		"vertical_stripe_left_m" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/wall_double/cargo
	color = COLOR_WARM_YELLOW

/decl/closet_appearance/wall_double/gaming
	color = COLOR_DARK_BLUE_GRAY
	decals = null
	extra_decals = list(
		"stripe_outer" = COLOR_PALE_PINK,
		"glass" = COLOR_WHITE
	)

/decl/closet_appearance/wall_double/science
	decals = list(
		"holes"
	)
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"stripe_inner_lower" = COLOR_PURPLE,
		"stripe_inner_middle" = COLOR_PURPLE
	)

/decl/closet_appearance/wall_double/command
	decals = list(
		"holes_right"
	)
	color = COLOR_BLUE_GRAY
	extra_decals = list(
		"vertical_stripe_left_l" = COLOR_GOLD,
		"vertical_stripe_left_m" = COLOR_GOLD,
		"vertical_stripe_left_r" = COLOR_GOLD
	)

/decl/closet_appearance/wall_double/ce
	decals = list(
		"holes_right"
	)
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"vertical_stripe_left_l" = COLOR_DARK_GOLD,
		"vertical_stripe_left_m" = COLOR_DARK_GOLD,
		"vertical_stripe_left_r" = COLOR_DARK_GOLD
	)

/decl/closet_appearance/wall_double/rd
	decals = list(
		"holes_right"
	)
	color = COLOR_OFF_WHITE
	extra_decals = list(
		"vertical_stripe_left_l" = COLOR_PURPLE,
		"vertical_stripe_left_m" = COLOR_GOLD,
		"vertical_stripe_left_r" = COLOR_PURPLE
	)

/decl/closet_appearance/wall_double/cmo
	decals = list(
		"holes_right"
	)
	color = COLOR_BABY_BLUE
	extra_decals = list(
		"vertical_stripe_left_l" = COLOR_GOLD,
		"vertical_stripe_left_m" = COLOR_GOLD,
		"vertical_stripe_left_r" = COLOR_GOLD
	)

/decl/closet_appearance/wall_double/hos
	decals = list(
		"holes_right"
	)
	color = COLOR_NT_RED
	extra_decals = list(
		"vertical_stripe_left_l" = COLOR_GOLD,
		"vertical_stripe_left_m" = COLOR_WARM_YELLOW,
		"vertical_stripe_left_r" = COLOR_GOLD
	)

/decl/closet_appearance/wall_double/iaa
	decals = list(
		"holes_right"
	)
	color = COLOR_DARK_BLUE_GRAY
	extra_decals = list(
		"vertical_stripe_left_l" = COLOR_GOLD,
		"vertical_stripe_left_m" = COLOR_GOLD,
		"vertical_stripe_left_r" = COLOR_GOLD
	)

/decl/closet_appearance/wall_double/engineering
	decals = list(
		"holes"
	)
	color = COLOR_YELLOW_GRAY

/decl/closet_appearance/wall_double/generic_civ
	color = COLOR_DARK_BLUE_GRAY

/decl/closet_appearance/wall_double/casino
	color = COLOR_GRAY20
	decals = null
	extra_decals = list(
		"stripe_outer" = COLOR_GOLD,
		"stripe_inner" = COLOR_ORANGE,
		"thaler" = COLOR_GREEN
	)

// Carts
/decl/closet_appearance/cart
	color = COLOR_GRAY20
	base_icon =  'icons/obj/closets/bases/cart.dmi'
	decal_icon = 'icons/obj/closets/decals/cart.dmi'
	decals = null
	extra_decals = null
	door_anim_time = 0

/decl/closet_appearance/cart/trash
	color = COLOR_BOTTLE_GREEN

/decl/closet_appearance/cart/biohazard
	can_lock = TRUE
	decals = list(
		"biohazard" = COLOR_GRAY80
	)

/decl/closet_appearance/cart/biohazard/alt
	color = COLOR_SURGERY_BLUE
	decals = list(
		"biohazard" = COLOR_RED_GRAY
	)

// From the Torch
/decl/closet_appearance/secure_closet/exploration // These three renamed since Polaris actually uses these
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_PURPLE,
		"exped" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/exploration/pilot
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"exped" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/exploration/pathfinder
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"exped" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/command
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/command/bo
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/command/xo
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_CLOSET_GOLD,
		"command" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/command/co
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_mid_full" = COLOR_OFF_WHITE,
		"stripe_vertical_right_full" = COLOR_CLOSET_GOLD,
		"command" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/torch/engineering
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_WARM_YELLOW,
		"exped" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/torch/engineering/atmos
	extra_decals = list(
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_mid_full" = COLOR_CYAN_BLUE,
		"atmos_upper" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/torch/engineering/se
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"exped" = COLOR_WARM_YELLOW
	)

/decl/closet_appearance/secure_closet/torch/engineering/ce
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"exped" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/medical
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_BABY_BLUE
	)

/decl/closet_appearance/secure_closet/torch/medical/physician
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BABY_BLUE,
		"stripe_vertical_right_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_BABY_BLUE
	)

/decl/closet_appearance/secure_closet/torch/medical/cmo
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BABY_BLUE,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/sol
	color = COLOR_BABY_BLUE
	extra_decals = list(
		"stripe_vertical_mid_full" =  COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/torch/sol/rep
	color = COLOR_BABY_BLUE
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_OFF_WHITE,
		"stripe_vertical_right_full" =  COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/torch/corporate
	color = COLOR_BOTTLE_GREEN
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/torch/corporate/liaison
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_OFF_WHITE,
		"stripe_vertical_right_full" = COLOR_OFF_WHITE,
		"command" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/torch/science
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_PURPLE_GRAY,
		"stripe_vertical_right_full" = COLOR_PURPLE_GRAY,
		"research" = COLOR_PURPLE_GRAY
	)

/decl/closet_appearance/secure_closet/torch/science/cso
	color = COLOR_BOTTLE_GREEN
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_GOLD,
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"research" = COLOR_GOLD
	)

/decl/closet_appearance/secure_closet/torch/security
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_NT_RED,
		"security" = COLOR_NT_RED
	)

/decl/closet_appearance/secure_closet/torch/security/forensics
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_NT_RED,
		"forensics" = COLOR_NT_RED
	)

/decl/closet_appearance/secure_closet/torch/security/warden
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_NT_RED,
		"stripe_vertical_right_full" = COLOR_NT_RED,
		"security" = COLOR_NT_RED
	)

/decl/closet_appearance/secure_closet/torch/security/hos
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_NT_RED,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_NT_RED,
		"security" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/hydroponics
	extra_decals = list(
		"stripe_vertical_right_partial" = COLOR_GREEN_GRAY,
		"stripe_vertical_mid_partial" =   COLOR_GREEN_GRAY,
		"hydro" = COLOR_GREEN_GRAY
	)

/decl/closet_appearance/secure_closet/torch/cargo
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/torch/cargo/worker
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BEASTY_BROWN,
		"stripe_vertical_right_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/torch/cargo/deck_officer
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_left_full" = COLOR_BEASTY_BROWN,
		"stripe_vertical_right_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_CLOSET_GOLD
	)