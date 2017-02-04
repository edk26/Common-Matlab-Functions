function varargout = ArtifactReject(varargin)
%SDK012714

% Edit the above text to modify the response to help ArtifactReject

% Last Modified by GUIDE v2.5 13-Mar-2015 10:11:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ArtifactReject_OpeningFcn, ...
                   'gui_OutputFcn',  @ArtifactReject_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ArtifactReject is made visible.
function ArtifactReject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ArtifactReject (see VARARGIN)

% Choose default command line output for ArtifactReject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ArtifactReject wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = ArtifactReject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bt_L.
function bt_L_Callback(hObject, eventdata, handles)
% hObject    handle to bt_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
if handles.specs.ch-1 >= 1
    handles.specs.ch=handles.specs.ch-1;
    handles.specs.chdata=handles.pdata{handles.specs.Epi}(:,:,handles.specs.ch);
    plot(handles.axes1,handles.specs.t,handles.specs.chdata);
    %plot(handles.axes1,handles.specs.chdata);
    set(handles.st_ch,'string',handles.pinfo(handles.specs.reci).labels{handles.specs.ch});
    set([gca;get(gca,'children')],'ButtonDownFcn',@axes_buttonpressfcn)
    
    lp=handles.specs.lp{handles.specs.ch,handles.specs.Epi}; 
    if length(lp)>0
        for i=1:length(lp)
            lp1=lp{i};
            plot([lp1(1,1),lp1(2,1)],[lp1(1,2),lp1(2,2)],'k','linewidth',2);
        end
    end
end
guidata(hObject,handles)

% --- Executes on button press in bt_R.
function bt_R_Callback(hObject, eventdata, handles)
% hObject    handle to bt_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
if handles.specs.ch+1 <= handles.specs.nch
    handles.specs.ch=handles.specs.ch+1;
    handles.specs.chdata=handles.pdata{handles.specs.Epi}(:,:,handles.specs.ch);
    plot(handles.axes1,handles.specs.t,handles.specs.chdata);
    %plot(handles.axes1,handles.specs.chdata);
    set(handles.st_ch,'string',handles.pinfo(handles.specs.reci).labels{handles.specs.ch});
    set([gca;get(gca,'children')],'ButtonDownFcn',@axes_buttonpressfcn)
    
    lp=handles.specs.lp{handles.specs.ch, handles.specs.Epi}; 
    if length(lp)>0
        for i=1:length(lp)
            lp1=lp{i};
            plot([lp1(1,1),lp1(2,1)],[lp1(1,2),lp1(2,2)],'k','linewidth',2);
        end
    end
    
    
end
guidata(hObject,handles)

% --------------------------------------------------------------------
function mn_File_Callback(hObject, eventdata, handles)
% hObject    handle to mn_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mn_Open_Callback(hObject, eventdata, handles)
% hObject    handle to mn_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.fname,handles.pname,~] = uigetfile({'*.mat'},'Select Data File');
handles.m = matfile(fullfile(handles.pname,handles.fname),'Writable',true);
handles.pinfo=handles.m.pinfo;
set(handles.figure1,'WindowButtonUpFcn',[])

for i=1:length(handles.pinfo)
   handles.specs.recs{i}=handles.pinfo(i).pID; 
end
[s,v] = listdlg('PromptString','Select subjects:',...
    'SelectionMode','single',...
    'ListString',handles.specs.recs);
handles.specs.reci=s;
handles.specs.pID=handles.pinfo(handles.specs.reci).pID;

fn    =  fieldnames(handles.m);
fni   =  strncmp(fn, handles.specs.pID, length(handles.specs.pID));
                      %Recording Epoch names
b={'Rsp';'Cmd';'ITI'};
mkvn  = @(A,B) [A,'_', B];
pID1  = repmat(cellstr(handles.specs.pID),length(b),1);
ln    = cellfun(mkvn, pID1, b,'UniformOutput',false);               %Variable Load Names


