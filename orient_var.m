function var = orient_var(var)
var=squeeze(var);
[r,c]=size(var);
if r>c
    var=var;
elseif c>r
    var=var';
end
