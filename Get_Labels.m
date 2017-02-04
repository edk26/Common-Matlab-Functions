function [ch, labels] = Get_Labels(CellArray,eID)


[s,v] = listdlg('PromptString','Select a file:',...
    'SelectionMode','multiple',...
    'ListString',CellArray(:,1));


labels=CellArray(s,1);
ch=eID(s);