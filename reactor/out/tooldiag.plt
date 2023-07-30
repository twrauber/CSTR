#
#  Batch file for gnuplot
#  Generated automatically !
#
#
#
#
set xlabel "Mapped dimension #1"
set ylabel "Mapped dimension #2"
set title "-TOOLDIAG- SAMMON PLOT of features.dat: 13-D mapped to 2-D\nIterations=1000  Mapping error=3.00092e-02"
set xrange [-0.352808:0.399400]
set yrange [-0.275806:0.532879]
plot"NORMAL", "INPUT_CONCENTRATION_A_HIGH", "INPUT_CONCENTRATION_A_HIGH+RECYCLE_FLOW_SET_POINT_HIGH+FOULED_HEAT_EXCHANGER", "1.000000", "1.074773", "1.124003", "RECYCLE_FLOWMETER_STUCK_HIGH", "LEAK_FLOW_IN_REACTOR"
pause -1 "Hit return to exit..."