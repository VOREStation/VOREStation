//bling item for medical. will make fun of the poors.
/obj/item/healthanalyzer/bling
	name = "Health Scamalyzer"
	desc = "A fancy, gem-encrusted hand-held body scanner able to distinguish vital signs of the subject, and provide handy (and egregious) cost estimates. There's a worn warning sticker on the back stating it doesn't work on poor or ugly people."
	icon = 'code/modules/maint_recycler/icons/goodies/recycler_goodies.dmi'
	icon_state = "scamalizer"
	item_state = "scamalizer" //
	item_icons = list(slot_l_hand_str = 'code/modules/maint_recycler/icons/goodies/goodies_lefthand.dmi', slot_r_hand_str = 'code/modules/maint_recycler/icons/goodies/goodies_righthand.dmi')

#define POOR_PERSON_THRESHOLD 1000 //below this and it's over.
/obj/item/healthanalyzer/bling/scan_mob(mob/living/M, mob/living/user)
	.=..()
	playsound(src, 'code/modules/maint_recycler/sfx/goodies/kaching.ogg', 50, 1) //dolla dolla bills.
	if(ishuman(M))
		var/mob/living/carbon/human/potentialpoor = M
		var/obj/item/card/id/potentialPoorID = potentialpoor.GetIdCard()
		if(potentialPoorID == null)
			to_chat(user, span_warning("Warning! Unregistered Patient. Potentially unable to afford treatment. Continue with monetary caution and validate insurance coverage."))
			return

		var/datum/money_account/failed_at_capitalism_account = get_account(potentialPoorID.associated_account_number)


		if(!failed_at_capitalism_account) //yuck! must've failed to keep the minimum balance...
			to_chat(M, span_warning("Warning! Patient account is invalid. Ensure they have a non-counterfeit ID, double check validity of insurance coverage."))
			return

		if(failed_at_capitalism_account.suspended)
			to_chat(M, span_warning("Warning! Patient account is suspended. Extreme risk of fraud and other financially-destitute behavior, double check validity of insurance coverage."))
			return

		if(failed_at_capitalism_account.money < POOR_PERSON_THRESHOLD)
			to_chat(user, span_warning("Warning! Patient is Financially Inept. Likely Unable to afford treatment. Continue with extreme monetary caution and validate insurance coverage is legitimate."))
			return

		if(failed_at_capitalism_account.money > POOR_PERSON_THRESHOLD * 2) //if only it was 2x irl....
			to_chat(user, span_notice("Patient is a HVI (High Value Individual). Provide High Quality Care Immediately."))
			return

		to_chat(user, span_notice("Patient is Financially Secure. Provide Care."))
#undef POOR_PERSON_THRESHOLD


/obj/random/fromList
	var/list/to_spawn

/obj/random/fromList/TFGuns
	//same weight as the crate
	to_spawn =	list(
			/obj/item/gun/energy/mouseray=300,
			/obj/item/gun/energy/mouseray/corgi=50,
			/obj/item/gun/energy/mouseray/woof=50,
			/obj/item/gun/energy/mouseray/cat=50,
			/obj/item/gun/energy/mouseray/chicken=50,
			/obj/item/gun/energy/mouseray/lizard =50,
			/obj/item/gun/energy/mouseray/rabbit =50,
			/obj/item/gun/energy/mouseray/fennec =50,
			/obj/item/gun/energy/mouseray/monkey =5,
			/obj/item/gun/energy/mouseray/wolpin =5,
			/obj/item/gun/energy/mouseray/otie =5,
			/obj/item/gun/energy/mouseray/direwolf=5,
			/obj/item/gun/energy/mouseray/giantrat=5,
			/obj/item/gun/energy/mouseray/redpanda=50,
			/obj/item/gun/energy/mouseray/catslug=5,
			/obj/item/gun/energy/mouseray/teppi=5,
			/obj/item/gun/energy/mouseray/metamorphosis = 1,
			/obj/item/gun/energy/mouseray/metamorphosis/advanced/random = 1)


/obj/random/fromList/spawn_item()
	var/type = pickweight(to_spawn)
	new type(get_turf(src))
	qdel(src)

/obj/item/clothing/suit/recycling_shirt
	name = "recycling shirt"
	desc = "A shirt with a recycling symbol on it. This person recycles things! So ecological!"
	icon_override = 'code/modules/maint_recycler/icons/goodies/recyclingshirt.dmi'
	icon = 'code/modules/maint_recycler/icons/goodies/recyclingshirt.dmi'
	item_state = "recycle_mob"
	icon_state = "recycle"

/obj/random/fromList/sexy_costumes //"sexy"
	to_spawn =	list(
			/obj/item/clothing/suit/maxman=1,
			/obj/item/clothing/suit/sexyminer=1,
			/obj/item/clothing/suit/lumber=1,
			/obj/item/clothing/suit/shrine_maiden=1,
			/obj/item/clothing/suit/iasexy=1,
			/obj/item/clothing/suit/sumo = 1,
			/obj/item/clothing/under/dress/wench=1,
			/obj/item/clothing/under/schoolgirl = 1,
			/obj/item/clothing/suit/stripper/stripper_pink =1,
			/obj/item/clothing/suit/stripper/stripper_green =1

			)

/obj/random/fromList/ducky
		to_spawn =	list(
			/obj/item/bikehorn/rubberducky=100,
			/obj/item/bikehorn/rubberducky/blue=1, //lube
			/obj/item/bikehorn/rubberducky/pink=1, //freaky
			/obj/item/bikehorn/rubberducky/grey=1, //spooky
			/obj/item/bikehorn/rubberducky/white=1 //zap
			)

/obj/random/fromList/insuls
	to_spawn = list(
		/obj/item/clothing/gloves/yellow = 10,
		/obj/item/clothing/gloves/fyellow = 1
	)

/obj/random/fromList/mecha_toys
	to_spawn = list(
		/obj/item/toy/mecha/ripley = 1,
		/obj/item/toy/mecha/fireripley = 1,
		/obj/item/toy/mecha/deathripley = 1,
		/obj/item/toy/mecha/gygax = 1,
		/obj/item/toy/mecha/durand = 1,
		/obj/item/toy/mecha/honk = 1,
		/obj/item/toy/mecha/marauder = 1,
		/obj/item/toy/mecha/seraph = 1,
		/obj/item/toy/mecha/mauler = 1,
		/obj/item/toy/mecha/odysseus = 1,
		/obj/item/toy/mecha/phazon= 1,
		/obj/item/toy/mecha/reticence = 1,
		/obj/item/toy/mecha/clarke = 1,
		/obj/item/toy/mecha/fivestars = 1
	)

/obj/item/reagent_containers/food/snacks/packaged/vendburger/ancient
	name = "dubious packaged burger"
	desc = "God weeps. you flew too close to the sun. the plastic is yellowed. the bun is nearly entirely a whiteish-bluish-greenish mess. This abomination is probably sapient at this point, no doubt older than most of the station. you didn't even think twice. your wax wings are melting. it's over. you're falling. and the burger remains, as accursed as it is. this is your fault. you unleashed it from it's damnable prison. Pandora's box has been opened, and the only thing inside was this burger."
	nutriment_desc = list("regret. regret. regret.")

/obj/item/reagent_containers/food/snacks/packaged/vendburger/ancient/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_MOLD, 5) //entirely mold by volume
	reagents.add_reagent(REAGENT_ID_SALMONELLA, 5) //don't ask where the chicken came from.
	reagents.add_reagent(REAGENT_ID_MINDBREAKER, 2) //regret.
