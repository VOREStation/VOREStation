// This is a defines file for card sprite stacks. If a new card set comes in, this file can just be disabled and a new one made to match the new sprites.
// Generally, if the icon file is card_xxx.dmi, this filename should be sprite_stacks_xxx.dm
// Please make sure that only the relevant sprite_stacks_xxx.file is included, if more are made.



/obj/item/weapon/card
	icon = 'icons/obj/card_new.dmi' // These are redefined here so that changing sprites is as easy as clicking the checkbox.
	base_icon = "icons/obj/card_new.dmi"

	// New sprite stacks can be defined here. You could theoretically change icon-states as well but right now this file compiles before station_ids.dm so those wouldn't be affected.
	id
		centcom
			initial_sprite_stack = list("base-stamp", "top-blue", "dept-nanotrasen", "stamp-n", "pips-gold")
			vip
				initial_sprite_stack = list("base-stamp-gold", "dept-vip", "top-blue", "stamp-n", "pips-gold")
			ERT
				initial_sprite_stack = list("base-stamp", "top-dark", "dept-ert", "stamp-n")
		silver
			initial_sprite_stack = list("base-stamp-silver", "top-mime", "stamp-n-generic")
			secretary
				initial_sprite_stack = list("base-stamp", "top-blue", "dept-secretary", "stamp-n")
			hop
				initial_sprite_stack = list("base-stamp-silver", "top-blue", "dept-hop", "stamp-n", "pips-gold")
		medical
			initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "stamp-n")
			chemist
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "stamp-n", "pips-engineering")
			geneticist
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "stamp-n", "pips-science")
			psych
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "stamp-n", "pips-science")
			emt
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "stamp-n", "pips-command")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-medblu", "dept-medical", "stamp-n", "pips-gold")
			sar
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-exploration", "stamp-n", "pips-command")
		security
			initial_sprite_stack = list("base-stamp", "top-red", "dept-security", "stamp-n")
			detective
				initial_sprite_stack = list("base-stamp", "top-red", "dept-security", "stamp-n", "pips-cargo")
			warden
				initial_sprite_stack = list("base-stamp", "top-red", "dept-security", "stamp-n", "pips-command")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-red", "dept-security", "stamp-n", "pips-gold")
		engineering
			initial_sprite_stack = list("base-stamp", "top-orange", "dept-engineering", "stamp-n")
			atmos
				initial_sprite_stack = list("base-stamp", "top-orange", "dept-engineering", "pips-medical", "stamp-n")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-orange", "dept-engineering", "stamp-n", "pips-gold")
		science
			initial_sprite_stack = list("base-stamp", "top-purple", "dept-science", "stamp-n")
			roboticist
				initial_sprite_stack = list("base-stamp", "top-purple", "dept-science", "stamp-n", "pips-engineering")
			explorer
				initial_sprite_stack = list("base-stamp", "top-blue", "dept-exploration", "stamp-n")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-purple", "dept-science", "stamp-n", "pips-gold")
				pathfinder
					initial_sprite_stack = list("base-stamp-silver", "top-blue", "dept-exploration", "stamp-n", "pips-gold")
		cargo
			initial_sprite_stack = list("base-stamp", "top-brown", "dept-cargo", "stamp-n")
			miner
				initial_sprite_stack = list("base-stamp", "top-brown", "dept-cargo", "stamp-n", "pips-science")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-brown", "dept-cargo", "stamp-n", "pips-gold")
		civilian
			initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "stamp-n")
			chaplain
				initial_sprite_stack = list("base-stamp-silver", "top-dark", "letter-cross", "pips-white")
			internal_affairs
				initial_sprite_stack = list("base-stamp", "top-green", "dept-internal-affairs", "stamp-n")
			botanist
				initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "stamp-n", "pips-cargo")
			bartender
				initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "stamp-n", "pips-dark")
			chef
				initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "stamp-n", "pips-white")		
			janitor
				initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "stamp-n", "pips-science")
			journalist
				initial_sprite_stack = list("base-stamp", "top-green", "dept-press", "stamp-n")
			clown
				initial_sprite_stack = list("base-stamp", "top-pink", "dept-clown", "stamp-n")
			mime
				initial_sprite_stack = list("base-stamp", "top-white", "stamp-n-mime")
			pilot
				initial_sprite_stack = list("base-stamp", "top-generic", "dept-pilot", "stamp-n", "pips-command")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-command", "stamp-n", "pips-civilian")