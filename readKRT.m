function [K, R, t] = readKRT(filename)
fidin = fopen(filename);
R = zeros(3, 3);
t = zeros(1, 3);
K = zeros(3, 3);
for i = 1:3
    tline = fgetl(fidin);
    K(i, :) = str2num(tline);
end
tline = fgetl(fidin);

for i = 1:3
    tline = fgetl(fidin);
    R(i, :) = str2num(tline);
end

tline = fgetl(fidin);
t = str2num(tline);
t = t';
end