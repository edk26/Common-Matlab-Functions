%% Set batch list
%% Set batch list

% BS_subjects = {'AA071614';'DM021115';'FB111914';'HM021115';'JD021815';'RZ030415';'SE040115';'WO031815'};
% CL = [1,1,2,2,2,2,2,1];
% rec_n = [1,7,13,14,17,34,38,41];

BS_subjects = {'DM021115'};
BS_electrodes = {'elec_L_DM021115'};
CL = [1];
rec_n = [7];

%% Set Anon Functions

fndvert = {@(A,B) min(pdist2(A,B));...
    @(A,B) B(A,:);...
    @(A,B,C) find(uint16(round(pdist2(A,B)))'<C);};


%% Initialize Paths
subject_path = 'D:\Dropbox\Research\Programs\Electrode_Imaging\Fluoro_Imaging\Brainstorm_CortLoc\';
FS_subject_path = 'D:\Dropbox\Research\Programs\Electrode_Imaging\Fluoro_Imaging\Subjects\';
ICBM152_path = 'D:\Dropbox\Research\Programs\brainstorm3\ICBM152_2015\';
output_path = 'D:\Dropbox\Research\Programs\Electrode_Imaging\Fluoro_Imaging\Brainstorm_CortLoc\Stath Locs\';
BrainImaging_path = 'D:\Dropbox\Research\Data\Movement 1\BrainImaging\';

%%

std = load([ICBM152_path,'tess_cortex_pial_high.mat'], 'Vertices', 'Faces', 'Atlas', 'Reg');
to_do = 1;
clc
for s = to_do

    fprintf('%s...', BS_subjects{s});
    
   cl = CL(s);
    
    load(fullfile(subject_path,[BS_subjects{s},'_transform_matrix']),'Wmat')
    SS = load(fullfile(BrainImaging_path,'Individual',['cortex_',BS_subjects{s},'.mat']));
    
    %SS.cortex.vert(:,1) = SS.cortex.vert(:,1)*-1; %
    %For DP!!!
    
    clear EL
    %EL.elecmatrix = ElLocs{rec_n(s)};
    EL = load(fullfile( BrainImaging_path, [BS_electrodes{s}] ));
    if ~isfield(EL,'CortElecLoc')
       EL.CortElecLoc =  num2cell(EL.elecmatrix,2)';
    end
    [~,ar]  = cellfun(fndvert{1}, EL.CortElecLoc', repmat({SS.cortex.vert}, size(EL.CortElecLoc',1),1), 'uniformoutput', false );
    
    VR_comm = zeros(size(Wmat,1),1);
    el_cl = cell(length(ar),1);
    el_mt = zeros(length(ar),3);
    for eli = 1:length(ar)
        VR_indiv_el = zeros(length(SS.cortex.vert),1);
        VR_indiv_el(ar{eli})=1;
        a = Wmat*VR_indiv_el;
        
        [~,mxi] = max(a);
        loc = std.Vertices(mxi,:);
        
        if cl == 1 && ~strcmp(BS_subjects{s},'DP090914')%FLIP TO RIGHT
            loc(2) = loc(2)*-1;
        end
        
        el_cl{eli} = loc;
        el_mt(eli,:) = loc;

        VR_comm = VR_comm + a;
    end
    
    CortElecLoc = el_cl; elecmatrix = el_mt;
    save(fullfile(output_path, [BS_electrodes{s}]), 'CortElecLoc', 'elecmatrix')
    ElLocs_ICBM{rec_n(s)} = cell2mat(CortElecLoc);
    fprintf('done!\n')
end



%% TEst
clf
subplot(2,1,1)
Hp = patch('vertices',std.Vertices,'faces',std.Faces,'edgecolor','none','FaceColor',[.65,.65,.65]);
axis equal
camlight('headlight','infinite');
hold on

elh = plot3(el_mt(:,1),el_mt(:,2),el_mt(:,3),'.','markersize',15);

for i = 1:6
   th(i) = text(el_mt(i,1),el_mt(i,2),el_mt(i,3),num2str(i),'color',[1,.2,.2],'fontsize',15);
end

subplot(2,1,2)
Hp = patch('vertices',SS.cortex.vert,'faces',SS.cortex.tri(:,[1 3 2]),'edgecolor','none','FaceColor',[.65,.65,.65]); camlight infinite; axis equal
