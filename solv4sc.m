function [x,w,to]=solv4sc(U,S,V,y,d,N,cent)
% given U,S,V decomposition of B
% given an input y 
% single input version

% d image dimensionality
% N number of bases + polynomial part
%Nd  number of data points
% x embedding coordinate on the circle
% w weights of each style vector
% to estimated viewpoint

Nd=1;
B1=U*S*V';
K=size(V',2);
%intial weights
w=ones(Nd,K)/K;
x=zeros(N,Nd);
w0=zeros(Nd,K);

count=0;
while(norm(w-w0)>0.00001 & count<100)
    
        % PX: start from the average of all the style vector,
        %     then search for the best veiwpoint
        %compute rbf coeff
        w0=w;
        count=count+1;

        CF1=reshape(B1*w',d,N);

        err=100000000;
        to=0;
    
        Ft=y;
        % 1-D search for veiwpoint
        for tv=0 : 0.1 : 1*pi % pi or 2pi (2/2)
            Pv=[cos(tv') sin(tv')];
            d2=dist2(Pv,cent);
            Dst=sqrt(d2);
            Fv= CF1* [phi(Dst)'; ones(size(Pv',2),1)' ; Pv'];
            nor=norm(Ft-Fv);
            if nor<=err
                err=nor;
                to=tv;
            end
        end
        Po=[cos(to') sin(to')];
        d2=dist2(Po,cent);
        Dst=sqrt(d2);
        x=[phi(Dst)'; ones(size(Po',2),1)' ; Po'];

        
% PX: updata the weight for each style,
%     less reconstruct error get more weight
% compute new weights
sigma=0.8; 
sigma_2=sigma^2;

Pc=zeros(K,Nd);

for i=1:K,
  b=reshape(B1(:,i),d,N);
  Pc(i)=exp(-sum((y-b*x).^2)/(2 *sigma_2));
end

Pc=Pc./sum(Pc);

w=Pc';

end

