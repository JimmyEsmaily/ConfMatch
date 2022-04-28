clc;
clear;
close all;
%%
rng(1);
SelfConf = 0;
OtherConf = 0;
Cohs = repmat([1.6, 3.2, 6.4, 12.8, 25.6], [1, 40]);
Cohs = Cohs(randperm(length(Cohs)));
%%
j = 1;
for jj=1:50
    j
Constat1 = [0.32];
Constat2 = [0.32];

Vriables1 = [-0.0005]; %
Vriables2 = [0.004]; % 
SParams1 = [Constat1 Vriables1];
SParams2 = [Constat2 Vriables2];
Wang1 = 1.04; % 1.06
Wang2 = .97; % 0.97
    for i=1:size(Cohs,2)
        coh = Cohs(i)/100;
        if i==1
            [t1, history1,Conf1(i),time1,choice1(i),Is1(i),RT1(i)] = Model_Match... % First
                (SParams1,coh,SelfConf,OtherConf,i,Wang1,0);
            
            [t2, history2,Conf2(i),time2,choice2(i),Is2(i),RT2(i)] = Model_Match... % Second
                (SParams2,coh,SelfConf,OtherConf,i,Wang2,0);
            
        else
            [t1, history1,Conf1(i),time1,choice1(i),Is1(i),RT1(i)] = Model_Match... % First
                (SParams1,coh,Conf1(i-1),Conf2(i-1),i,Wang1,0);
            
            [t2, history2,Conf2(i),time2,choice2(i),Is2(i),RT2(i)] = Model_Match... % Second
                (SParams2,coh,Conf2(i-1),Conf1(i-1),i,Wang2,.0);
        end
    end
    Allconf1(j,:) = Conf1;
    Allconf2(j,:) = Conf2;
    Decision1(j,:) = choice1;
    Decision2(j,:) = choice2;
    AllRT1(j,:) = RT1;
    AllRT2(j,:) = RT2;
    j = j+1;
end
save('FinalMatch_15','Allconf1','Allconf2','Decision1','Decision2','AllRT1','AllRT2');
%% plot Confs
