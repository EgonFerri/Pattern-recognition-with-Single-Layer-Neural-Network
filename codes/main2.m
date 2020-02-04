clear;
% Dataset parameters
tr_freq     = .5;
tr_seed     = 1700963;
tr_p        = 250;
te_seed     = 101010;
te_q        = tr_p;
% Parameters for optimization:
epsG = 10^-6; kmax = 1000;                                    % Stopping criterium:
ils=1; ialmax = 2; kmaxBLS=30; epsal=10^-3; c1=0.01; c2=0.45; % Linesearch
typealmax= 2;
num_target = 1;
la= 1;
isd= 3;

%solve the nn
[Xtr,ytr,wo,tr_acc,Xte,yte,te_acc,niter,tex]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);

%uo_nn_Xyplot(Xte, yte, wo) to plot results 
%uo_nn_Xyplot(wo, 0, []) to plot weights