##################################################
# Author: ABM Tafsirul Islam
# Email: tafsirul.islam@primesilicon.com
# Version: 1.0 
# Date: 03/04/2024
##################################################
# open the input file
set fi [open "timing_report_cts.txt" "r"]

# open the output file
set fo [open "place_vs_cts_timing_report.csv" "w+"] 
puts $fo "Startpoint,Endpoint,Slack"
# read the file
while {[gets $fi line] != -1} {
    if {[regexp "Start*" $line]} {
       
    set sp [lreplace [ split $line ":"] 0 0 ]
    set start_point [string map {"\{" "" "\}" ""} $sp]
    #puts $start_point
    }

    if {[regexp "End*" $line]} {
    set ep [lreplace [ split $line ":"] 0 0 ]
    set end_point [string map {"\{" "" "\}" ""} $ep]
    # puts $end_point
    }

    if {[regexp "slack*" $line]} {
    set slack [lindex [split $line] end-4 ]
    puts $fo "$start_point,$end_point,$slack"
    }

}
# pattern match with start point

# pattern match with end point
# Dump the result in the file 
close $fo
close $fi