clear

ndays = 7;
nstep = 24*ndays;

load('CS3_2_ExteriorClima.mat')
%

[~,ind] = unique(ds.DateTime,'first');
ds = ds(ind,:);
% aumentamos los datos disponibles
for k = 1:4
    ds2 = ds;
    ds2.temp = [ds.temp(k*24+1:end) ;ds.temp(1:k*24)];
    tspan = ds2.DateTime -  ds2.DateTime(1);
    ds2.DateTime = ds.DateTime(end) + tspan+ hours(1);

    ds = [ds;ds2(1:end,:)];
end

clf 
nt = 100;
plot(ds.temp(1:nt))
hold on
ds.temp = smoothdata(ds.temp,'SmoothingFactor',0.01);
plot(ds.temp(1:nt))

%
clf
hold on



ndata = floor(size(ds,1)/nstep);
%

celldata = arrayfun(@(i)ds(nstep*(i-1) +1 :(nstep*i),[1 2]),1:ndata,'UniformOutput',0);

max_temp_day = cell(ndata,1);
min_temp_day = cell(ndata,1);
parfor j = 1:ndata
max_temp_day{j} = arrayfun(@(i) max(celldata{j}.temp((24*(i-1)+1):(24*i))),1:ndays);
min_temp_day{j} = arrayfun(@(i) min(celldata{j}.temp((24*(i-1)+1):(24*i))),1:ndays);
fprintf("compute max min for signal "+j+"/"+ndata+"\n")
end

save('data')


%%
clf
subplot(2,1,1)
plot(ds.temp((1:(nstep+24))))
xlim([0 200])
subplot(2,1,2)

plot(ds2.temp(1:nstep))
xlim([0 200])

