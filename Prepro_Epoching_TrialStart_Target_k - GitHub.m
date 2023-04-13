%
%Katerina Lymperidou - July 2019
%
%Project: Analysis and visualization of multivariate causality and information flow between event
%related conditions on Field Dependent – Field Independent EEG data
%
%Computational BioMedicine Lab - Foundation of Research and Technology
%Hellas FORTH Crete, Greece
%
%Part of this project submitted as Thesis in partial fulfillment of the requirements for 
%the degree Master of Brain and Mind Sciences, University of Crete
%
%In this file: Preprocessing & Epoching with reference point the "Trial Start-32773" and the "Target-33285"
%Creating long epochs (all trial long) and short epochs   

clc;
clear all; 
close all; 

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%Number of the subjects participated in the research
subjectNums=31;

%Define the path were the folders are
startpath='C:\Users\...';


 for i=2:subjectNums
        
         if (i==6)
            continue
        end
       
            subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_merged', '.set']);
            
            %Read the data file of each subject
            EEG = pop_loadset('filename', subjectpath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%PREPROCESSING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            % calculate filter order
            transitionBand=2;
            m=pop_firwsord('hamming',EEG.srate,transitionBand);
            
            % filter data
            [EEG,~,~]=pop_firws(EEG,'fcutoff',[2 65],'forder',m,'ftype','bandpass','wtype','hamming');
                        
            %Rereference
            EEG = pop_reref( EEG, []);

            %Epoching
            EEG = pop_epoch( EEG, {  '32773'  }, [-2  12], 'filename', 'Merged datasets epochs', 'epochinfo', 'yes');

            %Removing the Baseline 
            EEG = pop_rmbase( EEG, [-2000     0]);
            
            %Reject
            EEG = pop_rejepoch( EEG, [1:10] ,0);
           
                   
            %Save the dataset with filtering, rereference, epoching with
            %reference point the'32773' event
            subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_TrialStart', '.set']);

            EEG = pop_saveset( EEG, subjectpath);
            
            
            
            %Create a dataset with ref point the '33285' event (1st Butt)
            subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_merged', '.set']);
            
            %Read the data file of each subject
            EEG0 = pop_loadset('filename', subjectpath);
        
            
            % calculate filter order
            transitionBand=2;
            m=pop_firwsord('hamming',EEG0.srate,transitionBand);
            
            % filter data
            [EEG0,~,~]=pop_firws(EEG0,'fcutoff',[2 65],'forder',m,'ftype','bandpass','wtype','hamming');
            
            % Rereference
            EEG0 = pop_reref( EEG0, []);            
            
            %Epoching
            EEG0 = pop_epoch( EEG0, {  '33285'  }, [-2  12], 'filename', 'Merged datasets epochs', 'epochinfo', 'yes');

            %Removing the Baseline 
            EEG0 = pop_rmbase( EEG0, [-2000     0]);
            
            %Reject training trials - first 10 trials
            EEG0 = pop_rejepoch( EEG0, [1:10] ,0);
           
                   
            %Save the dataset with filtering, rereference, epoching with
            %reference point the'32773' event
            subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_Target', '.set']);

            EEG0 = pop_saveset( EEG0, subjectpath);

  
             
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%% SEPARATE CONDITIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % read EEG conditions file
    subjectpath=fullfile(startpath,['subject',num2str(i)]);
    load(fullfile(subjectpath,['subject' num2str(i) '_conditions.mat']));          
            
%   %prepare the first 10 (training) trials to reject
%     trialsReject=zeros(1,length(condition_seq));
%     trialsReject(1:10)=1;
%     
%     condition_seq=condition_seq(11:end);
    
   %prepare trialsReject1, to reject condition 2-normal image
    trialsReject1=zeros(1,length(condition_seq));
    trialsReject1(condition_seq==2)=1;
    
   %prepare trialsReject2 to reject condition 1-bistable image
    trialsReject2=zeros(1,length(condition_seq));
    trialsReject2(condition_seq==1)=1; 
    
%%%%%%%%%%REJECT EPOCHS IN ORDER TO CREATE
   subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_TrialStart', '.set']);
   EEG = pop_loadset('filename', subjectpath);

%     reject the first 10  training trials
%     EEGrej=pop_rejepoch(EEG,trialsReject, 0);


    % In order to keep only condition1 , we reject trials with condition 2
   EEG1=pop_rejepoch(EEG,trialsReject1, 0);
   EEG1=pop_editset(EEG1,'setname','Trial start - condition 1');
   
   
   subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_TrialStart', '.set']);
   EEG = pop_loadset('filename', subjectpath);
   
    % In order to keep only condition2 , we reject trials with condition 1
   EEG2=pop_rejepoch(EEG,trialsReject2,0);
   EEG2=pop_editset(EEG2,'setname','Trial start - condition 2');
   
    EEG1=pop_editset(EEG1,'setname','Trial start - condition 1');
    EEG2=pop_editset(EEG2,'setname','Trial start - condition 2');
    
    % save datasets
    datasetName1=['subject' num2str(i) '_TrialStart_cond1'];
    datasetName2=['subject' num2str(i) '_TrialStart_cond2'];
    
    %Channels edit in EEG1 
    EEG1=pop_chanedit(EEG1, 'lookup','C:\\Program Files\\MATLAB\\toolbox\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',[],'load',{'C:\\Users\\katlympe\\Documents\\MATLAB\\CBML\\chan_locs.xyz' 'filetype' 'xyz'});
%     EEG1 = eeg_checkset( EEG1 );
    
    %Channels edit in EEG2 
    EEG2=pop_chanedit(EEG2, 'lookup','C:\\Program Files\\MATLAB\\toolbox\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',[],'load',{'C:\\Users\\katlympe\\Documents\\MATLAB\\CBML\\chan_locs.xyz' 'filetype' 'xyz'});
%     EEG = eeg_checkset( EEG );
    
%     % load channel info for both datasets
%     EEG1=pop_chanedit(EEG1,'load',{filename,'chan_locs.xyz'});
%     EEG2=pop_chanedit(EEG2,'load',{filename,'chan_locs.xyz'});
    
    subjectpath=fullfile(startpath,['subject',num2str(i)]);
    EEG1=pop_saveset(EEG1,datasetName1,subjectpath);
    EEG2=pop_saveset(EEG2,datasetName2,subjectpath);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 
 

   
 %%%%%%%%Extract shorter epochs from "TrialStart_cond1" with reference point "Trial Start|'32773'"
 %%%%%%%%and the "Target|'33285'"
 subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_TrialStart_cond1', '.set']);
   FullTrialCond1 = pop_loadset('filename', subjectpath);
   
    datasetnameStart=['subject' num2str(i) ' - Trial Start Cond1'];
    datasetnameTarget=['subject' num2str(i) ' - Target Cond1'];
    OUTEEGstart=pop_epoch(FullTrialCond1,{'32773'},[-2 5],'newname',datasetnameStart);
    OUTEEGtarget=pop_epoch(FullTrialCond1,{'33285'},[-2 5],'newname',datasetnameTarget);
    
%     OUTEEGstart=pop_mergeset(ALLEEG,dataset_nums_start);
%     OUTEEGtarget=pop_mergeset(ALLEEG,dataset_nums_target);

    OUTEEGstart=pop_editset(OUTEEGstart,'setname','Trial start Cond1_SE');
    OUTEEGtarget=pop_editset(OUTEEGtarget,'setname','Target Cond1_SE');
    
    
    OUTEEGstart=pop_chanedit(OUTEEGstart, 'lookup','C:\\Program Files\\MATLAB\\toolbox\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',[],'load',{'C:\\Users\\katlympe\\Documents\\MATLAB\\CBML\\chan_locs.xyz' 'filetype' 'xyz'});
    OUTEEGtarget=pop_chanedit(OUTEEGtarget, 'lookup','C:\\Program Files\\MATLAB\\toolbox\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',[],'load',{'C:\\Users\\katlympe\\Documents\\MATLAB\\CBML\\chan_locs.xyz' 'filetype' 'xyz'});

    % load channel info for both datasets
%     OUTEEGstart=pop_chanedit(OUTEEGstart,'load',{'chan_locs.xyz'});
%     OUTEEGtarget=pop_chanedit(OUTEEGtarget,'load',{'chan_locs.xyz'});
   
    % save datatsets into .set files
    datasetName1=['subject' num2str(i) '_Trial start Cond1_SE'];
    datasetName2=['subject' num2str(i) '_Target Cond1_SE'];

    subjectpath=fullfile(startpath,['subject',num2str(i)]);
    OUTEEGstart1=pop_saveset(OUTEEGstart,datasetName1,subjectpath);
    OUTEEGtarget1=pop_saveset(OUTEEGtarget,datasetName2,subjectpath);
    
    
    
    
 %%%%%%%%Extract shorter epochs from "TrialStart_Cond2" with reference point "Trial Start|'32773'"
 %%%%%%%%and the "Target|'33285'"
 
   subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_TrialStart_cond2', '.set']);
   FullTrialCond1 = pop_loadset('filename', subjectpath);
   
    datasetnameStart=['subject' num2str(i) ' - Trial Start Cond2'];
    datasetnameTarget=['subject' num2str(i) ' - Target Cond2'];
    
    % Epoching between [-2,5] sec with reference points
    OUTEEGstart=pop_epoch(FullTrialCond1,{'32773'},[-2 5],'newname',datasetnameStart);
    OUTEEGtarget=pop_epoch(FullTrialCond1,{'33285'},[-2 5],'newname',datasetnameTarget);
    
%     OUTEEGstart=pop_mergeset(ALLEEG,dataset_nums_start);
%     OUTEEGtarget=pop_mergeset(ALLEEG,dataset_nums_target);

    % Name the files
    OUTEEGstart=pop_editset(OUTEEGstart,'setname','Trial start Cond2_SE');
    OUTEEGtarget=pop_editset(OUTEEGtarget,'setname','Target Cond2_SE');
    
    % Add the channels name
    OUTEEGstart=pop_chanedit(OUTEEGstart, 'lookup','C:\\Program Files\\MATLAB\\toolbox\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',[],'load',{'C:\\Users\\katlympe\\Documents\\MATLAB\\CBML\\chan_locs.xyz' 'filetype' 'xyz'});
    OUTEEGtarget=pop_chanedit(OUTEEGtarget, 'lookup','C:\\Program Files\\MATLAB\\toolbox\\eeglab14_1_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',[],'load',{'C:\\Users\\katlympe\\Documents\\MATLAB\\CBML\\chan_locs.xyz' 'filetype' 'xyz'});

    % load channel info for both datasets - different way
%     OUTEEGstart=pop_chanedit(OUTEEGstart,'load',{'chan_locs.xyz'});
%     OUTEEGtarget=pop_chanedit(OUTEEGtarget,'load',{'chan_locs.xyz'});
   
    % save datatsets into .set files
    datasetName1=['subject' num2str(i) '_Trial start Cond2_SE'];
    datasetName2=['subject' num2str(i) '_Target Cond2_SE'];

    subjectpath=fullfile(startpath,['subject',num2str(i)]);
    OUTEEGstart2=pop_saveset(OUTEEGstart,datasetName1,subjectpath);
    OUTEEGtarget2=pop_saveset(OUTEEGtarget,datasetName2,subjectpath);
       
  
 end
