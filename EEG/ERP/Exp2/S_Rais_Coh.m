clc;
clear;
close all;
%%
load Data_SFinal15.mat;
%%
NN = [18, 57, 45, 46];

time = -1500:4:1000;
AnTime = [-200:4:600];
TimeBin = dsearchn(time',AnTime');
BLine = dsearchn(time',[-100:4:0]');
BLine1 = dsearchn(TimeBin,BLine);

XBin = time(TimeBin);
Bin = 20;
Data_S = squeeze(mean(AllData_S(NN,TimeBin,:),1)) *(10^5);
Data_S = bsxfun(@minus,Data_S, mean(Data_S(BLine1,:)));
BadRecords = DeleteBadRecord(Data_S);
Allinfo_S(BadRecords,:) = [];
Data_S(:,BadRecords) = [];




%
Coh5_Indx = find(Allinfo_S(:,2)==25.6);
Coh4_Indx = find(Allinfo_S(:,2)==12.8);
Coh3_Indx = find(Allinfo_S(:,2)==6.4);
Coh2_Indx = find(Allinfo_S(:,2)==3.2);
Coh1_Indx = find(Allinfo_S(:,2)==1.6);

Data5 = Data_S(:,Coh5_Indx);
Data4 = Data_S(:,Coh4_Indx);
Data3 = Data_S(:,Coh3_Indx);
Data2 = Data_S(:,Coh2_Indx);
Data1 = Data_S(:,Coh1_Indx);
% Coh
Mean5 = mean(Data5,2);
Mean4 = mean(Data4,2);
Mean3 = mean(Data3,2);
Mean2 = mean(Data2,2);
Mean1 = mean(Data1,2);
ERPCoeff = ones(1, Bin)/Bin;

Mean5 = filter(ERPCoeff, 1,Mean5);
Mean4 = filter(ERPCoeff, 1,Mean4);
Mean3 = filter(ERPCoeff, 1,Mean3);
Mean2 = filter(ERPCoeff, 1,Mean2);
Mean1 = filter(ERPCoeff, 1,Mean1);


figure, hold on;
P{1} = plot(XBin,Mean5,'Color',flip([1 0 0]),'LineWidth',3);
P{2} = plot(XBin,Mean4,'Color',flip([.75 0 0.25]),'LineWidth',3);
P{3} = plot(XBin,Mean3,'Color',flip([.5 0 0.5]),'LineWidth',3);
P{4} = plot(XBin,Mean2,'Color',flip([.25 0 .75]),'LineWidth',3);
P{5} = plot(XBin,Mean1,'Color',flip([0 0 1]),'LineWidth',3);


h = area([200 500],[-2 15.5;-2 15.5],-2);
set(h,'FaceColor',[.1 .1 .1]);
set(h,'EdgeColor','none');

alpha(0.2)


title('Social');

set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Time (ms)');
ylabel('Amplitude(\muV)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
xlim([-100,550]);
ylim([-2 12]);