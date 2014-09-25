Convex Optimization is a beatufiul and powerful field of applied mathematics that I've been learning since 2012. 
The basic idea is this: we can efficiently optimize complicated nonlinear functions subject to inequality constraints 
and affine equality constraints if the functions are *convex*, a mathematical property. 
And we have a convergence theory giving accurate estimates on just how fast we can solve these problems. 
For more, see http://cvxr.com/ and http://web.stanford.edu/~boyd/cvxbook/

CVX finds applications in many fields ranging from machine learning, to signal processing, to finance, statistics, 
circuit design, communications, and network modeling. It is the superset of problems such as quadratic programming 
(e.g. least squares) and linear programming. Accompanying the theory are efficient interior-point methods. For 
prototyping and modeling purposes, a MATLAB framework called "CVX" has been developed allowing easy programming
of problem descriptions to be input to a general solver system. 

The CVX software allows you to specify problems of the following form:

variable [declare variables' size/structure]
minimize [objective function]
subject to [inequality constraints]
           [affine equality constraints, i.e. Ax == b]
		   
The software then parses your problem and converts it to a form acceptable by a general-purpose solver. Here's an
example program:

cvx_begin
	variable x(n);
	minimize( norm(A*x-b) );
	subject to
		C*x == d;
		norm(x,Inf) <= 1;
cvx_end

This program minimizes the norm of the difference of A*x and vector b subject to equality constraints C*x == d, 
and that the infinity norm (i.e. max absolute component value) of our vector variable x has to be <= 1. Running this code
in your MATLAB script will invoke the CVX engine and return an optimal value of the problem, and the optimal 
solution vector x. The matrices A, C and vector b are problem data that can be declared outside the CVX scope. 
For more, see http://web.cvxr.com/cvx/doc/ 

In this repository are some of the practical optimization problems I've solved using CVX, as well as basic 
implementation of a few optimization algorithms. Examples include:

- Maximum likelihood estimation of sports team tournament results
- Fitting an ellipsoid to data points
- Rational function approximation of an exponential distribution
- Signal processing: removal of Gaussian noise
- Linear separation of trinary data
- Maximum volume rectangle inside a polyhedron (i.e. a form of "centering")
- Gradient descent algorithm template
- Newton method algorithm template

Other applications I've come across that are framed readily and solved efficiently as convex optimization 
problems include:

- Support vector machines (i.e. maximum margin classifier & approximate linear separation of sets)
- Network flow optimization
- Portfolio optimization using a k-factor risk model

In summary, what's great about convex optimization is:

1) Allows one to frame and analyze complicated problems easily, 
2) Wide ranging applications encompassed by the generality,
3) Enables very fast prototyping with the CVX framework,
4) Theory extends to implementation details involving problem structure. These expose efficiency opportunities
accessible through numerical linear algebra, using existing packages like LAPACK and BLAS.
