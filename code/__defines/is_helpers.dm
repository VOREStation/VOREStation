
#define isdatum(D)		istype(D, /datum)
#define isweakref(A)	istype(A, /datum/weakref)

//#define islist(D)		istype(D, /list)	//Built in

//---------------
#define isatom(D)		istype(D, /atom)
#define isclient(D)		istype(D, /client)

//---------------
//#define isobj(D)		istype(D, /obj)		//Built in

#define isitem(D)		istype(D, /obj/item)

#define isradio(A)		istype(A, /obj/item/device/radio)

#define isairlock(A)	istype(A, /obj/machinery/door/airlock)

#define isorgan(A)		istype(A, /obj/item/organ/external)

#define isstorage(A)	istype(A, /obj/item/weapon/storage)

#define ismecha(A)      istype(A, /obj/mecha)

#define isstructure(A)	istype(A, /obj/structure)

//---------------
//#define isarea(D)		istype(D, /area)	//Built in

//---------------
//#define ismob(D)		istype(D, /mob)		//Built in
#define isliving(A)		istype(A, /mob/living)

#define isobserver(A)	istype(A, /mob/observer/dead)
#define isEye(A)		istype(A, /mob/observer/eye)

#define isnewplayer(A)	istype(A, /mob/new_player)

#define isanimal(A)		istype(A, /mob/living/simple_mob)
#define ismouse(A)		istype(A, /mob/living/simple_mob/animal/passive/mouse)
#define iscorgi(A)		istype(A, /mob/living/simple_mob/animal/passive/dog/corgi)
#define isslime(A)		istype(A, /mob/living/simple_mob/slime)
#define isxeno(A)		istype(A, /mob/living/simple_mob/animal/space/alien)

#define iscarbon(A)		istype(A, /mob/living/carbon)
#define isalien(A)		istype(A, /mob/living/carbon/alien)
#define isbrain(A)		istype(A, /mob/living/carbon/brain)
#define ishuman(A)		istype(A, /mob/living/carbon/human)

#define issilicon(A)	istype(A, /mob/living/silicon)
#define isAI(A)			istype(A, /mob/living/silicon/ai)
#define isrobot(A)		istype(A, /mob/living/silicon/robot)
#define isshell(A)		istype(A, /mob/living/silicon/robot/ai_shell)
#define ispAI(A)		istype(A, /mob/living/silicon/pai)

#define isbot(A)		istype(A, /mob/living/bot)

#define isvoice(A)		istype(A, /mob/living/voice)

//---------------
//#define isturf(D)		istype(D, /turf)	//Built in
#define isopenspace(A)	istype(A, /turf/simulated/open)
#define isspace(A)		istype(A, /turf/space)
#define isopenturf(A)	istype(A, /turf/simulated/open) || istype(A, /turf/space)
#define isnonsolidturf(A)	istype(A, /turf/simulated/open) || istype(A, /turf/space) || istype(A, /turf/simulated/floor/water) || istype(A, /turf/simulated/floor/lava)
#define ismineralturf(A) istype(A, /turf/simulated/mineral)

#define istaurtail(A)	istype(A, /datum/sprite_accessory/tail/taur)
#define islongtail(A)	istype(A, /datum/sprite_accessory/tail/longtail)
