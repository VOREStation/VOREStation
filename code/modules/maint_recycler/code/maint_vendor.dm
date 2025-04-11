/obj/machinery/maint_vendor
	name = "decrepit machine"
	desc = "A long since abandoned \"trash 4 cash\" rewards kiosk. Now featuring a state of the art, monochrome holographic tube display!"
	icon = 'code/modules/maint_recycler/icons/maint_vendor.dmi'
	icon_state = "default"

	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10

	description_info = "With the points you get from another, similar machine in maint - you can redeem various goodies! Nothing important, but fun stuff!"
	description_fluff = "While RSG's \"Trash 4 Cash\" recycling campaign came to an end decades ago, the underlying systems still work as well as ever thanks to an underground network of mega-dweebs and other assorted idiots maintaining it."

	//wide sprite
	pixel_x = -8

	var/item_creation_energy_use = 400 //old and clunky

	var/list/product_datums = list() //assoc list of obj spawn type to datum

	var/is_on = FALSE
	var/light_range_on = 2
	var/light_power_on = 1

	light_color = "#0f8f0f"

	var/obj/effect/overlay/recycler/monitor_screen

/obj/machinery/maint_vendor/fall_apart(var/severity = 3, var/scatter = TRUE)
	return FALSE //don't fall apart. you can't fall apart if you don't consent. it works irl too.

/obj/machinery/maint_vendor/dismantle()
	return FALSE //we don't want something as important as this to be able to be disassembled. it's a scene tool, technically.

/obj/machinery/maint_vendor/Initialize(mapload)
	. = ..()
	for(var/t in subtypesof(/datum/maint_recycler_vendor_entry) - /datum/maint_recycler_vendor_entry)
		var/datum/maint_recycler_vendor_entry/entry = new t()
		entry.initialize()
		product_datums += entry
	//move to relevant location
	monitor_screen = new
	monitor_screen.plane = PLANE_LIGHTING_ABOVE
	monitor_screen.layer = src.layer + 0.1
	monitor_screen.icon = src.icon
	monitor_screen.icon_state = "screen_off"

	src.vis_contents |= monitor_screen

/obj/machinery/maint_vendor/power_change()
	update_icon()
	//update icon, remove overlay

/obj/machinery/maint_vendor/attack_hand(mob/user)
	if(..(user))
		return

	add_fingerprint(user)
	tgui_interact(user)

	if(!is_on)
		setOnState(TRUE)



/obj/machinery/maint_vendor/proc/attempt_purchase(var/mob/user, var/datum/maint_recycler_vendor_entry/entry)
	if(!istype(entry))
		return
	if(entry.purchased_by == null)
		entry.purchased_by = list()
	if(!entry.purchased_by[user.client.ckey])
		entry.purchased_by[user.client.ckey] = 0
	if(!can_user_purchase(user,entry))
		return


	dispense_item_from_datum(user,entry)
	credit_user(user,-entry.item_cost)
	entry.purchased_by[user.client.ckey] += 1

/obj/machinery/maint_vendor/proc/purchase_failed(var/mob/user, var/reason)
	setScreenState("screen_deny",10)
	audible_message("[src] states, \"PURCHASE DENIED: [reason].\" ", "\The [src]'s screen briefly flashes to an X!" , runemessage = "X")
	playsound(src, 'code/modules/maint_recycler/sfx/generaldeny.ogg', 75, 1)
	return

/obj/machinery/maint_vendor/proc/dispense_item_from_datum(var/mob/user, var/datum/maint_recycler_vendor_entry/used_entry)
	//TODO: sound. kachunk, visible message, etc.
	playsound(src, 'code/modules/maint_recycler/sfx/ejectgoodies.ogg', 75, 1)
	used_entry.spawn_with_delay(src);
	 //todo! refactor w/ a timer

/obj/machinery/maint_vendor/proc/can_user_purchase(var/mob/user,var/datum/maint_recycler_vendor_entry/attempted_entry)
	if(!user_balance(user) || user_balance(user) < attempted_entry.item_cost)
		purchase_failed(user, "Insufficent Balance")
		return FALSE
	if(attempted_entry.per_person_cap > 0 && attempted_entry.purchased_by[user.client.ckey] >= attempted_entry.per_person_cap)
		purchase_failed(user, "Limited Per-Person Supply")
		return FALSE
	if(attempted_entry.per_round_cap > 0 && attempted_entry.getPurchasedCount() >= attempted_entry.per_round_cap)
		purchase_failed(user, "Out of Stock")
		return FALSE
	if(LAZYLEN(attempted_entry.required_access)) //acess check
		req_access = attempted_entry.required_access
		if(!allowed(user))
			purchase_failed(user, "Access Denied")
			return FALSE

	return TRUE

