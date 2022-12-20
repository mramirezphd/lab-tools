%Uptake Quantifier v0.1, work in progress.


%This script generate projections from .tif files extracted from .lei
%packages.

clc;
clear variables;
close all;



%% 1. Select the folder with the images to analyze and create folders

currentdir = pwd;
addpath(pwd);
filedir = uigetdir();

if exist([filedir, '/cell_borders'],'dir') == 0
    mkdir(filedir, '/cell_borders');
end
border_dir = [filedir, '/cell_borders'];


if exist([filedir, '/avg_apical'],'dir') == 0
    mkdir(filedir, '/avg_apical');
end
apical_dir = [filedir, '/avg_apical'];

if exist([filedir, '/avg_basal'],'dir') == 0
    mkdir(filedir, '/avg_basal');
end
basal_dir = [filedir, '/avg_basal'];


if exist([filedir, '/ecad_apical'],'dir') == 0
    mkdir(filedir, '/ecad_apical');
end
ecadapical_dir = [filedir, '/ecad_apical'];

if exist([filedir, '/ecad_basal'],'dir') == 0
    mkdir(filedir, '/ecad_basal');
end
ecadbasal_dir = [filedir, '/ecad_basal'];


if exist([filedir, '/original_files'],'dir') == 0
    mkdir(filedir, '/original_files');
end
ori_dir = [filedir,'/original_files'];

%% 2. Counting how many files to analyze

cd(filedir);
files = dir('*.tif');
numberfiles= numel(files);
n_channel = 3;

%% 3. First loop: stack by stack

for i=1:numberfiles
    currentfile= [num2str(i),'.tif'];
    % the following line recalls bfopen from the bioformats package, which
    % allows us to operate with image stacks
    stack = bfopen(currentfile);
    % the files as it is now contains a lot of stuff like metadata that we
    % do not need, we recall the first page which contains the actual
    % slices with the next line.
    disc= stack{1,1};
    % we now calculate how many steps the stack has.
    disc_steps= ((size(disc, 1))/n_channel);
    %we now generate the variables that will contain the data for the
    %projections

    ecad_signal= [];
    tau_signal= [];

    %% 3.5 The second loop begins, to generate stacks of E-cad and Tau
    for j= 1:3:size(disc, 1)
        ecad_signal = cat(3,ecad_signal,double(disc{j}));
    end

    for j= 3:3:size(disc, 1)
        tau_signal = cat(3,tau_signal,double(disc{j}));
    end

    borderecad= ecad_signal(:,:,1:6);
    borderecad = squeeze(max(borderecad, [], 3));
    borderecad = uint16(borderecad);
    cd(border_dir);
    imwrite(borderecad,[num2str(i), '.tif']);
    
    cd(filedir);
    
end

close all;
clear variables;
clc;