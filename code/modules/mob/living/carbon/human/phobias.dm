//Handling and defining of phobias and fears
#define NYCTOPHOBIA 1
#define ARACHNOPHOBIA 2
#define HEMOPHOBIA 4
#define THALASSOPHOBIA 8
#define CLAUSTROPHOBIA_MINOR 16
#define CLAUSTROPHOBIA_MAJOR 32
#define ANATIDAEPHOBIA 64
#define AGRAVIAPHOBIA 128

/mob/living/carbon/human/proc/handle_phobias()
	if(phobias & NYCTOPHOBIA)
		var/turf/T = get_turf(src)
		var/brightness = T.get_lumcount()
		if(brightness < 0.2)
			fear = min((fear + 3), 102)
	if(phobias & ARACHNOPHOBIA)
		for (var/mob/living/simple_mob/animal/giant_spider/S in viewers(src, null))
			if(!istype(S) || S.stat)
				continue
			fear = min((fear + 6), 102)
	if(phobias & HEMOPHOBIA)
		for(var/obj/effect/decal/cleanable/blood/B in view(7, src))
			var/obj/effect/decal/cleanable/blood/oil/O = B
			var/obj/effect/decal/cleanable/blood/tracks/T = B
			if(istype(O) || istype(T))
				continue
			fear = min((fear + 2), 102)
		for(var/turf/simulated/floor/water/blood/T in view(7, src))
			fear = min((fear + 2), 102)
	if(phobias & THALASSOPHOBIA)
		var/turf/T = get_turf(src)
		if(istype(T,/turf/simulated/floor/water/underwater) || istype(T,/turf/simulated/floor/water/deep))
			fear = min((fear + 4), 102)
	if(phobias & CLAUSTROPHOBIA_MINOR)
		if(!isturf(loc))
			if(!istype(loc,/obj/belly) && !istype(loc,/obj/item/holder/micro))
				fear = min((fear + 3), 102)
	if(phobias & CLAUSTROPHOBIA_MAJOR) //Also activated inside of a belly
		if(!isturf(loc))
			if(!istype(loc,/obj/item/holder/micro))
				fear = min((fear + 3), 102)
	if(phobias & ANATIDAEPHOBIA)
		for (var/mob/living/simple_mob/animal/space/goose/G in viewers(src, null))
			if(!istype(G) || G.stat)
				continue
			fear = min((fear + 3), 102)
		for (var/mob/living/simple_mob/animal/sif/duck/D in viewers(src, null))
			if(!istype(D) || D.stat)
				continue
			fear = min((fear + 3), 102)
		for(var/obj/item/bikehorn/rubberducky/R in view(7, src))
			if(!istype(R))
				continue
			fear = min((fear + 2), 102)
	if(phobias & AGRAVIAPHOBIA)
		if(is_floating)
			fear = min((fear + 4), 102)
