
/*
 * lbnesquik - Github
 * Provided massive components of this. Polaris PR #5720.
 */

//This is for the round end stats system.

//roundstat is used for easy finding of the variables, if you ever want to delete all of this,
//just search roundstat and you'll find everywhere this thing reaches into.
//It used to be bazinga but it only fly with microwaves.

GLOBAL_VAR_INIT(cans_opened_roundstat, 0)
GLOBAL_VAR_INIT(lights_switched_on_roundstat, 0)
GLOBAL_VAR_INIT(turbo_lift_floors_moved_roundstat, 0)
GLOBAL_VAR_INIT(lost_limbs_shift_roundstat, 0)
GLOBAL_VAR_INIT(seed_planted_shift_roundstat, 0)
GLOBAL_VAR_INIT(step_taken_shift_roundstat, 0)
GLOBAL_VAR_INIT(destroyed_research_items_roundstat, 0)
GLOBAL_VAR_INIT(items_sold_shift_roundstat, 0)
GLOBAL_VAR_INIT(disposals_flush_shift_roundstat, 0)
GLOBAL_VAR_INIT(rocks_drilled_roundstat, 0)
GLOBAL_VAR_INIT(mech_destroyed_roundstat, 0)
GLOBAL_VAR_INIT(prey_eaten_roundstat, 0)		//VOREStation Edit - Obviously
GLOBAL_VAR_INIT(prey_absorbed_roundstat, 0)		//VOREStation Edit - Obviously
GLOBAL_VAR_INIT(prey_digested_roundstat, 0)		//VOREStation Edit - Obviously
GLOBAL_VAR_INIT(items_digested_roundstat, 0)	//VOREStation Edit - Obviously
//GLOBAL_VAR_INIT(security_tickets, 0)			//VOREStation Edit
var/global/list/security_printer_tickets = list()


/hook/roundend/proc/RoundTrivia()//bazinga
	var/list/valid_stats_list = list() //This is to be populated with the good shit

	if(GLOB.lost_limbs_shift_roundstat > 1)
		valid_stats_list.Add("[GLOB.lost_limbs_shift_roundstat] limbs left their owners bodies this shift, oh no!")
	else if(GLOB.destroyed_research_items_roundstat > 13)
		valid_stats_list.Add("[GLOB.destroyed_research_items_roundstat] objects were destroyed in the name of Science! Keep it up!")
	else if(GLOB.mech_destroyed_roundstat > 1)
		valid_stats_list.Add("[GLOB.mech_destroyed_roundstat] mechs were destroyed this shift. What did you do?")
	else if(GLOB.seed_planted_shift_roundstat > 20)
		valid_stats_list.Add("[GLOB.seed_planted_shift_roundstat] seeds were planted according to our sensors this shift.")

	if(GLOB.rocks_drilled_roundstat > 80)
		valid_stats_list.Add("Our strong miners pulverized a whole [GLOB.rocks_drilled_roundstat] piles of pathetic rubble.")
	else if(GLOB.items_sold_shift_roundstat > 15)
		valid_stats_list.Add("The vending machines sold [GLOB.items_sold_shift_roundstat] items today.")
	else if(GLOB.step_taken_shift_roundstat > 900)
		valid_stats_list.Add("The employees walked a total of [GLOB.step_taken_shift_roundstat] steps for this shift! It should put them on the road to fitness!")

	if(GLOB.cans_opened_roundstat > 0)
		valid_stats_list.Add("[GLOB.cans_opened_roundstat] cans were drank today!")
	else if(GLOB.lights_switched_on_roundstat > 0)
		valid_stats_list.Add("[GLOB.lights_switched_on_roundstat] light switches were flipped today!")
	else if(GLOB.turbo_lift_floors_moved_roundstat > 20)
		valid_stats_list.Add("The elevator moved up [GLOB.turbo_lift_floors_moved_roundstat] floors today!")
	else if(GLOB.disposals_flush_shift_roundstat > 40)
		valid_stats_list.Add("The disposal system flushed a whole [GLOB.disposals_flush_shift_roundstat] times for this shift. We should really invest in waste treatement.")

	//VOREStation add Start - Ticket time!
	if(security_printer_tickets.len)
		valid_stats_list.Add("<span class = 'danger'>[security_printer_tickets.len] unique security tickets were issued today!</span><br>Examples include:")
		var/good_num = 5
		var/ourticket
		while(good_num > 0)
			ourticket = null
			if(security_printer_tickets.len)
				ourticket = pick(security_printer_tickets)
				security_printer_tickets -= ourticket
				if(ourticket)
					valid_stats_list.Add("<b>-</b>\"[ourticket]\"")
				good_num--
			else
				good_num = 0

	//VOREStation Add Start - Vore stats lets gooooo
	if(GLOB.prey_eaten_roundstat > 0)
		valid_stats_list.Add("A total of [GLOB.prey_eaten_roundstat] individuals were eaten today!")
	if(GLOB.prey_digested_roundstat > 0)
		valid_stats_list.Add("A total of [GLOB.prey_digested_roundstat] individuals were digested today!")
	if(GLOB.prey_absorbed_roundstat > 0)
		valid_stats_list.Add("A total of [GLOB.prey_absorbed_roundstat] individuals were absorbed today!")
	if(GLOB.items_digested_roundstat > 0)
		valid_stats_list.Add("A total of [GLOB.items_digested_roundstat] items were digested today!")
	//VOREStation Add End

	if(LAZYLEN(valid_stats_list))
		to_world("<B>Shift trivia!</B>")

		for(var/body in valid_stats_list)
			to_world("[body]")
