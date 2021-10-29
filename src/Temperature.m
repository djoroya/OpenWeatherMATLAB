clear

key = "22855c4d4d8f95c2869749a8b7c02487";

lat = 43.34840399222273;
long = -2.798025610745676;
cnt = 7;
%

url = "https://api.openweathermap.org/data/2.5/onecall?lat="+num2str(lat)+"&lon="+num2str(long)+"&appid="+key;

r = webread(url);

%%
clf
hold on
temps = {'day','night','max','min'};
for itemp = temps
    try
        plot(arrayfun(@(i) r.daily{i}.temp.(itemp{:}) - 273.15,1:8),'.-')
    catch
        plot(arrayfun(@(i) r.daily(i).temp.(itemp{:}) - 273.15,1:8),'.-')
    end
end
legend('day','night','max','min')


%%
%%

try 
    tmin = arrayfun(@(i) r.daily{i}.temp.min,1:7);
    tmax = arrayfun(@(i) r.daily{i}.temp.max,1:7);
catch
    tmin = arrayfun(@(i) r.daily(i).temp.min,1:7);
    tmax = arrayfun(@(i) r.daily(i).temp.max,1:7);  
end

in = [tmin tmax];

load('data/net.mat')

[Tspan,tspan] = Forecast_Exterior_Clima(tmin,tmax,inet,Tm,Ts);
%
tmin_plot = repmat(tmin,24,1);
tmin_plot = tmin_plot(:);
%
tmax_plot = repmat(tmax,24,1);
tmax_plot = tmax_plot(:);
figure(1)
clf
 hold on
 T_k = 273.15;
 plot(tspan,tmin_plot'-T_k,'.-')
 plot(tspan,tmax_plot'-T_k,'.-')
 plot(tspan,Tspan-T_k,'.-')
 grid on
 %ylim([5 30])
