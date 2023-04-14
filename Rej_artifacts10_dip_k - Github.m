

clear all; 
close all; 
clc;

eeglab;
startpath='E:\Copy_of_kat_sets';

%No of subjects
SubjectNums=5;

for i=[7 9 14 15 16 17 18 19 20 22 23 24 25 26 28 29 30]%2:SubjectNums 

   subjectpath=fullfile(startpath,['subject',num2str(i)], ['subject', num2str(i), '_TrialEnd(Butt2)_Cond1_SE_ICA' , '.set']);
   EEG = pop_loadset('filename', subjectpath);
   
   %Labeling the idividual components
   EEG = pop_iclabel(EEG);
   EEG = eeg_checkset( EEG );
   
   %Flag the components that satisfy these rules for heart, muscle
   %artifacts etc
   EEG = pop_icflag(EEG, [0 0.3;0.7 1;0.7 1;NaN NaN;NaN NaN;NaN NaN;0.5 0.6]);

   %Create a file that saves the flagged components
   %k=(sum(flagReject)); save('k','flagReject');
   EEG = eeg_checkset( EEG );
   
   load('flagReject.mat')
   
    if k<10 || k>10

        for j=1:(length(EEG.etc.ic_classification.ICLabel.classifications))
    
            EEG_component(j)=EEG.etc.ic_classification.ICLabel.classifications(j,1);
    
        end
        
        % Sort the components & Remove the first 10 comp
        [B,I]=sort(EEG_component);
        EEG = pop_subcomp( EEG, [I(1:10)], 0);
        EEG = eeg_checkset( EEG );
        
    else
         EEG = pop_subcomp( EEG, [], 0);
         
    end
   
   % Dipole fitting
   EEG = pop_dipfit_settings( EEG, 'hdmfile','C:\\Users\\katlympe\\Downloads\\CBML\\EEGlab\\eeglab_current\\eeglab2019_0\\plugins\\dipfit3.2\\standard_BESA\\standard_BESA.mat','coordformat','Spherical','mrifile','C:\\Users\\katlympe\\Downloads\\CBML\\EEGlab\\eeglab_current\\eeglab2019_0\\plugins\\dipfit3.2\\standard_BESA\\avg152t1.mat','chanfile','C:\\Users\\katlympe\\Downloads\\CBML\\EEGlab\\eeglab_current\\eeglab2019_0\\plugins\\dipfit3.2\\standard_BESA\\standard-10-5-cap385.elp','chansel',[1:24] );
   EEG = pop_multifit(EEG, [] ,'threshold',100,'plotopt',{'normlen' 'on'});

   % Save dataset
    datasetName =['subject' num2str(i) '_TrialEnd(Butt2)_Cond1_SE_ICA_rejar10_dip'];
    subjectpath=fullfile(startpath,['subject',num2str(i)]);
    EEG=pop_saveset(EEG, datasetName ,subjectpath);


    
end