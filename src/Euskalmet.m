% https://www.euskalmet.euskadi.eus/observacion/datos-de-estaciones/#
% Historicos recientes de Mungia 

clear
% Descriptions of variables

% Station Code 
stat_code = 'C057';
date = datetime('2020-01-01');
date = datetime('2021-10-29');

url = "https://www.euskalmet.euskadi.eus/vamet/stations/readings/"+ ...
       stat_code+ ...
       "/" + num2str(date.Year,'%04.f')   + ...
       "/" + num2str(date.Month,'%02.f')  + ...
       "/" + num2str(date.Day,'%02.f')    + ...
       "/readingsData.json";

r = webread(url);
%%
irradance = r.x70;

time = fieldnames(irradance.data.x2300);

date_str = string(datestr(date));
time = arrayfun(@(i)  datetime(date_str +" "+i{:}(2:3)+":"+i{:}(5:6)),time,'UniformOutput',1);
%
values = struct2array(irradance.data.x2300);

%%
[time,ind ]= sort(time);
values = values(ind);
plot(time,values,'.- ')

%%
rcell = struct2cell(r);

%%

for ir = fieldnames(r)'
    
    if strcmp(r.(ir{:}).type,'measuresForSun')
       r.(ir{:}).name
    end
end