function y = reflect(x,minx,maxx)
y = x;

% Reflect y in maxx.
t = find(y > maxx);
y(t) = 2*maxx - y(t);

% Reflect y in minx.
t1 = find(y < minx);
t2 = 0;
while ~isempty(t1) | ~isempty(t2), % Repeat until no more values out of range.
   if ~isempty(t1), y(t1) = 2*minx - y(t1); end
   t2 = find(y > maxx);
   if ~isempty(t2), y(t2) = 2*maxx - y(t2); end
   t1 = find(y < minx);
end
return;

