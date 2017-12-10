camera = struct('Image', {}, ...
                'K', {}, ...
                'R', {}, ...
                'T', {} ...
                );
   
[camera(1).K, camera(1).R, camera(1).T] = readKRT('0005.png.camera');
[camera(2).K, camera(2).R, camera(2).T] = readKRT('0006.png.camera');

Rrel = camera(2).R'*camera(1).R;
Trel = camera(2).R' * (camera(1).T - camera(2).T);
camera(1).Image = 255 * im2double(rgb2gray(imread('0005.png')));
camera(2).Image = 255 * im2double(rgb2gray(imread('0006.png')));

znear = 1.5;          % minimum depth
zfar = 3.5;          % maximum depth
nsteps = 250;       % number of planes used
n = [0 0 1]';
dstep = (zfar - znear) / (nsteps - 1);
depths = znear:dstep:zfar;

[r, c] = size(camera(1).Image);
depth_map = zeros(r, c);
bestNCC = zeros(r, c);

X1 = gpuArray(repmat(1:c,r,1));
Y1 = gpuArray(repmat((1:r)',1,c));

for d=depths
H = (camera(2).K*(Rrel - Trel * n'./d)/camera(1).K^(-1));

end