[handles.file.FileName,handles.file.PathName,FilterIndex] = uigetfile({'*.mat'; '*.edf';'*.ns2';'*.ns5'},'Select Data File');
[xlname,xlpath,~] = uigetfile({'*.xlsx'},'Select Labels Spreadsheet');

A=importdata(fullfile(xlpath,xlname));
[labels,ch]=xl_labels(A);
%AnalogElectrodeIDs=[1:64,129:160,257:288];
%ch=AnalogElectrodeIDs(ch);
%%

[~,~,AnalogElectrodeIDs]=GetAnalogData(fullfile(handles.file.PathName,handles.file.FileName), fs, 0);
ch=AnalogElectrodeIDs(ch);
if FilterIndex==3
    fs=1000;
    [~, raw, ~] = GetAnalogData(fullfile(handles.file.PathName,handles.file.FileName), fs, ch);
    
elseif FilterIndex==4
    fs=30000;
    for chi=1:length(ch)
        [~, raw_tmp, ~] = GetAnalogData(fullfile(handles.file.PathName,handles.file.FileName), fs, ch(chi));
        [raw, handles.specs.fs] = stath_decimate (raw, fs, 10);
    end
end

[fname, pname] = uiputfile('*.mat', 'Save raw as:');
save(fullfile(pname,fname),'fs','raw','labels','-v7.3')