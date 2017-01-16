% Xi Peng, Sep 30th 2013
close all; clear all;

path = '../../data/multipie/All_em_mat/';

ME = []; ST = [];
testnum = 5; trannum = 25;
for i = 1:1:trannum
    mat_name = sprintf('%02dTrain_%02dTest.mat', i, testnum);
    [me, st] = MainFile([path mat_name]);
    ME = [ME, me];
    ST = [ST, st];
end