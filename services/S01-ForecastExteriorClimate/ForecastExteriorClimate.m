function Forecast_Exterior_Clima()
    key = "22855c4d4d8f95c2869749a8b7c02487";

    lat = 43.34840399222273;
    long = -2.798025610745676;
    %

    url = "https://api.openweathermap.org/data/2.5/onecall?lat="+num2str(lat)+"&lon="+num2str(long)+"&appid="+key;

    r = webread(url);

    ndays = 7; 
    try
        tmin = arrayfun(@(i) r.daily(i).temp.min,1:ndays);
        tmax = arrayfun(@(i) r.daily(i).temp.max,1:ndays);  
    catch
        tmin = arrayfun(@(i) r.daily(i).temp.min,1:ndays);
        tmax = arrayfun(@(i) r.daily(i).temp.max,1:ndays);  
    end

    s = load('S01_net.mat');

    
    [Tspan,tspan] = Forecast_Exterior_Clima(tmin,tmax,s.inet,s.Tm,s.Ts);
    %
    ds.tspan   = tspan';
    ds.Temperature = Tspan';

    ds = struct2table(ds);
    writetable(ds,'ds.csv')
end
