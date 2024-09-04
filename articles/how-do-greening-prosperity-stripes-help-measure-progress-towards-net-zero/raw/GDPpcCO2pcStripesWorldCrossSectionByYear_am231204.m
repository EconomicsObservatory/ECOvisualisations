%% MATLAB program to create stripes colormap of GDP pc in PPP international USD of 2017, CO2 pc and GPR pc for ALL countries in 4 cross-sections (1990, 2000, 2010 and 2020)
% File name: GDPpcCO2StripesWorldCrossSectionByYear_am231204.m
% AM230630 in R2017a 1st trial -> and success! -> based on:
% http://mres.uni-potsdam.de/index.php/2022/11/16/ed-hawkins-warming-stripes-with-matlab/
% AM230701 in R2023a minor edits and development
% AM230709 in R2023a further minor edits and development
% AM230720 in R2023a major development and addition of CO2 emissions and a brown-to-green colormap
% AM230720 in R2023a further improvenets and addition of greening prosperity ratio stripes
% AM231005 in R2023a switching to GDP pc in PPP inernational USD of 2017 and addition of greening prosperity ratio stripes
% AM231006 in R2023a adding together World, HiIncCs, LoIncCs, US, EU, China
% AM231007 in R2023a trying (again) to fix the stripe colormaps in multiplots -> unsuccessful again (see the figure at the bottom of the code), but just fixed it in Overleaf/Beamer!
% AM231019 in R2023a adding a cross-section representation for 1990, 2000, 2010 and 2020
% AM231117 in R2023a fixing minor name inconsistencies for the cross-section colour maps (CS) for CO2 emissions
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

diary GDPpcCO2pcStripesWorldCrossSectionByYear_am231204.txt % create a diary log (*.txt) file saving the output from the command window
tic                          % start stopwatch timer
t = datetime('now')          % return a datetime scalar representing the current date and time

%% Loading the Dataset for 1990

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
datacolumn_GDPpcCS1990PPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI5:AI270');
data_GDPpcCS1990PPPIntlUSDof2017 = transpose(datacolumn_GDPpcCS1990PPPIntlUSDof2017);
ticksGDP = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); %AM231005 Select the cross-section range, i.e., cross-section vector, to be displayed (NO earlier data)!
%ticksGDP = readtable('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','TextType','string')
%ldata_GDPpcCS1990PPPIntlUSDof2017 = log(data_GDPpcCS1990PPPIntlUSDof2017);
%dldata_GDPpcCS1990PPPIntlUSDof2017 =
%diff(ldata_GDPpcCS1990PPPIntlUSDof2017)*100;
%ticksdlGDP = xlsread;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
datacolumn_CO2pcCS1990MetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI5:AI270');
data_CO2pcCS1990MetricTons = transpose(datacolumn_CO2pcCS1990MetricTons);
ticksCO2 = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); %AM231005 Select the cross-section range, i.e., cross-section vector, to be displayed (NO earlier data again: but symmetry)!
%ldata_CO2pcWorldMetricTons = log(data_CO2pcWorldMetricTons);
%dldata_CO2pcWorldMetricTons = diff(ldata_CO2pcWorldMetricTons)*100;
%ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017 = data_GDPpcCS1990PPPIntlUSDof2017 ./ data_CO2pcCS1990MetricTons;
ticksGreenProsppc = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); % AM231005 Keep the name/label "ticks" because it is used/called below in generating the graphs!
%ldata_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017)*100;
%ticksdlGreenProsppcWorldGDP = 1991:2020;

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

%% Creating the World GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig1 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',[1 266]',...
   'YData',[2000 2040],...
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcCS1990PPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(8,"points")
%title('GDP per capita in 1990 in PPP International USD of 2017');
title('1990','FontSize',18);

saveas(gcf,'GDPCS1990pcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPCS1990pcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPCS1990pcPPPIntlUSDof2017Abs.epsc')

