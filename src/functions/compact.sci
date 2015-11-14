// function to compact reduced matrix
function [y, s] = compact(A)
    [m,n] = size(A);
    resp = [];
    scores = [];
    for i = 0:n
        f = find(sum(A,2) == i);
        if ~isempty(f) then
            resp = [resp; sum(A(f,:),1)];
            scores = [scores; i];
        end
    end
    y = resp;
    s = scores;
endfunction
