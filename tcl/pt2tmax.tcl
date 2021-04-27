#########################################################################
#
#                                  pt2tmax
#                  Copyright (c) 1998-2010 by Synopsys, Inc.
#                             ALL RIGHTS RESERVED
#
#
# This program is proprietary and confidential information of Synopsys, Inc.
# and may be used and disclosed only as authorized in a license agreement
# controlling such use and disclosure.
#
##########################################################################
#
# Tcl script to write critical paths from PrimeTime in the Tetramax format
# for path delay test.
#
##########################################################################

proc write_delay_paths {num args} {

  global timing_enable_preset_clear_arcs

  set version "E-2010.12"

  set pending "file_name"
  set max_paths_use 0 
  set crit_slack_use 0
  set paths_per_use 0
  set launch_clock_use 0
  set capture_clock_use 0
  set IO_use 0
  set each_use 0
  set zstate_use 1
  set group_use 0
  set net_use 0
  set cell_use 0
  set recalculate_use 0
  set outfile_use 0

  set max_paths 1
  set paths_per 1
  set launch_clock "*"
  set capture_clock "*"
  set thru_pin "*"
  set delay_type max

  set nlist $num
  append nlist " "
  append nlist $args

  foreach n $nlist {
	if {$pending == "num_paths"} {
		set max_paths $n
	} elseif {$pending == "crit_time"} {
		set crit_slack $n
	} elseif {$pending == "num_per"} {
		set paths_per $n
	} elseif {$pending == "one_clock_name"} {
		set launch_clock $n
		set capture_clock $n
	} elseif {$pending == "launch_clock_name"} {
		set launch_clock $n
	} elseif {$pending == "capture_clock_name"} {
		set capture_clock $n
	} elseif {$pending == "group_name"} {
		set group $n
	} elseif {$pending == "pin_name"} {
		set thru_pin $n
	} elseif {$pending == "delay_type"} {
		set delay_type $n
		if {$delay_type != "max" && $delay_type != "min" } {
			echo "Error: -delay_type must be either max or min"
			return 0
		}
	}
	if {$pending != "file_name"} {
		set pending "file_name"
		continue
	}
	if {$n == "-max_paths"} {
		set pending "num_paths"
		set max_paths_use 1
	} elseif {$n == "-slack"} {
		set pending "crit_time"
		set crit_slack_use 1
	} elseif {$n == "-nworst"} {
		set pending "num_per"
		set paths_per_use 1
	} elseif {$n == "-clock"} {
		set pending "one_clock_name"
		set launch_clock_use 1
		set capture_clock_use 1
	} elseif {$n == "-launch"} {
		set pending "launch_clock_name"
		set launch_clock_use 1
	} elseif {$n == "-capture"} {
		set pending "capture_clock_name"
		set capture_clock_use 1
	} elseif {$n == "-IO"} {
		set IO_use 1
	} elseif {$n == "-each"} {
		set each_use 1
	} elseif {$n == "-noZ"} {
		set zstate_use 0
	} elseif {$n == "-group"} {
		set pending "group_name"
		set group_use 1
	} elseif {$n == "-net"} {
		set pending "pin_name"
		set net_use 1
	} elseif {$n == "-cell"} {
		set pending "pin_name"
		set cell_use 1
	} elseif {$n == "-delay_type"} {
		set pending "delay_type"
	} elseif {$n == "-recalculate"} {
		set recalculate_use 1
	} elseif {$n == "-version"} {
		echo "pt2tmax Version $version\n"
		return
	} elseif {$n == "-help"} {
		echo "Usage: write_delay_paths -max_paths <num_paths> \[-slack <crit_time>\] \[-nworst <num_per>\]"
		echo "       \[-clock <clock_name> | -launch <clock_name> | -capture <clock_name>\]"
		echo "       \[-IO \[-each\]\] \[-noZ\] \[-group <group_name>\]"
		echo "       \[-net <pin_name>\] \[-cell <pin_name>\] <file_name>\n"
		echo "Selects paths for delay fault test generation and writes them in TetraMAX delay path format.\n"
		echo "		-max_paths <num_paths> 	: Specifies the maximum number of paths to be written"
		echo "		-slack <crit_time> 	: Selects paths with slack less than <crit_time>"
		echo "		-nworst <num_per>	: Specifies the number of paths to each endpoint"
		echo "			 		: The default is 1"
		echo "		-clock <clock_name> 	: Selects paths in <clock_name> domain"
		echo "		-launch <clock_name> 	: Selects paths starting from <clock_name> domain"
		echo "		-capture <clock_name> 	: Selects paths ending at <clock_name> domain"
		echo "		-IO		 	: Selects I/O paths"
		echo "				 	: The default is to only write internal paths"
		echo "		-each		 	: Selects path(s) for each I/O"
		echo "		-noZ		 	: Suppresses paths through three state enables"
		echo "		-group <group_name> 	: Selects paths from existing <group_name>"
		echo "		-net <pin_name> 	: Selects path(s) for each fanout connected to <pin_name>"
		echo "		-cell <pin_name> 	: Selects path(s) for each input of cell connected to <pin_name>"
		echo "		-delay_type <max|min> 	: Use max (default) to get delay paths, use min to get hold paths"
		echo "		-version 		: Displays current version\n"
		return
	} else {
		if {$outfile_use == 1} {
			echo "Error: unrecognized argument \"$outfile\"."
			return
		}
		set outfile $n
		set outfile_use 1
	}
  }

  if {[expr $max_paths_use + $crit_slack_use] > 0} {
    if {[expr $each_use + $net_use + $cell_use] > 0} {
	echo "Warning: \"-max_paths\" and \"-slack\" are ignored with \"-each\", \"-net\" or \"-cell\"."
    }
  }
  if {$each_use == 1} {
    if {$IO_use == 0} {
	echo "Error: \"-each\" cannot be specified without \"-IO\"."
	return
    }
  }
  if {[expr $launch_clock_use + $capture_clock_use] > 0} {
    if {[expr $IO_use + $group_use] > 0} {
	echo "Error: <clock_name> cannot be specified with \"-IO\" or \"-group\"."
	return
    }
  }
  if {[expr $IO_use + $group_use] > 1} {
	echo "Error: \"-IO\" and \"-group\" cannot be specified together."
	return
  }
  if {[expr $each_use + $net_use + $cell_use] > 1} {
	echo "Error: \"-each\", \"-net\" and \"-cell\" cannot be specified together."
	return
  }
  if {$outfile_use == 0} {
	echo "Error: <file_name> must be specified for final argument."
	return
  }


  if {$group_use == 0} {
    remove_path_group -all
    update_timing
    if {$IO_use == 1} {
      set group "IO"
    } elseif {[expr $launch_clock_use + $capture_clock_use] > 0} {
      set group $launch_clock
      append group "-"
      append group $capture_clock
      group_path -name $group -from [get_clocks $launch_clock] -to [get_clocks $capture_clock]
    } else {
      set group "internal"
      group_path -name internal -from [all_clocks] -to [all_clocks]
    }
    group_path -name IO -from [all_inputs]
    group_path -name IO -to [all_outputs]
    foreach_in_collection clock [all_clocks] {
      set clk_ports [get_ports -quiet [get_attribute -quiet $clock sources]]
      if {[sizeof_collection $clk_ports] > 0} {
        group_path -name **clock** -from $clk_ports
      }
    }
    if {$timing_enable_preset_clear_arcs == "true"} {
      set async_pins [get_pins -quiet -filter "is_async_pin == true" -hierarchical *]
      if {[sizeof_collection $async_pins] > 0} {
        #set_disable_timing $async_pins
        group_path -name **clock** -from [all_clocks] -through $async_pins -to [all_clocks]
        group_path -name **clock** -from [all_inputs] -through $async_pins
        group_path -name **clock** -through $async_pins -to [all_outputs]
      }
    }
    if {$zstate_use == 0} {
      set zstate_pins [get_pins -quiet -filter "is_three_state_enable_pin == true" -hierarchical *]
      if {[sizeof_collection $zstate_pins] > 0} {
        #set_disable_timing $zstate_pins
        group_path -name **zstate** -from [all_clocks] -through $zstate_pins -to [all_clocks]
        group_path -name **zstate** -from [all_inputs] -through $zstate_pins
        group_path -name **zstate** -through $zstate_pins -to [all_outputs]
      }
    }
  }
  update_timing
  check_timing


  redirect $outfile { echo "" }
  redirect -append $outfile { echo "// pt2tmax" }
  redirect -append $outfile { echo "// Version $version" }
  redirect -append $outfile { echo "" }

  set path_num 0
  if {$each_use == 1} {
    set inputs [all_inputs]
    set input_cnt [sizeof_collection $inputs]
    set outputs [all_outputs]
    set path_items [add_to_collection $inputs $outputs]
  } elseif {$net_use == 1} {
    set path_items [get_pins -filter "direction == in" -leaf -of_objects [get_nets -of_objects $thru_pin]]
  } elseif {$cell_use == 1} {
    set path_items [get_pins -filter "direction == in" -of_objects [get_cells -of_objects $thru_pin]]
  } else {
    set path_items [get_path_groups $group]
  }
  foreach_in_collection item $path_items {
    if {[get_attribute $item object_class] == "path_group"} {
      if {$crit_slack_use == 1} {
        if {$recalculate_use == 1} {
	  set crit_paths [get_timing_paths -group $item \
					   -delay_type $delay_type \
					   -slack_lesser_than $crit_slack \
					   -max_paths $max_paths \
					   -nworst $paths_per \
					   -unique_pins \
					   -pba_mode exhaustive]
        } else {
	  set crit_paths [get_timing_paths -group $item \
					   -delay_type $delay_type \
					   -slack_lesser_than $crit_slack \
					   -max_paths $max_paths \
					   -nworst $paths_per \
					   -unique_pins]
        }
      } else {
        if {$recalculate_use == 1} {
	  set crit_paths [get_timing_paths -group $item \
					   -delay_type $delay_type \
					   -max_paths $max_paths \
					   -nworst $paths_per \
					   -unique_pins \
					   -pba_mode exhaustive]
        } else {
	  set crit_paths [get_timing_paths -group $item \
					   -delay_type $delay_type \
					   -max_paths $max_paths \
					   -nworst $paths_per \
					   -unique_pins]
        }
      }
    } elseif {[get_attribute $item object_class] == "port"} {
      if {$input_cnt > 0} {
        if {$recalculate_use == 1} {
	  set crit_paths [get_timing_paths -from $item \
					   -delay_type $delay_type \
					   -max_paths $paths_per \
					   -nworst $paths_per \
					   -unique_pins \
					   -pba_mode exhaustive]
        } else {
	  set crit_paths [get_timing_paths -from $item \
					   -delay_type $delay_type \
					   -max_paths $paths_per \
					   -nworst $paths_per \
					   -unique_pins]
        }
      } else {
        if {$recalculate_use == 1} {
	  set crit_paths [get_timing_paths -to $item \
					   -delay_type $delay_type \
					   -max_paths $paths_per \
					   -nworst $paths_per \
					   -unique_pins \
					   -pba_mode exhaustive]
        } else {
	  set crit_paths [get_timing_paths -to $item \
					   -delay_type $delay_type \
					   -max_paths $paths_per \
					   -nworst $paths_per \
					   -unique_pins]
        }
      }
      set input_cnt [expr $input_cnt - 1]
    } elseif {[get_attribute $item object_class] == "pin"} {
        if {$recalculate_use == 1} {
	  set crit_paths [get_timing_paths -through $item \
					   -delay_type $delay_type \
					   -max_paths $paths_per \
					   -nworst $paths_per \
					   -unique_pins \
					   -pba_mode exhaustive]
        } else {
	  set crit_paths [get_timing_paths -through $item \
					   -delay_type $delay_type \
					   -max_paths $paths_per \
					   -nworst $paths_per \
					   -unique_pins]
        }
    }

    foreach_in_collection path $crit_paths {
      set path_group [get_attribute -quiet $path path_group]
      if {$path_group == ""} {
        # ports/pins without timing paths
        continue
      }
      if {[get_object_name $path_group] != $group} {
        # paths in another timing group
        continue
      }
      set path_pins [get_attribute $path points]
      if {$delay_type == "min" || [sizeof_collection $path_pins] < 4} {
        # paths without combinational cells cause P10 without special care
        # hold_time ATPG requires driving cell output to prevent M763
        set short_path 1
      } else {
        set short_path 0
      }
      set start [get_attribute $path startpoint]
      set end [get_attribute $path endpoint]
      set slack [get_attribute $path slack]
      set lent [get_attribute -quiet $path time_lent_to_startpoint]
      set borrowed [get_attribute -quiet $path time_borrowed_from_endpoint]

      if {[get_attribute $start object_class] == "port"} {
        set start_point $start
        set start_time [get_attribute -quiet $path startpoint_input_delay_value]
        if {$start_time == ""} {
          # paths from clock ports
          continue
        }
        set start_clk ""
        set start_edge ""
      } else {
        set start_point [get_cells -of_objects $start]
        set start_time [get_attribute -quiet $path startpoint_clock_open_edge_value]
        set start_clk [get_attribute $path startpoint_clock]
        set start_edge [get_attribute $path startpoint_clock_open_edge_type]
      }
      if {[get_attribute $end object_class] == "port"} {
        set end_point $end
        # output paths do not have start/end times
        set required [get_attribute $path required]
        set start_time ""
        set end_time ""
        set end_clk ""
        set end_edge ""
      } else {
        set end_point [get_cells -of_objects $end]
        set end_time [get_attribute $path endpoint_clock_close_edge_value]
        set required "Inf"
        set end_clk [get_attribute $path endpoint_clock]
        set end_edge [get_attribute $path endpoint_clock_close_edge_type]
      }

      set path_num [expr $path_num + 1]
      redirect -append $outfile {  echo "\$path \{" }
      redirect -append $outfile { echo [format "  // from: %s" [get_object_name $start_point]] }
      redirect -append $outfile { echo [format "  // to: %s" [get_object_name $end_point]] }
      redirect -append $outfile { echo [format "  \$name \"%s_%d\" ;" $group $path_num] }

      if {$start_time != ""} {
        redirect -append $outfile { echo [format "  \$cycle %g ;" [expr $end_time - $start_time]] }
      } else {
        if {$required != "Inf"} {
          redirect -append $outfile { echo [format "  \$cycle %g ;" $required] }
        }
      }
      if {$slack != "Inf"} {
        redirect -append $outfile { echo -n [format "  \$slack %g ;" $slack] }
      }
      if {$lent > 0} {
        redirect -append $outfile { echo -n [format " // (lent %g)" $lent] }
      }
      if {$borrowed > 0} {
        redirect -append $outfile { echo -n [format " // (borrowed %g)" $borrowed] }
      }
      redirect -append $outfile { echo "" }

      if {$start_clk != ""} {
        set clk_ports [get_ports -quiet [get_attribute -quiet $start_clk sources]]
        if {[sizeof_collection $clk_ports] == 1} {
          redirect -append $outfile { echo [format "  \$launch \"%s\" ; // (%s edge)" \
		[get_object_name $clk_ports] $start_edge] }
        }
      }
      if {$end_clk != ""} {
        set clk_ports [get_ports -quiet [get_attribute -quiet $end_clk sources]]
        if {[sizeof_collection $clk_ports] == 1} {
          redirect -append $outfile { echo [format "  \$capture \"%s\" ; // (%s edge)" \
		[get_object_name $clk_ports] $end_edge] }
        }
      }

      redirect -append $outfile { echo "  \$transition \{" }
      set pin_num 0
      set start_pin "true"

      foreach_in_collection point $path_pins {
        set pin [get_attribute $point object]
        set pin_num [expr $pin_num + 1]
        set direction [get_attribute $pin direction]
        if {$pin_num < 2} {
          # source cell input pins cause P6/P5 error
          # input ports for short IO paths must be printed to avoid P10
          if {$short_path == 0 || [get_attribute -quiet $pin is_port] == "false"} {
            continue
          }
        }
        if {$direction == "inout"} {
          if {$start_pin == "false"} {
            if {[get_attribute -quiet $pin is_port] == "false"} {
              # intermediate inout pins cause P5 error
              continue
            }
          }
        } elseif {$direction != "in" && $short_path == 0} {
          # output pins are redundant in path list
          continue
        } 
        set start_pin "false"

       if { [get_attribute $pin object_class] != "port"  } {
        if {[get_attribute $point rise_fall] == "rise"} {
          redirect -append $outfile { echo [format "    \"%s\" ^ ; // (%s)" \
		[get_object_name $pin] \
		[get_attribute -quiet [get_cells -of_objects $pin] ref_name]] }
        } else {
          redirect -append $outfile { echo [format "    \"%s\" v ; // (%s)" \
		[get_object_name $pin] \
		[get_attribute -quiet [get_cells -of_objects $pin] ref_name]] }
        }
	  } else {
        if {[get_attribute $point rise_fall] == "rise"} {
          redirect -append $outfile { echo [format "    \"%s\" ^ ; // (%s)" \
		[get_object_name $pin] \
		[get_object_name $pin] ] }
        } else {
          redirect -append $outfile { echo [format "    \"%s\" v ; // (%s)" \
		[get_object_name $pin] \
		[get_object_name $pin] ] }
        }
	   }
      }
      redirect -append $outfile { echo "  \}" }
      redirect -append $outfile { echo "\}" }
      redirect -append $outfile { echo "" }
    }
  }
}


