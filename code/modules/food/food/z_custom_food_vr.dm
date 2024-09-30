// Customizable Foods //////////////////////////////////////////
var/global/deepFriedEverything = 0
var/global/deepFriedNutriment = 0
var/global/foodNesting = 0
var/global/recursiveFood = 0
var/global/ingredientLimit = 20


/obj/item/reagent_containers/food/snacks/customizable
	icon = 'icons/obj/food_custom.dmi'
	bitesize = 2

	var/ingMax = 100
	var/list/ingredients = list()
	var/stackIngredients = 0
	var/fullyCustom = 0
	var/addTop = 0
	var/image/topping
	var/image/filling

/obj/item/reagent_containers/food/snacks/customizable/Initialize(loc,ingredient)
	. = ..()
	topping = image(icon,,"[initial(icon_state)]_top")
	filling = image(icon,,"[initial(icon_state)]_filling")
	src.reagents.add_reagent("nutriment",3)
	src.updateName()
	return

/obj/item/reagent_containers/food/snacks/customizable/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/reagent_containers/food/snacks))
		if((contents.len >= ingMax) || (contents.len >= ingredientLimit))
			to_chat(user, "<span class='warning'>That's already looking pretty stuffed.</span>")
			return

		var/obj/item/reagent_containers/food/snacks/S = I
		if(istype(S,/obj/item/reagent_containers/food/snacks/customizable))
			var/obj/item/reagent_containers/food/snacks/customizable/SC = S
			if(fullyCustom && SC.fullyCustom)
				to_chat(user, "<span class='warning'>You slap yourself on the back of the head for thinking that stacking plates is an interesting dish.</span>")
				return
		if(!recursiveFood && istype(I, /obj/item/reagent_containers/food/snacks/customizable))
			//to_chat(user, "<span class='warning'>[pick("As uniquely original as that idea is, you can't figure out how to perform it.","That would be a straining topological exercise.","This world just isn't ready for your cooking genius.","It's possible that you may have a problem.","It won't fit.","You don't think that would taste very good.","Quit goofin' around.")]</span>")
			to_chat(user, "<span class='warning'>As uniquely original as that idea is, you can't figure out how to perform it.</span>")
			return
		/*if(!user.drop_item())
			to_chat(user, "<span class='warning'>\The [I] is stuck to your hands!</span>")
			return*/
		user.drop_item()
		I.forceMove(src)

		if(S.reagents)
			S.reagents.trans_to_holder(reagents,S.reagents.total_volume)

		ingredients += S

		if(src.addTop)
			cut_overlay(topping)
		if(!fullyCustom && !stackIngredients && LAZYLEN(our_overlays))
			cut_overlay(filling) //we can't directly modify the overlay, so we have to remove it and then add it again
			var/newcolor = S.filling_color != "#FFFFFF" ? S.filling_color : AverageColor(getFlatIcon(S, S.dir, 0), 1, 1)
			filling.color = BlendRGB(filling.color, newcolor, 1/ingredients.len)
			add_overlay(filling)
		else
			add_overlay(generateFilling(S))
		if(addTop)
			drawTopping()

		updateName()
		to_chat(user, "<span class='notice'>You add the [I.name] to the [src.name].</span>")
	else
		. = ..()
	return

/obj/item/reagent_containers/food/snacks/customizable/proc/generateFilling(var/obj/item/reagent_containers/food/snacks/S, params)
	var/image/I
	if(fullyCustom)
		var/icon/C = getFlatIcon(S, S.dir, 0)
		I = image(C)
		I.pixel_y = 12 * empty_Y_space(C)
	else
		I = filling
		if(istype(S) && S.filling_color != "#FFFFFF")
			I.color = S.filling_color
		else
			I.color = AverageColor(getFlatIcon(S, S.dir, 0), 1, 1)
		if(src.stackIngredients)
			I.pixel_y = src.ingredients.len * 2
		else
			src.overlays.len = 0
	if(src.fullyCustom || src.stackIngredients)
		var/clicked_x = text2num(params2list(params)["icon-x"])
		if (isnull(clicked_x))
			I.pixel_x = 0
		else if (clicked_x < 9)
			I.pixel_x = -2 //this looks pretty shitty
		else if (clicked_x < 14)
			I.pixel_x = -1 //but hey
		else if (clicked_x < 19)
			I.pixel_x = 0  //it works
		else if (clicked_x < 25)
			I.pixel_x = 1
		else
			I.pixel_x = 2
	return I

/obj/item/reagent_containers/food/snacks/customizable/proc/updateName()
	var/i = 1
	var/new_name
	for(var/obj/item/S in ingredients)
		if(i == 1)
			new_name += "[S.name]"
		else if(i == src.ingredients.len)
			new_name += " and [S.name]"
		else
			new_name += ", [S.name]"
		i++
	new_name = "[new_name] [initial(name)]"
	if(length(new_name) >= 150)
		name = "something yummy"
	else
		name = new_name
	return new_name

/obj/item/reagent_containers/food/snacks/customizable/Destroy()
	QDEL_LIST_NULL(ingredients)
	return ..()