for i=1:size(ln,1)
    handles.pdata{i}=handles.m.(ln{i});
end

handles.specs.ch=1;
handles.specs.nch=length(handles.pinfo(handles.specs.reci).labels);
handles.specs.chdata=handles.pdata{1}(:,:,handles.specs.ch);
handles.specs.lp=cell(handles.specs.nch,size(b,1));
handles.specs.EpN=b;
handles.specs.Epi=1;
handles.specs.fs=handles.pinfo(handles.specs.reci,1).fs;

if ~isfield(handles.pinfo(handles.specs.reci),'Arts') || isempty(handles.pinfo(handles.specs.reci).Arts)
    handles.pinfo(handles.specs.reci).Arts = cell(handles.specs.nch, size(handles.pdata,2));
end

% handles.specs.t = linspace( -handles.pinfo(handles.specs.reci).pre, handles.pinfo(handles.specs.reci).post,...
%     size(handles.pdata{1},1) );
handles.specs.t = [1:1:length(handles.specs.chdata)]./handles.specs.fs;

cla
plot(handles.axes1,handles.specs.t,handles.specs.chdata);

set(handles.st_pID,'string',handles.specs.pID);
set(handles.st_Ep,'string',handles.specs.EpN{1});
set(handles.st_ch,'string',handles.pinfo(handles.specs.reci).labels{handles.specs.ch});
set(handles.lb_EpSelect,'string',handles.specs.EpN,'Value',1);

guidata(hObject,handles)

% --------------------------------------------------------------------
function mn_Save_Callback(hObject, eventdata, handles)
% hObject    handle to mn_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.m.pinfo=handles.pinfo;


function axes_buttonpressfcn(hObject, eventdata, handles)
handles=guidata(hObject);

tmp=get(handles.axes1,'CurrentPoint');
handles.specs.cp=[];
handles.specs.cp(1,:)=[tmp(1,1),tmp(1,2)];
th=text(handles.specs.cp(1,1),handles.specs.cp(1,2),'x');
set(handles.figure1,'WindowButtonUpFcn',@axes_buttonupfcn)
guidata(hObject,handles);



function axes_buttonupfcn(hObject, eventdata, handles)
handles=guidata(hObject);
tmp=get(handles.axes1,'CurrentPoint');
handles.specs.cp(2,:)=[tmp(1,1),tmp(1,2)];
th=text(handles.specs.cp(2,1),handles.specs.cp(2,2),'x');
cp=handles.specs.cp;
hold on
lh=plot([cp(1,1),cp(2,1)],[cp(1,2),cp(2,2)],'k','linewidth',2);
handles.specs.lp{handles.specs.ch, handles.specs.Epi}{end+1,1}=cp;

ntr=size(handles.specs.chdata,2);
art_tr=[];
for tr_i=1:ntr
    [x0,~,~,~] = intersections(handles.specs.t,handles.specs.chdata(:,tr_i),cp(:,1),cp(:,2),0);
    if ~isempty(x0), art_tr=[art_tr; tr_i]; end
end
if isfield(handles.pinfo(handles.specs.reci),'Arts')
    art_tr=union(handles.pinfo(handles.specs.reci).Arts{handles.specs.ch, handles.specs.Epi},art_tr);
end
handles.pinfo(handles.specs.reci).Arts{handles.specs.ch, handles.specs.Epi} = art_tr;


set(handles.figure1,'WindowButtonUpFcn',@axes_buttonupfcn)
guidata(hObject,handles)


% --- Executes on button press in bt_DeleteArts.
function bt_DeleteArts_Callback(hObject, eventdata, handles)
% hObject    handle to bt_DeleteArts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pinfo(handles.specs.reci).Arts{handles.specs.ch, handles.specs.Epi}=[];
guidata(hObject,'handles');