##########################################################################
#
# Tcl script to convert PrimeTime timing violations to timing exceptions.
#
##########################################################################

proc write_exceptions_from_violations {args} {
	set version "E-2010.12"
	set output tmax_exceptions.sdc
	set path_position 0
	set max_iter_num 40
	set delay_type max

	set position [lsearch -exact $args {-specific_start_pin}]
	if {$position != -1} {
		set path_position 1
		set newargs [lreplace $args $position $position]
		set args $newargs
	}
	foreach {name value} $args {
		if {$name == "-output"} {
			set output $value
		} elseif {$name == "-max_iterations"} {
			set max_iter_num $value
		} elseif {$name == "-delay_type"} {
			set delay_type $value
			if {$delay_type != "max" && $delay_type != "min" && $delay_type != "min_max"} {
				echo "Error: -delay_type must be max, min, or min_max"
				return 0
			}
		} elseif {$name == "-help"} {
			echo "Usage: write_exceptions_from_violations \[-output <filename>\] \[-specific_start_pin\] \[-max_iterations <number>\] \[-delay_type <max|min|min_max>\]"
			echo "Converts timing violations to exceptions for TMAX in SDC format."
			echo "    -output <filename>"
			echo "        Default is tmax_exceptions.sdc."
			echo "    -specific_start_pin"
			echo "        Write separate exceptions for different outputs of a violating cell."
			echo "        Default is one exception per startpoint cell."
			echo "    -max_iterations <number>"
			echo "        Iterate <number> times before placing blanket exceptions on endpoints."
			echo "        Default is 40."
			echo "    -delay_type <max|min|min_max>"
			echo "        Use max for setup, min for hold, or min_max for both."
			echo "        Default is max."
			return 1
		} else {
			echo "Error: Invalid option $name"
			echo "Try using -help"
			return 0
		}
	}

	set OUT [open $output w]
	puts $OUT "# Timing Exceptions for TMAX in SDC "
	puts $OUT "# Generated by pt2tmax Version $version"
	puts $OUT "#"

	# Iterate until timing is clean.  Necessary for multiple-output
	# startpoints, since the start_end_pair will only report the worst
	# output pin for a given startpoint.
	# Not really needed unless -specific_start_pin is specified.

	set path_num 1
	set iter_num 1
	for {set iter_num 1} {$iter_num <= $max_iter_num} {incr iter_num} {
		echo "Iteration $iter_num update_timing..."
		update_timing
		set paths [get_timing_paths -start_end_pair -delay_type $delay_type -slack_lesser_than 0]
		set num_paths [sizeof_collection $paths]
		echo "Iteration $iter_num found $num_paths Paths..."
		if {$num_paths < 1} {
			echo "Iteration $iter_num Exiting because timing is clean!"
			puts $OUT "# Exiting because timing is clean!  Iteration = $iter_num"
			break
		}
		if {$iter_num == $max_iter_num} {
			puts $OUT "# "
			puts $OUT "# Iteration limit reached, suppressing path startpoints"
		}

		echo "Iteration $iter_num Path processing..."
		# If we are still here, then we are below the iteration limit,
		# and there are still violating paths in this collection.
		foreach_in_collection path $paths {

			# Report the path info from PT:
			set Start_obj [get_attribute $path startpoint]
			set Start_name [get_object_name $Start_obj]
			set End_obj [get_attribute $path endpoint]
			set End_name [get_object_name $End_obj]
			set path_group_name [get_object_name [get_attribute $path path_group]]
			set path_delay_type [get_attribute $path path_type]
			set slack_value [get_attribute $path slack]

			puts $OUT "# Path Index: $path_num    Iteration: $iter_num"
			puts $OUT "#  Start:      $Start_name"
			puts $OUT "#  End:        $End_name"
			puts $OUT "#  Group:      $path_group_name"
			puts $OUT "#  Type:       $path_delay_type"
			puts $OUT "#  Slack:      $slack_value"

			if {$path_delay_type == "max"} {
				set exception_type "-setup"
			} else {
				set exception_type "-hold"
			}

			if {$iter_num == $max_iter_num} {
				# Force a false path just to the endpoint:
				puts $OUT "set_false_path $exception_type -to $End_name"
				set_false_path $exception_type -to $End_name
			} elseif {[get_attribute $Start_obj object_class] == "port"} {
				# Screen out startpoints at ports
				puts $OUT "set_false_path $exception_type -from $Start_name -to $End_name"
				set_false_path $exception_type -from $Start_name -to $End_name
			} elseif {$path_position} {
				# The 0th index is the clock pin of the startpoint on reg->reg paths:
				# The 1st index is the output pin of the startpoint on reg->reg paths:
				set Points_coll [get_attribute $path points]
				set Point1_pin [index_collection $Points_coll 1]
				set Point1_name [get_object_name [get_attribute $Point1_pin object] ]
				puts $OUT "set_false_path $exception_type -through $Point1_name -to $End_name"
				set_false_path $exception_type -through $Point1_name -to $End_name
			} else {
				puts $OUT "set_false_path $exception_type -from $Start_name -to $End_name"
				set_false_path $exception_type -from $Start_name -to $End_name
			}

			# Increment path count:
			incr path_num
		}
	}

	close $OUT
}


