var/bluespace_item_types = newlist(/obj/item/storage/backpack/holding,
/obj/item/storage/bag/trash/holding,
/obj/item/storage/pouch/holding,
/obj/item/storage/belt/utility/holding,
/obj/item/storage/belt/medical/holding
)

//wrapper
/proc/do_teleport(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null, local=TRUE, bohsafe=FALSE)
	new /datum/teleport/instant/science(arglist(args))
	return

/datum/teleport
	var/atom/movable/teleatom //atom to teleport
	var/atom/destination //destination to teleport to
	var/precision = 0 //teleport precision
	var/datum/effect/effect/system/effectin //effect to show right before teleportation
	var/datum/effect/effect/system/effectout //effect to show right after teleportation
	var/soundin //soundfile to play before teleportation
	var/soundout //soundfile to play after teleportation
	var/force_teleport = 1 //if false, teleport will use Move() proc (dense objects will prevent teleportation)
	var/local = TRUE //If false, can teleport from/to any z-level
	var/bohsafe = FALSE //If true, can teleport safely with a BoH


/datum/teleport/New(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null, local=TRUE, bohsafe=FALSE)
	..()
	if(!initTeleport(arglist(args)))
		return 0
	return 1

/datum/teleport/proc/initTeleport(ateleatom,adestination,aprecision,afteleport,aeffectin,aeffectout,asoundin,asoundout,local,bohsafe)
	if(!setTeleatom(ateleatom))
		return 0
	if(!setDestination(adestination))
		return 0
	src.bohsafe = bohsafe
	if(!setPrecision(aprecision))
		return 0
	setEffects(aeffectin,aeffectout)
	setForceTeleport(afteleport)
	setSounds(asoundin,asoundout)
	src.local = local
	return 1

//must succeed
/datum/teleport/proc/setPrecision(aprecision)
	if(isnum(aprecision))
		precision = aprecision
		return 1
	return 0

//must succeed
/datum/teleport/proc/setDestination(atom/adestination)
	if(istype(adestination))
		destination = adestination
		return 1
	return 0

//must succeed in most cases
/datum/teleport/proc/setTeleatom(atom/movable/ateleatom)
	if(istype(ateleatom, /obj/effect) && !istype(ateleatom, /obj/effect/dummy/chameleon))
		qdel(ateleatom)
		return 0
	if(istype(ateleatom))
		teleatom = ateleatom
		return 1
	return 0

//custom effects must be properly set up first for instant-type teleports
//optional
/datum/teleport/proc/setEffects(datum/effect/effect/system/aeffectin=null,datum/effect/effect/system/aeffectout=null)
	effectin = istype(aeffectin) ? aeffectin : null
	effectout = istype(aeffectout) ? aeffectout : null
	return 1

//optional
/datum/teleport/proc/setForceTeleport(afteleport)
		force_teleport = afteleport
		return 1

//optional
/datum/teleport/proc/setSounds(asoundin=null,asoundout=null)
		soundin = isfile(asoundin) ? asoundin : null
		soundout = isfile(asoundout) ? asoundout : null
		return 1

//placeholder
/datum/teleport/proc/teleportChecks()
		return 1

/datum/teleport/proc/playSpecials(atom/location,datum/effect/effect/system/effect,sound)
	if(location)
		if(effect)
			spawn(-1)
				src = null
				effect.attach(location)
				effect.start()
		if(sound)
			spawn(-1)
				src = null
				playsound(location,sound,60,1)
	return

//do the monkey dance
/datum/teleport/proc/doTeleport()

	var/turf/destturf
	var/turf/curturf = get_turf(teleatom)
	if(precision)
		var/list/posturfs = circlerangeturfs(destination,precision)
		destturf = safepick(posturfs)
	else
		destturf = get_turf(destination)

	if(!destturf || !curturf)
		return 0

	playSpecials(curturf,effectin,soundin)

	var/obj/structure/bed/chair/C = null
	if(isliving(teleatom))
		var/mob/living/L = teleatom
		if(L.buckled)
			C = L.buckled
	if(attempt_vr(src,"try_televore",args)) return
	if(force_teleport)
		teleatom.forceMove(destturf)
		playSpecials(destturf,effectout,soundout)
	else
		if(teleatom.Move(destturf))
			playSpecials(destturf,effectout,soundout)
	if(C)
		C.forceMove(destturf)

	return 1

