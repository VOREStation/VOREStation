#define UNDERWATER_CASINO_NAME "Casino Canal"

// ****** OBJECTS ******

// Different type of chip machine that gives visitors a set amount of chips to start with.
// No pay-to-win here - One free use per ckey!
/obj/machinery/oneuse_chipmachine
	name = "automated chip dispenser"
	desc = "A curious device that dispenses a set amount of chips to each visitor one time, and one time only."
	icon = 'icons/obj/casino.dmi'
	icon_state = "chipmachine"
	anchored = 1
	var/list/used_ckeys = list() // Players who have already received their chips.
	var/amt_chips_to_dispense = 250
	var/speaking = FALSE // Whether or not we are saying one message (to prevent overlap)

/obj/machinery/oneuse_chipmachine/proc/state_message(var/message, var/delay=0)
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!delay)
		speaking = FALSE
		playsound(loc, 'sound/voice/emotes/wawa.ogg', 50, 1)
		audible_message("[icon2html(src,hearers(src))] [span_bold("\The [src]")] states, \"[message]\"", runemessage = "wawa")
	else
		speaking = TRUE
		addtimer(CALLBACK(src, PROC_REF(state_message), message), delay, TIMER_DELETE_ME)


/obj/machinery/oneuse_chipmachine/attackby(obj/item/W, mob/user, attack_modifier, click_parameters)
	if(!speaking)
		if(istype(W,/obj/item/spacecash))
			state_message("Our apologies, but the [UNDERWATER_CASINO_NAME] does not accept payments of any kind. We ask only for your enjoyment of our games and facilities.")
			state_message("Instead, please extend an empty hand before this machine. If this is your first time using this machine this shift, we will provide you with a set of starting chips.", 3 SECONDS)
		if(istype(W,/obj/item/spacecasinocash))
			state_message("Our apologies, but the [UNDERWATER_CASINO_NAME] does not convert chips to money.")
			state_message("We do not require money to run our facilities. By that same token, you do not need money to enjoy them.", 3 SECONDS)

/obj/machinery/oneuse_chipmachine/attack_hand(mob/user)
	if(user.ckey in used_ckeys)
		if(!speaking)
			state_message("You have already received your chips for this shift.")
			state_message("The [UNDERWATER_CASINO_NAME] allows only [amt_chips_to_dispense] chips to be given per visitor, regardless of financial status.", 3 SECONDS)
	else
		spawn_casinochips(amt_chips_to_dispense, src.loc, user)
		playsound(loc, 'sound/items/vending.ogg', 50, 1)
		state_message("Thank you for visiting the [UNDERWATER_CASINO_NAME]. Please accept these complementary chips and enjoy your stay.", 1 SECONDS)
		used_ckeys += user.ckey

// ****** AREAS ******

/area/redgate/casinocanal
	name = "Casino Canal"
	requires_power = FALSE
	dynamic_lighting = TRUE
	flags = RAD_SHIELDED
	base_turf = /turf/simulated/floor/water/underwater
