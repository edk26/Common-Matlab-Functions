function [CU, r] = Get_Unique_Detections (C)

if size(C,2)>3
    C=C(:,1:3);
end

parfor i=1:size(C,1)
    for j=1:3
        if ~iscellstr(C(i,j))
            C{i,j}=num2str(C{i,j});
        end
    end
end

[CU, r, c] = uniqueRowsCA(C);