clc;
clear;
close all;
%%
rng(1)
load Behave_SData.mat;
%%
Aindx = SData(:, end-1);
Lindx = find(Aindx == 2);
Hindx = find(Aindx == 1);
Cohs = [1.6, 3.2, 6.4, 12.8, 25.6];
NumSub = length(unique(SData(:, end)));

ACC = zeros(length(SData),1);
ACC((SData(:,3) - SData(:,4)) == 0) = 1;

SData(:,3) = ACC;

TmpData_Low = SData(Lindx, :);
for i=1:size(Cohs,2)
    cBin = find(TmpData_Low(:, 2) == Cohs(i));
    tmpdata = TmpData_Low(cBin,:);
    for si=1:NumSub
        sBin = find(tmpdata(:,end) == si);
        MeanVal_L(si,i) = mean(tmpdata(sBin, 3));
    end
    SEMConfLow(i) = std(MeanVal_L(:,i))./sqrt(NumSub);
    LowConf(i) = mean(MeanVal_L(:,i));   
end

for si=1:NumSub
    coh = [1.6 3.2 6.4 12.8 25.6];
    coh=log(coh)/log(2);
    modelFun =  @(p,x) 1- 1/2*(exp(-(x./p(1)).^p(2)));
    startingVals = [1 2];
    coefEsts = nlinfit(coh(1:5), MeanVal_L(si,:), modelFun, startingVals);
    Alpha_L(si) = coefEsts(1);
    
end

TmpData_High = SData(Hindx, :);
for i=1:size(Cohs,2)
    cBin = find(TmpData_High(:, 2) == Cohs(i));
    tmpdata = TmpData_High(cBin,:);
    for si=1:NumSub
        sBin = find(tmpdata(:,end) == si);
        MeanVal_H(si,i) = mean(tmpdata(sBin, 3));
    end
    SEMConfHigh(i) = std(MeanVal_H(:,i))./sqrt(NumSub);
    HighConf(i) = mean(MeanVal_H(:,i));   
end

for si=1:NumSub
    coh = [1.6 3.2 6.4 12.8 25.6];
    coh=log(coh)/log(2);
    modelFun =  @(p,x) 1- 1/2*(exp(-(x./p(1)).^p(2)));
    startingVals = [1 2];
    coefEsts = nlinfit(coh(1:5), MeanVal_H(si,:), modelFun, startingVals);
    Alpha_H(si) = coefEsts(1);
    
end

%% Booststartp
MyFun = @(x) mean(x);
H_BootCI = bootci(10000,{MyFun,abs(Alpha_H)},'alpha',1-.68);
L_BootCI = bootci(10000,{MyFun,abs(Alpha_L)},'alpha',1-.68);
%% ACC

hold on;
Means = [0 mean(MeanVal_L)];
Error_Bar_E = std(MeanVal_L)/sqrt(NumSub);
color = 'r';
MyWeibull;
hold on;

Means = [0 mean(MeanVal_H)];
Error_Bar_E = std(MeanVal_H)/sqrt(NumSub);
color='b';
MyWeibull;
hold on;
set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Stimulus Strength (%coh)')
ylabel('Probability Correct');
legend([P{2} P{1}],'LowConfAgent','HighConfAgent');
SEMH = mean(H_BootCI)-H_BootCI(1);
SEML = mean(L_BootCI)-L_BootCI(1);
HErrorBar([4.03],[.82],[SEML],[SEML],[1 0 1]);
hold on;
HErrorBar([4.14],[.82],[SEMH],[SEMH],[1 .5 0])
legend boxoff;
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
ylim([.5 1]);
%%

Cohs = SData(:,2);
Subs = SData(:,end);
Condition = SData(:,end-1);

MyTable = table(Subs,Cohs,ACC,Condition);


glme = fitglme(MyTable,...
		'ACC ~ 1 + Condition + Cohs + (1|Subs)',...
		'Distribution','Poisson ','Link','log','FitMethod','MPL',...
		'DummyVarCoding','effects')
    
    [glme.Coefficients.Estimate(2:end),glme.Coefficients.SE(2:end),...
    glme.Coefficients.Lower(2:end),glme.Coefficients.Upper(2:end),...
    glme.Coefficients.tStat(2:end),glme.Coefficients.pValue(2:end)]