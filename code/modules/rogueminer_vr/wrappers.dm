/obj/effect/step_trigger/teleporter/random/rogue
	teleport_z = 7
	teleport_z_offset = 7

//Sure, I could probably do this with math. But I'm tired.
/*
         S1      200
 -----------------------------------
 |001/199  099/199|102/199  199/199|
 |                |                |S
 |       A1       |       A2       |2
 |                |                |
0|001/102  099/102|102/102  199/102|2
0|---------------------------------|0
0|001/099  099/099|102/099  199/099|0
 |                |                |
S|       A3       |       A4       |
4|                |                |
 |001/001  099/001|102/001  199/001|
 -----------------------------------
                 200      S3
*/

//////////// AREA 1
/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A1S1
	teleport_x = 1
	teleport_y = 102
	teleport_x_offset = 99
	teleport_y_offset = 102

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A1S2
	teleport_x = 1
	teleport_y = 102
	teleport_x_offset = 1
	teleport_y_offset = 199

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A1S3
	teleport_x = 1
	teleport_y = 199
	teleport_x_offset = 99
	teleport_y_offset = 199

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A1S4
	teleport_x = 99
	teleport_y = 102
	teleport_x_offset = 99
	teleport_y_offset = 199

//////////// AREA 2
/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A2S1
	teleport_x = 102
	teleport_y = 102
	teleport_x_offset = 199
	teleport_y_offset = 102

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A2S2
	teleport_x = 102
	teleport_y = 102
	teleport_x_offset = 102
	teleport_y_offset = 199

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A2S3
	teleport_x = 102
	teleport_y = 199
	teleport_x_offset = 199
	teleport_y_offset = 199

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A2S4
	teleport_x = 199
	teleport_y = 102
	teleport_x_offset = 199
	teleport_y_offset = 199

//////////// AREA 3
/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A3S1
	teleport_x = 1
	teleport_y = 1
	teleport_x_offset = 99
	teleport_y_offset = 1

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A3S2
	teleport_x = 1
	teleport_y = 1
	teleport_x_offset = 1
	teleport_y_offset = 99

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A3S3
	teleport_x = 1
	teleport_y = 99
	teleport_x_offset = 99
	teleport_y_offset = 99

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A3S4
	teleport_x = 99
	teleport_y = 1
	teleport_x_offset = 99
	teleport_y_offset = 99

//////////// AREA 4
/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A4S1
	teleport_x = 102
	teleport_y = 1
	teleport_x_offset = 199
	teleport_y_offset = 1

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A4S2
	teleport_x = 102
	teleport_y = 1
	teleport_x_offset = 102
	teleport_y_offset = 99

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A4S3
	teleport_x = 102
	teleport_y = 99
	teleport_x_offset = 199
	teleport_y_offset = 99

/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/A4S4
	teleport_x = 199
	teleport_y = 1
	teleport_x_offset = 199
	teleport_y_offset = 99
