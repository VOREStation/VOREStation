/**************
* TEST SKILLS *
***************/

/datum/category_group/skill/debug
	name = "Debugging"
	category_item_type = /datum/category_item/skill/debug

/datum/category_item/skill/debug/test1
	id = "Lorem Ipsum"
	name = "Lorem Ipsum"
	flavor_desc = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sit amet elementum justo. Mauris nec elementum orci. \
	Sed nec tortor eget tellus semper venenatis. Pellentesque imperdiet sapien quam, a cursus arcu rutrum ut. \
	Nunc nibh felis, laoreet a elementum ac, lobortis sed lorem. Sed ligula nulla, vulputate nec purus eget, \
	pretium venenatis elit. Phasellus erat odio, sodales eget lacus et, consectetur tempor ex. Pellentesque luctus \
	consequat luctus. Suspendisse potenti. Donec eleifend sapien sit amet fermentum ultrices. Maecenas eget ex nunc. \
	Quisque pellentesque auctor nulla, sodales bibendum est venenatis non. Fusce sed laoreet magna."
	govern_desc = "Governs absolutely nothing at all, and is used to test things."
	typical_desc = "Nobody should have this skill."
	levels = list(
		/datum/skill_level/debug/zero,
		/datum/skill_level/debug/one,
		/datum/skill_level/debug/two,
		/datum/skill_level/debug/three,
		/datum/skill_level/debug/four
		)

/datum/skill_level/debug/zero
	name = "Zero"
	flavor_desc = "Cras at lorem neque. Duis justo arcu, luctus nec posuere quis, aliquam aliquam quam. \
	Integer egestas sit amet ante a tincidunt. Vivamus vel maximus metus. Nam vehicula justo id eleifend pretium. \
	Curabitur egestas, libero placerat vulputate placerat, nibh magna laoreet elit, quis lacinia magna turpis sed arcu. \
	Cras dui mauris, condimentum id iaculis non, viverra eu leo."
	mechanics_desc = "Does absolutely nothing."

/datum/skill_level/debug/one
	name = "Nil"
	flavor_desc = "Nunc sollicitudin sem mi, ut maximus elit pulvinar et. Integer feugiat sapien at pellentesque tempus. \
	Vivamus tristique luctus ornare. Nunc rutrum quam et magna dapibus aliquet. \
	Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In pulvinar leo sed nisl luctus tempus. \
	Quisque lacus quam, vestibulum quis erat nec, aliquam volutpat massa. Maecenas a tellus ipsum. \
	Proin consectetur metus nec eros porttitor, sed vulputate nibh tempor. Aenean porta scelerisque sagittis."
	mechanics_desc = "Still does nothing."
	cost = 10

/datum/skill_level/debug/two
	name = "Naught"
	flavor_desc = " Etiam purus quam, ultricies et iaculis vitae, pretium in urna. Maecenas varius ut ligula a sollicitudin. \
	Nulla molestie sapien et dui fermentum, nec luctus arcu feugiat. Integer a felis vitae purus luctus consectetur. \
	Mauris placerat, urna vel fringilla sagittis, odio nibh cursus libero, ut pretium nisi nibh a nisi. \
	Integer in ultrices dui, sed ornare neque. Duis et sodales massa. Etiam hendrerit dui imperdiet erat pretium convallis. \
	Nam vitae erat id purus placerat sagittis eget vel nisi. Ut laoreet justo eget blandit efficitur. Cras ornare gravida porttitor. \
	Sed dictum risus at diam mollis, at aliquet lectus vestibulum. Mauris id facilisis augue, vitae facilisis metus. \
	Sed bibendum lobortis vestibulum. Morbi venenatis egestas ante, sit amet placerat felis."
	mechanics_desc = "Just like before, nothing."
	cost = 20

/datum/skill_level/debug/three
	name = "Empty"
	flavor_desc = "Curabitur pharetra, arcu sit amet iaculis ultricies, est nisi fringilla metus, vel molestie sapien ligula et massa. \
	Nullam cursus, justo eget feugiat congue, sapien nulla ultrices lacus, hendrerit placerat nisi sem in nulla. \
	Etiam gravida dolor leo, ac placerat eros vestibulum venenatis. Proin ac odio id eros tempor imperdiet at non massa. \
	Sed a condimentum tellus. Fusce semper urna at diam porta, ut euismod lorem pellentesque. \
	Etiam ipsum velit, faucibus nec fermentum eget, vulputate at lectus. In tincidunt velit odio, \
	ut accumsan erat rutrum in. Etiam sagittis hendrerit pulvinar. Vivamus interdum commodo tellus in volutpat."
	mechanics_desc = "What part of 'nothing' do you not understand?"
	cost = 40

/datum/skill_level/debug/four
	name = "Void"
	flavor_desc = " Morbi in tellus in justo rhoncus tincidunt. Nam mollis mollis sem at aliquet. Phasellus pretium porta velit non pulvinar. \
	Sed tempus tempor magna vitae ornare. Suspendisse potenti. Nam eu vehicula nulla, eu porttitor nisl. \
	Fusce lobortis felis consectetur tempus tincidunt. Morbi pharetra vulputate tellus, in maximus mauris vestibulum quis."
	mechanics_desc = "Guess."
	enhancing = TRUE
	cost = 60