# Necessary software: Fortran compiler, gnuplot, Python3


LINUX
# if not installed in Linux as administrator execute:
# sudo apt-get install gfortran
# sudo apt-get install gnuplot

WINDOWS
Free Fortran compiler: Force Fortran http://www.lepsch.com/downloads/Force3beta3Setup.exe
Gnuplot: https://sourceforge.net/projects/gnuplot/files/gnuplot/


Versions:
cstr1: Original software
cstr2: Add noise immediatly after a variable is updated (all 14 measured variables)
cstr3: NEW INPUT FORMAT (config batch files for cstr2 not compatible)
	* Input cleaned up
	* Add additional noise immediatly after a variable is updated individually for all 14 measured variables
cstr4:
    * Additionally, the two setpoints (SP1, SP2) are written out as two new columns at the end of the line.


DEFAULT VERSION: cstr2


# Compile the Fortran source
gfortran -O3 -o cstr2 cstr2.f


# Execution produces data file 'X.csv'


# Execute script for fault 12
cstr2 < ../cfg/fault_12_abnormal_feed_flowrate.txt

# Visualize 14 variables and 4 constraints with 'gnuplot'
gnuplot gnuplot-data.gnu
# ... or with Python
python3 processX.py

#=================================

# Execute script for fault 17
cstr2 < fault_17_abnormal_jacket_effluent_pressure.txt

# Visualize 14 variables and 4 constraints with 'gnuplot'
gnuplot gnuplot-data.gnu
# ... or with Python
python3 processX.py
