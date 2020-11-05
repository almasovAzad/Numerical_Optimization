function [t,xx] = eks(A,x0,tspan,i,n,example) %Solve ODE
CC = A(1:n,1+n:2*n); 
AA = A(1:n,1:n);
[t,xx] = ode45(@(tt,x) dfx(tt,x,AA,CC,i,example),tspan,x0');
end