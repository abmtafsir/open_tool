# Steps to follow:
# Open "openroad" interactive shell
# Load db with "read_bd Path/to/go/file_name"
# Source the following script: "source TI_read_macro_placement.tcl"
# Show in gui: "gui::show" 
# Selec the macro and change "placement status: placed" in gui
# Source the following script with "source -verbose macro_placement_rearrange.tcl"

# ord is a shell which is being dedicated to work for some commands
# get_db_block: is the data base for all blocks which contains all the instances 
set block [ord::get_db_block] 

# getInst: command finds the instances from the database of block.
# getMaster: command finds the master db of the instance
# getType: command finds the type of the instance  
foreach inst [$block getInsts] {
	if {[[$inst getMaster] getType ] == "BLOCK"} { ; # finds the instances that are dedicated for the BLOCK (macro)
		$inst setPlacementStatus PLACED ; # changed the placement status from locked to placed
	
	}
 
}

# macro orientation according to hierarchy
place_cell -inst_name dmem/dmem0 -orient MY -origin {16.368 39.744}
place_cell -inst_name dmem/dmem1 -orient MY -origin {30.72 39.744}
place_cell -inst_name dmem/dmem2 -orient MY -origin {45.12 39.744}
place_cell -inst_name dmem/dmem3 -orient MY -origin {59.472 39.744}
