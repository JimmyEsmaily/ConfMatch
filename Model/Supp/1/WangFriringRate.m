function [t, history,choice,time] = WangFriringRate(Vars0,coh)
global info;
global Confss;
% global WsIs;
% global Bound;
% StartP = Vars0(1);
% Bound = Vars0(2);
% mu0 = Vars0(3);
StartP = 0;
Bound = .32;
mu0 = 45.8;

% JN11 = Vars0(3);
% JN12 = Vars0(4);
WsIs = Vars0(1);
% WsWang = Vars0(2);
WsWangR = 1.21;
WsWangI = 1.3;

%% Funcs
    function d = dS1(S1, S2, I0, I1, I2, Inoise1, Inoise2,Is)
        d = -S1/tS + (1-S1).*g.*H1(Isyn1(S1,S2, I0, I1, Inoise1,Is), Isyn2(S1, S2, I0, I2, Inoise2,Is));
    end

    function d = dS2(S1, S2, I0, I1, I2, Inoise1, Inoise2,Is)
        d = -S2/tS + (1-S2).*g.*H2(Isyn1(S1,S2, I0, I1, Inoise1,Is), Isyn2(S1, S2, I0, I2, Inoise2,Is));
    end

JN11 = 0.2609*WsWangR; % nA (Wang)
% JN11 = 0.2915; % For Subject
JN22 = JN11;
JN12 = 0.0497*WsWangI; % nA (Wang)
% JN12 = 0.0479; % For Subject
JN21 = JN12;
I0 = 0.3255; % nA
tS = 0.1; % s %tau_NMDA
g = 0.641; %unitless %gamma

    function x = Isyn1(S1, S2, I0, I1, Inoise1,Is)
        x = JN11*S1 - JN12*S2 + I0 + I1 + Inoise1+WsIs*Is;
    end

    function x = Isyn2(S1, S2, I0, I2, Inoise2,Is)
        x = JN22*S2 - JN21*S1 + I0 + I2 + Inoise2+WsIs*Is;
    end
%%%%%%%%%%%%%%%%
JA_vec = [0, 0.0005, 0.0010, 0.0015, 0.0020];
JA11 = JA_vec(1);
JA22 = JA11;
JA12 = 0.1*JA11;
JA21 = JA12;
    function h = H1(x1, x2)
        a = 270 + 239400*JA11; b = 108 + 97000*JA11; d = 0.1540 - 30*JA11;  % Parameters for excitatory cells
        fA1 = JA12*( -276*x2 + 106 ).*( sign(x2-0.4) + 1 )/2;
        h = (a*x1 - b) ./ (1 - exp(-d*(a*x1 - fA1 - b)));
        % To ensure firing rates are always positive (noise may cause negative)
        h(h < 0) = 0;
    end

    function h = H2(x1, x2)
        a = 270 + 239400*JA22; b = 108 + 97000*JA22; d = 0.1540 - 30*JA22;  % Parameters for excitatory cells
        fA1 = JA21*( -276*x1 + 106 ).*( sign(x1-0.4) + 1 )/2;
        h = (a*x2 - b) ./ (1 - exp(-d*(a*x2 - fA1 - b)));
        % To ensure firing rates are always positive (noise may cause negative)
        h(h < 0) = 0;
    end

    function d = dInoise(Inoise)
        d = 1/tA * -(Inoise + randn(size(Inoise))*sqrt(tA/dt*snoise^2));
    end
tA = 0.002; % s %tau_AMPA
snoise = 0.02; % nA
dt = 0.0005; %s
    function [I1, I2] = stimulus(coh,mu0,ONOFF)
        I1 = JAext * mu0 * (1+coh)* ONOFF;
        I2 = JAext * mu0 * (1-coh)* ONOFF;
    end

%where
JAext = 0.2243E-3; % nC, is the AMPA synaptic coupling of the external input;
% JAext = 0.00052; %from Wang
% mu0 = 30;  % Hz, the baseline external input firing rate.

%Finally here is a function to do Euler integration:
    function [t, history] = euler(Func, var0, dt, time0, time, skip)
        if ~exist('skip', 'var')
            skip = 1;
        end
        
        t = time0:dt*skip:time;
        history = zeros([size(var0) numel(t)]);
        history(:,:,1) = var0;
        
        for i = 2:numel(t)*skip;
            var0 = var0 + Func(var0) .* dt;
            if mod(i-1, skip) == 0
                history(:,:,(i-1)/skip+1) = var0;
            end
        end
    end

