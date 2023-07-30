# Necessary software: Fortran compiler, gnuplot


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
cstr3: NEW INPUT FORMAT
	* Input cleaned up
	* Add additional noise immediatly after a variable is updated individually for all 14 measured variables


# Compile the Fortran source
gfortran -O3 -o cstr1 cstr1.f


# Execution produces data file 'X.csv'



# Execute script for fault 2
cstr1 < fault_2.txt

# Visualize 14 variables and 4 constraints with 'gnuplot'
gnuplot gnuplot-data.gnu


# Execute script for fault 3
cstr1 < fault_3.txt

# Visualize 14 variables and 4 constraints with 'gnuplot'
gnuplot gnuplot-data.gnu


# Execute script for fault 14
cstr1 < fault_14.txt

# Visualize 14 variables and 4 constraints with 'gnuplot'
gnuplot gnuplot-data.gnu
