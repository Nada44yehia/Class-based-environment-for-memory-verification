# Create work library
vlib work
vmap work work

# Compile all files 
vlog pack.sv
vlog memory_interface.sv
vlog transaction.sv
vlog sequencer.sv
vlog driver.sv
vlog monitor.sv
vlog scoreboard.sv
vlog subscriber.sv
vlog environment.sv
vlog test.sv
vlog tb_top.sv

# Run simulation with coverage enabled
vsim -voptargs=+acc -coverage work.tb_top

# Add all signals to wave (optional)
add wave -r *

# Run simulation
run -all

# Save coverage database
coverage save coverage.ucdb

# Generate coverage report in transcript
coverage report -details

# Optional: Open GUI coverage viewer
#coverage view