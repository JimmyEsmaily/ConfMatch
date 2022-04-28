clc;
clear;
close all;
%%
load PlotData1.mat
%%

TBin = Bintime;
for ti = 1:size(Cohs_L,2)
    tfit = fitlm(TBin',squeeze(hist_H(ti,1,TBin)));
    Slope_H_W(ti) = tfit.Coefficients.Estimate(2)*1000;
    
    tfit = fitlm(TBin',squeeze(hist_L(ti,1,TBin)));
    Slope_L_W(ti) = tfit.Coefficients.Estimate(2)*1000;
    
    tfit = fitlm(TBin',squeeze(abs(hist_H(ti,1,TBin)-hist_H(ti,2,TBin))));
    Slope_H_D(ti) = tfit.Coefficients.Estimate(2)*1000;
    
    tfit = fitlm(TBin',squeeze(abs(hist_L(ti,1,TBin)-hist_L(ti,2,TBin))));
    Slope_L_D(ti) = tfit.Coefficients.Estimate(2)*1000;

    
end


%%
CohArray = Cohs_H;
%%
Cohs = [1.6, 3.2,6.4,12.8,25.6]/100;
for i=1:size(Cohs,2)
    TData = Slope_H_W(CohArray==Cohs(i));
    SlopCoh_HW(i) = mean(TData);
    SEM_HW(i) = std(TData)/sqrt(size(find(CohArray==Cohs(i)),2));
    
    
    TData = Slope_H_D(CohArray==Cohs(i));
    SlopCoh_HD(i) = mean(TData);
    SEM_HD(i) = std(TData)/sqrt(size(find(CohArray==Cohs(i)),2));
    
end

%%
CohArray = Cohs_L;
for i=1:size(Cohs,2)

    
    TData = Slope_L_W(CohArray==Cohs(i));
    SlopCoh_LW(i) = mean(TData);
    SEM_LW(i) = std(TData)/sqrt(size(find(CohArray==Cohs(i)),2));
    
    TData = Slope_L_D(CohArray==Cohs(i));
    SlopCoh_LD(i) = mean(TData);
    SEM_LD(i) = std(TData)/sqrt(size(find(CohArray==Cohs(i)),2));
end


%%% Winner
close all;
figure, hold on;
for i=1:5
    TmpMean = [SlopCoh_LW(i),SlopCoh_HW(i)];
    TmpSEM = [SEM_LW(i),SEM_HW(i)];
    PP = bar([i],TmpMean(1),.3);
    PP.FaceColor = [1 .5 0];
    PP.LineWidth = 2;

    P=bar([i+.3],TmpMean(2),.3);
    P.FaceColor = [1 0 1];
    P.LineWidth = 2;
    
    MyErrorBar([i],TmpMean(1),TmpSEM(1),'k-');
    MyErrorBar([i+.3],TmpMean(2),TmpSEM(2),'k-');
    
    
    
end
legend([PP,P],{'LCA','HCA'});
legend boxoff;
xtick = [1:5];
xticklabl = {'1.6', '3.2','6.4','12.8','25.6','Avg'};
set(gca,'XTick',xtick,'XTickLabel',xticklabl);
set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Motion Strength (%)');
ylabel('Slope(DiffAE/s)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
ylim([0,10]);


%%%%% Difference

figure, hold on;
for i=1:5
    TmpMean = [SlopCoh_LD(i),SlopCoh_HD(i)];
    TmpSEM = [SEM_LD(i),SEM_HD(i)];
    PP = bar([i],TmpMean(1),.3);
    PP.FaceColor = [1 .5 0];
    PP.LineWidth = 2;

    P=bar([i+.3],TmpMean(2),.3);
    P.FaceColor = [1 0 1];
    P.LineWidth = 2;
    
    MyErrorBar([i],TmpMean(1),TmpSEM(1),'k-');
    MyErrorBar([i+.3],TmpMean(2),TmpSEM(2),'k-');
    
    
    
end
legend([PP,P],{'LCA','HCA'});
legend boxoff;
xtick = [1:5];
xticklabl = {'1.6', '3.2','6.4','12.8','25.6','Avg'};
set(gca,'XTick',xtick,'XTickLabel',xticklabl);
set(gca,'Box','off');
set(gcf,'Color','w');
xlabel('Motion Strength (%)');
ylabel('Slope(DiffAE/s)');
set(gca,'TickDir','out');
set(gca,'FontSize',20);
set(gca,'linewidth',1.5);
set(gca,'linewidth',1.5);
ylim([0,10]);