% --------------------------------------------------------------------
function mn_ClearArts_Callback(hObject, eventdata, handles)
% hObject    handle to mn_ClearArts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pinfo(handles.specs.reci).Arts=cell(handles.specs.nch,size(handles.specs.EpN,1));
handles.specs.lp=cell(handles.specs.nch,size(handles.specs.EpN,1));
guidata(hObject,handles)


% --- Executes on selection change in lb_EpSelect.
function lb_EpSelect_Callback(hObject, eventdata, handles)
% hObject    handle to lb_EpSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_EpSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_EpSelect
handles.specs.Epi=get(hObject,'value');

set(handles.st_Ep,'string',handles.specs.EpN{handles.specs.Epi});

handles.specs.chdata=handles.pdata{handles.specs.Epi}(:,:,handles.specs.ch);
handles.specs.t = [1:1:length(handles.specs.chdata)]./handles.specs.fs;
cla
plot(handles.axes1,handles.specs.t,handles.specs.chdata);
%plot(handles.axes1,handles.specs.chdata);

set(handles.st_ch,'string',handles.pinfo(handles.specs.reci).labels{handles.specs.ch});
set([gca;get(gca,'children')],'ButtonDownFcn',@axes_buttonpressfcn)

lp=handles.specs.lp{handles.specs.ch,handles.specs.Epi};
if length(lp)>0
    for i=1:length(lp)
        lp1=lp{i};
        plot([lp1(1,1),lp1(2,1)],[lp1(1,2),lp1(2,2)],'k','linewidth',2);
    end
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function lb_EpSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_EpSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function mn_SwitchSubj_Callback(hObject, eventdata, handles)
% hObject    handle to mn_SwitchSubj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=1;

[s,v] = listdlg('PromptString','Select subjects:',...
    'SelectionMode','single',...
    'ListString',handles.specs.recs);
handles.specs.reci=s;
handles.specs.pID=handles.pinfo(handles.specs.reci).pID;

fn    =  fieldnames(handles.m);
fni   =  strncmp(fn, handles.specs.pID, length(handles.specs.pID));
b={'Rsp';'Cmd';'ITI'};
mkvn  = @(A,B) [A,'_', B];
pID1  = repmat(cellstr(handles.specs.pID),length(b),1);
ln    = cellfun(mkvn, pID1, b,'UniformOutput',false);               %Variable Load Names


for i=1:size(ln,1)
    handles.pdata{i}=handles.m.(ln{i});
end

handles.specs.ch=1;

%----!!!!!!!!!!!!!!!!!!!!!-------------
%handles.specs.nch=length(handles.pinfo(handles.specs.reci).labels);% Have
%moved from this to be able to use BP referenced data... ctrlF and replace
%back to this to use non-BP data again...
handles.specs.nch=length(handles.pinfo(handles.specs.reci).labels);

handles.specs.chdata=handles.pdata{1}(:,:,handles.specs.ch);
handles.specs.lp=cell(handles.specs.nch,size(b,1));
handles.specs.EpN=b;
handles.specs.Epi=1;
handles.specs.fs=handles.pinfo(handles.specs.reci,1).fs;

if ~isfield(handles.pinfo(handles.specs.reci),'Arts') || isempty(handles.pinfo(handles.specs.reci).Arts)
    handles.pinfo(handles.specs.reci).Arts = cell(handles.specs.nch, size(handles.pdata,2));
end

handles.specs.t = [1:1:length(handles.specs.chdata)]./handles.specs.fs;

cla
plot(handles.axes1,handles.specs.t,handles.specs.chdata);

set(handles.st_pID,'string',handles.specs.pID);
set(handles.st_Ep,'string',handles.specs.EpN{1});
set(handles.st_ch,'string',handles.pinfo(handles.specs.reci).labels{handles.specs.ch});
set(handles.lb_EpSelect,'string',handles.specs.EpN,'Value',1);

guidata(hObject,handles)
