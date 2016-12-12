function [ data ] = retrieve_solarbeat( startday, endday, host, db )
%{
Name:   retrieve_solarbeat.m

Version history:
    2016-12-11: v0.1, initial version

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
starttime = '00:00:00';
endtime = '23:59:59';
querry_limit = 5000;
sd = '[SensorData]';
sdts = 'SensorDataTimeStamp';
sdtsquotes = '[SensorDataTimeStamp]';
sdval = '[SensorDataValue]';

%% inputs
startday = datetime(startday,'InputFormat','yyyy-MM-dd');
endday = datetime(endday,'InputFormat','yyyy-MM-dd');

%% retrieve
for i=1:1:length(db)
    % connect to database
    conn = database(db(i).name,db(i).username,db(i).password,...
        'Vendor','Microsoft SQL Server','Server',host,...
        'AuthType','Server','PortNumber',1433);
    today = startday;
    data{i} = [];
    k = 1;
    
    while today <= endday
        % construct daily timetable
        Time = transpose(datetime(datevec(today)):minutes(1):datetime(datevec(today+hours(23)+minutes(59))));
        Index = transpose(k:1:k-1+length(Time));
        daily_table = timetable(Time,Index);
        k = k+length(Time);
        clear Time Index;
        
        % retrieve from server
        for j=1:1:length(db(i).sensor)
            % compose querry
            str_today = datestr(today,'yyyy-mm-dd');
            from_query = ['[', db(i).name, '].', sd, '.[', db(i).sensor{j}, ']'];
            longstring_start = [char(39), str_today, ' ', starttime, char(39)];
            longstring_end = [char(39), str_today, ' ', endtime, char(39)];
            date_query = [sdts, ' >= ', longstring_start, ' AND ', sdts, ' <= ', longstring_end];
            total_query = ['SELECT TOP ', num2str(querry_limit), ' * FROM ', from_query, ' WHERE ', date_query];
            % execute querry
            curs = exec(conn,total_query);
            fetched = fetch(curs);
            % write to daily timetable
            if isequal(fetched.Data,{'No Data'}) % whether 'No Data'
                Time = transpose(datetime(datevec(today)):minutes(1):datetime(datevec(today+hours(23)+minutes(59))));
                Data = nan(length(Time),1); % write NaN to daily timetable
                temp_table = timetable(Time,Data);
                temp_table.Properties.VariableNames = {db(i).variable{j}};
                daily_table = synchronize(daily_table,temp_table);
                % clear temp
                clear Time Data temp_table;
            else
                Time = datetime(cell2mat(fetched.Data(:,2)),'InputFormat','yyyy-MM-dd HH:mm:ss.0');
                Data = cell2mat(fetched.Data(:,3)); % write fetched data to daily timetable
                temp_table = timetable(Time,Data);
                temp_table.Properties.VariableNames = {db(i).variable{j}};
                daily_table = synchronize(daily_table,temp_table);
                % clear temp
                clear Time Data temp_table;
            end
        end
        % concatenate daily timetables
        data{i} = [data{i}; daily_table];
        today = today + days(1);
    end
    % close connection
    close(conn);
end
end

