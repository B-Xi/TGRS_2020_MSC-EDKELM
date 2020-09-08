function errRadians = getSam(a, b, alpha)
% GETSAM computes the spectral angle error between the vector b and
% every column of matrix a (or just the first column, if a is a vector)
normab = sqrt(sum(a.^2,2))*sqrt(sum(b.^2,2))';
errRadians = acos((a*b')./normab);
errRadians=exp(-alpha*errRadians); %2*7
end