n = [0 0 1]';
% 
% n = Rrel' * n;

g = ones(5, 1)/5;
threshold = 0.5;
ref = camera(1).Image;
meanref = colfilter(colfilter(ref,g).',g).';
sqrref = ref .* ref;
meansqrref = colfilter(colfilter(sqrref,g).',g).';
varref = meansqrref - meanref .* meanref;
positive = bsxfun(@gt, varref, 0);
stdref = sqrt(positive .* varref);
[ydim, xdim] = size(camera(1).Image);
% image x and y pixel coordinates
X1 = repmat(1:xdim,ydim,1);
Y1 = repmat((1:ydim)',1,xdim);

% Z1 = ones(ydim, xdim);
% 
% P = camera(1).K*[eye(3) -eye(3)*[0 0 0]'];
% 
% P = P' * (P * P')^(-1);
% 
% dx2 = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, P(1,1), X1), bsxfun(@times, P(1, 2), Y1)), P(1,3));
% 
% dy2 = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, P(2,1), X1), bsxfun(@times, P(2, 2), Y1)), P(2,3));
% 
% dz2 = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, P(3,1), X1), bsxfun(@times, P(3, 2), Y1)), P(3,3));
% 
% dw = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, P(4,1), X1), bsxfun(@times, P(4, 2), Y1)), P(4,3));
% 
% 
% 
% dx2 = bsxfun(@rdivide, dx2, dw);
% 
% dy2 = bsxfun(@rdivide, dy2, dw);
% 
% dz2 = bsxfun(@rdivide, dz2, dw);

for d = 4:0.1:10
    H = (camera(1).K * (Rrel + Trel * n'/d) * camera(1).K^(-1)); % homography
    H = H / H(3,3);
    
    % calculate new pixel positions in sensor image
    x2 = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, H(1,1), X1), bsxfun(@times, H(1,2), Y1)), H(1,3));
    y2 = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, H(2,2), Y1), bsxfun(@times, H(2,1), X1)), H(2,3));
    w  = bsxfun(@plus, bsxfun(@plus, bsxfun(@times, H(3,1), X1), bsxfun(@times, H(3,2), Y1)), H(3,3));
    x2 = bsxfun(@rdivide, x2, w);
    y2 = bsxfun(@rdivide, y2, w);
    
    

    % interpolate pixel values in transformed image
    warped = interp2(X1, Y1, camera(2).Image, x2, y2, 'linear', 0);
    
    meanwarped = colfilter(colfilter(warped,g).',g).';
    sqrwarped = warped .* warped;
    meansqrwarped = colfilter(colfilter(sqrwarped,g).',g).';
    var = meansqrwarped - meanwarped .* meanwarped;
    positive = bsxfun(@gt, var, 0);
    
    stdwarped = sqrt(positive .* var) + (1 - positive) * threshold / 10;
    
    I1I2 = warped .* camera(1).Image;                                    % element-wise product
    mean1mean2 = meanref .* meanwarped;                     % product of means in a window
    sI1I2 = colfilter(colfilter(I1I2,g).',g).';             % mean of products in a window
    stdprod = stdref .* stdwarped;
    ncc = (sI1I2 - mean1mean2) ./ stdprod; 
    
    abovethreshref = bsxfun(@gt, stdref, threshold);
    abovethreshwarped = bsxfun(@gt, stdwarped, threshold);
    abovethresh = bsxfun(@and, abovethreshref, abovethreshwarped);
    ncc = abovethresh .* ncc;
    
%     t = d / sqrt(sum(n ./ n));
% 
%     pplane = t*n;
%     
%     NZ1 = Z1 * t * sum(n.*n);
%     
%     NZ1 = bsxfun(@rdivide, NZ1, dx2*n(1) + dy2*n(2) + dz2*n(3));
    
    greater = bsxfun(@gt, ncc, bestncc);
    less = bsxfun(@minus, 1, greater);
    depthmap = bsxfun(@plus, bsxfun(@times, greater, d), bsxfun(@times, depthmap, less));
    bestncc = bsxfun(@plus, bsxfun(@times, greater, ncc), bsxfun(@times, less, bestncc));
end