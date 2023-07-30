1.) To compile just type 'make'
2.) To execute just type 'reactor'
	This starts the simulation of the chemical reactor.



Faults are defined in the file 'faults.c'

In order to invoke a faults, the variable 'event'
has to be changed (modification of a line)
when: The discrete time step when the event (fault) occurs
what: The kind of fault (as defined in the file), e.g. leak


The variable 'dump_interval' controls the sampling of the data,
i.e. when and in which time steps the variable values are collected.
The result is written to a file which can be read by 'tooldiag'.

Besides the time evolution of the variables can be visualized by 'gnuplot'


Have fun. More questions: thomas.rauber@ufes.br
