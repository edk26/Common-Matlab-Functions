function [labels,ch]=xl_labels(A)
f1=fieldnames(A);
% [s1,ok1] = listdlg('ListString',f1);
f2=fieldnames(A.(f1{1}));
[s2,ok1] = listdlg('ListString',f2);
f3=A.(f1{1}).(f2{s2})(5:end,1)%NOTE-This depends on first 4 rows being garbage!!!!
f33=A.(f1{2}).(f2{s2})(:,1);
[s3,ok1] = listdlg('ListString',f3);

labels=f3(s3);
ch=f33(s3);