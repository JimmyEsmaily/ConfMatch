clc;
clear;
close all;
%%
load XYSocial_FinalITI.mat;  % load data for study 2
% load XYSocial_FinalITI_Old.mat; % load data for study 1

%%
AnalysisTime = 1:3000;  % means [-1000, 2000]ms
%%
fc = 6;
fs = 1000;
[b,a] = butter(2,fc/(fs/2));  % low pass filter
ii = 1;
jj = 1;
BeforeBin = 1000;
for iii=1:size(SocialPupilXY,1)
    TmpITI = SocialPupilXY{iii,end};
    
    if TmpITI<3 % only consider data with ITI less than 3 seconds
        TmpPupil = SocialPupilXY{iii,1}((1500-BeforeBin):4500)+1;
        TmpPupil = DeleteBlink(TmpPupil);
        TmpPupil = [ones(200,1)*TmpPupil(1);TmpPupil];  % Zero padding
        TmpPupil = filter(b,a,TmpPupil);
        TmpPupil(1:200) = []; 
        TmpPupil = zscore(TmpPupil);
        Pupils_S(ii,:) = TmpPupil(1:3000+BeforeBin);
        ii = ii+1;
    else
        SBadR(jj) = iii;
        jj = jj+1;
    end
    
end
%%

ITI_S = [SocialPupilXY{:,end}];
SBadR = find(ITI_S>3);

Agents = [SocialPupilXY{:,14}];
Agents(SBadR) = [];
Hinx = [find(Agents==1),find(Agents==3)];
Linx = [find(Agents==2),find(Agents==4)];

ITI_S(SBadR) = [];
ITI_H = ITI_S(Hinx);
ITI_L = ITI_S(Linx);


SubNum_S = [SocialPupilXY{:,15}];
SubNum_S(SBadR) = [];
SubNum_H = SubNum_S(Hinx);
SubNum_L = SubNum_S(Linx);

AllPupils{1} = Pupils_S(Hinx,AnalysisTime);
AllPupils{2} = Pupils_S(Linx,AnalysisTime);




%%
Bin = 30;
XBin = [-999+Bin:2000]./1000;
color = {[1 0 1],[1 .5 0]};
figure
for i=1:size(AllPupils,2)
    tmpdata = mean(AllPupils{i});
    PPData(i,:) = tmpdata;
    ERPCoeff = ones(1, Bin)/Bin;
    tmpdata = filter(ERPCoeff, 1,tmpdata);
    tmpdata = tmpdata(Bin+1:end);
    
    B_Stim(i) = mean(tmpdata(1:BeforeBin));
    tmpdata = [tmpdata - (B_Stim(i))];
    P{i} = plot(XBin,tmpdata,'Color',color{i},'LineWidth',3);
    hold on;
    MeanITI_H = mean(ITI_H);
    STDITI_H = std(ITI_H);
    MeanITI_L = mean(ITI_L);
    STDITI_L = std(ITI_L);
    
    h = area([MeanITI_H-STDITI_H MeanITI_H+STDITI_H],[-.7;-.7], 1.6);
    set(h,'FaceColor',[1 0 1]);
    set(h,'EdgeColor','none');
    
    alpha(0.2)
    
    YBin = -.7:0.01:1.4;
    plot(MeanITI_H*ones(length(YBin)),YBin,'-.','Color',[1 0 1],'LineWidth',2);
    
    h = area([MeanITI_L-STDITI_L MeanITI_L+STDITI_L],[-.7;-.7], 1.6);
    set(h,'FaceColor',[1 .5 0]);
    set(h,'EdgeColor','none');
    
    alpha(0.2)
    
    plot(MeanITI_L*ones(length(YBin)),YBin, '-.','Color',[1 .5 0],'LineWidth',2);
    
    
end
set(gcf,'color','w');
set(gca,'Box','off');
legend([P{1},P{2}],'HCA','LCA');
ylim([-0.7 1.3]);
xlim([-.2, 2])
xlabel('Time (s)');
ylabel('Normalized Pupil Diameter(a.u.)');
legend boxoff
set(gca,'TickDir','out');
set(gca,'FontSize',15);
set(gca,'linewidth',1.5);
