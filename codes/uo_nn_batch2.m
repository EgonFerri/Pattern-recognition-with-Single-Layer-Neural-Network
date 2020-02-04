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

iheader = 1;

la = 1;
typealmax = 2;

fileID = fopen('uo_nn_batch2.csv','w');
for num_target = 1:10
    for isd = [1,3]            
         [Xtr,ytr,wo,tr_acc,Xte,yte,te_acc,niter,tex]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
         if iheader == 1 fprintf(fileID,'num_target;   la; isd; typealmax; niter;     tex; te_acc; tex/te_acc;\n'); end
         fprintf(fileID,'         %1i; %4.1f;   %1i; %1i; %4i; %7.4f;  %5.1f; %7.4f;\n', mod(num_target,10), la, isd,typealmax, niter, tex, te_acc, tex/te_acc);
         iheader=0;
    end
 end
fclose(fileID);
