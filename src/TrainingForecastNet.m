clear 
load('data')
%%

k = 500;
xx = repmat(max_temp_day{k},24,1);
xx = xx(:);

yy = repmat(min_temp_day{k},24,1);
yy = yy(:);

clf
hold on
plot(celldata{k}.DateTime,xx)
plot(celldata{k}.DateTime,yy)

plot(celldata{k}.DateTime,celldata{k}.temp )
grid on
   

%%
XData_max = reshape([min_temp_day{:}],7,ndata);
XData_min = reshape([max_temp_day{:}],7,ndata);
XData = cat(3,XData_min, XData_max);
%%
XData = permute(XData,[1 3 2]);
XData = reshape(XData,7,1,2,ndata);
%


%
YData = arrayfun(@(i) celldata{i}.temp,1:ndata,'UniformOutput',false);
YData = [YData{:}];
%


%% normalize 
Tm = 288.0655;
Ts = 5;

YData = (YData - Tm)/Ts;
XData = (XData - Tm)/Ts;


%%
ntest = 500;
YData_test  = YData(:,1:ntest);
YData_train = YData(:,(ntest+1):end);
%
XData_test  = XData(:,:,:,1:ntest);
XData_train = XData(:,:,:,(ntest+1):end);

%%
options = trainingOptions('adam', ...
    'ValidationFrequency',100, ...
    'MiniBatchSize',1000, ...
    'MaxEpochs',500, ...
    'ValidationData',{XData_test,reshape(YData_test,1,1,nstep,ntest)},...
    'InitialLearnRate',1e-2, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.999, ...
    'LearnRateDropPeriod',10, ...
    'Shuffle','every-epoch', ...
    'L2Regularization',1e-7, ...
    'Plots','training-progress', ...
    'Verbose',false);

layers = [imageInputLayer([7 1 2]) 
          convolution2dLayer([7 1],16)
          reluLayer  
          fullyConnectedLayer(16)
          reluLayer  
          fullyConnectedLayer(32)
          reluLayer  
          fullyConnectedLayer(64)
          reluLayer  
          fullyConnectedLayer(168)
          regressionLayer];
      
      
inet = trainNetwork(XData_train,reshape(YData_train,1,1,nstep,ndata-ntest),layers,options);

save('fullnet')
save('net','inet','Ts','Tm')
%%
load('fullnet')
%%
T_k = 273.15;
% T_k = 0;
for itt = 1:100
    
    clf
    hold on

    in1 = XData(:,1,1,itt);
    in2 =  XData(:,1,2,itt);

    in_plot_1 = repmat(in1,1,24)';
    in_plot_2 = repmat(in2,1,24)';

    plot(celldata{itt}.DateTime,in_plot_1(:)*Ts + Tm - T_k);
    plot(celldata{itt}.DateTime,in_plot_2(:)*Ts + Tm - T_k);

    out = predict(inet,XData(:,:,:,itt));
    plot(celldata{itt}.DateTime,out*Ts + Tm - T_k,'LineWidth',2);
    plot(celldata{itt}.DateTime,celldata{itt}.temp - T_k,'.-');
    grid on
    legend('max','min','predict','real')
    ylim([0 30])
    pause(3)
    
end 
