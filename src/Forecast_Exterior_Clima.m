function [r,dt] = Forecast_Exterior_Clima(tmin,tmax,inet,Tm,Ts)



XData_max = reshape(tmin,7,1);
XData_min = reshape(tmax,7,1);
XData = cat(3,XData_min, XData_max);
XData = permute(XData,[1 3 2]);
in = reshape(XData,7,1,2,1);

in = (in- Tm)/Ts;
out = predict(inet,reshape(in,7,1,2,1));
%
dt = datetime('2020-01-01')+hours(1:24*7);


r = out*Ts + Tm ;
end

