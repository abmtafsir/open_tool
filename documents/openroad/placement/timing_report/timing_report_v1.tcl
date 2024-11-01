
##################################################
# Author: ABM Tafsirul Islam
# Email: tafsirul.islam@primesilicon.com
# Version: 1.0 
# Date: 01/03/2024
##################################################

# open the input file in read mode
set f [open "timing_report.txt" "r"]
# open the csv file to dump the output
set fo [open "timing_report.csv" "w+"]
        puts $fo "Start_point, End_point, Cell, Delay"
# read the input file line by line
while {[gets $f line] != -1} {
    if {[regexp "Start*" $line]} { ; # to extract the "Start Point" line
        set start_point [lindex [split $line] 1] ; # to extract the name of the start point
        puts $fo ",,,"
} elseif {[regexp "End*" $line]} { ; # to extract the "End Point" line
        set end_point [lindex [split $line] 1] ; # to extract the name of the end point
} elseif {[regexp "BUF*" $line] || [regexp "INV*" $line] && ![regexp "CK" $line]} { ; # to extract the lines that contains "BUF" or "INV"
    set buf_name [lindex [split $line] 7]
    set str_buf_name [string map {"(" "" ")" ""} $buf_name] ; # erase the "()"
    set buf_delay [lrange [split $line] 2 3]
    set str_buf_delay [string map {"{}" ""} $buf_delay] ; # erase the "{}"
    puts $fo "$start_point, $end_point, $str_buf_name,$str_buf_delay"   
} elseif {[regexp {\(.*x.*\)} $line] && ![regexp "INV*" $line] && ![regexp "BUF*" $line] && ![regexp "/CLK" $line]} { ; # to extract the std cells
    set std_cell [lindex [split $line] end] 
    set str_std_cell [string map {"(" "" ")" ""} $std_cell]
    set cell_delay  [lreplace [lreplace [lreplace [lreplace [split $line] end end] end end] end end] end end]
    set str_cell_delay [string map {"{}" ""} $cell_delay]
    puts $fo "$start_point, $end_point, $str_std_cell,$str_cell_delay" 
    
} 
}


close $f
close $fo

