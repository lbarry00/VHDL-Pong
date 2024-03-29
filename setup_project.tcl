# Thanks to https://grittyengineer.com/vivado-project-mode-tcl-script/ for this script!

# Create output directory and clear contents
set outputdir ./out
file mkdir $outputdir
set files [glob -nocomplain "$outputdir/*"]
if {[llength $files] != 0} {
    puts "deleting contents of $outputdir"
    file delete -force {*}[glob -directory $outputdir *]; # clear folder contents
} else {
    puts "$outputdir is empty"
}

#Create project
create_project -part xc7a100tcsg324-1 pong_game $outputdir

#add source files to Vivado project
# add_files -fileset sim_1 ./path/to/testbench.vhd
# add_files [glob ./path/to/sources/*.vhd]
# add_files -fileset constrs_1 ./path/to/constraint/constraint.xdc
# add_files [glob ./path/to/library/sources/*.vhd]
# set_property -library userDefined [glob ./path/to/library/sources/*.vhd]
add_files [glob ./src/*.vhd]
add_files -fileset constrs_1 ./constraints/Nexys4DDR_Master.xdc

#set top level module and update compile order
set_property top Pong_VGA [current_fileset]
update_compile_order -fileset sources_1
# update_compile_order -fileset sim_1

#launch synthesis
launch_runs synth_1
wait_on_run synth_1

#Run implementation and generate bitstream
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
puts "Implementation done!"