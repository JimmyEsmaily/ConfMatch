clc;
clear;
close all;
%%
load Data_I1.mat;
load Locs.mat;
%%



EEGData = AllData_I;
AllCoh = Allinfo_I(:,2);
ERP = mean((EEGData(:,:,:)),3);
figure;
time = -200:1000;
AnTime = [200:499];
TimeBin = dsearchn(time',AnTime');

topoplot(mean(ERP(:,TimeBin),2),Locs,'plotrad',.66,'electrodes','off')   % 'plotchans', NN

I=colorbar;
caxis([-2 4.5]);
set(gcf,'Color','w');
set(gca,'FontSize',30);
