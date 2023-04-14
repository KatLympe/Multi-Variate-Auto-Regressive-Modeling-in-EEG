%
%Katerina Lymperidou - April 2020, Last update April 2021 
%
%Project: Analysis and visualization of multivariate causality and information flow between event
%related conditions on Field Dependent – Field Independent EEG data
%
%Computational BioMedicine Lab - Foundation of Research and Technology
%Hellas FORTH Crete, Greece
%
%In this file: Select the ROIs of interest (from 68 sources/channels),
%Estimated fitting of the model for each subject
%(this file uses functions from the tool "SIFT" (https://www.nitrc.org/projects/sift/) (look References below)
%
%%References: Delorme A, Mullen T, Kothe C, et al. EEGLAB, SIFT, NFT, BCILAB, and ERICA: new tools for advanced EEG processing. Comput Intell Neurosci. 2011;2011:130714. doi:10.1155/2011/130714
%Kaminski M, Blinowska KJ. Directed Transfer Function is not influenced by volume conduction-inexpedient pre-processing should be avoided. Front Comput Neurosci. 2014;8:61. Published 2014 Jun 10. doi:10.3389/fncom.2014.00061

clear all; 
close all; 
clc;

eeglab;
startpath='E:\Copy_of_kat_sets';

%No of subjects
SubjectNums=4;

for i=[7]%3 4 5 7 9 14 15 16 17 18 19 20 22 23 24 25 26 28 29 30]%4:SubjectNums 

 subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_TrialEnd(Butt2)_Cond1_SE_ICA_SRC2CHAN', '.set']);
 EEG = pop_loadset('filename', subjectpath);
 
 %Select the ROIs of interest
 EEG = pop_select( EEG, 'channel',{'caudalanteriorcingulate R' 'caudalmiddlefrontal R' 'cuneus R' 'fusiform L' 'inferiorparietal L' 'lingual L' 'parahippocampal L' 'postcentral R' 'posteriorcingulate R' 'precentral L' 'rostralmiddlefrontal R' 'superiorfrontal R' 'superiortemporal L'});

% enter parameters for preprocessing
    WindowLengthSec   = 0.5; % sliding window length in seconds
    WindowStepSizeSec = 0.03; % sliding window step size in seconds
    ModelOrder = 10;

% Preprocessing --- SIFT toolbox
[EEG, prepcfg] = pre_prepData('ALLEEG',EEG,'VerbosityLevel',1, 'SignalType', 'Channels', 'resetConfigs',1, 'NormalizeData',{'Method',{'ensemble' 'time'}});

% Model Fitting --- SIFT toolbox
[EEG, modfitcfg] = pop_est_fitMVAR(EEG,'nogui','algorithm','Vieira-Morf','winlen',WindowLengthSec,...
      'winstep',WindowStepSizeSec,'morder',ModelOrder,'verb',1);
 
 % Save dataset
 datasetName =['subject' num2str(i) '_TrialEnd(Butt2)_Cond1_SE_ICA_Fitt'];
 subjectpath=fullfile(startpath,['subject',num2str(i)]);
 EEG=pop_saveset(EEG, datasetName ,subjectpath); 
end