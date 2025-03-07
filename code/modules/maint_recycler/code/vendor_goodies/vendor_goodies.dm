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
