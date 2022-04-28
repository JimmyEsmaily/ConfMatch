clc;
clear;
close all;
%%
load Data_I.mat;
load Locs64.mat;
%%



EEGData = AllData_I * 10^5;
AllCoh = Allinfo_I(:,2);
ERP = mean((EEGData(:,:,:)),3);
figure;
time = -1500:4:2999;
AnTime = [200:4:499];
TimeBin = dsearchn(time',AnTime');

topoplot(mean(ERP(:,TimeBin),2),Locs,'plotrad',.66,'electrodes','off')   % 'plotchans', NN

I=colorbar;
caxis([-12 12]);
set(gcf,'Color','w');
set(gca,'FontSize',30);
