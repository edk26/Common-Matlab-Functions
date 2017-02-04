function [rawout,ok] = reference_channels (rawout, rawin, labels)

% raw=handles.data.raw;

[s1,ok1] = listdlg('PromptString','Select channels to be referenced:',...
    'SelectionMode','multiple',...
    'ListString',labels)

[s2,ok2] = listdlg('PromptString','Select reference channel:',...
    'SelectionMode','multiple',...
    'ListString',labels)

ok=ok1+ok2;
    
ref=mean(rawin(:,s2),2);
for i=s1
    rawout(:,i)=rawout(:,i)-ref;
end
    

end