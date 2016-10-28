#!/bin/bash
# This is how I think the logic could work - this is not real bash code by any stretch of the imagination :)

# launch lpj-guess and rstudio, pipe initial conditions files into them
horsemodel.R | rstudio
grassmodel.csv | lpj-guess
# global variable for timestep 
$TIMESTEP = 0

# fixed loop runs each model 1 step at a time, writes output and pipes to program
for i in {1:100}
do 
  $TIMESTEP = $TIMESTEP + 1
    if $TIMESTEP > 0
      "netlogo-output-" $TIMESTEP - 1 ".csv" | lpj-guess set grass "column2" # read in netlogo output from previous timestep
  run lpj-guess # command to advance one timestep
  write grass "guess-output-" $TIMESTEP ".csv" # save grass amount
  "guess-output-" $TIMESTEP ".csv" | rstudio horsemodel.R set grass "column2" # read in guess output into horse model
  run horsemodel.R # advance one timestep in horsemodel
  write grass "netlogo-output-" $TIMESTEP ".csv" # save grass amount

done

