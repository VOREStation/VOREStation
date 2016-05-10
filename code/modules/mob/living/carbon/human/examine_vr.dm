/mob/living/carbon/human/proc/examine_weight()
    var/message = ""

    switch(weight)
        if(0 to 74)
            message = "\red \He \is terribly lithe and frail!\n"
        if(75 to 99)
            message = "\He has a very slender frame.\n"
        if(100 to 124)
            message = "\He has a lightweight, athletic build.\n"
        if(125 to 174)
            message = "\He has a healthy, average body.\n"
        if(175 to 224)
            message = "\He has a thick, heavy physique.\n"
        if(225 to 274)
            message = "\He has a plush, chubby figure.\n"
        if(275 to 325)
            message = "\He has an especially plump body with a round potbelly and large hips.\n"
        if(325 to 374)
            message = "\He has a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs.\n"
        if(375 to 474)
            message = "\red \He \is incredibly obese. \his massive potbelly sags over \his waistline while \his fat ass would probably require two chairs to sit down comfortably!\n"
        else
            message = "\red \He \is so morbidly obese, you wonder how they can even stand, let alone waddle around the station. \He can't get any fatter without being immobilized.\n"
    return message