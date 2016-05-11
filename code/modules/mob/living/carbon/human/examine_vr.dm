/mob/living/carbon/human/proc/examine_weight()
    var/message = ""

    switch(weight)
        if(0 to 74)
            message = "\red They are terribly lithe and frail!\n" //I couldn't get the t.he, t_he, or \he to work, so... Let's just use they!
        if(75 to 99)
            message = "They have a very slender frame.\n"
        if(100 to 124)
            message = "They have a lightweight, athletic build.\n"
        if(125 to 174)
            message = "They have a healthy, average body.\n"
        if(175 to 224)
            message = "They have a thick, heavy physique.\n"
        if(225 to 274)
            message = "They have a plush, chubby figure.\n"
        if(275 to 325)
            message = "They have an especially plump body with a round potbelly and large hips.\n"
        if(325 to 374)
            message = "They have a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs.\n"
        if(375 to 474)
            message = "\red They are incredibly obese. Their massive potbelly sags over their waistline while their fat ass would probably require two chairs to sit down comfortably!\n"
        else
            message = "\red They are so morbidly obese, you wonder how they can even stand, let alone waddle around the station. They can't get any fatter without being immobilized.\n"
    return message //Credit to Aronai for helping me actually get this working!