/datum/teleport/proc/teleport()
	if(teleportChecks())
		return doTeleport()
	return 0

/datum/teleport/instant //teleports when datum is created

/datum/teleport/instant/New(ateleatom, adestination, aprecision=0, afteleport=1, bohsafe=0, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	if(..())
		teleport()
	return


/datum/teleport/instant/science/setEffects(datum/effect/effect/system/aeffectin,datum/effect/effect/system/aeffectout)
	if(!aeffectin || !aeffectout)
		var/datum/effect/effect/system/spark_spread/aeffect = new
		aeffect.set_up(5, 1, teleatom)
		var/datum/effect/effect/system/spark_spread/aeffect2 = new
		aeffect2.set_up(5, 1, teleatom)
		effectin = effectin || aeffect
		effectout = effectout || aeffect2
		return 1
	else
		return ..()

/datum/teleport/instant/science/setPrecision(aprecision)
	..()
	if(bohsafe)
		return 1

	var/list/bluespace_things = newlist()

	for (var/item in bluespace_item_types)
		if (istype(teleatom, item))
			precision = rand(1, 100)
		bluespace_things |= teleatom.search_contents_for(item)

	if(isliving(teleatom))
		var/mob/living/L = teleatom
		if(LAZYLEN(L.buckled_mobs))
			for(var/mob/rider in L.buckled_mobs)
				for (var/item in bluespace_item_types)
					bluespace_things |= rider.search_contents_for(item)

	if(bluespace_things.len)
		precision = max(rand(1,100)*bluespace_things.len,100)
		if(isliving(teleatom))
			var/mob/living/MM = teleatom
			to_chat(MM, span_danger("The Bluespace interface on your [teleatom] interferes with the teleport!"))
	return 1

/datum/teleport/instant/science/teleportChecks()
	if(istype(teleatom, /obj/item/disk/nuclear)) // Don't let nuke disks get teleported --NeoFite
		teleatom.visible_message(span_danger("\The [teleatom] bounces off of the portal!"))
		return 0

	if(!isemptylist(teleatom.search_contents_for(/obj/item/disk/nuclear)))
		if(isliving(teleatom))
			var/mob/living/MM = teleatom
			MM.visible_message(span_danger("\The [MM] bounces off of the portal!"),span_warning("Something you are carrying seems to be unable to pass through the portal. Better drop it if you want to go through."))
		else
			teleatom.visible_message(span_danger("\The [teleatom] bounces off of the portal!"))
		return 0
	var/obstructed = 0
	var/turf/dest_turf = get_turf(destination)
	if(local && !(dest_turf.z in using_map.player_levels))
		if(isliving(teleatom))
			to_chat(teleatom, span_warning("The portal refuses to carry you that far away!"))
		return 0
	else if(istype(destination.loc, /obj/belly))
		var/obj/belly/destination_belly = destination.loc
		var/mob/living/telenommer = destination_belly.owner
		if(istype(telenommer))
			if(istype(teleatom, /obj/machinery) || istype(teleatom, /obj/structure))
				return 0
			else if(!isliving(teleatom))
				return 1
			else
				var/mob/living/telemob = teleatom
				if(telemob.can_be_drop_prey && telenommer.can_be_drop_pred)
					return 1
		obstructed = 1
	else if(!((isturf(destination) && !destination.density) || (isturf(destination.loc) && !destination.loc.density)) || !destination.x || !destination.y || !destination.z)	//If we're inside something or outside universe
		obstructed = 1
		to_chat(teleatom, span_warning("Something is blocking way on the other side!"))
	if(obstructed)
		return 0
	else
		return 1
