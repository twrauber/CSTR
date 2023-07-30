%Define each function as g(x)=0
function G = g(x)
global H R p;
G = [
	H(1) + p/(9800*x(2)) - x(1) - R(1)*x(2)*x(2)*sign(x(2));
	x(1) - H(2) - R(2)*x(3)*x(3)*sign(x(3));
	x(1) - H(3) - R(3)*x(4)*x(4)*sign(x(4));
	x(2) - x(3) - x(4)
];

