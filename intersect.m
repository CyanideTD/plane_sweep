[ydim, xdim] = size(reference);
X1 = repmat(1:xdim,ydim,1);
Y1 = repmat((1:ydim)',1,xdim);
Z1 = ones(ydim, xdim);
P = P' * (P * P')^(-1);
x2 = bsxfun(@plus, bsxfun(@times, P(1,1), X1), bsxfun(@times, P(1, 2), Y1), P(1,3));
y2 = bsxfun(@plus, bsxfun(@times, P(2,1), X1), bsxfun(@times, P(2, 2), Y1), P(2,3));
z2 = bsxfun(@plus, bsxfun(@times, P(3,1), X1), bsxfun(@times, P(3, 2), Y1), P(3,3));
w = bsxfun(@plus, bsxfun(@times, P(4,1), X1), bsxfun(@times, P(4, 2), Y1), P(4,3));

x2 = bsxfun(@rdivide, x2, w);
y2 = bsxfun(@rdivide, y2, w);
z2 = bsxfun(@rdivide, z2, w);

t = d / sqrt(sum(v1 ./ v1));
pplane = t*v1;
