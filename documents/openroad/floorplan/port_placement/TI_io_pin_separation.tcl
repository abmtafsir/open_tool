##################################################
# Author: ABM Tafsirul Islam
# Email: tafsirul.islam@primesilicon.com
# Version: 1.0 
# Date: 01/03/2024
# Description: IO pin separation 
##################################################

# extract all the ports
set all_port [get_port *] ; # get_port: extract all the port  

# pre-define some null value for further calculation
set input_count 0
set output_count 0
set x 0
set y 0

# set the value of x and y axis of the core
set length_of_x_axis 80
set length_of_y_axis 90


foreach port $all_port {
# get_name: extract the name of the instance
    set property [get_property -object_type port [get_name $port] direction] ; # get_property: extract the property of the port; such as input or output
    if {$property == "input"} {
        set input_count [expr {$input_count + 1}]   
        place_pin -pin_name [get_name $port] -layer M6 -location "$x 90"                 
        set x [expr {$x + 2.22}]

    } elseif {$property == "output"} {
        set output_count [expr {$output_count + 1}]
        place_pin -pin_name [get_name $port] -layer M6 -location "80 $y"
        set y [expr {$y + 0.90}]
    }

}

#puts $input_count
#puts $output_count