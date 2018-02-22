/area/submap/spa
	name = "\improper Space Spa"
	requires_power = 0
	dynamic_lighting = 0




// NEVER EVER use these on an actual included map.
// These are for admins to use when they make quick maps and upload the .dmm files for loading
// during a round. They're just generic areas so they can use them and have them exist without
// using real map areas.
/area/submap/admin_upload
	name = "\improper Unknown Area AU" //Nobody will know what this means if they see it, anyway.
	requires_power = 1
	dynamic_lighting = 1
/area/submap/admin_upload/pow
	name = "\improper Unknown Area AU+P"
	requires_power = 0
/area/submap/admin_upload/lit
	name = "\improper Unknown Area AU+L"
	dynamic_lighting = 0
/area/submap/admin_upload/powlit
	name = "\improper Unknown Area AU+PL"
	requires_power = 0
	dynamic_lighting = 0
