th = 0.5;
dpm = gpuArray(zeros(ydim, xdim));
N = dpm;

for v = 1:2
    over = bsxfun(@gt, bestncc(:,:,v), th);
    dpm = dpm + over .* depthmap(:,:,v);
    N = N + over;
end

dpm = bsxfun(@rdivide, dpm, N);
dpm = gather(dpm);
denoised = denoiseTVL1(dpm, ref, 0.3, 100, 9.5, 2);
