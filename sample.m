clear all
close all

%% construct the structure db
% the first database to connect, such as SMS
db(1).name = '521090_SMS'; % the name of the database, ask Roland or find it in GUI tool
db(1).username = 'username'; % the username to connect this databse, ask Roland
db(1).password = 'password'; % the password to connect this databse, ask Roland
db(1).sensor = {'Avg_GHI','Avg_DNI'}; % sensors you would like to retrieve

% the second database to connect, such as ZG
db(2).name = '526650_ZG';
db(2).username = 'username';
db(2).password = 'password';
db(2).sensor = {'PD_West_BD(W/m2)','PYR_ZZ (W/m2)'}; % watch out some sensors have (W/m2) in their names

%% inputs
startday = '2016-11-01'; % from when you would like to retrieve
endday = '2016-11-02'; % until when you would like to retrieve
host = '123.123.123.123'; % solarbeat server's ip, ask Roland

%% retrieve
% output is a cell array, each cell corresponds each database. Each cell
% contains a timetable, which contains all data.
data = retrieve_solarbeat( startday, endday, host, db ); % start retrieval

%% convert
% if you prefer individual variables, the following code may hint your converion. 
Timestamp = data{1};
G_h = data{2}(:,1);
G_dir = data{2}(:,2);
PD_West_BD = data{3}(:,1);
PYR_ZZ = data{3}(:,2);
