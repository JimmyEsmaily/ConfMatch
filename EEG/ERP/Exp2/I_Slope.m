clc;
clear;
close all;
%%
load Data_I.mat;
%%

NN = [18, 57, 45, 46];
time = -1500:4:3999;
AnTime = [-200:4:600];
TimeBin = dsearchn(time',AnTime');

XBin = AnTime;
TimeStep = 5;
TimeWin = 100;
BLine = dsearchn(time',[-100:4:0]');
BLine1 = dsearchn(TimeBin,BLine);
Data_I = squeeze(mean(AllData_I(NN,TimeBin,:),1)) *(10^5);

Bin = 5;

ERPCoeff = ones(1, Bin)/Bin;

for i=1:size(Data_I,2)
    Data_I(:,i) = filter(ERPCoeff, 1,Data_I(:,i));

end


Data_I = bsxfun(@minus,Data_I, mean(Data_I(BLine1,:)));

BadRecords = DeleteBadRecord(Data_I);
Allinfo_I(BadRecords,:) = [];
Data_I(:,BadRecords) = [];

allsub_I = Allinfo_I(:,end);
CohData_I = Allinfo_I(:,2);
TBin = dsearchn(AnTime',[0:4:500]');
for ti = 1:size(Data_I,2)
        tfit = fitlm(TBin',zscore(Data_I(TBin,ti)));
        Slope_I(ti) = tfit.Coefficients.Estimate(2)*1000;
    
end

Slops = [mean(Slope_I)];
SEM = [std(Slope_I)/sqrt(length(Slope_I))];
%
Cohs = [1.6, 3.2,6.4,12.8,25.6];
CohArray_I = Allinfo_I(:,2);
AllSS_I = [];
Group_I = [];
for i=1:size(Cohs,2)
    TData = Slope_I(CohArray_I==Cohs(i));
    SlopCoh_I(i) = mean(TData);
    SEM_I(i) = std(TData)/sqrt(size(find(CohArray_I==Cohs(i)),1));
end
%
close all;
figure, hold on;
for i=1:5
    TmpMean = [SlopCoh_I(i)];
    TmpSEM = [SEM_I(i)];
    PP = bar([i],TmpMean(1),.3);
    PP.FaceColor = 'k';
    P.LineWidth = 2;
    
    MyErrorBar([i],TmpMean(1),TmpSEM,'k-');
end


legend boxoff;
xtick = [1:5];
xticklabl = {'1.6','3.2','6.4','12.8','25.6','Avg'};
set(gca,'XTick',xtick,'XTickLabel',xticklabl);
set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Motion Strength (%)');
ylabel('Slope(\muV/s)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
Resp = Allinfo_I(:,5);

TCohs = [1.6, 3.2,6.4,12.8,25.6];
for si=1:10
    SubBin = find(Allinfo_I(:,7)==si);
    TmpSlop = Slope_I(SubBin);
    TmpCoh = Allinfo_I(SubBin,2);
    TMPResp = Resp(SubBin);
    RResp = find(TMPResp == 0);
    LResp = find(TMPResp == 180);

    SubResp(si,1) = mean(TmpSlop(RResp));
    SubResp(si,2) = mean(TmpSlop(LResp));

    for ci=1:5
        CohBin = find(TmpCoh==TCohs(ci));
        SMat_I(si,ci) = mean(TmpSlop(CohBin));
    end
    
end

Cohtest = Allinfo_I(:,2);
Subs = Allinfo_I(:,end);
Slope = Slope_I';


MyTable = table(Subs,Cohtest, Slope);
glme = fitglme(MyTable,...
		'Slope ~ 1 + Cohtest + (1|Subs)',...
		'Distribution','Normal','Link','identity','FitMethod','MPL',...
		'DummyVarCoding','effects');
Res_RT = [glme.Coefficients.Estimate(2:end),glme.Coefficients.SE(2:end),...
    glme.Coefficients.Lower(2:end),glme.Coefficients.Upper(2:end),...
    glme.Coefficients.tStat(2:end),glme.Coefficients.pValue(2:end)];