GDPWpcDev = imread('GDPCS1990pcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Plot - absolute level

fig2 = figure
bar(1:266, data_GDPpcCS1990PPPIntlUSDof2017,'BarWidth',0.75)
axis ([1 266 0 120000])
fontsize(8,"points")
grid on
xlabel('')
 %'XTickLabelRotation',90,...
ylabel('GDP per capita in 1990 in PPP international USD of 2017')
title('1990','FontSize',18);

saveas(gcf,'Plot_GDPpcCS1990PPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcCS1990PPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcCS1990PPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcCS1990PPPIntlUSDof2017Abs_min = min(data_GDPpcCS1990PPPIntlUSDof2017);
data_GDPpcCS1990PPPIntlUSDof2017Abs_max = max(data_GDPpcCS1990PPPIntlUSDof2017);
data_GDPpcCS1990PPPIntlUSDof2017Abs_range = data_GDPpcCS1990PPPIntlUSDof2017Abs_max - data_GDPpcCS1990PPPIntlUSDof2017Abs_min;
stripe_GDPpcCS1990PPPIntlUSDof2017Abs_range = data_GDPpcCS1990PPPIntlUSDof2017Abs_range/16;
data_GDPpcCS1990PPPIntlUSDof2017Abs_mean = mean(data_GDPpcCS1990PPPIntlUSDof2017);
data_GDPpcCS1990PPPIntlUSDof2017Abs_median = median(data_GDPpcCS1990PPPIntlUSDof2017);
%data_GDPpcCS1990PPPIntlUSDof2017Abs_mode = mode(data_GDPpcCS1990PPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GDPpcCS1990PPPIntlUSDof2017Abs_std = std(data_GDPpcCS1990PPPIntlUSDof2017);

tabGDPpcCS1990PPPIntlUSDof2017Abs = table(categorical({'data_GDPpcCS1990PPPIntlUSDof2017Abs_min';'data_GDPpcCS1990PPPIntlUSDof2017Abs_max';'data_GDPpcCS1990PPPIntlUSDof2017Abs_range';'stripe_GDPpcCS1990PPPIntlUSDof2017Abs_range';'data_GDPpcCS1990PPPIntlUSDof2017Abs_mean';'data_GDPpcCS1990PPPIntlUSDof2017Abs_median'; 'data_GDPpcCS1990PPPIntlUSDof2017Abs_std'}),{data_GDPpcCS1990PPPIntlUSDof2017Abs_min; data_GDPpcCS1990PPPIntlUSDof2017Abs_max; data_GDPpcCS1990PPPIntlUSDof2017Abs_range; stripe_GDPpcCS1990PPPIntlUSDof2017Abs_range; data_GDPpcCS1990PPPIntlUSDof2017Abs_mean; data_GDPpcCS1990PPPIntlUSDof2017Abs_median; data_GDPpcCS1990PPPIntlUSDof2017Abs_std});
writetable(tabGDPpcCS1990PPPIntlUSDof2017Abs,'tabGDPpcCS1990USDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the CS1990 CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig3 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcCS1990MetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(8,"points")
%title('Average CS1990 CO2 Emissions per capita for 1990-2020');
title('1990','FontSize',18);

saveas(gcf,'CO2pcCS1990Abs.fig') %AM230701 checking online
saveas(gcf,'CO2pcCS1990Abs.png')
saveas(gcf,'CO2pcCS1990Abs.epsc')

CO2WpcAbs = imread('CO2pcCS1990Abs.png'); %AM230701 checking online

%% Plot - absolute level

fig4 = figure
bar(1:266,data_CO2pcCS1990MetricTons,'BarWidth',0.75)
axis ([1 266 0 45])
fontsize(8,"points")
grid on
xlabel('')
ylabel('CO2 emissions pc, in metric tons')
title('1990','FontSize',18);

saveas(gcf,'Plot_CO2pcCS1990MetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcCS1990MetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcCS1990MetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcCS1990MetricTonsAbs_min = min(data_CO2pcCS1990MetricTons);
data_CO2pcCS1990MetricTonsAbs_max = max(data_CO2pcCS1990MetricTons);
data_CO2pcCS1990MetricTonsAbs_range = data_CO2pcCS1990MetricTonsAbs_max - data_CO2pcCS1990MetricTonsAbs_min;
stripe_CO2pcCS1990MetricTonsAbs_range = data_CO2pcCS1990MetricTonsAbs_range/16;
data_CO2pcCS1990MetricTonsAbs_mean = mean(data_CO2pcCS1990MetricTons);
data_CO2pcCS1990MetricTonsAbs_median = median(data_CO2pcCS1990MetricTons);
%data_CO2pcCS1990MetricTonsAbs_mode = mode(data_CO2pcCS1990MetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
data_CO2pcCS1990MetricTonsAbs_std = std(data_CO2pcCS1990MetricTons);

tabCO2pcCS1990MetricTonsAbs = table(categorical({'data_CO2pcCS1990MetricTonsAbs_min';'data_CO2pcCS1990MetricTonsAbs_max';'data_CO2pcCS1990MetricTons_range';'stripe_CO2pcCS1990MetricTonsAbs_range';'data_CO2pcCS1990MetricTonsAbs_mean';'data_CO2pcCS1990MetricTonsAbs_median'; 'data_CO2pcCS1990MetricTonsAbs_std'}),{data_CO2pcCS1990MetricTonsAbs_min; data_CO2pcCS1990MetricTonsAbs_max; data_CO2pcCS1990MetricTonsAbs_range; stripe_CO2pcCS1990MetricTonsAbs_range; data_CO2pcCS1990MetricTonsAbs_mean; data_CO2pcCS1990MetricTonsAbs_median; data_CO2pcCS1990MetricTonsAbs_std});
writetable(tabCO2pcCS1990MetricTonsAbs,'tabCO2pcCS1990MetricTonsAbs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeneingProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the World Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig5 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProsppc,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProsppc',...
   'YData',[2000 2040],...c
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(8,"points")
%xlabel('FontSize',6)
%title('Average CS1990 Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('1990','FontSize',18);

saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS1990Abs.fig') %AM230701 checking online
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS1990Abs.png')
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS1990Abs.epsc')

GreenProsppcDefGDPpcPPPUSD2017WpcAbs = imread('GreenProsppcDefGDPpcPPPUSD2017CS1990Abs.png'); %AM230701 after checking online

%% Plot - absolute level

fig6 = figure
bar(1:266,data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017,'BarWidth',0.75)
axis ([1 266 0 120000])
fontsize(8,"points")
grid on
xlabel('')
ylabel('Greening prosperity ratio pc (GDP pc / CO2 pc)')
title('1990','FontSize',18);

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS1990Abs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS1990Abs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS1990Abs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017_range';'stripe_CO2pcCS1990MetricTonsAbs_range';'data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_range; stripe_CO2pcCS1990MetricTonsAbs_range; data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs ,'tabGreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")


%% Loading the Dataset for 2000

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
datacolumn_GDPpcCS2000PPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AS5:AS270');
data_GDPpcCS2000PPPIntlUSDof2017 = transpose(datacolumn_GDPpcCS2000PPPIntlUSDof2017);
ticksGDP = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); %AM231005 Select the cross-section range, i.e., cross-section vector, to be displayed (NO earlier data)!
%ticksGDP = readtable('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','TextType','string')
%ldata_GDPpcCS2000PPPIntlUSDof2017 = log(data_GDPpcCS2000PPPIntlUSDof2017);
%dldata_GDPpcCS2000PPPIntlUSDof2017 =
%diff(ldata_GDPpcCS2000PPPIntlUSDof2017)*100;
%ticksdlGDP = xlsread;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
datacolumn_CO2pcCS2000MetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AS5:AS270');
data_CO2pcCS2000MetricTons = transpose(datacolumn_CO2pcCS2000MetricTons);
ticksCO2 = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); %AM231005 Select the cross-section range, i.e., cross-section vector, to be displayed (NO earlier data again: but symmetry)!
%ldata_CO2pcWorldMetricTons = log(data_CO2pcWorldMetricTons);
%dldata_CO2pcWorldMetricTons = diff(ldata_CO2pcWorldMetricTons)*100;
%ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017 = data_GDPpcCS2000PPPIntlUSDof2017 ./ data_CO2pcCS2000MetricTons;
ticksGreenProsppc = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); % AM231005 Keep the name/label "ticks" because it is used/called below in generating the graphs!
%ldata_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017)*100;
%ticksdlGreenProsppcWorldGDP = 1991:2020;

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

%% Creating the World GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig7 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',[1 266]',...
   'YData',[2000 2040],...
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcCS2000PPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(8,"points")
%title('GDP per capita in 2000 in PPP International USD of 2017');
title('2000','FontSize',18);

saveas(gcf,'GDPCS2000pcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPCS2000pcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPCS2000pcPPPIntlUSDof2017Abs.epsc')

GDPWpcDev = imread('GDPCS2000pcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Plot - absolute level

fig8 = figure
bar(1:266, data_GDPpcCS2000PPPIntlUSDof2017,'BarWidth',0.75)
axis ([1 266 0 120000])
fontsize(8,"points")
grid on
xlabel('')
 %'XTickLabelRotation',90,...
ylabel('GDP per capita in 2000 in PPP international USD of 2017')
title('2000','FontSize',18);

saveas(gcf,'Plot_GDPpcCS2000PPPIntlUSDof2017AbsSince2000Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcCS2000PPPIntlUSDof2017AbsSince2000Annual.png')
saveas(gcf,'Plot_GDPpcCS2000PPPIntlUSDof2017AbsSince2000Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcCS2000PPPIntlUSDof2017Abs_min = min(data_GDPpcCS2000PPPIntlUSDof2017);
data_GDPpcCS2000PPPIntlUSDof2017Abs_max = max(data_GDPpcCS2000PPPIntlUSDof2017);
data_GDPpcCS2000PPPIntlUSDof2017Abs_range = data_GDPpcCS2000PPPIntlUSDof2017Abs_max - data_GDPpcCS2000PPPIntlUSDof2017Abs_min;
stripe_GDPpcCS2000PPPIntlUSDof2017Abs_range = data_GDPpcCS2000PPPIntlUSDof2017Abs_range/16;
data_GDPpcCS2000PPPIntlUSDof2017Abs_mean = mean(data_GDPpcCS2000PPPIntlUSDof2017);
data_GDPpcCS2000PPPIntlUSDof2017Abs_median = median(data_GDPpcCS2000PPPIntlUSDof2017);
%data_GDPpcCS2000PPPIntlUSDof2017Abs_mode = mode(data_GDPpcCS2000PPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GDPpcCS2000PPPIntlUSDof2017Abs_std = std(data_GDPpcCS2000PPPIntlUSDof2017);

tabGDPpcCS2000PPPIntlUSDof2017Abs = table(categorical({'data_GDPpcCS2000PPPIntlUSDof2017Abs_min';'data_GDPpcCS2000PPPIntlUSDof2017Abs_max';'data_GDPpcCS2000PPPIntlUSDof2017Abs_range';'stripe_GDPpcCS2000PPPIntlUSDof2017Abs_range';'data_GDPpcCS2000PPPIntlUSDof2017Abs_mean';'data_GDPpcCS2000PPPIntlUSDof2017Abs_median'; 'data_GDPpcCS2000PPPIntlUSDof2017Abs_std'}),{data_GDPpcCS2000PPPIntlUSDof2017Abs_min; data_GDPpcCS2000PPPIntlUSDof2017Abs_max; data_GDPpcCS2000PPPIntlUSDof2017Abs_range; stripe_GDPpcCS2000PPPIntlUSDof2017Abs_range; data_GDPpcCS2000PPPIntlUSDof2017Abs_mean; data_GDPpcCS2000PPPIntlUSDof2017Abs_median; data_GDPpcCS2000PPPIntlUSDof2017Abs_std});
writetable(tabGDPpcCS2000PPPIntlUSDof2017Abs,'tabGDPpcCS2000USDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the CS2000 CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 2000
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig9 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcCS2000MetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(8,"points")
%title('Average CS2000 CO2 Emissions per capita for 2000-2020');
title('2000','FontSize',18);

saveas(gcf,'CO2pcCS2000Abs.fig') %AM230701 checking online
saveas(gcf,'CO2pcCS2000Abs.png')
saveas(gcf,'CO2pcCS2000Abs.epsc')

CO2WpcAbs = imread('CO2pcCS2000Abs.png'); %AM230701 checking online

%% Plot - absolute level

fig10 = figure
bar(1:266,data_CO2pcCS2000MetricTons,'BarWidth',0.75)
axis ([1 266 0 45])
fontsize(8,"points")
grid on
xlabel('')
ylabel('CO2 emissions pc, in metric tons')
title('2000','FontSize',18);

saveas(gcf,'Plot_CO2pcCS2000MetricTonsSince2000Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcCS2000MetricTonsSince2000Annual.png')
saveas(gcf,'Plot_CO2pcCS2000MetricTonsSince2000Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcCS2000MetricTonsAbs_min = min(data_CO2pcCS2000MetricTons);
data_CO2pcCS2000MetricTonsAbs_max = max(data_CO2pcCS2000MetricTons);
data_CO2pcCS2000MetricTonsAbs_range = data_CO2pcCS2000MetricTonsAbs_max - data_CO2pcCS2000MetricTonsAbs_min;
stripe_CO2pcCS2000MetricTonsAbs_range = data_CO2pcCS2000MetricTonsAbs_range/16;
data_CO2pcCS2000MetricTonsAbs_mean = mean(data_CO2pcCS2000MetricTons);
data_CO2pcCS2000MetricTonsAbs_median = median(data_CO2pcCS2000MetricTons);
%data_CO2pcCS2000MetricTonsAbs_mode = mode(data_CO2pcCS2000MetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
data_CO2pcCS2000MetricTonsAbs_std = std(data_CO2pcCS2000MetricTons);

tabCO2pcCS2000MetricTonsAbs = table(categorical({'data_CO2pcCS2000MetricTonsAbs_min';'data_CO2pcCS2000MetricTonsAbs_max';'data_CO2pcCS2000MetricTons_range';'stripe_CO2pcCS2000MetricTonsAbs_range';'data_CO2pcCS2000MetricTonsAbs_mean';'data_CO2pcCS2000MetricTonsAbs_median'; 'data_CO2pcCS2000MetricTonsAbs_std'}),{data_CO2pcCS2000MetricTonsAbs_min; data_CO2pcCS2000MetricTonsAbs_max; data_CO2pcCS2000MetricTonsAbs_range; stripe_CO2pcCS2000MetricTonsAbs_range; data_CO2pcCS2000MetricTonsAbs_mean; data_CO2pcCS2000MetricTonsAbs_median; data_CO2pcCS2000MetricTonsAbs_std});
writetable(tabCO2pcCS2000MetricTonsAbs,'tabCO2pcCS2000MetricTonsAbs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeneingProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the World Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 2000
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig11 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProsppc,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProsppc',...
   'YData',[2000 2040],...c
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(8,"points")
%xlabel('FontSize',6)
%title('Average CS2000 Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 2000-2020');
title('2000','FontSize',18);

saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS2000Abs.fig') %AM230701 checking online
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS2000Abs.png')
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS2000Abs.epsc')

GreenProsppcDefGDPpcPPPUSD2017WpcAbs = imread('GreenProsppcDefGDPpcPPPUSD2017CS2000Abs.png'); %AM230701 after checking online

%% Plot - absolute level

fig12 = figure
bar(1:266,data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017,'BarWidth',0.75)
axis ([1 266 0 120000])
fontsize(8,"points")
grid on
xlabel('')
ylabel('Greening prosperity ratio pc (GDP pc / CO2 pc)')
title('2000','FontSize',18);

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS2000Abs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS2000Abs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS2000Abs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017_range';'stripe_CO2pcCS2000MetricTonsAbs_range';'data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_range; stripe_CO2pcCS2000MetricTonsAbs_range; data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs ,'tabGreenProsppcCS2000DefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")


%% Loading the Dataset for 2010

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
datacolumn_GDPpcCS2010PPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','BC5:BC270');
data_GDPpcCS2010PPPIntlUSDof2017 = transpose(datacolumn_GDPpcCS2010PPPIntlUSDof2017);
ticksGDP = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); %AM231005 Select the cross-section range, i.e., cross-section vector, to be displayed (NO earlier data)!
%ticksGDP = readtable('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','TextType','string')
%ldata_GDPpcCS2010PPPIntlUSDof2017 = log(data_GDPpcCS2010PPPIntlUSDof2017);
%dldata_GDPpcCS2010PPPIntlUSDof2017 =
%diff(ldata_GDPpcCS2010PPPIntlUSDof2017)*100;
%ticksdlGDP = xlsread;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
datacolumn_CO2pcCS2010MetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','BC5:BC270');
data_CO2pcCS2010MetricTons = transpose(datacolumn_CO2pcCS2010MetricTons);
ticksCO2 = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); %AM231005 Select the cross-section range, i.e., cross-section vector, to be displayed (NO earlier data again: but symmetry)!
%ldata_CO2pcWorldMetricTons = log(data_CO2pcWorldMetricTons);
%dldata_CO2pcWorldMetricTons = diff(ldata_CO2pcWorldMetricTons)*100;
%ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017 = data_GDPpcCS2010PPPIntlUSDof2017 ./ data_CO2pcCS2010MetricTons;
ticksGreenProsppc = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); % AM231005 Keep the name/label "ticks" because it is used/called below in generating the graphs!
%ldata_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017)*100;
%ticksdlGreenProsppcWorldGDP = 1991:2020;

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

%% Creating the World GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig13 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',[1 266]',...
   'YData',[2000 2040],...
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcCS2010PPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(8,"points")
%title('GDP per capita in 2010 in PPP International USD of 2017');
title('2010','FontSize',18);

saveas(gcf,'GDPCS2010pcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPCS2010pcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPCS2010pcPPPIntlUSDof2017Abs.epsc')

GDPWpcDev = imread('GDPCS2010pcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Plot - absolute level

fig14 = figure
bar(1:266, data_GDPpcCS2010PPPIntlUSDof2017,'BarWidth',0.75)
axis ([1 266 0 120000])
fontsize(8,"points")
grid on
xlabel('')
 %'XTickLabelRotation',90,...
ylabel('GDP per capita in 2010 in PPP international USD of 2017')
title('2010','FontSize',18);

saveas(gcf,'Plot_GDPpcCS2010PPPIntlUSDof2017AbsSince2010Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcCS2010PPPIntlUSDof2017AbsSince2010Annual.png')
saveas(gcf,'Plot_GDPpcCS2010PPPIntlUSDof2017AbsSince2010Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcCS2010PPPIntlUSDof2017Abs_min = min(data_GDPpcCS2010PPPIntlUSDof2017);
data_GDPpcCS2010PPPIntlUSDof2017Abs_max = max(data_GDPpcCS2010PPPIntlUSDof2017);
data_GDPpcCS2010PPPIntlUSDof2017Abs_range = data_GDPpcCS2010PPPIntlUSDof2017Abs_max - data_GDPpcCS2010PPPIntlUSDof2017Abs_min;
stripe_GDPpcCS2010PPPIntlUSDof2017Abs_range = data_GDPpcCS2010PPPIntlUSDof2017Abs_range/16;
data_GDPpcCS2010PPPIntlUSDof2017Abs_mean = mean(data_GDPpcCS2010PPPIntlUSDof2017);
data_GDPpcCS2010PPPIntlUSDof2017Abs_median = median(data_GDPpcCS2010PPPIntlUSDof2017);
%data_GDPpcCS2010PPPIntlUSDof2017Abs_mode = mode(data_GDPpcCS2010PPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GDPpcCS2010PPPIntlUSDof2017Abs_std = std(data_GDPpcCS2010PPPIntlUSDof2017);

tabGDPpcCS2010PPPIntlUSDof2017Abs = table(categorical({'data_GDPpcCS2010PPPIntlUSDof2017Abs_min';'data_GDPpcCS2010PPPIntlUSDof2017Abs_max';'data_GDPpcCS2010PPPIntlUSDof2017Abs_range';'stripe_GDPpcCS2010PPPIntlUSDof2017Abs_range';'data_GDPpcCS2010PPPIntlUSDof2017Abs_mean';'data_GDPpcCS2010PPPIntlUSDof2017Abs_median'; 'data_GDPpcCS2010PPPIntlUSDof2017Abs_std'}),{data_GDPpcCS2010PPPIntlUSDof2017Abs_min; data_GDPpcCS2010PPPIntlUSDof2017Abs_max; data_GDPpcCS2010PPPIntlUSDof2017Abs_range; stripe_GDPpcCS2010PPPIntlUSDof2017Abs_range; data_GDPpcCS2010PPPIntlUSDof2017Abs_mean; data_GDPpcCS2010PPPIntlUSDof2017Abs_median; data_GDPpcCS2010PPPIntlUSDof2017Abs_std});
writetable(tabGDPpcCS2010PPPIntlUSDof2017Abs,'tabGDPpcCS2010USDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the CS2010 CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 2010
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig15 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcCS2010MetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(8,"points")
%title('Average CS2010 CO2 Emissions per capita for 2010-2020');
title('2010','FontSize',18);

saveas(gcf,'CO2pcCS2010Abs.fig') %AM230701 checking online
saveas(gcf,'CO2pcCS2010Abs.png')
saveas(gcf,'CO2pcCS2010Abs.epsc')

CO2WpcAbs = imread('CO2pcCS2010Abs.png'); %AM230701 checking online

%% Plot - absolute level

fig16 = figure
bar(1:266,data_CO2pcCS2010MetricTons,'BarWidth',0.75)
axis ([1 266 0 45])
fontsize(8,"points")
grid on
xlabel('')
ylabel('CO2 emissions pc, in metric tons')
title('2010','FontSize',18);

saveas(gcf,'Plot_CO2pcCS2010MetricTonsSince2010Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcCS2010MetricTonsSince2010Annual.png')
saveas(gcf,'Plot_CO2pcCS2010MetricTonsSince2010Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcCS2010MetricTonsAbs_min = min(data_CO2pcCS2010MetricTons);
data_CO2pcCS2010MetricTonsAbs_max = max(data_CO2pcCS2010MetricTons);
data_CO2pcCS2010MetricTonsAbs_range = data_CO2pcCS2010MetricTonsAbs_max - data_CO2pcCS2010MetricTonsAbs_min;
stripe_CO2pcCS2010MetricTonsAbs_range = data_CO2pcCS2010MetricTonsAbs_range/16;
data_CO2pcCS2010MetricTonsAbs_mean = mean(data_CO2pcCS2010MetricTons);
data_CO2pcCS2010MetricTonsAbs_median = median(data_CO2pcCS2010MetricTons);
%data_CO2pcCS2010MetricTonsAbs_mode = mode(data_CO2pcCS2010MetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
data_CO2pcCS2010MetricTonsAbs_std = std(data_CO2pcCS2010MetricTons);

tabCO2pcCS2010MetricTonsAbs = table(categorical({'data_CO2pcCS2010MetricTonsAbs_min';'data_CO2pcCS2010MetricTonsAbs_max';'data_CO2pcCS2010MetricTons_range';'stripe_CO2pcCS2010MetricTonsAbs_range';'data_CO2pcCS2010MetricTonsAbs_mean';'data_CO2pcCS2010MetricTonsAbs_median'; 'data_CO2pcCS2010MetricTonsAbs_std'}),{data_CO2pcCS2010MetricTonsAbs_min; data_CO2pcCS2010MetricTonsAbs_max; data_CO2pcCS2010MetricTonsAbs_range; stripe_CO2pcCS2010MetricTonsAbs_range; data_CO2pcCS2010MetricTonsAbs_mean; data_CO2pcCS2010MetricTonsAbs_median; data_CO2pcCS2010MetricTonsAbs_std});
writetable(tabCO2pcCS2010MetricTonsAbs,'tabCO2pcCS2010MetricTonsAbs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeneingProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the World Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 2010
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig17 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProsppc,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProsppc',...
   'YData',[2000 2040],...c
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(8,"points")
%xlabel('FontSize',6)
%title('Average CS2010 Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 2010-2020');
title('2010','FontSize',18);

saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS2010Abs.fig') %AM230701 checking online
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS2010Abs.png')
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS2010Abs.epsc')

GreenProsppcDefGDPpcPPPUSD2017WpcAbs = imread('GreenProsppcDefGDPpcPPPUSD2017CS2010Abs.png'); %AM230701 after checking online

%% Plot - absolute level

fig18 = figure
bar(1:266,data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017,'BarWidth',0.75)
axis ([1 266 0 120000])
fontsize(8,"points")
grid on
xlabel('')
ylabel('Greening prosperity ratio pc (GDP pc / CO2 pc)')
title('2010','FontSize',18);

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS2010Abs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS2010Abs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS2010Abs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017_range';'stripe_CO2pcCS2010MetricTonsAbs_range';'data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_range; stripe_CO2pcCS2010MetricTonsAbs_range; data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcCS2010DefByGDPpcPPPIntlUSDof2017Abs ,'tabGreenProsppcCS1990DefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")




%% Loading the Dataset for 2020

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
datacolumn_GDPpcCS2020PPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','BM5:BM270');
data_GDPpcCS2020PPPIntlUSDof2017 = transpose(datacolumn_GDPpcCS2020PPPIntlUSDof2017);
ticksGDP = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); %AM231005 Select the cross-section range, i.e., cross-section vector, to be displayed (NO earlier data)!
%ticksGDP = readtable('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','TextType','string')
%ldata_GDPpcCS2020PPPIntlUSDof2017 = log(data_GDPpcCS2020PPPIntlUSDof2017);
%dldata_GDPpcCS2020PPPIntlUSDof2017 =
%diff(ldata_GDPpcCS2020PPPIntlUSDof2017)*100;
%ticksdlGDP = xlsread;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
datacolumn_CO2pcCS2020MetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','BM5:BM270');
data_CO2pcCS2020MetricTons = transpose(datacolumn_CO2pcCS2020MetricTons);
ticksCO2 = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); %AM231005 Select the cross-section range, i.e., cross-section vector, to be displayed (NO earlier data again: but symmetry)!
%ldata_CO2pcWorldMetricTons = log(data_CO2pcWorldMetricTons);
%dldata_CO2pcWorldMetricTons = diff(ldata_CO2pcWorldMetricTons)*100;
%ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017 = data_GDPpcCS2020PPPIntlUSDof2017 ./ data_CO2pcCS2020MetricTons;
ticksGreenProsppc = 1:2:266; %xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','B5:B270'); % AM231005 Keep the name/label "ticks" because it is used/called below in generating the graphs!
%ldata_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017)*100;
%ticksdlGreenProsppcWorldGDP = 1991:2020;

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

%% Creating the World GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig19 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',[1 266]',...
   'YData',[2000 2040],...
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcCS2020PPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(8,"points")
%title('GDP per capita in 2020 in PPP International USD of 2017');
title('2020','FontSize',18);

saveas(gcf,'GDPCS2020pcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPCS2020pcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPCS2020pcPPPIntlUSDof2017Abs.epsc')

GDPWpcDev = imread('GDPCS2020pcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Plot - absolute level

fig20 = figure
bar(1:266, data_GDPpcCS2020PPPIntlUSDof2017,'BarWidth',0.75)
axis ([1 266 0 120000])
fontsize(8,"points")
grid on
xlabel('')
 %'XTickLabelRotation',90,...
ylabel('GDP per capita in 2020 in PPP international USD of 2017')
title('2020','FontSize',18);

saveas(gcf,'Plot_GDPpcCS2020PPPIntlUSDof2017AbsSince2020Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcCS2020PPPIntlUSDof2017AbsSince2020Annual.png')
saveas(gcf,'Plot_GDPpcCS2020PPPIntlUSDof2017AbsSince2020Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcCS2020PPPIntlUSDof2017Abs_min = min(data_GDPpcCS2020PPPIntlUSDof2017);
data_GDPpcCS2020PPPIntlUSDof2017Abs_max = max(data_GDPpcCS2020PPPIntlUSDof2017);
data_GDPpcCS2020PPPIntlUSDof2017Abs_range = data_GDPpcCS2020PPPIntlUSDof2017Abs_max - data_GDPpcCS2020PPPIntlUSDof2017Abs_min;
stripe_GDPpcCS2020PPPIntlUSDof2017Abs_range = data_GDPpcCS2020PPPIntlUSDof2017Abs_range/16;
data_GDPpcCS2020PPPIntlUSDof2017Abs_mean = mean(data_GDPpcCS2020PPPIntlUSDof2017);
data_GDPpcCS2020PPPIntlUSDof2017Abs_median = median(data_GDPpcCS2020PPPIntlUSDof2017);
%data_GDPpcCS2020PPPIntlUSDof2017Abs_mode = mode(data_GDPpcCS2020PPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GDPpcCS2020PPPIntlUSDof2017Abs_std = std(data_GDPpcCS2020PPPIntlUSDof2017);

tabGDPpcCS2020PPPIntlUSDof2017Abs = table(categorical({'data_GDPpcCS2020PPPIntlUSDof2017Abs_min';'data_GDPpcCS2020PPPIntlUSDof2017Abs_max';'data_GDPpcCS2020PPPIntlUSDof2017Abs_range';'stripe_GDPpcCS2020PPPIntlUSDof2017Abs_range';'data_GDPpcCS2020PPPIntlUSDof2017Abs_mean';'data_GDPpcCS2020PPPIntlUSDof2017Abs_median'; 'data_GDPpcCS2020PPPIntlUSDof2017Abs_std'}),{data_GDPpcCS2020PPPIntlUSDof2017Abs_min; data_GDPpcCS2020PPPIntlUSDof2017Abs_max; data_GDPpcCS2020PPPIntlUSDof2017Abs_range; stripe_GDPpcCS2020PPPIntlUSDof2017Abs_range; data_GDPpcCS2020PPPIntlUSDof2017Abs_mean; data_GDPpcCS2020PPPIntlUSDof2017Abs_median; data_GDPpcCS2020PPPIntlUSDof2017Abs_std});
writetable(tabGDPpcCS2020PPPIntlUSDof2017Abs,'tabGDPpcCS2020USDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the CS2020 CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 2020
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig21 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcCS2020MetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(8,"points")
%title('Average CS2020 CO2 Emissions per capita for 2020-2020');
title('2020','FontSize',18);

saveas(gcf,'CO2pcCS2020Abs.fig') %AM230701 checking online
saveas(gcf,'CO2pcCS2020Abs.png')
saveas(gcf,'CO2pcCS2020Abs.epsc')

CO2WpcAbs = imread('CO2pcCS2020Abs.png'); %AM230701 checking online

%% Plot - absolute level

fig22 = figure
bar(1:266,data_CO2pcCS2020MetricTons,'BarWidth',0.75)
axis ([1 266 0 45])
fontsize(8,"points")
grid on
xlabel('')
ylabel('CO2 emissions pc, in metric tons')
title('2020','FontSize',18);

saveas(gcf,'Plot_CO2pcCS2020MetricTonsSince2020Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcCS2020MetricTonsSince2020Annual.png')
saveas(gcf,'Plot_CO2pcCS2020MetricTonsSince2020Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcCS2020MetricTonsAbs_min = min(data_CO2pcCS2020MetricTons);
data_CO2pcCS2020MetricTonsAbs_max = max(data_CO2pcCS2020MetricTons);
data_CO2pcCS2020MetricTonsAbs_range = data_CO2pcCS2020MetricTonsAbs_max - data_CO2pcCS2020MetricTonsAbs_min;
stripe_CO2pcCS2020MetricTonsAbs_range = data_CO2pcCS2020MetricTonsAbs_range/16;
data_CO2pcCS2020MetricTonsAbs_mean = mean(data_CO2pcCS2020MetricTons);
data_CO2pcCS2020MetricTonsAbs_median = median(data_CO2pcCS2020MetricTons);
%data_CO2pcCS2020MetricTonsAbs_mode = mode(data_CO2pcCS2020MetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
data_CO2pcCS2020MetricTonsAbs_std = std(data_CO2pcCS2020MetricTons);

tabCO2pcCS2020MetricTonsAbs = table(categorical({'data_CO2pcCS2020MetricTonsAbs_min';'data_CO2pcCS2020MetricTonsAbs_max';'data_CO2pcCS2020MetricTons_range';'stripe_CO2pcCS2020MetricTonsAbs_range';'data_CO2pcCS2020MetricTonsAbs_mean';'data_CO2pcCS2020MetricTonsAbs_median'; 'data_CO2pcCS2020MetricTonsAbs_std'}),{data_CO2pcCS2020MetricTonsAbs_min; data_CO2pcCS2020MetricTonsAbs_max; data_CO2pcCS2020MetricTonsAbs_range; stripe_CO2pcCS2020MetricTonsAbs_range; data_CO2pcCS2020MetricTonsAbs_mean; data_CO2pcCS2020MetricTonsAbs_median; data_CO2pcCS2020MetricTonsAbs_std});
writetable(tabCO2pcCS2020MetricTonsAbs,'tabCO2pcCS2020MetricTonsAbs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeneingProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the World Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 2020
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig23 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[1 266],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProsppc,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProsppc',...
   'YData',[2000 2040],...c
   'XData',[1 266],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(8,"points")
%xlabel('FontSize',6)
%title('Average CS2020 Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 2020-2020');
title('2020','FontSize',18);

saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS2020Abs.fig') %AM230701 checking online
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS2020Abs.png')
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017CS2020Abs.epsc')

GreenProsppcDefGDPpcPPPUSD2017WpcAbs = imread('GreenProsppcDefGDPpcPPPUSD2017CS2020Abs.png'); %AM230701 after checking online

%% Plot - absolute level

fig24 = figure
bar(1:266,data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017,'BarWidth',0.75)
axis ([1 266 0 120000])
fontsize(8,"points")
grid on
xlabel('')
ylabel('Greening prosperity ratio pc (GDP pc / CO2 pc)')
title('2020','FontSize',18);

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS2020Abs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS2020Abs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CS2020Abs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017_range';'stripe_CO2pcCS2020MetricTonsAbs_range';'data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_range; stripe_CO2pcCS2020MetricTonsAbs_range; data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs ,'tabGreenProsppcCS2020DefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")







%%% END of program %%%