##################################################
# Author: ABM Tafsirul Islam
# Email: tafsirul.islam@primesilicon.com
# Version: 1.0 
# Date: 01/03/2024
# Short Description: This script is for finding out 
# the number of buffer and inverter from timing report
##################################################


# null value to count the number of buf,inv,std_cell
set count_buf 0
set count_inv 0
set count_std_cell 0

# open the file in read mode
set fo [open "timing_report_place.txt" "r"]
while {[gets $fo line] != -1} {
# counts the number of buffer    
    if {[regexp "BUF*" $line] } {
        incr count_buf
# counts the number of inverter        
    } elseif {[regexp "INV*" $line] && ![regexp "CKINV*" $line] } {
        incr count_inv
# counts the number of standerd cells
    } elseif {[regexp {\(.*x.*\)} $line] && ![regexp "INV*" $line] && ![regexp "BUF*" $line] && ![regexp "/CLK" $line]} {
        incr count_std_cell
    }
}

puts "buf: $count_buf"
puts "inv: $count_inv"
puts "std_cell: $count_std_cell"

close $fo