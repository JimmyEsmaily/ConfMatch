clc;
clear;
close all;
%%
load I_Params.mat
%%
rng(1);
j = 1;
NumIter = 100;
Cohs = [0:.5:25]/100;
AllCoh = repmat(Cohs,NumIter,1);
AllW = [-.0:0.0005:0.005];
for cc=1:size(AllCoh,2)
    coh = AllCoh(:,cc);
    for ww=1:size(AllW,2)
        Vriables1 = [AllW(ww)]; % 0.005 %
        Vriables2 = [AllW(ww)]; % 0.025
        SParams1 = [Vriables1, Params_I];
        SParams2 = [Vriables2];
        [t1, history1,Conf,time,choice] = Model_ACCConf...
            (SParams1,coh);
        Allconf(cc,ww) = mean([Conf]);
        Decision(cc,ww) = size(find(choice),1)/NumIter;
        AllRT(cc,ww) = mean([time]);
    end
    cc
end
save('ACCConf_15','Allconf','Decision','AllRT');
%%
PlotContour