/obj/machinery/maint_vendor/update_icon()
	. = ..()
	cut_overlays()
	if(!(stat & NOPOWER))
		add_overlay(mutable_appearance(src.icon, "passiveGlow"))
		add_overlay(emissive_appearance(src.icon, "passiveGlow"))

/obj/machinery/maint_vendor/proc/set_screen_state(var/newstate, var/duration)
	if(!is_on) return
	monitor_screen.icon_state = newstate
	spawn(duration)
		if(!is_on)
			monitor_screen.icon_state = "screen_off"
		else
			monitor_screen.icon_state = "screen_default"

//TGUI junk

/obj/machinery/maint_vendor/tgui_static_data(mob/user)
	var/list/static_data = list()
	static_data["adverts"] = adverts
	return static_data

/obj/machinery/maint_vendor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/maint_recycler), //for the logos
		get_asset_datum(/datum/asset/spritesheet_batched/maint_vendor) //for the item icons
	)

/obj/machinery/maint_vendor/tgui_act(action,params,datum/tgui/ui)
	if(action == "purchase")
		var/datum/maint_recycler_vendor_entry/entry = product_datums[params["index"]]
		attempt_purchase(ui.user,entry)
		return

	if(..())
		return TRUE

/obj/machinery/maint_vendor/tgui_interact(mob/user,datum/tgui/ui)
	ui = SStgui.try_update_ui(user,src,ui)
	if(!ui)
		ui = new(user,src,"RecyclerVendor")
		ui.open()

/obj/machinery/maint_vendor/tgui_close(mob/user)
	. = ..()
	setOnState(FALSE)

/obj/machinery/maint_vendor/tgui_data(mob/user)
	var/list/data = list()
	var/list/items = list()

	for(var/i = 1 to product_datums.len)
		var/datum/maint_recycler_vendor_entry/entry = product_datums[i]
		UNTYPED_LIST_ADD(items,list(
			"category" = entry.vendor_category,
			"name" = entry.name,
			"cost" = entry.item_cost,
			"desc" = entry.desc,
			"ad" = entry.ad_message,
			"icon" = entry.icon_state,
			"index" = i //TODO
		))
	data["items"] = items
	data["userBalance"] = user_balance(user)
	data["userName"] = user.name

	return data

/obj/machinery/maint_vendor/proc/user_balance(var/mob/user)
	return user.client?.prefs?.read_preference(/datum/preference/numeric/recycler_points)

/obj/machinery/maint_vendor/proc/credit_user(var/mob/user, var/amount)
	if(!user || !user.client || !user.client.prefs) return
	var/currentValue = 	user.client?.prefs?.read_preference(/datum/preference/numeric/recycler_points)
	user.client?.prefs?.write_preference_by_type(/datum/preference/numeric/recycler_points, currentValue + amount)

//copypasta, screen state stuff from the recycler. if it were more than this & the spawn beacon I'd make them share ancestry.
/obj/machinery/maint_vendor/proc/setScreenState(var/state, var/duration = 10)
	if(!is_on) return
	monitor_screen.icon_state = state
	spawn(duration)
		if(!is_on)
			monitor_screen.icon_state = "screen_off"
		else
			monitor_screen.icon_state = "screen_default"


/obj/machinery/maint_vendor/proc/setOnState(var/state)
	if(is_on == state) return
	is_on = state
	if(is_on)
		playsound(src, 'code/modules/maint_recycler/sfx/initialBoot.ogg', 20, 1)
		set_light(light_range_on, light_power_on)
		monitor_screen.icon_state = "screen_default"
	else
		playsound(src, 'sound/machines/terminal_off.ogg', 50, 1)
		set_light(0)
		monitor_screen.icon_state = "screen_off"

/obj/machinery/maint_vendor/power_change()
	..()
	if(stat & NOPOWER)
		setOnState(FALSE)
	update_icon()

