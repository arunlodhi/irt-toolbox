// Rasch Model
function y = prob(b, t)
    [B, T] = meshgrid(b,t);
    y = 1 ./(1+exp(-(T-B)));
endfunction
