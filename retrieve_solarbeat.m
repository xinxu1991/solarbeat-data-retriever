function [ data ] = retrieve_solarbeat( startday, endday, host, db )
%{
Name:   retrieve_solarbeat.m

Version history:
    2016-12-11: v0.1, initial version
    2016-12-11: v0.1-l, add support to early versions of MATLAB that don't
    support timetable

Author: Xin Xu (xuxin.cqu@live.com)

Required:
    1. MATLAB
    2. MATLAB database toolbox
    (https://www.mathworks.com/products/database.html)
    3. Credentials of SolarBEAT server (may be requested from dr. Roland
    Valckenborg from SEAC)
    4. Understanding of MATLAB timetable data type
    (https://nl.mathworks.com/help/matlab/timetables.html)

Purpose:
    This MATLAB function may retrieve measurement data from SEAC SolarBEAT
    server. User can define the period to retrieve. Data will be organized
    in a MATLAB timetable, which can be converted to any format by the user. 

%}

%% parameters
daystart = '00:00:00';
dayend = '23:59:59';
sample_rate = minutes(1);
querry_limit = 5000;
sd = '[SensorData]';
sdts = 'SensorDataTimeStamp';
sdtsquotes = '[SensorDataTimeStamp]';
sdval = '[SensorDataValue]';

%% inputs
starttime = datetime([startday,' ',daystart],'InputFormat','yyyy-MM-dd HH:mm:ss');
endtime = datetime([endday,' ',dayend],'InputFormat','yyyy-MM-dd HH:mm:ss');
startday = datetime(startday,'InputFormat','yyyy-MM-dd');
endday = datetime(endday,'InputFormat','yyyy-MM-dd');

%% retrieve
% timestamp
data{1} = transpose(starttime:sample_rate:endtime);
for i=1:1:length(db)
    % connect to database
    conn = database(db(i).name,db(i).username,db(i).password,...
        'Vendor','Microsoft SQL Server','Server',host,...
        'AuthType','Server','PortNumber',1433);
    today = startday;
    data{i+1} = nan(length(data{1}),length(db(i).sensor));
   
    while today <= endday      
        % retrieve from server
        for j=1:1:length(db(i).sensor)
            % compose querry
            str_today = datestr(today,'yyyy-mm-dd');
            from_query = ['[', db(i).name, '].', sd, '.[', db(i).sensor{j}, ']'];
            longstring_start = [char(39), str_today, ' ', daystart, char(39)];
            longstring_end = [char(39), str_today, ' ', dayend, char(39)];
            date_query = [sdts, ' >= ', longstring_start, ' AND ', sdts, ' <= ', longstring_end];
            total_query = ['SELECT TOP ', num2str(querry_limit), ' * FROM ', from_query, ' WHERE ', date_query];
            % execute querry
            curs = exec(conn,total_query);
            fetched = fetch(curs);
            % write to daily timetable
            if ~isequal(fetched.Data,{'No Data'}) % whether 'No Data'
                Time = datetime(cell2mat(fetched.Data(:,2)),'InputFormat','yyyy-MM-dd HH:mm:ss.0');
                Data = cell2mat(fetched.Data(:,3)); % write fetched data to daily timetable
                Index = round((Time-starttime)/sample_rate)+1;
                data{i+1}(Index,j) = Data;
                % clear temp
                clear Time Data Index;
            end
        end
        today = today + days(1);
    end
    % close connection
    close(conn);
end
end