/obj/item/reagent_containers/food/snacks/customizable/proc/drawTopping()
	var/image/I = topping
	I.pixel_y = (ingredients.len+1)*2
	add_overlay(I)


// Sandwiches //////////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/customizable/sandwich
	name = "sandwich"
	desc = "A timeless classic."
	icon_state = "c_sandwich"
	stackIngredients = 1
	addTop = 0

/obj/item/reagent_containers/food/snacks/customizable/sandwich/attackby(obj/item/I,mob/user)
	if(istype(I,/obj/item/reagent_containers/food/snacks/slice/bread) && !addTop)
		I.reagents.trans_to_holder(reagents,I.reagents.total_volume)
		qdel(I)
		addTop = 1
		src.drawTopping()
	else
		..()

/obj/item/reagent_containers/food/snacks/customizable/burger
	name = "burger"
	desc = "The apex of space culinary achievement."
	icon_state = "c_burger"
	stackIngredients = 1
	addTop = 1

// Misc Subtypes ///////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/customizable/fullycustom
	name = "on a plate"
	desc = "A unique dish."
	icon_state = "fullycustom"
	fullyCustom = 1 //how the fuck do you forget to add this?
	ingMax = 1

/obj/item/reagent_containers/food/snacks/customizable/soup
	name = "soup"
	desc = "A bowl with liquid and... stuff in it."
	icon_state = "soup"
	trash = /obj/item/trash/bowl

/obj/item/reagent_containers/food/snacks/customizable/pizza
	name = "pan pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"

/obj/item/reagent_containers/food/snacks/customizable/pasta
	name = "spaghetti"
	desc = "Noodles. With stuff. Delicious."
	icon_state = "pasta_bot"

// Various Snacks //////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/slice/bread/attackby(obj/item/I,mob/user,params)
	if(istype(I,/obj/item/reagent_containers/food/snacks))
		if(!recursiveFood && istype(I, /obj/item/reagent_containers/food/snacks/customizable))
			to_chat(user, "<span class='warning'>Sorry, no recursive food.</span>")
			return
		var/obj/F = new/obj/item/reagent_containers/food/snacks/customizable/sandwich(get_turf(src),I) //boy ain't this a mouthful
		F.attackby(I, user)
		qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/bun/attackby(obj/item/I, mob/user)
	// Bun + meatball = burger
	if(istype(I,/obj/item/reagent_containers/food/snacks/meatball))
		new /obj/item/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(I)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(I, /obj/item/reagent_containers/food/snacks/cutlet))
		new /obj/item/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(I)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(I, /obj/item/reagent_containers/food/snacks/sausage))
		new /obj/item/reagent_containers/food/snacks/hotdog(src)
		to_chat(user, "You make a hotdog.")
		qdel(I)
		qdel(src)

	if(istype(I,/obj/item/reagent_containers/food/snacks))
		if(!recursiveFood && istype(I, /obj/item/reagent_containers/food/snacks/customizable))
			to_chat(user, "<span class='warning'>Sorry, no recursive food.</span>")
			return
		var/obj/F = new/obj/item/reagent_containers/food/snacks/customizable/burger(get_turf(src),I)
		F.attackby(I, user)
		qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/sliceable/flatdough/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		if(!recursiveFood && istype(I, /obj/item/reagent_containers/food/snacks/customizable))
			to_chat(user, "<span class='warning'>Sorry, no recursive food.</span>")
			return
		var/obj/F = new/obj/item/reagent_containers/food/snacks/customizable/pizza(get_turf(src),I)
		F.attackby(I, user)
		qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/spagetti/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		if(!recursiveFood && istype(I, /obj/item/reagent_containers/food/snacks/customizable))
			to_chat(user, "<span class='warning'>Sorry, no recursive food.</span>")
			return
		var/obj/F = new/obj/item/reagent_containers/food/snacks/customizable/pasta(get_turf(src),I)
		F.attackby(I, user)
		qdel(src)
	else
		return ..()

// Custom Meals ////////////////////////////////////////////////
/*
/obj/item/trash/plate/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/reagent_containers/food/snacks))
		if(istype(I,/obj/item/reagent_containers/food/snacks/customizable/fullycustom)) //no platestacking even with recursive food, for now
			to_chat(user, "<span class='warning'>That's already got a plate!</span>")
			return
		var/obj/F = new/obj/item/reagent_containers/food/snacks/customizable/fullycustom(get_turf(src),I)
		F.attackby(I, user)
		qdel(src)
	else
		return ..()
*/

/obj/item/trash/bowl
	name = "bowl"
	desc = "An empty bowl. Put some food in it to start making a soup."
	icon = 'icons/obj/food_custom.dmi'
	icon_state = "soup"

/obj/item/trash/bowl/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/reagent_containers/food/snacks))
		if(!recursiveFood && istype(I, /obj/item/reagent_containers/food/snacks/customizable))
			to_chat(user, "<span class='warning'>Sorry, no recursive food.</span>")
			return
		var/obj/F = new/obj/item/reagent_containers/food/snacks/customizable/soup(get_turf(src),I)
		F.attackby(I, user)
		qdel(src)
	else
		return ..()
