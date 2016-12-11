clear all
close all

%% construct the structure db
% the first database to connect, such as SMS
db(1).name = '521090_SMS'; % the name of the database, ask Roland or find it in GUI tool
db(1).username = 'username'; % the username to connect this databse, ask Roland
db(1).password = 'password'; % the password to connect this databse, ask Roland
db(1).sensor = {'Avg_GHI','Avg_DNI','Avg_DHI_meas','theta','phi','Std_GHI','Min_GHI','Max_GHI'}; % sensors you would like to retrieve
db(1).variable = {'G_h','G_dir','G_dif','theta_s_deg','phi_s_deg','G_h_std','G_h_min','G_h_max'}; % how you would like to rename data from sensors

% the second database to connect, such as ZG
db(2).name = '526650_ZG';
db(2).username = 'username';
db(2).password = 'password';
db(2).sensor = {'PD_West_BD(W/m2)','PD_West_AU(W/m2)','PD_West_AD(W/m2)','PD_West_BU(W/m2)',...
    'PD_East_BD(W/m2)','PD_East_AU(W/m2)','PD_East_AD(W/m2)','PD_East_BU(W/m2)',...
    'PYR_ZZ (W/m2)'}; % watch out some sensors have (W/m2) in their names
db(2).variable = {'PD_West_BD','PD_West_AU','PD_West_AD','PD_West_BU',...
    'PD_East_BD','PD_East_AU','PD_East_AD','PD_East_BU',...
    'PYR_ZZ'}; % (W/m2) cannot be in vairable names, so rename it by setting different names here

%% inputs
startday = '2016-11-01'; % from when you would like to retrieve
endday = '2016-11-20'; % until when you would like to retrieve
host = '123.123.123.123'; % solarbeat server's ip, ask Roland

%% retrieve
% output is a cell array, each cell corresponds each database. Each cell
% contains a timetable, which contains all data.
data = retrieve_solarbeat( startday, endday, host, db ); % start retrieval

%% convert
% if you prefer individual variables, the following code may hint your converion. 
Timestamp = data{1}.Properties.RowTimes;
GHI = data{1}{:,2};
DNI = data{1}{:,3};
PD_West_BD = data{2}{:,2};

    
