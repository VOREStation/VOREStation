/obj/structure/prop/altevian_generator_wrecked
	name = "Phoronic Conversion System"
	desc = "A reactor system similar to the PACMAN generators seen throughout the stars. This one is a specific model created by the altevians. It seems this reactor has a way to maximize the fuel usage one would see with this kind of process. \
			However, due to its construction and size it is nearly impossible to break apart. It still can be moved if need be with special tools. This one appears to be totally wrecked though."
	icon = 'icons/obj/props/decor64x64.dmi'
	icon_state = "alteviangenwrecked"
	bound_width = 64
	bound_height = 64

/obj/structure/prop/altevian_jump_drive
	name = "Prosper-M Stellar Drive"
	desc = "A drive created by the Altevian Hegemony that focuses heavily on using Bluespace and other tactics to achieve a stable traversal between the stars. \
			This drive is commonly seen on their medium sized craft to help with logistical operations."
	icon = 'icons/obj/props/decor128x128.dmi'
	icon_state = "altevian_jump_drive"
	bound_width = 128
	bound_height = 128
	var/has_misc_overlay = TRUE

/obj/structure/prop/altevian_jump_drive/Initialize()
	.=..()
	update_icon()

/obj/structure/prop/altevian_jump_drive/update_icon()
	cut_overlays()
	if(has_misc_overlay)
		add_overlay("jump_drive_misc_anim_overlay")

/obj/structure/prop/altevian_jump_drive/active
	icon_state = "altevian_jump_drive-active"

/obj/structure/prop/altevian_jump_drive/wrecked
	icon_state = "altevian_jump_drive_wrecked"
	desc = "A drive created by the Altevian Hegemony that focuses heavily on using Bluespace and other tactics to achieve a stable traversal between the stars. \
			This drive is commonly seen on their medium sized craft to help with logistical operations. This one appears to be totally wrecked."
	has_misc_overlay = FALSE
