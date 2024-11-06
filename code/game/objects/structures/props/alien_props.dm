// These contain structures to make certain 'alien' (as in the ayyy ones, not xenomorphs) submaps more filled, and don't really do anything.

/obj/structure/prop/alien
	name = "some alien thing"
	desc = "My description is broken, bug a developer."
	icon = 'icons/obj/abductor.dmi'
	density = TRUE
	anchored = TRUE

/obj/structure/prop/alien/computer
	name = "alien console"
	desc = "The console flashes what appear to be symbols you've never seen before."
	icon_state = "console-c"
	interaction_message = span_warning("The console flashes a series of unknown symbols as you press a button on what is presumably a keyboard. It probably some sort of \
	authentication error. Since you're not an alien, you should probably leave it alone.")

/obj/structure/prop/alien/computer/camera
	desc = "This console is briefly flashing video feeds of various locations close by."
	icon_state = "camera"

/obj/structure/prop/alien/computer/camera/flipped
	icon_state = "camera_flipped"

/obj/structure/prop/alien/dispenser
	name = "alien dispenser"
	desc = "This looks like it dispenses... something?"
	icon_state = "dispenser"
	interaction_message = span_warning("You don't see any mechanism to operate this. Probably for the best.")

/obj/structure/prop/alien/pod
	name = "alien pod"
	desc = "This seems to be a container for something."
	icon_state = "experiment"
	interaction_message = span_warning("You don't see any mechanism to open this thing. Probably for the best.")

/obj/structure/prop/alien/pod/open
	name = "opened alien pod"
	desc = "At one point, this probably contained something interesting..."
	icon_state = "experiment-open"
	interaction_message = span_warning("You don't see any mechanism to close this thing.")


// Obtained by scanning both a void core and void cell.
// The reward is a good chunk of points and some faulty physics wank.
/datum/category_item/catalogue/anomalous/precursor_a/alien_void_power
	name = "Precursor Alpha Technology - Void Power"
	desc = "Several types of precursor objects observed so far appear to be driven by electricity, however the \
	source appears to be from self contained objects, with no apparent means of generation being visible.\
	To anyone with a basic understanding of physics, that should not be possible, due to appearing to be a \
	perpetual motion machine.\
	<br><br>\
	This phenomenon has been given the term 'void power' by this device, until adaquate information becomes available. \
	Several possible explainations exists for this behaviour;\
	<br>\
	<ul>\
		<li>* These objects do, in fact, power themselves for free, and the modern understanding of the physical world \
		 is in fact incorrect. This is the most obvious answer, but it is very unlikely to be true.</li>\
		<li>* The objects draw from an unknown source of energy that exists at all points in space, or at least where the \
		void powered machine was found, that presently cannot be detected or determined, and converts that energy into electrical energy \
		to drive the machine it is inside of.</li>\
		<li>* The objects appear to power themselves, but are actually giving the appearance of being a closed system, when instead \
		an unknown, external object or machine is transferring power through an unknown means to the primary system being \
		powered, acting as a non-physical conduit. This might be the most likely explaination, however it would open many new \
		questions as well, such as how the hypothesized external machine is able to transfer power without any physical \
		interactions inbetween, or the distance between the true source of power and the void powered object, which  could \
		be vast, possibly across star systems or even originating from outside the galaxy.</li>\
	</ul>\
	Regardless of the method, it is remarkable how the electrical systems have resisted entrophy and remained functional to this day. \
	Unfortunately, the extreme rarity of these objects, combined with small throughput, means that humanity will not become a \
	post-scarcity civilization from this discovery, but instead might have a few permanent flashlights."
	unlocked_by_all = list(
		/datum/category_item/catalogue/anomalous/precursor_a/alien_void_core,
		/datum/category_item/catalogue/anomalous/precursor_a/alien_void_cell
		)
	value = CATALOGUER_REWARD_MEDIUM


/datum/category_item/catalogue/anomalous/precursor_a/alien_void_core
	name = "Precursor Alpha Object - Void Core"
	desc = "This is a very enigmatic machine. Scans show that electricity is being outputted from inside \
	of it, and being distributed to its environment, however no apparent method of power generation \
	appears to exist inside the machine. This ability also appears to be shared with certain other \
	kinds of machines made by this species.\
	<br><br>\
	Scanning similar objects may yield more information."
	value = CATALOGUER_REWARD_EASY

/obj/structure/prop/alien/power
	name = "void core"
	icon_state = "core"
	desc = "An alien machine that seems to be producing energy seemingly out of nowhere."
	interaction_message = span_warning("Messing with something that makes energy out of nowhere seems very unwise.")
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_void_core)

/obj/item/prop/alien
	name = "some alien item"
	desc = "My description is broken, bug a developer."
	icon = 'icons/obj/abductor.dmi'

// Mostly useless. Research might like it, however.
/obj/item/prop/alien/junk
	name = "alien object"
	desc = "You have no idea what this thing does."
	icon_state = "health"
	w_class = ITEMSIZE_SMALL
	var/static/list/possible_states = list("health", "spider", "slime", "emp", "species", "egg", "vent", "mindshock", "viral", "gland")
	var/static/list/possible_tech = list(TECH_MATERIAL, TECH_ENGINEERING, TECH_PHORON, TECH_POWER, TECH_BIO, TECH_COMBAT, TECH_MAGNET, TECH_DATA)

/obj/item/prop/alien/junk/Initialize()
	. = ..()
	icon_state = pick(possible_states)
	var/list/techs = possible_tech.Copy()
	origin_tech = list()
	for(var/i = 1 to rand(1, 4))
		var/new_tech = pick(techs)
		techs -= new_tech
		origin_tech[new_tech] = rand(5, 9)

	origin_tech[TECH_PRECURSOR] = rand(0,2)

/obj/item/prop/alien/phasecoil
	name = "reverberating device"
	desc = "A device pulsing with an ominous energy."
	icon_state = "circuit_phase"
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_PHORON = 3, TECH_POWER = 5, TECH_MAGNET = 5, TECH_DATA = 5, TECH_PRECURSOR = 2, TECH_ARCANE = 1)
