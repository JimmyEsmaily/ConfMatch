clc;
clear;
close all;
%%
% load XYSocial_FinalITI.mat;
load XYSocial_FinalITI_Old.mat;

%%
ii = 1;
jj = 1;
fc = 6; % 6
fs = 1000;
[b,a] = butter(2,fc/(fs/2));
NumB = 0;
BeforeBin = 1000;
for iii=1:size(SocialPupilXY,1)
    iii
    TmpITI = SocialPupilXY{iii,end};
    
    if TmpITI<3
        TmpPupil = SocialPupilXY{iii,1}(1:4500)+1;
        TmpPupil = DeleteBlink(TmpPupil);
%         
        TmpPupil = [ones(2000,1)*TmpPupil(1);TmpPupil]; % Pad to avoid Edge Artifact
        TmpPupil = filter(b,a,TmpPupil);
        TmpPupil(1:2000) = [];      
        
        TmpPupil = TmpPupil((1500-BeforeBin):4500);
        TmpPupil = zscore(TmpPupil);
        TmpPupil = TmpPupil - mean(TmpPupil(1:BeforeBin));
        Smean(ii) = mean(TmpPupil(BeforeBin:BeforeBin+round(TmpITI*1000)));
        ii = ii+1;
    else
        BadRecords(jj) = iii;
        jj=jj+1;
    end
end
%%
AgentIndx = [SocialPupilXY{:,14}];
AgentIndx(BadRecords) = [];
High_Indx = find(mod(AgentIndx,2)==1);
Low_Indx = find(mod(AgentIndx,2)==0);
HighMean = Smean(High_Indx);
LowMean = Smean(Low_Indx);
%%
Agents = [SocialPupilXY{:,14}];
Agents(BadRecords) = [];
Hinx = find(mod(AgentIndx,2)==1);
Linx = find(mod(AgentIndx,2)==0);

SubNum_S = [SocialPupilXY{:,15}];
SubNum_S(BadRecords) = [];
SubNum_H = SubNum_S(Hinx);
SubNum_L = SubNum_S(Linx);
Cohs_S = [SocialPupilXY{:,10}];
Cohs_H = Cohs_S(Hinx);
Cohs_L = Cohs_S(Linx);

%% GLMM
Means = [HighMean';LowMean'];
Cohss = [Cohs_H'; Cohs_L'];
Subs = [SubNum_H';SubNum_L'];
Condition = 1*ones([length(SubNum_H)+length(SubNum_L)],1);
Condition(1:length(SubNum_H)) = 2;

MyTable_Mean = table(Subs,Means,Condition, Cohss);

glme = fitglme(MyTable_Mean,...
    'Means ~ 1+Condition  + (1|Subs)',...
    'Distribution','Normal','Link','identity','FitMethod','MPL',...
    'DummyVarCoding','effects')

%% Plot
figure, hold on;
SEM_H = 1.96*std(HighMean)/sqrt(length(HighMean));
SEM_L = 1.96*std(LowMean)/sqrt(length(LowMean));

b1=bar(1,mean(HighMean),.4);
b1.FaceColor = [1 0 1];
b1.LineWidth = 2;
MyErrorBar(1,mean(HighMean),SEM_H,'k-')
b2=bar(2,mean(LowMean),.4);
b2.FaceColor = [1 .5 0];
b2.LineWidth = 2;

MyErrorBar(2,mean(LowMean),SEM_L,'k-')
xticklabl = {'HCA','LCA'};
xtick = [1:2];
set(gca,'XTick',xtick,'XTickLabel',xticklabl);
set(gca,'Box','off');
set(gcf,'Color','w');
ylabel('Normalized Pupil Diameter(a.u.)');

plot([1,2],[.7 .7],'k-','LineWidth',2);
text(1.35,.75,'***','FontSize',30);



set(gca,'TickDir','out');
set(gca,'FontSize',30);
set(gca,'linewidth',1.5);
ylim([0,1.15]);