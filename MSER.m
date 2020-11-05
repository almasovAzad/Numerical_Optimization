function mser = MSER(A,x0,tspan,m,n,yk,example)
for i=1:m
    [x,~,t] = Measurement(A,x0,tspan,m,n,example);
    for j=1:length(t)
        asd(j) = (norm(yk{i}(j,:) - x{i}(j,:)))^2;
    end
    dsa(i) = sum(asd);
end
mser = sum(dsa);
end