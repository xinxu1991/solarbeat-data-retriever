# solarbeat-data-retriever
A MATLAB function to retrieve data from SEAC SolarBEAT. More information on SEAC: https://www.seac.cc
# 2 branches
There are 2 branches available: master and legacy. You can switch branch from the dropdown menu in the upper left. Click download button on the right to download scripts as a zip.
## Master branch
Master branch uses the feature _timetables_ of the latest MATLAB (since **R2016b**), [see documentation](https://nl.mathworks.com/help/matlab/timetables.html). If you don't know how to work with timetables, or have lower version MATLAB, use legacy version instead.
## Legacy branch
Doing the same thing as the master branch, but by using traditional array and cell. 
# Tutorial
## Get credentials from SolarBEAT
Please contact Dr. Valckenborg for credentials (IP, username, password, etc.) of SolarBEAT database.
## Setup MATLAB database toolbox
The retriever requires MALTAB database toolbox, please install it before proceeding. [See how.](https://nl.mathworks.com/matlabcentral/answers/101885-how-do-i-install-additional-toolboxes-into-an-existing-installation-of-matlab.)
## Install JBOD driver
The retriever requires JBOD driver. To install it:

1.	Go to https://msdn.microsoft.com/en-us/library/mt683464.aspx 
2.	Click **Download the Microsoft JDBC Driver 6.0, 4.2, 4.1, or 4.0 for SQL Server**
3.	Select language and select **sqljdbc_6.0.7728.100_enu.exe** to download
4.	Execute **sqljdbc_6.0.7728.100_enu.exe**, it will unzip a folder in the current directory
5.	Copy the unzipped folder to **C:/Program Files/**

Then you have to specify it in MATLAB:

1.	Run MATLAB
2.	Execute _prefdir_ in the console, output should be a path
3.	Copy the path, quit MATLAB, and visit the path
4.	Create a file called **javaclasspath.txt** in the folder, open **javaclasspath.txt** and insert the path to the driver JAR file. The entry should include the full path to the driver including the driver file name. For example in our case, **C:\Program Files\Microsoft JDBC Driver 6.0 for SQL Server\sqljdbc_6.0\enu\sqljdbc41.jar** 
5.	Save and close the **javaclasspath.txt**
6.	Restart MATLAB

## Done
Then you can use the script to download data.


