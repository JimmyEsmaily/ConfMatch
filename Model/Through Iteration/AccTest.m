clc;
clear;
close all;
%%
load FinalZero_15.mat;
IACC1 = mean(Decision1,2);
IACC2 = mean(Decision2,2);
load FinalMatch_15.mat;
SACC1 = mean(Decision1,2);
SACC2 = mean(Decision2,2);
%%
TestI = ranksum(IACC1,IACC2);
TestS1 = ranksum(IACC1,SACC1);
TestS2 = ranksum(IACC2,SACC2);


