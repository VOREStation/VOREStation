// This is a defines file for card sprite stacks. If a new card set comes in, this file can just be disabled and a new one made to match the new sprites.
// Generally, if the icon file is card_xxx.dmi, this filename should be sprite_stacks_xxx.dm
// Please make sure that only the relevant sprite_stacks_xxx.file is included, if more are made.

/obj/item/weapon/card
	icon = 'icons/obj/card_new.dmi' // These are redefined here so that changing sprites is as easy as clicking the checkbox.
	base_icon = "icons/obj/card_new.dmi"

	// New sprite stacks can be defined here. You could theoretically change icon-states as well but right now this file compiles before station_ids.dm so those wouldn't be affected.
	/*
	id
		generic
			initial_sprite_stack = list("base-stamp", "top-generic", "stamp-silhouette", "clip")
		centcom
			initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n", "pips-gold")
			vip
				initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n", "pips-gold")
			ERT
				initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n", "pips-red", "stripe-red")
		silver
			initial_sprite_stack = list("base-stamp-silver", "top-mime", "stamp-n-generic")
			secretary
				initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n")
			hop
				initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n", "stripe-white")
		medical
			initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n")
			chemist
				initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "pips-orange")
			geneticist
				initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "pips-purple")
			psych
				initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "pips-purple")
			emt
				initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "pips-blue")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-medblu", "stamp-n", "stripe-gold")
			sar
				initial_sprite_stack = list("base-stamp", "top-darkgreen", "stamp-n", "pips-medblu")
		security
			initial_sprite_stack = list("base-stamp", "top-red", "stamp-n")
			detective
				initial_sprite_stack = list("base-stamp", "top-red", "stamp-n", "pips-brown")
			warden
				initial_sprite_stack = list("base-stamp", "top-red", "stamp-n", "pips-white")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-red", "stamp-n", "stripe-gold")
		engineering
			initial_sprite_stack = list("base-stamp", "top-orange", "stamp-n")
			atmos
				initial_sprite_stack = list("base-stamp", "top-orange", "pips-medblu", "stamp-n")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-orange", "stamp-n", "stripe-gold")
		science
			initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n")
			roboticist
				initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n", "pips-orange")
			explorer
				initial_sprite_stack = list("base-stamp", "top-darkgreen", "stamp-n")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-purple", "stamp-n", "stripe-gold")
				pathfinder
					initial_sprite_stack = list("base-stamp-silver", "top-darkgreen", "stamp-n", "pips-purple") //not a true head, no gold stripe for you
		cargo
			initial_sprite_stack = list("base-stamp", "top-brown", "stamp-n")
			miner
				initial_sprite_stack = list("base-stamp", "top-brown", "stamp-n", "pips-purple")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-brown", "stamp-n", "pips-gold")
		civilian
			initial_sprite_stack = list("base-stamp", "top-green", "stamp-n")
			chaplain
				initial_sprite_stack = list("base-stamp-silver", "top-dark", "stamp-cross", "pips-white")
			internal_affairs
				initial_sprite_stack = list("base-stamp", "top-green", "stamp-n")
			botanist
				initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "pips-brown")
			bartender
				initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "pips-dark")
			chef
				initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "pips-white")
			janitor
				initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "pips-purple")
			journalist
				initial_sprite_stack = list("base-stamp", "top-green", "stamp-n")
			clown
				initial_sprite_stack = list("base-stamp", "top-rainbow", "stamp-n")
			mime
				initial_sprite_stack = list("base-stamp", "top-white", "stamp-n", "stripe-black")
			pilot
				initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "pips-blue")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "stripe-white")
		syndicate
			initial_sprite_stack = list("base-stamp-dark", "top-syndicate", "stamp-s")
			officer
				initial_sprite_stack = list("base-stamp-dark", "top-syndicate", "stamp-s", "pips-gold", "stripe-gold")
		*/ // VOREStation Removal - defined in id_stacks_vr.dm