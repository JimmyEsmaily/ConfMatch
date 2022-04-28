clc;
clear;
close all;
%% Load LapLacian Data
load Lap_SData.mat;
%% X->Y
CPP = [13:16];
PFC = [28:31];

DIM = 1;                          
STEP = 1;
K = 20;
WINDOW_RADIUS = 5;

time = -200:1000;
AnTime = [-200:999];
TimeBin = dsearchn(time',AnTime');

XBin = time(TimeBin);


%%
SData = AllData_S(:,TimeBin,:);
X1=squeeze(mean(SData(PFC,:,:)))'; % From
Y1=squeeze(mean(SData(CPP,:,:)))'; % To
%% X->Y
package_init('.')
for i=1:size(X1,1)
    i
    X = X1(i,:);
    Y = Y1(i,:);
    W = delay_embed_future(X,STEP);    
    I(i,:,:)=transfer_entropy_t(X,Y,W,WINDOW_RADIUS);
end
%%
