%[start]alg uo_nn_solve
function [Xtr,ytr,wo,tr_acc,Xte,yte,te_acc,niter,tex]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax, kmaxBLS,epsal,c1,c2,isd)
tic %start execution time

%dataset generation
[Xtr,ytr] = uo_nn_dataset(tr_seed, tr_p, num_target, tr_freq); 
[Xte,yte] = uo_nn_dataset(te_seed, te_q, num_target, 0);

%functions
sig = @(X) 1./(1+exp(-X));
y = @(X,w) sig(w'*sig(X));
L = @(w) norm(y(Xtr,w)-ytr)^2 + (la*norm(w)^2)/2;
gL = @(w) 2*sig(Xtr)*((y(Xtr,w)-ytr).*y(Xtr,w).*(1-y(Xtr,w)))'+la*w;
acc = @(Xds,yds,wo) 100*sum(yds==round(y(Xds,wo)))/size(Xds,2); %accuracy

%optimize
x=zeros(35,1);
[wo, niter]=uo_solve(x,L,gL,epsG,kmax,c1,c2,isd,kmaxBLS, epsal, ialmax, typealmax);

%calculate result accuracy
tr_acc=acc(Xtr, ytr, wo);
te_acc=acc(Xte, yte, wo);

tex=toc; %end execution time
end
% [end]alg uo_nn_solve


% [start]alg solve
function [wo, k]= uo_solve(x,f,g,eps,kmax,c1,c2,isd,maxiter, epsal, ialmax, typealmax)
k=1; H = eye(size(x,1)); almax= ialmax;
while norm(g(x)) >= eps && k < kmax
    d= uo_descent(x,g, H, isd);
    [al, iWout] = uo_BLSNW32(f,g,x,d,almax,c1,c2,maxiter,epsal);
    xk(:,k)= x; dk(:,k)=d; alk(k)=al; iWk(k)=iWout;
    x = x + al*d; s=x-xk(:,k); y= g(x)-g(xk(:,k));
    if typealmax==1
        almax=2;
    end
    if typealmax==2
        almax =al*(g(xk(:,k))'*dk(:,k))/(g(x)'*uo_descent(x,g, H, isd));
    end
    if typealmax==3
        almax = 2*((f(x)-f(xk(:,k)))/(g(x)'*uo_descent(x,g, H, isd)));
    end
    ro=1/(y'*s); 
    H= ((eye(size(x,1))-ro*s*y')*H^-1*(eye(size(x,1))-ro*y*s')+ro*(s*s'))^-1;
    k = k+1;
end
wo=x;
end
% [end] Alg. solve %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [start]alg descent
function[d] = uo_descent(x,g, H, isd)
if isd==1 %GM
    d= -g(x);
end
if isd==3 %QM-BFGS
    d= -H*g(x);  
end
end
% [end]alg descent
