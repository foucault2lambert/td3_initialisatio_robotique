clear var
file = load("dataGps.mat")
Tgps=dataGps(:,1);
Xgps=dataGps(:,2);
Ygps=dataGps(:,3);
Qgps=dataGps(:,4);
DataOk=dataGps(:,5);
temp = diff(Tgps);
temp(temp == 0) = [];
f = numel(temp)/(max(Tgps)-min(Tgps))