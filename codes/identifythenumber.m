function[res]=identifythenumber(array)
tr_freq     = .5;
tr_seed     = 1700963;
tr_p        = 250;
te_seed     = 101010;
te_q        = tr_p;
% Parameters for optimization:
epsG = 10^-6; kmax = 1000;                                    % Stopping criterium:
ialmax = 2; kmaxBLS=30; epsal=10^-3; c1=0.01; c2=0.45; % Linesearch
typealmax= 2;
la= 1;
isd= 3;

sig = @(X) 1./(1+exp(-X));
y = @(X,w) sig(w'*sig(X));

%preparing outcomes for the binary search tree (is the number round? if it
%is is in [3,8,0]? and so on and so forth)
num_target=[3,6,8,9,10];
[~, ~, wo]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
wround=wo;

num_target=[3,8,10];
[~, ~, wo]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
w380=wo;

num_target=[3,8];
[~, ~, wo]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
w38=wo;

num_target=[3];
[~, ~, wo]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
w3=wo;

num_target=[6];
[~, ~, wo]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
w6=wo;

num_target=[1,4,7];
[~, ~, wo]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
w147=wo;

num_target=[1,7];
[~, ~, wo]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
w17=wo;

num_target=[1];
[~, ~, wo]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
w1=wo;

num_target=[2];
[~, ~, wo]=uo_nn_solve(num_target, tr_freq,tr_seed,tr_p,te_seed,te_q,la,epsG,kmax,ialmax,typealmax,kmaxBLS,epsal,c1,c2,isd);
w2=wo;

%binary tree search for each number of the array
for i=1:5
    value=array(:,i);
    if y(value, wround)>0.5
        if y(value, w380)>0.5
            if y(value, w38)>0.5
                if y(value, w3)>0.5
                    result= 3;
                else
                    result =8;
                end
            else
                result=0;
            end
        else 
           if y(value, w6)>0.5
               result=6;
           else
               result=9;
           end
        end
    else
        if y(value, w147)>0.5
            if y(value, w17)>0.5
                if y(value, w1)>0.5
                    result = 1;
                else
                    result = 7;
                end
            else
                result = 4;
            end
        else
            if y(value, w2)>0.5
                result = 2;
            else
                result = 5;
            end
        end
    end
    res(i)=result;
end
end
