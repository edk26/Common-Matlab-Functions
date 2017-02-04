function [pls]=plvshuffle(ph1,ph2)
trialn=size(ph1,2);
rng('shuffle')
for i=1:400
    rind=randperm(trialn);
    temp=ph1(:,rind);
    pls(:,i)=phaselockvalue(temp,ph2);
   
end
