%% MATLAB program to create stripes colormap of GDP pc in PPP international USD of 2017, CO2 pc and GPR pc for 1st Subsample
% File name: GDPpcCO2pcStripes1stSmpl3Groups9CountriesMinMaxWorld_am231204.m
% AM230630 in R2017a 1st trial -> and success! -> based on:
% http://mres.uni-potsdam.de/index.php/2022/11/16/ed-hawkins-warming-stripes-with-matlab/
% AM230701 in R2023a minor edits and development
% AM230709 in R2023a further minor edits and development
% AM230720 in R2023a major development and addition of CO2 emissions and a brown-to-green colormap
% AM230720 in R2023a further improvenets and addition of greening prosperity ratio stripes
% AM231005 in R2023a switching to GDP pc in PPP inernational USD of 2017 and addition of greening prosperity ratio stripes
% AM231006 in R2023a adding together World, HiIncCs, LoIncCs, US, EU, China
% AM231007 in R2023a trying (again) to fix the stripe colormaps in multiplots -> unsuccessful again (see the figure at the bottom of the code), but just fixed it otherwise in Overleaf/Beamer! 
% AM231021 in R2023a scaling colours from Min to Max in the World from 1990 to 2020 (1989/2021 is not year but the min/max value in the data vector; 2020 is the last year for CO2 emissions)
% AM231117 in R2023a minor renaming of titles in graphs plus a run with the updated file name and log file mentioning the 1st subsample
% AM231204 in R2023a final checks and minor edits

%% Acknowledgement

% "NOVEMBER 16, 2022 BY MARTIN H. TRAUTH
% Ed Hawkins? Warming Stripes with MATLAB"

% "Ed Hawkins, climatologist at U Reading, published a visualization graphics for climate data to display global warming.
% Here's a script to display the warming stripes with MATLAB. To display the popular warming stripes, Python scripts and
% R scripts exist, but I was not able to find a MATLAB script, inspired by a discussion on Twitter. In following script
% I used the HadCRUT.4.6.0.0 dataset by the Met Office Hadley Centre. The hex colormap was taken from the Python script
% and converted to RGB colors using a script by Jos van der Geest published on the MathWorks File Exchange."

%% Housekeeping

% Clear the Workspace and the Command Window and close all Figure Windows (respectively,the 3 commands in the next line).
clear; clc; close all

diary GDPpcCO2pcStripes1stSmpl3Groups9CountriesMinMaxWorld_am231204.txt % create a diary log (*.txt) file saving the output from the command window
tic                          % start stopwatch timer
t = datetime('now')          % return a datetime scalar representing the current date and time

