###
###
### Compiling and linking: make
###
### Running: reactor <config-file>
###                Ex. reactor ../cfg/config.csv
###
### Format config file:
###
### First line:	Number of time steps executed
### Second line:	Resolution of data dumping
### Next lines: # as first letter ==> Comment line, ignored
### <time-step>     <event-number> <ON/OFF-1/0>
### Exception event: 0=Data dumping
###
###	Fault numbers defined in 'fault.h'
###
###
### Example
###
10000			# Number of time steps
20			# Resolution of data dumping (every n-th step)
#									
# Timestamp		Event				State		
# ====================================================================
100			3				1
  # comment 1						
200			5				1
200			4				1
# comment 2						
 # comment 3						
300			0				1		# Data dump on
400			3				0
400			4				0
400			5				0
1000			0				0		# Data dump off

