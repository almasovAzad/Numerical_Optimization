# Numerical Optimization
Given general linear differential equation in matrix vector multiplication form [dx(t)/dt = Ax(t)+Cu(t)], I tried to estimate the coefficients of the linear differential equation. Given the parameters of the model, which are coefficients (A,C,  both are matrix) and stimulus values (u(t)), and the initial state of the system x(0), the response or solution x(t) can be determine numerically. This is the forward problem. However, in this project, I solve inverse problem through experiment results.
The inverse problem is the problem of finding the parameters in the model from a sequence of experiments. Specially we want to determine A and C given a sequence of experiments where we input different functions u(t) and measure the output x(t). And since x depends on the parameters,
I can write the solution as x(t; A;C).
When I conduct at experiment, measurements are always contaminated by noise and
samples are only taken at a discrete set of point say {t_1, ..., t_k}. So instead of being able
to measure x directly we instead measure:
y^i(t_k) = x^i(t_k) + e, where e is Gaussian random variable. So I try to estimate coefficients through experiments by minimizing the squared error.
