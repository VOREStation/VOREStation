/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

#define ui_entire_screen "WEST,SOUTH to EAST,NORTH"

//Lower left, persistant menu
#define ui_inventory "WEST:6,SOUTH:5"

//Lower center, persistant menu
#define ui_sstore1 "WEST+2:10,SOUTH:5"
#define ui_id "WEST+3:12,SOUTH:5"
#define ui_belt "WEST+4:14,SOUTH:5"
#define ui_back "CENTER-2:14,SOUTH:5"
#define ui_rhand "CENTER-1:16,SOUTH:5"
#define ui_lhand "CENTER:16,SOUTH:5"
#define ui_equip "CENTER-1:16,SOUTH+1:5"
#define ui_swaphand1 "CENTER-1:16,SOUTH+1:5"
#define ui_swaphand2 "CENTER:16,SOUTH+1:5"
#define ui_storage1 "CENTER+1:16,SOUTH:5"
#define ui_storage2 "CENTER+2:16,SOUTH:5"

#define ui_alien_head "CENTER-3:12,SOUTH:5"		//aliens
#define ui_alien_oclothing "CENTER-2:14,SOUTH:5"//aliens

#define ui_inv1 "CENTER-1,SOUTH:5"			//borgs
#define ui_inv2 "CENTER,SOUTH:5"			//borgs
#define ui_inv3 "CENTER+1,SOUTH:5"			//borgs
#define ui_borg_store "CENTER+2,SOUTH:5"	//borgs
#define ui_borg_inventory "CENTER-2,SOUTH:5"//borgs

#define ui_monkey_mask "WEST+4:14,SOUTH:5"	//monkey
#define ui_monkey_back "WEST+5:14,SOUTH:5"	//monkey

#define ui_construct_health "EAST:00,CENTER:15" //same height as humans, hugging the right border
#define ui_construct_purge "EAST:00,CENTER-1:15"
#define ui_construct_fire "EAST-1:16,CENTER+1:13" //above health, slightly to the left
#define ui_construct_pull "EAST-1:28,SOUTH+1:10" //above the zone_sel icon
#define ui_pai_comms "EAST-1:28,SOUTH+1:5"

//Lower right, persistant menu
#define ui_dropbutton "EAST-4:22,SOUTH:5"
#define ui_drop_throw "EAST-1:28,SOUTH+1:7"
#define ui_pull_resist "EAST-2:26,SOUTH+1:7"
#define ui_acti "EAST-2:26,SOUTH:5"
#define ui_movi "EAST-3:24,SOUTH:5"
#define ui_zonesel "EAST-1:28,SOUTH:5"
#define ui_acti_alt "EAST-1:28,SOUTH:5" //alternative intent switcher for when the interface is hidden (F12)

#define ui_borg_pull "EAST-3:24,SOUTH+1:7"
#define ui_borg_module "EAST-2:26,SOUTH+1:7"
#define ui_borg_panel "EAST-1:28,SOUTH+1:7"

#define ui_ai_core "SOUTH:6,WEST:16"
#define ui_ai_camera_list "SOUTH:6,WEST+1:16"
#define ui_ai_track_with_camera "SOUTH:6,WEST+2:16"
#define ui_ai_camera_light "SOUTH:6,WEST+3:16"
#define ui_ai_crew_monitor "SOUTH:6,WEST+4:16"
#define ui_ai_crew_manifest "SOUTH:6,WEST+5:16"
#define ui_ai_alerts "SOUTH:6,WEST+6:16"
#define ui_ai_announcement "SOUTH:6,WEST+7:16"
#define ui_ai_shuttle "SOUTH:6,WEST+8:16"
#define ui_ai_state_laws "SOUTH:6,WEST+9:16"
#define ui_ai_pda_send "SOUTH:6,WEST+10:16"
#define ui_ai_pda_log "SOUTH:6,WEST+11:16"
#define ui_ai_take_picture "SOUTH:6,WEST+12:16"
#define ui_ai_view_images "SOUTH:6,WEST+13:16"
#define ui_ai_multicam "SOUTH+1:6,WEST+11:16"
#define ui_ai_add_multicam "SOUTH+1:6,WEST+12:16"
#define ui_ai_updown "SOUTH+1:6,WEST+13:16"

//Upper-middle right (alerts)
#define ui_alert1 "EAST-1:28,CENTER+5:27"
#define ui_alert2 "EAST-1:28,CENTER+4:25"
#define ui_alert3 "EAST-1:28,CENTER+3:23"
#define ui_alert4 "EAST-1:28,CENTER+2:21"
#define ui_alert5 "EAST-1:28,CENTER+1:19"

//Gun buttons
#define ui_gun1 "EAST-2:26,SOUTH+2:7"
#define ui_gun2 "EAST-1:28, SOUTH+3:7"
#define ui_gun3 "EAST-2:26,SOUTH+3:7"
#define ui_gun_select "EAST-1:28,SOUTH+2:7"
#define ui_gun4 "EAST-3:24,SOUTH+2:7"

//Upper-middle right (damage indicators)
#define ui_toxin "EAST-1:28,NORTH-2:27"
#define ui_fire "EAST-1:28,NORTH-3:25"
#define ui_oxygen "EAST-1:28,NORTH-4:23"
#define ui_pressure "EAST-1:28,NORTH-5:21"

