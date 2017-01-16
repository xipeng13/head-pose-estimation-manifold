% Xi Peng, Sep 15th 2013
%function [me, st] = MainFile()
mat_path = '/Volumes/Data/Dropbox/Research/Headpose/ICPR14/data/multipie/all_mat/Train100_Test10.mat';
%clear all; close all;
disp(' '); disp(mat_path);
load(mat_path);
% each image was represented by a vector and samples of the same sequence
% were saved in one cell.
% in the sampledata.mat, there are 5 sequences (categories) for training
% and testing

Nseq= size(Ttrain, 2);%seq number for training
x={};%embedding coordinates
w={};%weights of each class style
a={};%estimated viewpoint
er={};%angle error


% embed on a circle
for seq=1:1:Nseq
    ti=angletrain{seq};
    t=ti*2*pi/360;
    P{seq}=[cos(t') sin(t')];
end

% learn mapping between the manifolds and the input space
disp('learn mapping between the manifolds and the input space');
M=15; % mapping centers
ti1=[1:M];
t1=ti1*1*pi/M; % pi or 2pi (1/2)
cent=[cos(t1') sin(t1')];

Nb=length(cent);
d=2;
CF=cell(1,Nseq);

for i=1:Nseq
  CF{i}=learnmapping_grbf(Ttrain{i}',P{i},cent);
end

%10368x5
B= zeros(prod(size(CF{1})),Nseq);

for i=1:Nseq,
  B(:,i)=reshape(CF{i}',prod(size(CF{i})),1);
end;

%decomposititon
%style vectors are the rows of V
%viewpoint bases are columus of US
%category vectors are rows of V
[U,S,V]=svd(B,0);

 
% solving for style and content of test dataset
disp('solving for style and content');
tnseq=size(Ttest,2); %seq number for testing

for nseq=1:1:tnseq
    
    
    message=sprintf('solvig for style and content of instance %d',nseq);
    disp(message); 
    
    nff=size(Ttest{nseq},2);
    
    for nf=1:1:nff
        y=Ttest{nseq}(:,nf);
        [x{nseq}(:,nf),w{nseq}(:,nf),a{nseq}(:,nf)]=solv4sc(U,S,V,y,size(Ttest{nseq},1),Nb+d+1,cent);
        %sigma_s = std(V');
        %[sv,a{nseq}(:,nf)]=hp_solv4sc_pf(U,S,V,y,size(Ttest{nseq},1),Nb+d+1,cent, sigma_s, 30);
        eee=a{nseq}(:,nf)*180/pi-angletest{nseq}(nf);
        if eee>180
            eee=eee-360;
        end
        if eee<-180
            eee=eee+360;              
        end
        er{nseq}(nf)=eee;
    end
        
end

errs = [];
for i = 1:1:length(er)
    errs = [errs er{i}];
end

me = mean(abs(errs)); st = std(abs(errs));
disp(['MAR:' num2str(me) ' STD:' num2str(st)]);
%save('er.mat', 'er');

%end
