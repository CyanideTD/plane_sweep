function Y = colfilter(X, h)


[r,c] = size(X);
m = length(h);
m2 = fix(m/2);

if any(X(:))

   xe = reflect([(1-m2):(r+m2)], 0.5, r+0.5);
   

   Y = conv2(X(xe,:),h(:),'valid'); 
else
   Y = zeros(r+1-rem(m,2),c); % Short cut if X is all zeros.
end
return;
