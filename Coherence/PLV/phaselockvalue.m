function [PLV]=phaselockvalue(ph1,ph2)
N=size(ph1,2);
iN=1/N;
PLV=iN*abs(sum(exp(1i.*(ph1-ph2)),2));