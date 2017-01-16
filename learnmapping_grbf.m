
% learn GRBF mapping
% input:
% D : original data matrix Nxd  N: is the number of samples, d: is the dimensionality of the input images
% X : embedding space representation. Nxe matrix N: number of samples, e: the dimesnionality of the embedding space
% cent: centers: exm e: the dimesnionality of the embedding space

function CF=learnmapping_grbf(D,X,cent)

% learn nonlinear mapping

[n dim] =size(cent);

N=size(D,2);

CF=[];

A=directs_grbf(X,cent);

F=[D; zeros(dim+1,N)];

Af=full(A);

CF=Af\F;

