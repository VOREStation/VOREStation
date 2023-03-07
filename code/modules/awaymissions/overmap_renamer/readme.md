/*

How to use - for mappers:

    Adding a new POI to an already defined lateloaded Z level (you can check which Z levels are handled by the renamer in code\controllers\subsystems\overmap_renamer_vr.dm)
        Within the folder you found this readme, click the appropriately named file (debris field -> debrisfield_renamer)
        There, create a new object as given in the following example:

        /obj/effect/landmark/overmap_renamer/debris_field/examplelandmark
	        name = "Debris field example landmark that hints at which POI it came from!!!"
	        descriptors = list("This element appears when you hover over the obj in the nav console", "if someone manages to examine it", "This is what the printed paper says")

        Make sure you use exactly 3 elements, no more and no less and make sure each element is enclosed in a "".
        If you want to only change one element, fill in the other ones with the appropriate  /obj/effect/overmap/visitable/ subtype's name, desc or scanner_desc your Z level corresponds to.

        Once done, just load up strongDMM and place your landmark within the map.
        Please use the _renamer.dm files to define landmarks, don't do it within the game.
        While it works just fine, this should make it easier to change the descriptor if it's problematic after review or found so down the line.
        Plus, if your .dmm is too big for github to show - this will let people review your descriptor easily.

        When making such landmarks: reserve them for MAJOR POIs - stuff a ship's scanner might pick up as having a significance.
        A small shuttle in the debris field shouldn't get a landmark
        The big alien derelict? Now that's worthy of a special landmark!
        The idea of this system is for us to be able to treat existing Z levels as technically different locations. 
        Did you want to make an abandoned mining facility overmap adventure? Now this system will let you turn the DF into one (if the dice permits)

    Adding a new POI to a brand new lateloaded Z level (you can check which Z levels are handled by the renamer in code\controllers\subsystems\overmap_renamer_vr.dm)
        First, go to your /obj/effect/overmap/visitable, and define unique_identifier as something unique. Like, "Debris Field" - basically, this is a way to check if the map loaded without causing compiler errors.

        Your task will become a bit more difficult now. Create a new .dm file following convention already estabilished with debrisfield_renamer.dm

            Within this file, define your /obj/effect/landmark/overmap_renamer/newname here
                add the following line: 
                    var/static/reference //leave thus null. The initialization will change this to contain reference to your overmap object instance. Saves us from excess looping
                    name = "obvious reference to the lateloaded Z in question here"
            Within this file, create a new /obj/effect/landmark/overmap_renamer/newname/Initialize()
                Within this proc, copy what's done in code\modules\awaymissions\overmap_renamer\debrisfield_renamer.dm
                except, replace if(D == "Debris Field") with whatever your unique identifier was defined for your specific overmap object

        Now go to code\controllers\subsystems\overmap_renamer_vr.dm
            copy the if("Debris Field - Z1 Space" in visitable_Z_levels_name_list) and everything belonging to this if statement
            paste it below this if statement and change things as described:
                change the if("map_template.name goes here" in visitable_z_levels_name_list) (you can get the proper name by going to wherever your /datum/map_template/ for your map is. For Debris field, it's maps\offmap_vr\common_offmaps.dm. Yours is probably there too!)
                change the if(D == "Debris Field") section in your new if statement just like you did for the landmark!

        And you're done! Refer to the "How to add a landmark" section on the top from now on.
        



Important procs, vars etc. contained within the following files:

    code\_helpers\global_lists_vr.dm
        var/list/visitable_overmap_object_instances - Collects instances with reference for things like the Debris Field, Space Whale, Talon etc. We need it to call the proc on the instance

    code\modules\overmap\sectors.dm
        var/list/possible_descriptors - contains a list of list("name","desc","scanner_desc")
        var/unique_identifier - A way to check if the object in question loaded without causing a compiler error. Name them sth easy to recognize, like "Debris field" for... debris field.
        var/real_name - Used to handle known = FALSE overmap objects properly
        var/real_desc - same as real_name
        /obj/effect/overmap/visitable/Initialize() - adds the object's instance with reference to visitable_overmap_object_instances

    code\modules\awaymissions\overmap_renamer\overmap_renamer.dm
        /obj/effect/overmap/visitable/proc/modify_descriptors() - Takes possible_descriptors from src, picks a valid one after sanitization. Gives warnings if input is invalid.
        /obj/effect/landmark/overmap_renamer - generic landmark, don't touch.

    code\modules\awaymissions\overmap_renamer\debrisfield_renamer.dm - Mappers, copy contents, changing the /overmap_renamer/debris_field to /overmap_renamer/yourthingy
        var/static/reference - I couldn't find a way to declare this higher up in the path. Make sure to delcare it when making landmarks for a new area. Static so all landmarks have it. This gets defined on runtime after the first landmark subtype initializes.
        /obj/effect/landmark/overmap_renamer/debris_field/Initialize() - Copy the entire thing, and change the "Debris Field" to your obj's var/unique_identifier

    code\controllers\subsystems\overmap_renamer_vr.dm
        /datum/controller/subsystem/overmap_renamer/proc/update_names() - Checks which Z levels are loaded, modifies them 
            To add new Z levels to the renamer, simply copy the if statement and its contents for debris field,
            taking care to change the "Debris Field - Z1 Space" to the name var defined in your lateloaded Z level's map_template datum
            example: maps\offmap_vr\common_offmaps.dm and then the /datum/map_template/common_lateload/away_debrisfield


*/