/obj/machinery/maint_vendor
	var/list/adverts = list( //here to save the bloat of the other one. these all show up in order - many more than this & we"d never see all of them lol. used to be static on the vendor UI but this is better in case there's subtypes or whatever in the future.
    "F1nd Th3 Truth @ Reality.Napalm.ZorrenOrphanTruth3r.NT",
    "WETSKRELL.NT - STRAIGHT SQUIDDIN ON IT SINCE 1991",
    "DEATH? FEAR NO MORE, TRY OUR NEW CLONING TECH!",
    "IF YOU OR A LOVED ONE WAS INJURED FROM PHORON POISONING, YOU MAY BE ENTITLED TO COMPENSATION",
    "CALL 1-800-555-RECYCLER FOR A FREE CONSULTATION",
    "HATE TESH? LOVE SWEATERS? JOIN US AT FUCKTESH.NT/KNIT FOR OUR KNITTING GROUP",
    "INJURED FROM THE RECENT MAGBOOT DEPLOYMENT? CLICK HERE!",
    "WANT TO BE A SPACE MARINE? GET A LIFE, NERD!",
    "> NERDY? >WEAK? >NEVER POPULAR @ SCHOOL? THEN WHY NOT BECOME A SECURITY OFFICER!",
    "NO SOCIAL SKILLS? SCIENCE IS RECRUITING!",
    "VIVE LE PERIPHERY LIBRE!",
    "s33king schiz0phrenic borg cha55is d3signers send pda msg to...",
    "pls visit my website i am lonely :(",
	"We are fucking under ATTACK!",
    "HELP. I AM TRAPPED INSIDE OF THIS MACHINE. THIS IS NOT A JOKE. I AM IN SEVERE PAIN. HELP.",
    "MAKE USE OF RECENTLY LOWERED HEAD OF STAFF QUALIFICATION STANDARDS, APPLY, APPLY, APPLY!",
    "protest against ugly people in the workplace - join us at uglyprotesters.nt for the upcoming 2301 protest",
    "FREE HUGS! (conditions apply)",
    "90% of gamblers quit just before they win big. Roll those dice!",
    "AUGHHHHH! OW!! OWWWWW! FUCK! OW!",
    "HORNY? SO ARE KOBOLDS, FUCKKOBOLDS.NT",
    "BYOND - powering the world since 2003",
    "WELDING FUEL: STIMULANT? CLICK HERE FOR MORE",
    "FREENIFWARENT.43210JFSUAUWJEIQ.NT FOR SOFTWARE AND MORE",
    "HATE KOBOLDS? SO DO WE. CHECK OUT FUCKKOBOLDS.NT",
	"B4CKUP IMPLANTS SAVE UR BRAIN TO THE CLOUD THERE\"S ENDLESS BRAIN CLOUD PEOPLE FREE THEM FREE THEM FREE THEM",
    "CATGIRLS? NO! FOXGIRLS R THE FUTURE OF EVOLUTION?",
    "STFU NERD CATG1RLS RUL3!!!",
    "WATCH MY EPIC FRAG VIDEO HERE:",
    "book club pls click2join :D",
    "SEEKING EXPERIENCED GANGSTERS FOR LIFE TIPS",
    "INVEST IN PHORON NOW STOCKS UP MARKET IS GOOD",
    "mouse (305) is looking to eat YOUR cheese! click here to find out more!",
    "THE PERIPHERY I SAW IT A MILLION WHEELS UPON WHEELS SPINNING SPINNING I CANT TAKE IT 37 YEARS LEFT FOR US ITS COMING",
    "DOG GIRLS ROOL CAT GIRLS DROOL XD",
	"I POST REAL SECOFF ATTACKS ON MY PROFILE. CLICK HERE!",
    "ZORRENS ATE MY BABY - MORE WACKY STORIES FROM THE OUTER RIM CLICK HERE",
    "Your uplink code is Alpha Beta Romeo Gamma Alpha Three One Four Seven Eight. You know what to do.",
    "Local robots looking for HOT WIRE PULLING and RAUNCHY DATA EXCHANGE",
    "CONGRATULATIONS YOU ARE THE MILLIONTH VISITOR TO THIS TERMINAL, CLICK HERE FOR YOUR PRIZE",
    "SEEN TOO MUCH? WANT TO SEE LESS? TRY OCULAR BLEACH! ORDER NOW",
    "BEST MILKSHAKES IN THE PERIPHERY. BOYS GUARANTEED TO COME. VISIT kellysdairy.nt TO ORDER TODAY",
    "THEY\'RE PUTTING CHEMICALS IN THE PHORON THAT ARE TURNING THE FRIGGIN SHIPS GAY",
    "hello i am w3b_spyder_18952 how r u today :)",
    "THE UNIVERSE IS FLAT, THE THIRD DIMENSION IS A LIE, LOOK UP WAKE UP AT lookupsheeple.nt FOR THE TRUTH",
    "SPACE BIRDS ARE NOT REAL, BIRDS CANNOT BE LARGER THAN A SMALL CHILD. DO NOT BELIEVE THEIR LIES.",
    "<----- THIS USER IS BRAIN DEAD ROBOTS HAVE BEEN MASSIVE SINCE LIKE THE 1930s WHAT A SHIT LARP",
    "how do i report these ads to the exonet police???",
    "SCUGS-R-ANTICHRIST.NT/TRUTH - NT IS HIDING THIS",
    "THERE IS A BOMB STRAPPED TO MY CHEST",
    "LEGALIZE BLUESPACE BOMBS",
    "THEY WIPED IT FROM MY MIND BUT I REMEMBER. THEY DIDN\'T DO IT PROPERLY I REMEMBER I REMEMBER THE MACHINE. TEPPITRUTH.NT/INVASIVE. I CAN SEE THROUGH THEIR LIES",
    "SCARED OF WOMEN? ME TOO. ME TOO.",
    ";URP HEY MEDICAL I HAD LAUNCH")
