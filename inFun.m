function u = inFun(tt,i,example) % Arbitrary Input functions
if example == 1;
    cc = sin(tt/i); % Each experiment these input functions keep changing          
    z  = cos(tt/i)-sin(tt/i);  % i is the ith experiment 
    uu = cos(tt/i);
    u = [z;cc;uu];
elseif example == 2;
    cc = sin(tt*i);          
    z  = cos(tt*i)-sin(tt*i);
    u = [z;cc];
else
    cc = sin(tt*i)+cos(tt/i);          
    z  = cos(tt*i)-sin(tt/i);
    u = [z;cc];
end
end