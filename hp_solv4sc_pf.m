function [sv,to]=hp_solv4sc_pf2(U,S,V,y,d,N,cent,sigma_s,itnum)
% given U,S,V decomposition of B
% given an input y 
% single input version
% d image dimensionality
% N number of bases + polynomial part
%Nd  number of data points ==1
% sigma_s1 variance of style vector distribution
% itnum iteration number

%initial
B1=U*S; % PX: viewpoint bases
Ks=size(V',2);
Kv=30;
sigma=0.8;
sigma_2=sigma^2;
%%%initialize particles

s=V';%style particles
%x=[0:2*pi/Kv:2*pi-2*pi/Kv];%viewpoint particles
x=[0 : 1*pi/Kv : 1*pi-1*pi/Kv];
%sigma_s=repmat(sigma_s1,1,50);
sigma_v=2*pi/Kv/2;
Ft=y;


for iteration=1:itnum

    wij=zeros(Ks,Kv);

    aaaPv=[cos(x') sin(x')];
    aaad2=dist2(aaaPv,cent);
    aaaDst=sqrt(aaad2);
    aaavvvv=[phi(aaaDst)'; ones(size(aaaPv',2),1)' ; aaaPv'];
    aaaFt=repmat(Ft,1,Kv);


    %%% compute weights
    CF2=reshape(B1*s,d,N,Ks);
    for i=1:Ks
        aaaFv= CF2(:,:,i)*aaavvvv;
        rec_er=sum((aaaFv-aaaFt).^2);
        wij(i,:)=exp(-rec_er/(2 *sigma_2));
    end

    %%% normalize weights
    allsum=sum(sum(wij));
    ws=sum(wij,2)./allsum;
    wv=sum(wij,1)./allsum;
    ws=ws./sum(ws);
    wv=wv./sum(wv);

    %%% find max weight
    [cs,is1]=max(wij);
    [cv,iv]=max(cs);
    is=is1(iv);

    %%%max output
    sv=s(:,is);
    to=x(iv);
   
    %%% resampling
    edges = min([0 cumsum(ws')],1); % protect against accumulated round-off
    edges(end) = 1;                 % get the upper edge exact
    u1 = rand/Ks;
    [temp, idx] = histc(u1:1/Ks:1, edges);
    s1=[];
    s1=normrnd(s(:,idx), repmat(sigma_s',1,Ks));

    %%% remain style sample with best performance
    [cc,ii]=max(ws);
    iis=find(idx==ii);
    s1(:,iis(1))=s(:,ii);

    %%% remain style particle with best performance
%     iis=[];
%     if isempty(find(idx==is))
%         [cc,ii]=max(ws);
%         iis=find(idx==ii);
%     else
%         iis=find(idx==is);
%     end
%     s1(:,iis(1))=s(:,is);

    s=s1;

    edges1 = min([0 cumsum(wv)],1); % protect against accumulated round-off
    edges1(end) = 1;                 % get the upper edge exact
    u2 = rand/Kv;
    [temp, idx1] = histc(u2:1/Kv:1, edges1);
    x1=[];
    x1=normrnd(x(idx1), repmat(sigma_v,1,Kv));
    x1(x1<0)=x1(x1<0)+2*pi;
    x1(x1>2*pi)=x1(x1>2*pi)-2*pi;

    %%% remain viewpoint sample with best performance
    [cc,ii]=max(wv);
    iiv=find(idx1==ii);
    x1(:,iiv(1))=x(:,ii);

    %%% remain viewpoint particle with best performance
%     iiv=[];
%     if isempty(find(idx1==iv))
%         [cc,ii]=max(wv);
%         iiv=find(idx1==ii);
%     else
%         iiv=find(idx1==iv);
%     end
%     x1(:,iiv(1))=x(:,iv);

    x=x1;

end
