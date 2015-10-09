// number of examinees at a raw score r
function y = num(r, A)
    f = find(sum(A,2) == r);
    y = size(f,2);
endfunction
