// VOREStation Add Start: Doing this here bc AUTOHISS_FULL is more readable than #
#define AUTOHISS_OFF 0
#define AUTOHISS_BASIC 1
#define AUTOHISS_FULL 2
// VOREStation Add End

/mob/living/carbon/human/Login()
	..()
	update_hud()
	// VOREStation Add
	if(client.prefs) // Safety, just in case so we don't runtime.
		if(!client.prefs.autohiss)
			client.autohiss_mode = AUTOHISS_FULL
		else
			switch(client.prefs.autohiss)
				if("Full")
					client.autohiss_mode = AUTOHISS_FULL
				if("Basic")
					client.autohiss_mode = AUTOHISS_BASIC
				if("Off")
					client.autohiss_mode = AUTOHISS_OFF
	// VOREStation Add
	if(species) species.handle_login_special(src)
	return

// VOREStation Add Start: Doing this here bc AUTOHISS_FULL is more readable than #
#undef AUTOHISS_OFF
#undef AUTOHISS_BASIC
#undef AUTOHISS_FULL
// VOREStation Add End