#define ui_alien_toxin "EAST-1:28,NORTH-2:25"
#define ui_alien_fire "EAST-1:28,NORTH-3:25"
#define ui_alien_oxygen "EAST-1:28,NORTH-4:25"

// Goes above HUD, mid-right
#define ui_ammo_hud1 "EAST-1:28,CENTER+1:25"
#define ui_ammo_hud2 "EAST-1:28,CENTER+2:27"
#define ui_ammo_hud3 "EAST-1:28,CENTER+3:29"
#define ui_ammo_hud4 "EAST-1:28,CENTER+4:31"

//Middle right (status indicators)
#define ui_temp "EAST-1:28,CENTER-2:13"
#define ui_health "EAST-1:28,CENTER-1:15"
#define ui_internal "EAST-1:28,CENTER:17"
									//borgs
#define ui_borg_health "EAST-1:28,CENTER-2:13" //borgs have the health display where humans have the pressure damage indicator.
#define ui_alien_health "EAST-1:28,CENTER-2:13" //aliens have the health display where humans have the pressure damage indicator.

#define ui_ling_chemical_display "EAST-1:28,CENTER-3:15"
#define ui_wiz_energy_display "EAST-1:28,CENTER-3:15"
//#define ui_wiz_instability_display "EAST-2:28,CENTER-3:15"
#define ui_wiz_instability_display "EAST-1:28,NORTH-2:27"

//Pop-up inventory
#define ui_shoes "WEST+1:8,SOUTH:5"

#define ui_iclothing "WEST:6,SOUTH+1:7"
#define ui_oclothing "WEST+1:8,SOUTH+1:7"
#define ui_gloves "WEST+2:10,SOUTH+1:7"

#define ui_glasses "WEST:6,SOUTH+2:9"
#define ui_mask "WEST+1:8,SOUTH+2:9"
#define ui_l_ear "WEST+2:10,SOUTH+2:9"
#define ui_r_ear "WEST+2:10,SOUTH+3:11"

#define ui_head "WEST+1:8,SOUTH+3:11"

//Intent small buttons
#define ui_help_small "EAST-3:8,SOUTH:1"
#define ui_disarm_small "EAST-3:15,SOUTH:18"
#define ui_grab_small "EAST-3:32,SOUTH:18"
#define ui_harm_small "EAST-3:39,SOUTH:1"

//#define ui_swapbutton "6:-16,1:5" //Unused

//#define ui_headset "SOUTH,8"
#define ui_hand "CENTER-1:14,SOUTH:5"
#define ui_hstore1 "CENTER-2,CENTER-2"
//#define ui_resist "EAST+1,SOUTH-1"
#define ui_sleep "EAST+1, NORTH-13"
#define ui_rest "EAST+1, NORTH-14"


#define ui_iarrowleft "SOUTH-1,EAST-4"
#define ui_iarrowright "SOUTH-1,EAST-2"

#define ui_spell_master "EAST-2:16,NORTH-1:26"
#define ui_genetic_master "EAST-1:16,NORTH-3:16"

// Ghost ones
#define ui_ghost_returntomenu "SOUTH:6,CENTER-3:24"
#define ui_ghost_jumptomob "SOUTH:6,CENTER-2:24"
#define ui_ghost_orbit "SOUTH:6,CENTER-1:24"
#define ui_ghost_reenter_corpse "SOUTH:6,CENTER:24"
#define ui_ghost_teleport "SOUTH:6,CENTER+1:24"
#define ui_ghost_pai "SOUTH: 6,CENTER+2:24"
#define ui_ghost_updown "SOUTH: 6,CENTER+3:24"

// NIF Soulcatcher guest ones
#define ui_nifsc_reenter "SOUTH:6,CENTER-3:24"
#define ui_nifsc_arproj "SOUTH:6,CENTER-2:24"
#define ui_nifsc_jumptoowner "SOUTH:6,CENTER-1:24"
#define ui_nifsc_nme "SOUTH:6,CENTER:24"
#define ui_nifsc_nsay "SOUTH:6,CENTER+1:24"

// Rig panel
#define ui_rig_deco1 "WEST:-7, SOUTH+5"
#define ui_rig_deco2 "WEST:-7, SOUTH+6"
#define ui_rig_pwr "WEST+1:-7, SOUTH+6"
#define ui_rig_health "WEST+1:-7, SOUTH+6"
#define ui_rig_air "WEST+1:-7, SOUTH+5"
#define ui_rig_airtoggle "WEST+1:-7, SOUTH+5"
#define ui_rig_deco1_f "WEST+2:-7, SOUTH+5"
#define ui_rig_deco2_f "WEST+2:-7, SOUTH+6"

// Mech panel
#define ui_mech_deco1 "WEST:-7, SOUTH+8"
#define ui_mech_deco2 "WEST:-7, SOUTH+9"
#define ui_mech_pwr "WEST+1:-7, SOUTH+9"
#define ui_mech_health "WEST+1:-7, SOUTH+9"
#define ui_mech_air "WEST+1:-7, SOUTH+8"
#define ui_mech_airtoggle "WEST+1:-7, SOUTH+8"
#define ui_mech_deco1_f "WEST+2:-7, SOUTH+8"
#define ui_mech_deco2_f "WEST+2:-7, SOUTH+9"

#define ui_smallquad "EAST-4:22,SOUTH:5"