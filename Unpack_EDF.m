function [raw,labels,fs] = Unpack_EDF
% Calls blockEdfLoad to pull UPMC Presby data from .edf files
% Outputs:
%   raw     - raw time series of selected channels
%   labels  - labels for selected channels
%   fs  - sampling frequency
% SDK011215

[handles.file.FileName,handles.file.PathName,FilterIndex] = uigetfile({'*.edf'},'Select Data File');

[hdr,shdr]=blockEdfLoad(fullfile(handles.file.PathName,handles.file.FileName));
labels=cell(size(shdr))';
for i=1:size(labels,1)
    labels{i}=shdr(i).signal_labels;
end

[s,v] = listdlg('PromptString','Select a file:',...
    'SelectionMode','multiple',...
    'ListString',labels)

[~,~,raw1]=blockEdfLoad(fullfile(handles.file.PathName,handles.file.FileName),labels(s)');
raw=zeros(size(raw1{1},1),size(raw1,2));
for i=1:size(raw1,2)
    raw(:,i)=raw1{i};
end

fs=round(shdr(1).samples_in_record/hdr.data_record_duration);

end