%and a combined function to calculate the step.
    function dx = step(x)
        dx(:,4) = dInoise(x(:,4));
        dx(:,1) = dS1(x(:,1), x(:,2), I0, I1, I2, x(:,3), x(:,4),Is);
        dx(:,2) = dS2(x(:,1), x(:,2), I0, I1, I2, x(:,3), x(:,4),Is);
        dx(:,3) = dInoise(x(:,3));
    end

%--------------------------------------------------------------------------
%%
% coh = (info.coh/100)';
[I1, I2] = stimulus(coh',mu0,1);
% SubConf = abs(info.Conf)/6;
% Is = [(SubConf(2:end)-abs(Confss(1:end-1)))]'/6;
% Is  = ([exp(abs(SubConf(2:end)-abs(Confss(1:end-1)))/6)]');
% Is  = ([exp(abs(SubConf-abs(Confss))/6)]');

% OtherConf = abs(Confss)/6;
% Is = [exp((SubConf-OtherConf))]';
% Is = [OtherConf]';
Is = ones(size(coh'));
% Is(1:floor(size(coh',1)/2))=0;
% Is = rand(size(coh'));

% Is = [(OtherConf)]';

% Is = [1;Is];
[t1, history1] = euler(@step, [StartP*ones(length(coh),2),zeros(length(coh), 2)], dt, 0, .5, 10);
[I1, I2] = stimulus(0,0,0);
I0 = 0;
[t2, history2] = euler(@step, squeeze(history1(:,:,end)), dt, t1(end), 3, 10);
t = [t1,t2];
history = cat(3,history1, history2);
%%
% Now let's plot psychometric and chronometric functions.
% We will set the decision threshold to be when either S1 or S2 crosses 0.5.
thresh = Bound;
% thresh    = 15;        % Decision threshold


%calculate choice and decision time for each trial
[choice, time, iter] = decisiontimes(t, history, thresh);
% AgentConf = DecisionConf(history);
% ACC1 = sum(choice)/size(choice,1);
% ACC = choice;
% CorrectRT = time(find(choice==1));
% WrongRT = time(find(choice==0));
% CorrecrPD = fitdist(CorrectRT,'Normal');
% WrongPD = fitdist(WrongRT,'Normal');
% MeanRT = mean(time);
% MaxLikeHood = 1;
% for ii=1:size(time,1)
%     if info.eval_answer(ii) =='t'
%         MaxLikeHood = MaxLikeHood*normpdf(info.RT(ii)/1000,CorrecrPD.mu,CorrecrPD.sigma);
%     else
%         MaxLikeHood = MaxLikeHood*normpdf(info.RT(ii)/1000,WrongPD.mu,WrongPD.sigma);
%     end
% end
% NormRTDiff = mean((info.NewRT)/max(info.NewRT))-(MeanRT/max(time));
% Error = abs((ACC-info.Efficiency/100))+abs(NormRTDiff);

% Fitness = -log(MaxLikeHood);
% Fitness = abs((ACC-info.Efficiency/100))
% AACOnf = mean(abs(info.Conf))/6;
% Fitness = abs((ACC1-info.Efficiency/100))+ abs(AACOnf-mean(AgentConf))

% AllPD = fitdist(AgentConf,'Normal');
% MaxLikeHood = sum(log(normpdf(abs(info.Conf)/6,AllPD.mu,AllPD.sigma)));
% Fitness = -MaxLikeHood

    function [choice, time, iter] = decisiontimes(t, history, thresh)
        %each row gets the NMDA variable or each trial
        Rin = squeeze(history(:,1,:));
        Rout = squeeze(history(:,2,:));
        
        in = (Rin > thresh);
        out = (Rout > thresh);
        
        [tin, iin] = min(in .* repmat(t, size(in, 1), 1) + max(t)*(~in), [], 2);
        [tout, iout] = min(out .* repmat(t, size(out, 1), 1) + max(t)*(~out), [], 2);
        
        choice = [tin < tout];
        time = min(tin, tout);
        iter = iin .* choice + iout.*~choice;
    end
    function FinalConf = DecisionConf(history)
        Rin = squeeze(history(:,1,:));
        Rout = squeeze(history(:,2,:));
%         tmpconf(:,1) = abs(mean(Rin(:,101:217),2)-mean(Rout(:,101:217),2));
        
        tmpconf(:,1) = abs(mean(Rin(:,1:100),2)-mean(Rout(:,1:100),2));
%         FinalConf = 1.32-.99./exp(5.9*tmpconf-.165);

        FinalConf=((tmpconf)/(max(tmpconf)));
    end
end