/mob/living/carbon/human/proc/reagent_purge()
	set name = "Purge Reagents"
	set desc = "Empty yourself of any reagents you may have consumed or come into contact with."
	set category = "IC"

	if(stat == DEAD) return

	to_chat(src, "<span class='notice'>Performing reagent purge, please wait...</span>")
	sleep(50)
	src.bloodstr.clear_reagents()
	src.ingested.clear_reagents()
	src.touching.clear_reagents()
	to_chat(src, "<span class='notice'>Reagents purged!</span>")

	return TRUE
	