%% World - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcWorldPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI264:BM264');
dataMinMaxW_GDPpcWorldPPPIntlUSDof2017 = [436.4 6800.827689	6779.81476	6807.327101	6825.268922	6946.092092	7054.240881	7197.880114	7371.052499	7472.881906	7633.006287	7871.167778	7923.580841	8001.098037	8145.033804	8402.121903	8629.561679	8899.215642	9174.687111	9249.207579	9013.614067	9309.046328	9503.641584	9641.619886	9791.488294	9970.739832	10156.95346	10321.1368	10549.82166	10777.87045	10941.96449	10499.64711 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcWorldMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI264:BM264');
dataMinMaxW_CO2pcWorldMetricTons = [0.001 4.020867687	3.983342889	3.910310291	3.87498525	3.842027309	3.893876264	3.919585121	3.935278691	3.907460918	3.881441811	3.951660425	3.958088692	3.961470273	4.090081614	4.223794234	4.329790027	4.417134594	4.528065637	4.503617262	4.39133164	4.604834238	4.68950194	4.685310416	4.719386053	4.681813043	4.600796551	4.557519663	4.577306263	4.641293735	4.582035579	4.291853096 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017 = dataMinMaxW_GDPpcWorldPPPIntlUSDof2017 ./ dataMinMaxW_CO2pcWorldMetricTons;
dataMinMaxW_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017 = [1000 2413.90217781374	2427.52816675141	2471.89852982368	2496.84363545003	2550.67550999375	2557.13639073253	2597.10276207660	2648.88798888902	2695.47360497521	2770.85058258023	2812.65119993753	2835.12164171350	2871.25783687935	2847.11273538804	2860.35477346594	2880.21176394222	2929.91744681570	2967.48499812164	3026.77089901039	3044.28833139282	3013.66447597032	3036.95225809868	3098.22748504370	3136.28340780250	3229.67409926315	3356.58963426798	3458.46852628094	3532.68775259456	3570.98550558720	3680.65552638178	3775.56471412619 120000] 
ticksGreenProsppcWorldGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the Colormaps (16 colours, as per their RGB 3-vector code for each color below)

% The colors below are from the Python script cited above, converted with Jos van der Geest's MATLAB code to RGB colors,
% and then stored in the variable wscolors (next).

wscolors_EHWarming_BlueToRed = [
   0.0314 0.1882 0.4196
   0.0314 0.3176 0.6118
   0.1294 0.4431 0.7098
   0.2588 0.5725 0.7765
   0.4196 0.6824 0.8392
   0.6196 0.7922 0.8824
   0.7765 0.8588 0.9373
   0.8706 0.9216 0.9686
   0.9961 0.8784 0.8235
   0.9882 0.7333 0.6314
   0.9882 0.5725 0.4471
   0.9843 0.4157 0.2902
   0.9373 0.2314 0.1725
   0.7961 0.0941 0.1137
   0.6471 0.0588 0.0824
   0.4039 0 0.0510
];

%AM230720 The colors below were chosen by me for the greening prosperity stripes

wscolors_AMGreening_BrownToGreen = [
140/255 70/255 20/255
170/255 90/255 40/255
200/255 110/255 60/255
210/255 130/255 80/255
220/255 150/255 100/255
230/255 170/255 140/255
240/255 200/255 200/255
253/255 245/255 230/255 %AM230725 Note that I chose all 3 R, G and B in the RGB triplet to increase gradually (top-down) for the Brown nuances as they get lighter
240/255 255/255 220/255
195/255 250/255 160/255
170/255 240/255 150/255
140/255 225/255 140/255
120/255 210/255 120/255
60/255 170/255 100/255
30/255 135/255 50/255
0/255 100/255 0/255     %AM230725 Note that I chose all 3 R, G and B in the RGB triplet to increase gradually (bottom-up) for the Green nuances as they get lighter
];

%AM231005 I had to reverse the above scale to capture the CO2 emisiions dynamics/time series trend!

wscolors_AMGreening_GreenToBrown = [
0/255 100/255 0/255
30/255 135/255 50/255
60/255 170/255 100/255
120/255 210/255 120/255
140/255 225/255 140/255
170/255 240/255 150/255
195/255 250/255 160/255
240/255 255/255 220/255
253/255 245/255 230/255
240/255 200/255 200/255
230/255 170/255 140/255
220/255 150/255 100/255
210/255 130/255 80/255
200/255 110/255 60/255
170/255 90/255 40/255
140/255 70/255 20/255
];

%% Creating the World GDP pc (min-max) Figure

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig1 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcWorldPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average World GDP per capita in PPP International USD of 2017 for 1990-1990');
title('World (min - max scale)'); % (within a min-max scale across all countries in the world over 1990-2020)

saveas(gcf,'MinMaxWGDPWpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPWpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPWpcPPPIntlUSDof2017Abs.epsc')

GDPWpcDev = imread('MinMaxWGDPWpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Creating the World CO2 pc (min-max) Figure

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig2 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcWorldMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average World CO2 Emissions per capita for 1990-2020');
title('World (min - max scale)');

saveas(gcf,'MinMaxWCO2WpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2WpcAbs.png')
saveas(gcf,'MinMaxWCO2WpcAbs.epsc')

CO2WpcAbs = imread('MinMaxWCO2WpcAbs.png'); %AM230701 checking online

%% Creating the World Greening Prosperity (Ratio) (min-max) Figure

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig3 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProsppcWorldGDPMinMaxW) max(ticksGreenProsppcWorldGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProsppcWorldGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProsppcWorldGDPMinMaxW',...
   'YData',[2000 2040],...c
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average World Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('World (min - max scale)');

saveas(gcf,'MinMaxWGreenProsppcDefGDPpcPPPUSD2017WorldAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProsppcDefGDPpcPPPUSD2017WorldAbs.png')
saveas(gcf,'MinMaxWGreenProsppcDefGDPpcPPPUSD2017WorldAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017WAbs = imread('MinMaxWGreenProsppcDefGDPpcPPPUSD2017WorldAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% High Income Countries - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcHiIncCsPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI100:BM100');
dataMinMaxW_GDPpcHiIncCsPPPIntlUSDof2017 = [436.4 31817.69427	32045.42473	32464.66383	32642.29035	33483.1534	34238.63235	35037.82256	36004.19975	36759.87929	37750.48143	39093.46598	39443.27185	39818.66448	40490.70555	41669.43629	42620.28215	43677.10284	44568.65983	44526.80385	42754.71894	43802.72071	44557.80987	44926.71699	45330.9998	46039.40881	46892.69383	47511.50073	48418.7849	49343.0418	50002.95378	47649.70964	50221.81629	51568.32717 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcHiIncCsMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI100:BM100');
dataMinMaxW_CO2pcHiIncCsMetricTons = [0.001 11.1252523	11.03049837	10.97310715	10.96611416	11.06401825	11.14769664	11.41460638	11.56051486	11.47696337	11.47643078	11.66637182	11.65447061	11.51069588	11.64337244	11.69439338	11.65974318	11.52413834	11.57371478	11.24712482	10.53146025	10.91708531	10.68510677	10.50475166	10.52009327	10.29448482	10.20324715	10.06764523	9.955483166	9.923913509	9.597237018	8.749912818 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017 = data_GDPpcHiIncCsPPPIntlUSDof2017 ./ data_CO2pcHiIncCsMetricTons;
dataMinMaxW_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017 = [1000 2859.95260294393	2905.16562802864	2958.56619190078	2976.65060418566	3026.31039118221	3071.36383957841	3069.56029712648	3114.41144134788	3202.92729894537	3289.39216014711	3350.95320058914	3384.38983260383	3459.27517178227	3477.57539890294	3563.19775941202	3655.33627132902	3790.05367177274	3850.85174982058	3958.94991475161	4059.71422170604	4012.30909680980	4170.08559735614	4276.79953392655	4308.99219584020	4472.24019381564	4595.85984233231	4719.22675692831	4863.52938334347	4972.13541318912	5210.14055284557	5445.73536109541  120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the HiIncCs GDP pc (min-max) Figure

fig4 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcHiIncCsPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average High-Income Countries GDP per capita in PPP International USD of 2017 for 1990-1990');
title('High-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWGDPHiIncCspcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPHiIncCspcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPHiIncCspcPPPIntlUSDof2017Abs.epsc')

GDPHiIncCspcDev = imread('MinMaxWGDPHiIncCspcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the HiIncCs CO2 pc (min-max) Figure

fig5 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcHiIncCsMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average CO2 Emissions in the High-Income Countries per capita for 1990-2020');
title('High-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWCO2HiIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2HiIncCspcAbs.png')
saveas(gcf,'MinMaxWCO2HiIncCspcAbs.epsc')

CO2HiIncCspcAbs = imread('MinMaxWCO2HiIncCspcAbs.png'); %AM230701 checking online

%% Creating the HiIncCs Greening Prosperity (Ratio) (min-max) Figure

fig6 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average High-Income Countries Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('High-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017HiIncCsAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017HiIncCsAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017HiIncCsAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017HiIncCsAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017HiIncCsAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Low Income Countries - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcLoIncCsPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI141:BM141');
dataMinMaxW_GDPpcLoIncCsPPPIntlUSDof2017 = [436.4 1336.656403	1308.475379	1248.239201	1218.869143	1183.145889	1205.763045	1236.823635	1291.996938	1293.455361	1299.205849	1303.844618	1342.146661	1355.878284	1383.253233	1430.444216	1486.232075	1540.4594	1600.104046	1649.611756	1661.30829	1729.69621	1740.383466	1703.098071	1749.998653	1813.79617	1853.999174	1890.792441	1918.39019	1937.142124	1966.980512	1927.798714 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcLoIncCsMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI141:BM141');
dataMinMaxW_CO2pcLoIncCsMetricTons = [0.001 0.626465514	0.599313228	0.534052136	0.491581987	0.468643022	0.449148841	0.420962498	0.407171114	0.39290741	0.40190074	0.410214094	0.413610087	0.398616685	0.404331892	0.406657336	0.436296835	0.443459199	0.420897294	0.437424209	0.395185578	0.384135323	0.346183894	0.315319967	0.280144624	0.282727023	0.248470821	0.249647648	0.291585253	0.290268283	0.294710864	0.26934105 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017 = data_GDPpcLoIncCsPPPIntlUSDof2017 ./ data_CO2pcLoIncCsMetricTons;
dataMinMaxW_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017 = [1000 2133.64721967645	2183.29133915169	2337.29839832846	2479.48292230811	2524.62073132851	2684.55116732930	2938.08508163382	3173.10559405962	3292.01060591379	3232.65354005083	3178.44910273555	3244.95630479393	3401.45893160810	3421.08367421044	3517.56648361006	3406.46999017456	3473.73423283891	3801.64964083538	3771.19446648294	4203.86872212364	4502.83040529687	5027.33806345416	5401.17420896893	6246.76865178996	6415.36189778446	7461.63742626181	7573.84439022305	6579.17425388117	6673.62656927392	6674.27214284179	7157.46341924867  120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the LoIncCs GDP pc (min-max) Figure

fig7 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcLoIncCsPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average Low-Income Countries GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Low-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWGDPLoIncCspcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPLoIncCspcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPLoIncCspcPPPIntlUSDof2017Abs.epsc')

GDPLoIncCspcDev = imread('MinMaxWGDPLoIncCspcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the LoIncCs CO2 pc (min-max) Figure

fig8 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcLoIncCsMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average CO2 Emissions in the Low-Income Countries per capita for 1990-2020');
title('Low-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWCO2LoIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2LoIncCspcAbs.png')
saveas(gcf,'MinMaxWCO2LoIncCspcAbs.epsc')

CO2LoIncCspcAbs = imread('MinMaxWCO2LoIncCspcAbs.png'); %AM230701 checking online

%% Creating the LoIncCs Greening Prosperity (Ratio) (min-max) Figure

fig9 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average Low-Income Countries Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Low-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017LoIncCsAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017LoIncCsAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017LoIncCsAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017LoIncCsAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017LoIncCsAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% US - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcUSPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI256:BM256');
dataMinMaxW_GDPpcUSPPPIntlUSDof2017 = [436.4 40451.4984	39871.34296	40707.29063	41279.5165	42419.19537	43042.21382	44149.37113	45560.92014	47050.99508	48743.88284	50169.85636	50149.82869	50529.34958	51497.73469	52989.03069	54331.65834	55307.71915	55885.64617	55427.17827	53514.9318	54510.46562	54954.46391	55796.97192	56432.32777	57301.60042	58420.70304	58965.98749	59907.75426	61348.4566	62470.92991	60158.91045 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcUSMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI256:BM256');
dataMinMaxW_CO2pcUSMetricTons = [0.001 19.40733586	19.00338958	19.02284515	19.21833148	19.25618525	19.216897	19.57536656	20.33085305	20.26628688	20.10112278	20.46979674	20.17153693	19.44553028	19.50650553	19.59761671	19.46927252	18.94591684	19.04291178	18.27849126	16.80868142	17.43173699	16.60418962	15.78976015	16.11117526	16.04091676	15.56001544	15.14988272	14.82324544	15.2225181	14.67338071	13.03282795 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017 = data_GDPpcUSPPPIntlUSDof2017 ./ data_CO2pcUSMetricTons;
dataMinMaxW_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017 = [1000  2084.34061694373	2098.11743271938	2139.91599660097	2147.92405595343	2202.88675119630	2239.81081944611	2255.35348140751	2240.97434736031	2321.63865881358	2424.93334202856	2450.92108176665	2486.16795353576	2598.50715573802	2640.02871264932	2703.85075320581	2790.63628501830	2919.24215706856	2934.72168660437	3032.37162641525	3183.76739116913	3127.08169342555	3309.67455697757	3533.74410898845	3502.68225896824	3572.21481122396	3754.54017073857	3892.17451771810	4041.47354368315	4030.11224513180	4257.43263483789	4615.95216897231 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the US GDP pc (min-max) Figure

fig10 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcUSPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('US GDP per capita in PPP International USD of 2017 for 1990-1990');
title('US (min-max scale)');

saveas(gcf,'MinMaxWGDPUSpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPUSpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPUSpcPPPIntlUSDof2017Abs.epsc')

GDPUSpcDev = imread('MinMaxWGDPUSpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the US CO2 pc (min-max) Figure

fig11 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcUSMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the US per capita for 1990-2020');
title('US (min-max scale)');

saveas(gcf,'MinMaxWCO2USpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2USpcAbs.png')
saveas(gcf,'MinMaxWCO2USpcAbs.epsc')

CO2USpcAbs = imread('MinMaxWCO2USpcAbs.png'); %AM230701 checking online

%% Creating the US Greening Prosperity (Ratio) (min-max) Figure

fig12 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('US Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('US (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017USAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017USAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017USAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017USAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017USAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mozambique - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcMOZPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI170:BM170');
dataMinMaxW_GDPpcMOZPPPIntlUSDof2017 = [436.4 460.1236967	473.6120038	436.3764156	469.3978174	476.3707587	465.8332957	502.4025415	544.2140759	584.0687207	636.7917411	628.6932794	687.193474	731.9895084	762.2861825	801.4271276	832.8388607	890.4529568	934.7363488	977.1908774	1011.561291	1047.591431	1092.773245	1137.284815	1179.670024	1228.656835	1271.961873	1279.920506	1287.234867	1292.897654	1285.18276	1233.424996	1226.766964	1243.073638 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcMOZMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI170:BM170');
dataMinMaxW_CO2pcMOZMetricTons = [0.001 0.083980414	0.069027205	0.079423135	0.090704629	0.073552561	0.075194151	0.072248277	0.077937387	0.073371488	0.071159742	0.080305012	0.077466769	0.084028058	0.0992664	0.096981829	0.084562385	0.089747377	0.104823601	0.102478438	0.111170736	0.116175443	0.138646533	0.148679265	0.16436497	0.185235794	0.204084856	0.261542138	0.25069794	0.233657168	0.248639659	0.222767553 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017 = data_GDPpcMOZPPPIntlUSDof2017 ./ data_CO2pcMOZMetricTons;
dataMinMaxW_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017 = [1000 5478.94053482059	6861.23691647719	5494.32375841415	5175.01501376842	6476.60329843425	6195.07355666801	6953.83422218481	6982.70875807703	7960.43171690524	8948.76399762830	7828.81749114796	8870.81624264707	8711.25108647736	7679.19639849365	8263.68337009038	9848.80999242605	9921.77135071913	8917.23182096775	9535.57541965620	9099.16880409759	9017.32242820459	7881.72065753486	7649.24965375912	7177.13772290079	6632.93422535381	6232.51473341994	4893.74490578214	5134.60488890466	5533.31047575157	5168.85667819211	5536.82518357032  120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the MOZ GDP pc (min-max) Figure

fig13 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcMOZPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Mozambique GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Mozambique (min-max scale)');

saveas(gcf,'MinMaxWGDPMOZpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPMOZpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPMOZpcPPPIntlUSDof2017Abs.epsc')

GDPMOZpcDev = imread('MinMaxWGDPMOZpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the MOZ CO2 pc (min-max) Figure

fig14 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcMOZMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Mozambique per capita for 1990-2020');
title('Mozambique (min-max scale)');

saveas(gcf,'MinMaxWCO2MOZpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2MOZpcAbs.png')
saveas(gcf,'MinMaxWCO2MOZpcAbs.epsc')

CO2MOZpcAbs = imread('MinMaxWCO2MOZpcAbs.png'); %AM230701 checking online

%% Creating the MOZ Greening Prosperity (Ratio) (min-max) Figure

fig15 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Mozambique Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Mozambique (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017MOZAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017MOZAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017MOZAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017MOZAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017MOZAbs.png'); %AM230701 after checking online


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% United Kingdom - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcUKPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI86:BM86');
dataMinMaxW_GDPpcUKPPPIntlUSDof2017 = [436.4 31308.14087	30867.17014	30907.27679	31600.963	32732.89922	33472.91924	34024.74104	35472.56464	36486.05777	37460.66876	38854.72752	39540.47565	40070.65117	41130.11367	41855.78876	42678.59814	43281.31798	44046.50347	43633.75339	41351.69289	42025.8388	42143.86385	42458.03736	42942.14941	43990.99672	44688.24495	45311.13153	46104.0554	46606.87727	47088.20553	41741.02145	44949.09304	46831.08543 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcUKMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI86:BM86');
dataMinMaxW_CO2pcUKMetricTons = [0.001 9.813068799	9.937877642	9.688810439	9.379580736	9.248704912	9.079920847	9.377801312	8.98865877	8.993440114	8.908156654	9.014527721	9.223024627	8.940232738	9.104093197	9.053089952	8.955400659	8.908613466	8.651030537	8.337820015	7.490694289	7.689567494	7.04484324	7.344260926	7.076100428	6.433347	6.159376361	5.824502691	5.553291497	5.425128404	5.175842473	4.601142251 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017 = data_GDPpcUKPPPIntlUSDof2017 ./ data_CO2pcUKMetricTons;
dataMinMaxW_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017 = [1000  3190.45362015949	3106.01229519531	3189.99705735436	3369.12319259335	3539.18732767009	3686.47698652000	3628.22157503054	3946.36903533180	4056.96344344960	4205.20992274937	4310.23440425205	4287.14844067449	4482.05906392293	4517.76061332039	4623.37047149705	4765.68271634377	4858.36748280286	5091.47474169543	5233.23282411725	5520.40856229796	5465.30592763211	5982.22876163321	5781.11777212225	6068.61785633591	6837.96423934692	7255.31974943902	7779.39919214576	8302.11333587758	8590.92611194667	9097.68907686885	9071.88240873794 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the UK GDP pc (min-max) Figure

fig16 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcUKPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('UK GDP per capita in PPP International USD of 2017 for 1990-1990');
title('UK (min-max scale)');

saveas(gcf,'MinMaxWGDPUKpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPUKpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPUKpcPPPIntlUSDof2017Abs.epsc')

GDPUKpcDev = imread('MinMaxWGDPUKpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the UK CO2 pc (min-max) Figure

fig17 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcUKMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the UK per capita for 1990-2020');
title('UK (min-max scale)');

saveas(gcf,'MinMaxWCO2UKpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2UKpcAbs.png')
saveas(gcf,'MinMaxWCO2UKpcAbs.epsc')

CO2UKpcAbs = imread('MinMaxWCO2UKpcAbs.png'); %AM230701 checking online

%% Creating the UK Greening Prosperity (Ratio) (min-max) Figure

fig18 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('UK Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('UK (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017UKAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017UKAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017UKAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017UKAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017UKAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% China - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcCHNPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI45:BM45');
dataMinMaxW_GDPpcCHNPPPIntlUSDof2017 = [436.4 1423.896348	1534.705272	1731.657215	1949.534268	2178.924057	2391.477116	2601.363426	2812.711135	3004.427342	3206.730026	3451.679231	3712.338132	4024.355697	4400.825183	4817.211845	5334.646639	5979.781712	6795.174012	7412.874363	8069.354638	8884.588031	9680.0977	10370.72657	11101.93893	11851.40422	12612.35165	13399.13732	14243.53261	15133.99562	15977.76383	16296.60938	17657.49518	18187.97874 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcCHNMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI45:BM45');
dataMinMaxW_CO2pcCHNMetricTons = [0.001 1.914546263	2.000543284	2.075740405	2.244842079	2.322189229	2.563478759	2.521871874	2.547903664	2.605835732	2.517420763	2.650409102	2.774762197	2.964821228	3.434036479	3.945154871	4.467696361	4.910276197	5.306368006	5.435079096	5.798319938	6.335419767	6.901347326	7.04520023	7.320154925	7.304712872	7.145131535	7.105479936	7.226160154	7.533193134	7.645435786	7.756137907 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017 = data_GDPpcCHNPPPIntlUSDof2017 ./ data_CO2pcCHNMetricTons;
dataMinMaxW_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017 = [1000 743.725223641273	767.144247298237	834.235924225712	868.450518706218	938.305987018259	932.903035505438	1031.52085284477	1103.93150804043	1152.96114198086	1273.81567371191	1302.31941511875	1337.89415778478	1357.36875430474	1281.53128537519	1221.04505437851	1194.04861210636	1217.80964485959	1280.56968613852	1363.89447742479	1391.67116084540	1402.36769738457	1402.63882442219	1472.02722882670	1516.62622494914	1622.43258919812	1765.16717562356	1885.74697859687	1971.10668826539	2008.97485965921	2089.84344072061	2101.12424188658 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the CHN GDP pc (min-max) Figure

fig19 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcCHNPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('China GDP per capita in PPP International USD of 2017 for 1990-1990');
title('China (min-max scale)');

saveas(gcf,'MinMaxWGDPCHNpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPCHNpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPCHNpcPPPIntlUSDof2017Abs.epsc')

GDPCHNpcDev = imread('MinMaxWGDPCHNpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the CHN CO2 pc (min-max) Figure

fig20 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcCHNMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in China per capita for 1990-2020');
title('China (min-max scale)');

saveas(gcf,'MinMaxWCO2CHNpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2CHNpcAbs.png')
saveas(gcf,'MinMaxWCO2CHNpcAbs.epsc')

CO2CHNpcAbs = imread('MinMaxWCO2CHNpcAbs.png'); %AM230701 checking online

%% Creating the CHN Greening Prosperity (Ratio) (min-max) Figure

fig21 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('China Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('China (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017CHNAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017CHNAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017CHNAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017CHNAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017CHNAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Brazil - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcBRAPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI34:BM34');
dataMinMaxW_GDPpcBRAPPPIntlUSDof2017 = [436.4 10401.84244	10328.95712	10103.78794	10431.40966	10867.75092	11151.19164	11224.39946	11432.65057	11304.097	11196.83853	11529.48662	11536.36383	11739.43184	11733.4112	12268.66383	12520.85499	12877.44418	13518.84778	14067.94581	13916.96323	14824.74115	15271.46935	15425.35293	15751.48445	15695.6431	15011.57719	14402.49401	14477.86177	14619.59113	14685.12789	14109.76397	14735.58178	15093.46512 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcBRAMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI34:BM34');
dataMinMaxW_CO2pcBRAMetricTons = [0.001 1.313131623	1.340029763	1.333318452	1.358610901	1.382139692	1.475603559	1.5804544	1.669181232	1.698944884	1.734769448	1.783500116	1.792112278	1.760651244	1.701852536	1.778441244	1.775662922	1.777477957	1.847975736	1.939215274	1.799328142	2.026605669	2.11062776	2.271417684	2.413446537	2.51459196	2.365360621	2.161259847	2.185486619	2.064261479	2.050770129	1.942523356 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017 = data_GDPpcBRAPPPIntlUSDof2017 ./ data_CO2pcBRAMetricTons;
dataMinMaxW_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017 = [1000 7921.40122465222	7708.00575483889	7577.92553388950	7677.99643671026	7862.99024546947	7557.03764181301	7102.00778819613	6849.25660037584	6653.59841901885	6454.36691442156	6464.52809983961	6437.29970196909	6667.66452576481	6894.49346874827	6898.54886798525	7051.36928380847	7244.78418167139	7315.48987101188	7254.45287138510	7734.53318590565	7315.05955093209	7235.51051594231	6791.06843279362	6526.55205191408	6241.82505795550	6346.42221617240	6663.93447552168	6624.54834753077	7082.23802064083	7160.78690928033	7263.62641827486 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the BRA GDP pc (min-max) Figure

fig22 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcBRAPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Brazil GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Brazil (min-max scale)');

saveas(gcf,'MinMaxWGDPBRApcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPBRApcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPBRApcPPPIntlUSDof2017Abs.epsc')

GDPBRApcDev = imread('MinMaxWGDPBRApcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the BRA CO2 pc (min-max) Figure

fig23 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcBRAMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Brazil per capita for 1990-2020');
title('Brazil (min-max scale)');

saveas(gcf,'MinMaxWCO2BRApcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2BRApcAbs.png')
saveas(gcf,'MinMaxWCO2BRApcAbs.epsc')

CO2BRApcAbs = imread('MinMaxWCO2BRApcAbs.png'); %AM230701 checking online

%% Creating the BRA Greening Prosperity (Ratio) (min-max) Figure

fig24 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Brazil Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Brazil (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017BRAAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017BRAAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017BRAAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017BRAAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017BRAAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Australia - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcAUSPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI18:BM18');
dataMinMaxW_GDPpcAUSPPPIntlUSDof2017 = [436.4 31006.10023	30496.12645	30285.85382	31232.58548	32164.65884	33044.8445	33905.26294	34852.75174	36099.02291	37475.97876	38494.88668	38779.6	39872.14753	40642.56228	41905.84966	42704.44247	43286.72354	44109.66937	44777.27372	44684.40149	44965.39336	45405.36537	46360.60712	46744.62388	47240.27446	47567.68066	48109.20272	48400.24579	49052.81795	49379.09333	48747.85171 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcAUSMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI18:BM18');
dataMinMaxW_CO2pcAUSMetricTons = [0.001 15.43718277	15.31527127	15.35397358	15.48170527	15.7309148	16.11460158	16.47101442	16.70617608	17.60233354	17.73724311	17.8373184	17.93072692	18.12321078	17.89453913	18.36887105	18.27847309	18.29274959	18.45473766	18.23928987	18.15720084	17.97375152	17.65605534	17.40561767	16.7945881	16.15574514	16.19845822	16.32033061	16.14809051	15.86356243	15.59572675	14.7726576 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017 = data_GDPpcAUSPPPIntlUSDof2017 ./ data_CO2pcAUSMetricTons;
dataMinMaxW_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017 = [1000 2008.53359581865	1991.22339450506	1972.50917912484	2017.38664608344	2044.67821828873	2050.61504763389	2058.48055780320	2086.21958578856	2050.80893519906	2112.84124194565	2158.10952174238	2162.74555872824	2200.05980250948	2271.22710340892	2281.35139941937	2336.32438951988	2366.33226259274	2390.15423559345	2454.98997199024	2460.97412789808	2501.72554794979	2571.65966551542	2663.54277196681	2783.31469715342	2924.05420208012	2936.55606057049	2947.80809681337	2997.27362485751	3092.16912389072	3166.19380039433	3299.87014102753 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the AUS GDP pc (min-max) Figure

fig25 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcAUSPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Australia GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Australia (min-max scale)');

saveas(gcf,'MinMaxWGDPAUSpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPAUSpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPAUSpcPPPIntlUSDof2017Abs.epsc')

GDPAUSpcDev = imread('MinMaxWGDPAUSpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the AUS CO2 pc (min-max) Figure

fig26 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcAUSMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Australia per capita for 1990-2020');
title('Australia (min-max scale)');

saveas(gcf,'MinMaxWCO2AUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2AUSpcAbs.png')
saveas(gcf,'MinMaxWCO2AUSpcAbs.epsc')

CO2AUSpcAbs = imread('MinMaxWCO2AUSpcAbs.png'); %AM230701 checking online

%% Creating the AUS Greening Prosperity (Ratio) (min-max) Figure

fig27 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Australia Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Australia (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017AUSAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017AUSAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017AUSAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017AUSAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017AUSAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% European Union - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcEUPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI78:BM78');
dataMinMaxW_GDPpcEUPPPIntlUSDof2017 = [436.4 28536.04434	28839.0116	29039.76279	28799.27558	29494.64743	30261.90244	30823.10421	31566.57308	32460.89774	33332.5218	34592.55249	35329.22119	35693.179	35954.88461	36812.79035	37445.98833	38691.53576	39847.2353	40067.34357	38263.4688	38992.56411	39794.87943	39457.85121	39320.95874	39882.19328	40746.41958	41485.78146	42663.20205	43553.67769	44369.81778	41814.82055	44185.78849	45712.87665 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcEUMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI78:BM78');
dataMinMaxW_CO2pcEUMetricTons = [0.001 8.488759509	8.371310572	8.072299028	7.896552457	7.851660339	7.956722528	8.17727225	8.003704002	7.972270112	7.823898486	7.835380431	7.957609932	7.920361392	8.099947134	8.079665765	8.011893369	8.005532581	7.883685225	7.680030926	7.10127533	7.282944399	7.081677864	6.93467872	6.744305756	6.402090419	6.517123396	6.525933461	6.571146878	6.415939469	6.101852107	5.506070436 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017 = data_GDPpcEUPPPIntlUSDof2017 ./ data_CO2pcEUMetricTons;
dataMinMaxW_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017 = [1000 3361.62713834318	3444.98168461826	3597.45875252066	3647.06949452988	3756.48539999996	3803.31252437393	3769.36260310236	3943.99556442327	4071.72577945885	4260.34691751824	4414.91677400515	4439.67742717100	4506.50888693317	4438.90361449839	4556.22688106478	4673.80013727101	4833.09953137440	5054.39196992432	5217.08101876508	5388.25309803200	5353.95603348003	5619.41395751960	5689.93212195576	5830.24556739830	6229.55795141134	6252.20931197618	6357.06473295973	6492.50470942983	6788.35545454434	7271.53280646714	7594.31268354284 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the EU GDP pc (min-max) Figure

fig28 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcEUPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('EU GDP per capita in PPP International USD of 2017 for 1990-1990');
title(['EU (min-max scale)']);

saveas(gcf,'MinMaxWGDPEUpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPEUpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPEUpcPPPIntlUSDof2017Abs.epsc')

GDPEUpcDev = imread('MinMaxWGDPEUpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the EU CO2 pc (min-max) Figure

fig29 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcEUMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the EU per capita for 1990-2020');
title('EU (min-max scale)');

saveas(gcf,'MinMaxWCO2EUpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2EUpcAbs.png')
saveas(gcf,'MinMaxWCO2EUpcAbs.epsc')

CO2EUpcAbs = imread('MinMaxWCO2EUpcAbs.png'); %AM230701 checking online

%% Creating the EU Greening Prosperity (Ratio) (min-max) Figure

fig30 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('EU Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('EU (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017EUAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017EUAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017EUAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017EUAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017EUAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% India - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcINDPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI114:BM114');
dataMinMaxW_GDPpcINDPPPIntlUSDof2017 = [436.4 1819.021597	1800.010902	1859.714851	1908.578224	1994.943942	2103.727155	2218.824342	2264.795571	2359.892551	2521.576658	2571.149656	2646.878224	2699.178102	2861.574708	3037.063815	3225.54433	3432.819251	3642.00241	3701.395479	3937.237642	4213.362991	4374.232272	4551.862127	4780.120345	5071.047084	5411.875588	5789.678066	6112.06665	6436.153402	6617.129869	6172.042386	6677.185031	7096.338899 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcINDMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI114:BM114');
dataMinMaxW_CO2pcINDMetricTons = [0.001 0.647451316	0.683086373	0.69007405	0.703136167	0.725622135	0.76518964	0.787231756	0.817360076	0.818720963	0.866242339	0.885077949	0.883746998	0.897242649	0.905456602	0.955470157	0.984261473	1.036533922	1.123599482	1.180361247	1.278873603	1.338033835	1.396878498	1.498204123	1.5276744	1.642465277	1.631323487	1.639914019	1.704926721	1.795595299	1.752534366	1.576093232 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017 = data_GDPpcINDPPPIntlUSDof2017 ./ data_CO2pcINDMetricTons;
dataMinMaxW_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017 = [1000 2809.51100219474	2635.11464028572	2694.94969385703	2714.37925394131	2749.28760601718	2749.28860000555	2818.51478284774	2770.86639854119	2882.41373677628	2910.93675039033	2904.99798117923	2995.06332718853	3008.30339140283	3160.36649632235	3178.60666962876	3277.12139526161	3311.82528621660	3241.37067481178	3135.81582683119	3078.67613588687	3148.92111128523	3131.43360622164	3038.21225515529	3129.01776984167	3087.46075431351	3317.47543076621	3530.47659787721	3584.94390131720	3584.41203728824	3775.74899306631	3916.03888742446 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the IND GDP pc (min-max) Figure

fig31 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcINDPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('India GDP per capita in PPP International USD of 2017 for 1990-1990');
title('India (min-max scale)');

saveas(gcf,'MinMaxWGDPINDpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPINDpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPINDpcPPPIntlUSDof2017Abs.epsc')

GDPINDpcDev = imread('MinMaxWGDPINDpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the IND CO2 pc (min-max) Figure

fig32 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcINDMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in India per capita for 1990-2020');
title('India (min-max scale)');

saveas(gcf,'MinMaxWCO2INDpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2INDpcAbs.png')
saveas(gcf,'MinMaxWCO2INDpcAbs.epsc')

CO2INDpcAbs = imread('MinMaxWCO2INDpcAbs.png'); %AM230701 checking online

%% Creating the IND Greening Prosperity (Ratio) (min-max) Figure

fig33 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('India Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('India (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017INDAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017INDAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017INDAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017INDAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017INDAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Japan - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcJPNPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI124:BM124');
dataMinMaxW_GDPpcJPNPPPIntlUSDof2017 = [436.4 32846.38961	33870.37404	34048.78455	33782.73545	34053.52423	34867.58039	35878.78947	36144.61755	35588.62512	35405.08013	36323.0953	36375.58642	36306.3302	36784.88103	37576.38989	38250.63801	38751.005	39280.8949	38781.19873	36577.8634	38069.95604	38149.61811	38735.89635	39569.63657	39739.54112	40402.58151	40727.96888	41444.21574	41763.82047	41654.32792	39989.57861 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcJPNMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI124:BM124');
dataMinMaxW_CO2pcJPNMetricTons = [0.001 8.831598341	8.905499177	8.961503717	8.872832435	9.272836281	9.33264314	9.420124526	9.30217362	8.942092563	9.231189045	9.3377238	9.220202282	9.468870493	9.504764403	9.449563638	9.512764042	9.331294289	9.593603175	9.04895325	8.609230985	9.036009995	9.495009896	9.827855738	9.944495272	9.564305918	9.268049646	9.166714407	9.063691208	8.76197885	8.478400575	8.03149587 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017 = data_GDPpcJPNPPPIntlUSDof2017 ./ data_CO2pcJPNMetricTons;
dataMinMaxW_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017 = [1000 3719.18970239286	3803.30999602997	3799.44991700934	3807.43530254734	3672.39571595545	3736.08846597958	3808.73834187677	3885.60986182974	3979.89898491194	3835.37591491029	3889.93035928292	3945.20481246202	3834.28311022469	3870.15179609811	3976.52117386554	4020.98042591532	4152.80065180102	4094.48818991489	4285.71102723808	4248.67952382908	4213.13788515354	4017.85975232366	3941.43924998752	3979.04926195805	4154.98432040032	4359.34021182217	4443.02801072288	4572.55380788459	4766.48268415594	4912.99361799870	4979.09471107538 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the JPN GDP pc (min-max) Figure

fig34 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDPMinMaxW) max(ticksGDPMinMaxW)],...
   'XTickMode','manual',...
   'XTick',ticksGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',dataMinMaxW_GDPpcJPNPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Japan GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Japan (min-max scale)');

saveas(gcf,'MinMaxWGDPJPNpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPJPNpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPJPNpcPPPIntlUSDof2017Abs.epsc')

GDPJPNpcDev = imread('MinMaxWGDPJPNpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the JPN CO2 pc (min-max) Figure

fig35 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2MinMaxW) max(ticksCO2MinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2MinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2MinMaxW,...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_CO2pcJPNMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Japan per capita for 1990-2020');
title('Japan (min-max scale)');

saveas(gcf,'MinMaxWCO2JPNpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2JPNpcAbs.png')
saveas(gcf,'MinMaxWCO2JPNpcAbs.epsc')

CO2JPNpcAbs = imread('MinMaxWCO2JPNpcAbs.png'); %AM230701 checking online

%% Creating the JPN Greening Prosperity (Ratio) (min-max) Figure

fig36 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDPMinMaxW) max(ticksGreenProspGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDPMinMaxW',...
   'YData',[2000 2040],...
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Japan Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Japan (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017JPNAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017JPNAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017JPNAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017JPNAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017JPNAbs.png'); %AM230701 after checking online

%%% end of program %%%
