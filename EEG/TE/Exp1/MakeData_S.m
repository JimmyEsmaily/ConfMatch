clc;
clear;
close all;
%%
load SData.mat;
load Corrdinates.mat;
%%

for i=1:size(AllData_S,3)
    i
    
    tmpdata = AllData_S(:,:,i);
    AllData_I(:,:,i) = laplacian_perrinX(tmpdata,X,Y,Z);
end