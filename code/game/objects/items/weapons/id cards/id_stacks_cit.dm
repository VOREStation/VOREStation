// This is a defines file for card sprite stacks. If a new card set comes in, this file can just be disabled and a new one made to match the new sprites.
// Generally, if the icon file is card_xxx.dmi, this filename should be sprite_stacks_xxx.dm
// Please make sure that only the relevant sprite_stacks_xxx.file is included, if more are made.



/obj/item/weapon/card
	icon = 'icons/obj/card_new.dmi' // These are redefined here so that changing sprites is as easy as clicking the checkbox.
	base_icon = "icons/obj/card_new.dmi"

	// New sprite stacks can be defined here. You could theoretically change icon-states as well but right now this file compiles before station_ids.dm so those wouldn't be affected.
	id
		centcom
			initial_sprite_stack = list("base-stamp", "top-blue", "dept-nanotrasen", "letter-n-command", "pips-gold")
			vip
				initial_sprite_stack = list("base-stamp-gold", "top-blue", "dept-vip-gold", "letter-n-command", "pips-gold")
			ERT
				initial_sprite_stack = list("base-stamp", "top-dark", "dept-nanotrasen", "letter-n-command")
		silver
			initial_sprite_stack = list("base-stamp-silver", "top-mime", "letter-n-generic")
			secretary
				initial_sprite_stack = list("base-stamp", "top-blue", "dept-secretary", "letter-n-command")
			hop
				initial_sprite_stack = list("base-stamp-silver", "top-blue", "dept-hop", "letter-n-command", "pips-gold")
		medical
			initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "letter-n-medical")
			chemist
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "letter-n-medical", "pips-engineering")
			geneticist
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "letter-n-medical", "pips-science")
			psych
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "letter-n-medical", "pips-science")
			emt
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-medical", "letter-n-medical", "pips-command")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-medblu", "dept-medical", "letter-n-command", "pips-gold")
			sar
				initial_sprite_stack = list("base-stamp", "top-medblu", "dept-exploration", "letter-n-command", "pips-command")
		security
			initial_sprite_stack = list("base-stamp", "top-red", "dept-security", "letter-n-security")
			detective
				initial_sprite_stack = list("base-stamp", "top-red", "dept-security", "letter-n-security", "pips-cargo")
			warden
				initial_sprite_stack = list("base-stamp", "top-red", "dept-security", "letter-n-security", "pips-command")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-red", "dept-security", "letter-n-command", "pips-gold")
		engineering
			initial_sprite_stack = list("base-stamp", "top-orange", "dept-engineering", "letter-n-engineering")
			atmos
				initial_sprite_stack = list("base-stamp", "top-orange", "dept-engineering", "pips-medical", "letter-n-engineering")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-orange", "dept-engineering", "letter-n-command", "pips-gold")
		science
			initial_sprite_stack = list("base-stamp", "top-purple", "dept-science", "letter-n-science")
			roboticist
				initial_sprite_stack = list("base-stamp", "top-purple", "dept-science", "letter-n-science", "pips-engineering")
			explorer
				initial_sprite_stack = list("base-stamp", "top-blue", "dept-exploration", "letter-n-command")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-purple", "dept-science", "letter-n-command", "pips-gold")
				pathfinder
					initial_sprite_stack = list("base-stamp-silver", "top-blue", "dept-exploration", "letter-n-command", "pips-gold")
		cargo
			initial_sprite_stack = list("base-stamp", "top-brown", "dept-cargo", "letter-n-cargo")
			miner
				initial_sprite_stack = list("base-stamp", "top-brown", "dept-cargo", "letter-n-cargo", "pips-science")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-brown", "dept-cargo", "letter-n-command", "pips-gold")
		civilian
			initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "letter-n-civilian")
			chaplain
				initial_sprite_stack = list("base-stamp-silver", "top-dark", "letter-cross", "pips-white")
			internal_affairs
				initial_sprite_stack = list("base-stamp", "top-green", "dept-internal-affairs", "letter-n-command")
			botanist
				initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "letter-n-civilian", "pips-cargo")
			bartender
				initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "letter-n-civilian", "pips-dark")
			chef
				initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "letter-n-civilian", "pips-white")		
			janitor
				initial_sprite_stack = list("base-stamp", "top-green", "dept-civilian", "letter-n-civilian", "pips-science")
			journalist
				initial_sprite_stack = list("base-stamp", "top-green", "dept-press", "letter-n-civilian")
			clown
				initial_sprite_stack = list("base-stamp", "top-pink", "dept-clown", "letter-n-clown")
			mime
				initial_sprite_stack = list("base-stamp", "top-white", "letter-n-mime")
			pilot
				initial_sprite_stack = list("base-stamp", "top-generic", "dept-pilot", "letter-n-command", "pips-command")
			head
				initial_sprite_stack = list("base-stamp-silver", "top-command", "letter-n-command", "pips-civilian")