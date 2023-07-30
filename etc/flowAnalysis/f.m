%Define each function as f(x)=0
function F = f(x)
global H R;
F = [
	x(1) - H(1) - R(1)*x(2)*x(2)*sign(x(2));
	H(2) - x(1) - R(2)*x(3)*x(3)*sign(x(3));
	x(1) - H(3) - R(3)*x(4)*x(4)*sign(x(4));
	x(2) - x(3) + x(4)
];
