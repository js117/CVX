% Given a quadratic, 1/2 * x'*P*x + q'*x + r (P > 0)
% Return the SOC format, i.e. ||Bk0*x + dk0||2 <= Bk1*x + dk1
% Source: http://en.wikipedia.org/wiki/Second-order_cone_programming#Example:_Quadratic_constraint
% (and some algebra)
function [Bk0, dk0, bk1, dk1] = QuadraticToSOC(P, q, r)

end