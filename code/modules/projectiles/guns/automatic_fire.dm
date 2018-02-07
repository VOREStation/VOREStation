//This entire file is unticked for quality control and testing


//True automagic gun modes. Dakka dakka.
//A significant portion of this code was donated by Mport from SS:CM

//This is used by guns shooting in automatic mode
/obj/screen/auto_target
	name = "targeter"
	icon = null//We dont want people to see this guy
	density = 0
	anchored = 1
	var/obj/item/weapon/gun/gun
	var/active = 0//Just tells us that it was clicked on so we should start shooting
	var/delay_del = 0//Delays the del if we retarget without shooting

/obj/screen/auto_target/New(loc, var/obj/item/weapon/gun/G)
		..()
		gun = G
		var/image/I = image('icons/effects/Targeted.dmi', src, "locked")
		I.override = 1
		usr << I
		//autodel() //Currently doesn't really work right.
		return

/obj/screen/auto_target/CanPass()//Everything should ignore this guy and just pass by
		return 1

	//Used to get rid of this if they target but dont actually shoot or stop shooting (no ammo) yet are still dragging us around
/obj/screen/auto_target/proc/autodel()
	set waitfor=0
	if(active == 1)
		return
	sleep(20)
	if(!src) return//Might not really be needed
	if(delay_del)//This says we want to wait another X seconds before trying to del
		delay_del = 0
		autodel()
		return
	if(gun.shooting == 0)
		qdel(src)
	else
		autodel()//Yes in theory this could hit the inf loop
	return

	//When the player clicks on the target it will disable the autodel and tell the gun to shoot
/obj/screen/auto_target/MouseDown(location,control,params)
	active += 1//Tell the autodel that we are actually using this now
	if(gun.shooting == 0)//If we are not shooting start shooting, we need this here or they have to drag to a new turf before it starts shooting, felt weird
		gun.Fire(loc, usr, params)
	return

	//Called when they drag the object somewhere else
	//If its not already shooting (should be though due to the above, but this does let it click at you when it runs dry) then start shooting,
/obj/screen/auto_target/MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
	if(gun.shooting == 0)//If we are not shooting start shooting
		gun.Fire(loc, usr, params)
	if(over_location != loc)//This updates the loc to our new location when we drag it to a new turf
		loc = over_location
	if((usr.get_active_hand() != gun))
		qdel(src)

	//This gets rid of us when they let go of the click, but only after they actually drag the target to a new turf which is why the below also has to exist
/obj/screen/auto_target/MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
	qdel(src)
	return
	//This is needed so if they just MouseDown and then let go it will stop shooting, otherwise we stick around till they run out of bullets
/obj/screen/auto_target/MouseUp(object,location,control,params)
	qdel(src)
	return

//This pseudo code is being left in place to serve as references to the modifications to gun.dm, the Fire() proc, and the afterattack() proc. -k22
//Code donated by Mport.
