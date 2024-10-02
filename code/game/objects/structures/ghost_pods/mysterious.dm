/obj/structure/ghost_pod/manual/corgi
	name = "glowing rune"
	desc = "This rune slowly lights up and goes dim in a repeating pattern, like a slow heartbeat. It's almost as if it's calling out to you to touch it..."
	description_info = "This will summon some manner of creature through quite dubious means. The creature will be controlled by a player."
	icon_state = "corgirune"
	icon_state_opened = "corgirune-inert"
	density = FALSE
	anchored = TRUE
	ghost_query_type = /datum/ghost_query/corgi_rune
	confirm_before_open = TRUE

/obj/structure/ghost_pod/manual/corgi/trigger()
	..(span_warning("\The [usr] places their hand on the rune!"), "is attempting to summon a corgi.")

/obj/structure/ghost_pod/manual/corgi/create_occupant(var/mob/M)
	lightning_strike(get_turf(src), cosmetic = TRUE)
	density = FALSE
	var/mob/living/simple_mob/animal/passive/dog/corgi/R = new(get_turf(src))
	if(M.mind)
		M.mind.transfer_to(R)
	to_chat(M, span_notice("You are a <b>Corgi</b>! Woof!"))
	R.ckey = M.ckey
	visible_message(span_warning("With a bright flash of light, \the [src] disappears, and in its place stands a small corgi."))
	log_and_message_admins("successfully touched \a [src] and summoned a corgi.")
	..()

/obj/structure/ghost_pod/manual/cursedblade
	name = "abandoned blade"
	desc = "A red crystal blade that someone jammed deep into a stone. If you try hard enough, you might be able to remove it."
	icon_state = "soulblade-embedded"
	icon_state_opened = "soulblade-released"
	density = TRUE
	anchored = TRUE
	ghost_query_type = /datum/ghost_query/cursedblade
	confirm_before_open = TRUE

/obj/structure/ghost_pod/manual/cursedblade/trigger()
	..(span_warning("\The [usr] attempts to pull out the sword!"), "is activating a cursed blade.")

/obj/structure/ghost_pod/manual/cursedblade/create_occupant(var/mob/M)
	density = FALSE
	var/obj/item/melee/cursedblade/R = new(get_turf(src))
	to_chat(M, "<span class='notice'>You are a <b>Cursed Sword</b>, discovered by a hapless explorer. \
	You were once an explorer yourself, when one day you discovered a strange sword made from a red crystal. As soon as you touched it,\
	your body was reduced to ashes and your soul was cursed to remain trapped in the blade forever. \
	Now it is up to you to decide whether you want to be a faithful companion, or a bitter prisoner of the blade.</span>")
	R.ghost_inhabit(M)
	visible_message(span_warning("The blade shines brightly for a brief moment as [usr] pulls it out of the stone!"))
	log_and_message_admins("successfully acquired a cursed sword.")
	..()
