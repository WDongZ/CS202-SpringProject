# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.cache/wt [current_project]
set_property parent.project_path C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths c:/Users/86153/Desktop/cpu2/CS202ComputerOrganization/SEU_CSE_507_user_uart_bmpg_1.3 [current_project]
set_property ip_output_repo c:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.ip_user_files/prgrom32.coe
add_files C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/ip/dmem32.coe
read_verilog -library xil_defaultlib {
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/ALU.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/IFetch.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/Immi.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/MemOrIO.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/clock_divider.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/controller.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/decoder.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/dmemory32.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/ioread.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/leds.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/m_inst.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/seven_segment_tube.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/switches.v
  C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/new/CPU.v
}
read_ip -quiet C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/ip/prgrom/prgrom.xci
set_property used_in_implementation false [get_files -all c:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/ip/prgrom/prgrom_ooc.xdc]

read_ip -quiet C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/ip/RAM/RAM.xci
set_property used_in_implementation false [get_files -all c:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/ip/RAM/RAM_ooc.xdc]

read_ip -quiet C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/ip/cpuclk/cpuclk.xci
set_property used_in_implementation false [get_files -all c:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/ip/cpuclk/cpuclk_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/ip/cpuclk/cpuclk.xdc]
set_property used_in_implementation false [get_files -all c:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/sources_1/ip/cpuclk/cpuclk_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/constrs_1/new/cons.xdc
set_property used_in_implementation false [get_files C:/Users/86153/Desktop/cpu2/CS202-SpringProject/Project/Lab9.srcs/constrs_1/new/cons.xdc]


synth_design -top CPU -part xc7a35tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef CPU.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file CPU_utilization_synth.rpt -pb CPU_utilization_synth.pb"
