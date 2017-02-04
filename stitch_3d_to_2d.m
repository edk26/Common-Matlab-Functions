function [stitched] = stitch_3d_to_2d (data)
sz=size(data);
stitched=nan(sz(1),sz(2)*sz(3));
for ch=1:sz(3)
    stitched(:,(ch-1)*sz(2)+1:ch*sz(2))=data(:,:,ch);
end




% for ch=1:sz(3)
%     for i=1:sz(2)
%         stitched((i-1)*sz(1)+1:i*sz(1),ch)=data(:,i,ch);
%     end
% end