%% MATLAB program to create stripes colormap of GDP pc in PPP international USD of 2017, CO2 pc and GPR pc for 1st Subsample
% File name: GDPpcCO2pcStripes1stSmpl4Groups8Countries_am231204.m
% AM230630 in R2017a 1st trial -> and success! -> based on:
% http://mres.uni-potsdam.de/index.php/2022/11/16/ed-hawkins-warming-stripes-with-matlab/
% AM230701 in R2023a minor edits and development
% AM230709 in R2023a further minor edits and development
% AM230720 in R2023a major development and addition of CO2 emissions and a brown-to-green colormap
% AM230720 in R2023a further improvenets and addition of greening prosperity ratio stripes
% AM231005 in R2023a switching to GDP pc in PPP inernational USD of 2017 and addition of greening prosperity ratio stripes
% AM231006 in R2023a adding together World, HiIncCs, LoIncCs, US, EU, China
% AM231007 in R2023a trying (again) to fix the stripe colormaps in multiplots -> unsuccessful again (see the figure at the bottom of the code), but just fixed it in Overleaf/Beamer!
% AM231116 in R2023a redefining upper bounds due to Switzerland in 2nd subsample
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

diary GDPpcCO2pcStripes1stSmpl3Groups9Countries_am231204.txt % create a diary log (*.txt) file saving the output from the command window
tic                          % start stopwatch timer
t = datetime('now')          % return a datetime scalar representing the current date and time

%% Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcWorldPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI264:BM264');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcWorldPPPIntlUSDof2017 = log(data_GDPpcWorldPPPIntlUSDof2017);
dldata_GDPpcWorldPPPIntlUSDof2017 = diff(ldata_GDPpcWorldPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcWorldMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI264:BM264');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcWorldMetricTons = log(data_CO2pcWorldMetricTons);
dldata_CO2pcWorldMetricTons = diff(ldata_CO2pcWorldMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017 = data_GDPpcWorldPPPIntlUSDof2017 ./ data_CO2pcWorldMetricTons;
ticksGreenProsppcWorldGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProsppcWorldGDP = 1991:2020;

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
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcWorldPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average World GDP per capita in PPP International USD of 2017 for 1990-1990');
title('World');

saveas(gcf,'GDPWpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPWpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPWpcPPPIntlUSDof2017Abs.epsc')

GDPWpcDev = imread('GDPWpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Plot - absolute level

fig2 = figure
plot(ticksGDP,data_GDPpcWorldPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average world GDP per capita in PPP international USD of 2017')
title('Average World GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Plot - growth rates

fig3 = figure
plot(ticksdlGDP,dldata_GDPpcWorldPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of average world GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Average World GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - absolute level

fig4 = figure
histogram(data_GDPpcWorldPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average World GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig5 = figure
histogram(dldata_GDPpcWorldPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Average World GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcWorldPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcWorldPPPIntlUSDof2017Abs_min = min(data_GDPpcWorldPPPIntlUSDof2017);
data_GDPpcWorldPPPIntlUSDof2017Abs_max = max(data_GDPpcWorldPPPIntlUSDof2017);
data_GDPpcWorldPPPIntlUSDof2017Abs_range = data_GDPpcWorldPPPIntlUSDof2017Abs_max - data_GDPpcWorldPPPIntlUSDof2017Abs_min;
stripe_GDPpcWorldPPPIntlUSDof2017Abs_range = data_GDPpcWorldPPPIntlUSDof2017Abs_range/16;
data_GDPpcWorldPPPIntlUSDof2017Abs_mean = mean(data_GDPpcWorldPPPIntlUSDof2017);
data_GDPpcWorldPPPIntlUSDof2017Abs_median = median(data_GDPpcWorldPPPIntlUSDof2017);
%data_GDPpcWorldPPPIntlUSDof2017Abs_mode = mode(data_GDPpcWorldPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GDPpcWorldPPPIntlUSDof2017Abs_std = std(data_GDPpcWorldPPPIntlUSDof2017);

tabGDPpcWorldPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcWorldPPPIntlUSDof2017Abs_min';'data_GDPpcWorldPPPIntlUSDof2017Abs_max';'data_GDPpcWorldPPPIntlUSDof2017Abs_range';'stripe_GDPpcWorldPPPIntlUSDof2017Abs_range';'data_GDPpcWorldPPPIntlUSDof2017Abs_mean';'data_GDPpcWorldPPPIntlUSDof2017Abs_median'; 'data_GDPpcWorldPPPIntlUSDof2017Abs_std'}),{data_GDPpcWorldPPPIntlUSDof2017Abs_min; data_GDPpcWorldPPPIntlUSDof2017Abs_max; data_GDPpcWorldPPPIntlUSDof2017Abs_range; stripe_GDPpcWorldPPPIntlUSDof2017Abs_range; data_GDPpcWorldPPPIntlUSDof2017Abs_mean; data_GDPpcWorldPPPIntlUSDof2017Abs_median; data_GDPpcWorldPPPIntlUSDof2017Abs_std});
writetable(tabGDPpcWorldPPPIntlUSDof2017Abs,'tabGDPpcWorldUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcWorldPPPIntlUSDof2017Abs_min = min(dldata_GDPpcWorldPPPIntlUSDof2017);
dldata_GDPpcWorldPPPIntlUSDof2017Abs_max = max(dldata_GDPpcWorldPPPIntlUSDof2017);
dldata_GDPpcWorldPPPIntlUSDof2017Abs_range = dldata_GDPpcWorldPPPIntlUSDof2017Abs_max - dldata_GDPpcWorldPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcWorldPPPIntlUSDof2017Abs_range = dldata_GDPpcWorldPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcWorldPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcWorldPPPIntlUSDof2017);
dldata_GDPpcWorldPPPIntlUSDof2017Abs_median = median(dldata_GDPpcWorldPPPIntlUSDof2017);
%dldata_GDPpcWorldPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcWorldPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcWorldPPPIntlUSDof2017Abs_std = std(dldata_GDPpcWorldPPPIntlUSDof2017);

tabdlGDPpcWorldPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcWorldPPPIntlUSDof2017Abs_min';'dldata_GDPpcWorldPPPIntlUSDof2017Abs_max';'dldata_GDPpcWorldPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcWorldPPPIntlUSDof2017Abs_range';'dldata_GDPpcWorldPPPIntlUSDof2017Abs_mean';'dldata_GDPpcWorldPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcWorldPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcWorldPPPIntlUSDof2017Abs_min; dldata_GDPpcWorldPPPIntlUSDof2017Abs_max; dldata_GDPpcWorldPPPIntlUSDof2017Abs_range; stripe_GDPpcWorldPPPIntlUSDof2017Abs_range; dldata_GDPpcWorldPPPIntlUSDof2017Abs_mean; dldata_GDPpcWorldPPPIntlUSDof2017Abs_median; dldata_GDPpcWorldPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcWorldPPPIntlUSDof2017Abs,'tabdlGDPpcWorldUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the World CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig6 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcWorldMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average World CO2 Emissions per capita for 1990-2020');
title('World');

saveas(gcf,'CO2WpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2WpcAbs.png')
saveas(gcf,'CO2WpcAbs.epsc')

CO2WpcAbs = imread('CO2WpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig7 = figure
plot(ticksCO2,data_CO2pcWorldMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average world CO2 emissions pc, in metric tons')
title('Average World CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcWorldMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcWorldMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcWorldMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig8 = figure
plot(ticksdlCO2,dldata_CO2pcWorldMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of average world CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Average World CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcWorldMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcWorldMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcWorldMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig9 = figure
histogram(data_CO2pcWorldMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average World CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcWorldMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcWorldMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcWorldMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig10 = figure
histogram(dldata_CO2pcWorldMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Average World CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcWorldMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcWorldMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcWorldMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcWorldMetricTonsAbs_min = min(data_CO2pcWorldMetricTons);
data_CO2pcWorldMetricTonsAbs_max = max(data_CO2pcWorldMetricTons);
data_CO2pcWorldMetricTonsAbs_range = data_CO2pcWorldMetricTonsAbs_max - data_CO2pcWorldMetricTonsAbs_min;
stripe_CO2pcWorldMetricTonsAbs_range = data_CO2pcWorldMetricTonsAbs_range/16;
data_CO2pcWorldMetricTonsAbs_mean = mean(data_CO2pcWorldMetricTons);
data_CO2pcWorldMetricTonsAbs_median = median(data_CO2pcWorldMetricTons);
%data_CO2pcWorldMetricTonsAbs_mode = mode(data_CO2pcWorldMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
data_CO2pcWorldMetricTonsAbs_std = std(data_CO2pcWorldMetricTons);

tabCO2pcWorldMetricTonsAbs = table(categorical({'data_CO2pcWorldMetricTonsAbs_min';'data_CO2pcWorldMetricTonsAbs_max';'data_CO2pcWorldMetricTons_range';'stripe_CO2pcWorldMetricTonsAbs_range';'data_CO2pcWorldMetricTonsAbs_mean';'data_CO2pcWorldMetricTonsAbs_median'; 'data_CO2pcWorldMetricTonsAbs_std'}),{data_CO2pcWorldMetricTonsAbs_min; data_CO2pcWorldMetricTonsAbs_max; data_CO2pcWorldMetricTonsAbs_range; stripe_CO2pcWorldMetricTonsAbs_range; data_CO2pcWorldMetricTonsAbs_mean; data_CO2pcWorldMetricTonsAbs_median; data_CO2pcWorldMetricTonsAbs_std});
writetable(tabCO2pcWorldMetricTonsAbs,'tabCO2pcWorldMetricTonsAbs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeneingProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcWorldMetricTonsAbs_min = min(dldata_CO2pcWorldMetricTons);
dldata_CO2pcWorldMetricTonsAbs_max = max(dldata_CO2pcWorldMetricTons);
dldata_CO2pcWorldMetricTonsAbs_range = dldata_CO2pcWorldMetricTonsAbs_max - dldata_CO2pcWorldMetricTonsAbs_min;
dlstripe_CO2pcWorldMetricTonsAbs_range = dldata_CO2pcWorldMetricTonsAbs_range/16;
dldata_CO2pcWorldMetricTonsAbs_mean = mean(dldata_CO2pcWorldMetricTons);
dldata_CO2pcWorldMetricTonsAbs_median = median(dldata_CO2pcWorldMetricTons);
%dldata_CO2pcWorldMetricTonsAbs_mode = mode(dldata_CO2pcWorldMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcWorldMetricTonsAbs_std = std(dldata_CO2pcWorldMetricTons);

tabdlCO2pcWorldMetricTonsAbs = table(categorical({'data_CO2pcWorldMetricTonsAbs_min';'data_CO2pcWorldMetricTonsAbs_max';'data_CO2pcWorldMetricTons_range';'stripe_CO2pcWorldMetricTonsAbs_range';'data_CO2pcWorldMetricTonsAbs_mean';'data_CO2pcWorldMetricTonsAbs_median'; 'dldata_CO2pcWorldMetricTonsAbs_std'}),{data_CO2pcWorldMetricTonsAbs_min; data_CO2pcWorldMetricTonsAbs_max; data_CO2pcWorldMetricTonsAbs_range; stripe_CO2pcWorldMetricTonsAbs_range; data_CO2pcWorldMetricTonsAbs_mean; data_CO2pcWorldMetricTonsAbs_median; dldata_CO2pcWorldMetricTonsAbs_std})
writetable(tabdlCO2pcWorldMetricTonsAbs,'tabdlCO2pcWorldMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the World Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig11 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProsppcWorldGDP) max(ticksGreenProsppcWorldGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProsppcWorldGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProsppcWorldGDP',...
   'YData',[2000 2040],...c
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average World Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('World');

saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017WorldAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017WorldAbs.png')
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017WorldAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017WpcAbs = imread('GreenProsppcDefGDPpcPPPUSD2017WorldAbs.png'); %AM230701 after checking online

%% Plot - absolute level

fig12 = figure
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average world greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Average World Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017WorldAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017WorldAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017WorldAbs.epsc')

%% Plot - growth rates

fig13 = figure
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth ratess (in % pa) of average world greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa)of Average World Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017WorldAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017WorldAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017WorldAbs.epsc')

%% Histogram - absolute level

fig14 = figure
histogram(data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average World Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017WorldAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017WorldAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017WorldAbs.epsc')

%% Histogram - growth rates

fig15 = figure
histogram(dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Average World Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017WorldAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017WorldAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017WorldAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017_range';'stripe_CO2pcWorldMetricTonsAbs_range';'data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_CO2pcWorldMetricTonsAbs_range; data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs ,'tabGreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_CO2pcWorldMetricTonsAbs_range';'dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_mean';'dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_median'; 'dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_CO2pcWorldMetricTonsAbs_range; dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcWorldDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% High Income Countries - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcHiIncCsPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI100:BM100');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcHiIncCsPPPIntlUSDof2017 = log(data_GDPpcHiIncCsPPPIntlUSDof2017);
dldata_GDPpcHiIncCsPPPIntlUSDof2017 = diff(ldata_GDPpcHiIncCsPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcHiIncCsMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI100:BM100');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcHiIncCsMetricTons = log(data_CO2pcHiIncCsMetricTons);
dldata_CO2pcHiIncCsMetricTons = diff(ldata_CO2pcHiIncCsMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017 = data_GDPpcHiIncCsPPPIntlUSDof2017 ./ data_CO2pcHiIncCsMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the HiIncCs GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig16 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcHiIncCsPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average High-Income Countries GDP per capita in PPP International USD of 2017 for 1990-1990');
title('High-Income Cs');

saveas(gcf,'GDPHiIncCspcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPHiIncCspcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPHiIncCspcPPPIntlUSDof2017Abs.epsc')

GDPHiIncCspcDev = imread('GDPHiIncCspcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig17 = figure
plot(ticksGDP,data_GDPpcHiIncCsPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average high-income countries GDP per capita in PPP international USD of 2017')
title('Average High-Income Countries GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig18 = figure
plot(ticksdlGDP,dldata_GDPpcHiIncCsPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of average high-income countries GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Average High-Income Countries GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig19 = figure
histogram(data_GDPpcHiIncCsPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average High-Income Countries GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig20 = figure
histogram(dldata_GDPpcHiIncCsPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Average High-Income Countries GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcHiIncCsPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcHiIncCsPPPIntlUSDof2017Abs_min = min(data_GDPpcHiIncCsPPPIntlUSDof2017)
data_GDPpcHiIncCsPPPIntlUSDof2017Abs_max = max(data_GDPpcHiIncCsPPPIntlUSDof2017)
data_GDPpcHiIncCsPPPIntlUSDof2017Abs_range = data_GDPpcHiIncCsPPPIntlUSDof2017Abs_max - data_GDPpcHiIncCsPPPIntlUSDof2017Abs_min
stripe_GDPpcHiIncCsPPPIntlUSDof2017Abs_range = data_GDPpcHiIncCsPPPIntlUSDof2017Abs_range/16
data_GDPpcHiIncCsPPPIntlUSDof2017Abs_mean = mean(data_GDPpcHiIncCsPPPIntlUSDof2017)
data_GDPpcHiIncCsPPPIntlUSDof2017Abs_median = median(data_GDPpcHiIncCsPPPIntlUSDof2017)
%data_GDPpcHiIncCsPPPIntlUSDof2017Abs_mode = mode(data_GDPpcHiIncCsPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcHiIncCsPPPIntlUSDof2017Abs_std = std(data_GDPpcHiIncCsPPPIntlUSDof2017);

tabGDPpcHiIncCsPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcHiIncCsPPPIntlUSDof2017Abs_min';'data_GDPpcHiIncCsPPPIntlUSDof2017Abs_max';'data_GDPpcHiIncCsPPPIntlUSDof2017Abs_range';'stripe_GDPpcHiIncCsPPPIntlUSDof2017Abs_range';'data_GDPpcHiIncCsPPPIntlUSDof2017Abs_mean';'data_GDPpcHiIncCsPPPIntlUSDof2017Abs_median';'data_GDPpcHiIncCsPPPIntlUSDof2017Abs_std'}),{data_GDPpcHiIncCsPPPIntlUSDof2017Abs_min; data_GDPpcHiIncCsPPPIntlUSDof2017Abs_max; data_GDPpcHiIncCsPPPIntlUSDof2017Abs_range; stripe_GDPpcHiIncCsPPPIntlUSDof2017Abs_range; data_GDPpcHiIncCsPPPIntlUSDof2017Abs_mean; data_GDPpcHiIncCsPPPIntlUSDof2017Abs_median; data_GDPpcHiIncCsPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcHiIncCsPPPIntlUSDof2017Abs,'tabGDPpcHiIncCsUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_min = min(dldata_GDPpcHiIncCsPPPIntlUSDof2017);
dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_max = max(dldata_GDPpcHiIncCsPPPIntlUSDof2017);
dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_range = dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_max - dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcHiIncCsPPPIntlUSDof2017Abs_range = dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcHiIncCsPPPIntlUSDof2017);
dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_median = median(dldata_GDPpcHiIncCsPPPIntlUSDof2017);
%dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcHiIncCsPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_std = std(dldata_GDPpcHiIncCsPPPIntlUSDof2017);

tabdlGDPpcHiIncCsPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_min';'dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_max';'dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcHiIncCsPPPIntlUSDof2017Abs_range';'dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_mean';'dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_min; dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_max; dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_range; stripe_GDPpcHiIncCsPPPIntlUSDof2017Abs_range; dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_mean; dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_median; dldata_GDPpcHiIncCsPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcHiIncCsPPPIntlUSDof2017Abs,'tabdlGDPpcHiIncCsUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the HiIncCs CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig21 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcHiIncCsMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average CO2 Emissions in the High-Income Countries per capita for 1990-2020');
title('High-Income Cs');

saveas(gcf,'CO2HiIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2HiIncCspcAbs.png')
saveas(gcf,'CO2HiIncCspcAbs.epsc')

CO2HiIncCspcAbs = imread('CO2HiIncCspcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig22 = figure
plot(ticksCO2,data_CO2pcHiIncCsMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average high-income countries CO2 emissions pc, in metric tons')
title('Average High-Income Countries CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcHiIncCsMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcHiIncCsMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcHiIncCsMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig23 = figure
plot(ticksdlCO2,dldata_CO2pcHiIncCsMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of average high-income countries CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Average High-Income Countries CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcHiIncCsMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcHiIncCsMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcHiIncCsMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig24 = figure
histogram(data_CO2pcHiIncCsMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average High-Income Countries CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcHiIncCsMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcHiIncCsMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcHiIncCsMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig25 = figure
histogram(dldata_CO2pcHiIncCsMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Average High-Income Countries CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcHiIncCsMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcHiIncCsMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcHiIncCsMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcHiIncCsMetricTonsAbs_min = min(data_CO2pcHiIncCsMetricTons)
data_CO2pcHiIncCsMetricTonsAbs_max = max(data_CO2pcHiIncCsMetricTons)
data_CO2pcHiIncCsMetricTonsAbs_range = data_CO2pcHiIncCsMetricTonsAbs_max - data_CO2pcHiIncCsMetricTonsAbs_min
stripe_CO2pcHiIncCsMetricTonsAbs_range = data_CO2pcHiIncCsMetricTonsAbs_range/16
data_CO2pcHiIncCsMetricTonsAbs_mean = mean(data_CO2pcHiIncCsMetricTons)
data_CO2pcHiIncCsMetricTonsAbs_median = median(data_CO2pcHiIncCsMetricTons)
%data_CO2pcHiIncCsMetricTonsAbs_mode = mode(data_CO2pcHiIncCsMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcHiIncCsMetricTonsAbs_std = std(data_CO2pcHiIncCsMetricTons);

tabCO2pcHiIncCsMetricTonsAbs = table(categorical({'data_CO2pcHiIncCsMetricTonsAbs_min';'data_CO2pcHiIncCsMetricTonsAbs_max';'data_CO2pcHiIncCsMetricTons_range';'stripe_CO2pcHiIncCsMetricTonsAbs_range';'data_CO2pcHiIncCsMetricTonsAbs_mean';'data_CO2pcHiIncCsMetricTonsAbs_median';'data_CO2pcHiIncCsMetricTonsAbs_std'}),{data_CO2pcHiIncCsMetricTonsAbs_min; data_CO2pcHiIncCsMetricTonsAbs_max; data_CO2pcHiIncCsMetricTonsAbs_range; stripe_CO2pcHiIncCsMetricTonsAbs_range; data_CO2pcHiIncCsMetricTonsAbs_mean; data_CO2pcHiIncCsMetricTonsAbs_median; data_CO2pcHiIncCsMetricTonsAbs_std})
writetable(tabCO2pcHiIncCsMetricTonsAbs,'tabCO2pcHiIncCsMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcHiIncCsMetricTonsAbs_min = min(dldata_CO2pcHiIncCsMetricTons);
dldata_CO2pcHiIncCsMetricTonsAbs_max = max(dldata_CO2pcHiIncCsMetricTons);
dldata_CO2pcHiIncCsMetricTonsAbs_range = dldata_CO2pcHiIncCsMetricTonsAbs_max - dldata_CO2pcHiIncCsMetricTonsAbs_min;
dlstripe_CO2pcHiIncCsMetricTonsAbs_range = dldata_CO2pcHiIncCsMetricTonsAbs_range/16;
dldata_CO2pcHiIncCsMetricTonsAbs_mean = mean(dldata_CO2pcHiIncCsMetricTons);
dldata_CO2pcHiIncCsMetricTonsAbs_median = median(dldata_CO2pcHiIncCsMetricTons);
%dldata_CO2pcHiIncCsMetricTonsAbs_mode = mode(dldata_CO2pcHiIncCsMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcHiIncCsMetricTonsAbs_std = std(dldata_CO2pcHiIncCsMetricTons);

tabdlCO2pcHiIncCsMetricTonsAbs = table(categorical({'data_CO2pcHiIncCsMetricTonsAbs_min';'data_CO2pcHiIncCsMetricTonsAbs_max';'data_CO2pcHiIncCsMetricTons_range';'stripe_CO2pcHiIncCsMetricTonsAbs_range';'data_CO2pcHiIncCsMetricTonsAbs_mean';'data_CO2pcHiIncCsMetricTonsAbs_median'; 'dldata_CO2pcHiIncCsMetricTonsAbs_std'}),{data_CO2pcHiIncCsMetricTonsAbs_min; data_CO2pcHiIncCsMetricTonsAbs_max; data_CO2pcHiIncCsMetricTonsAbs_range; stripe_CO2pcHiIncCsMetricTonsAbs_range; data_CO2pcHiIncCsMetricTonsAbs_mean; data_CO2pcHiIncCsMetricTonsAbs_median; dldata_CO2pcHiIncCsMetricTonsAbs_std})
writetable(tabdlCO2pcHiIncCsMetricTonsAbs,'tabdlCO2pcHiIncCsMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the HiIncCs Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig26 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average High-Income Countries Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('High-Income Cs');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.epsc')

CO2HiIncCspcAbs = imread('CO2HiIncCspcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig27 = figure
plot(ticksGreenProspGDP,data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average high-income countries greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Average High-Income Countries Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.epsc')

%% Plot - growth rates

fig28 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of average high-income countries greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Average High-Income Countries Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.epsc')


%% Histogram - absolute level

fig29 = figure
histogram(data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average High-Income Countries Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017HiIncCspcAbs.epsc')

%% Histogram - growth rates

fig30 = figure
histogram(dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Average High-Income Countries Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017HiIncCsAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017HiIncCsAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017HiIncCsAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcHiIncCsDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcHiIncCsDefByGDPpcPPPIntUSDof2017Abs,'tabGreenProsppcHiIncCsDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Low-Income Countries - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcLoIncCsPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI141:BM141');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcLoIncCsPPPIntlUSDof2017 = log(data_GDPpcLoIncCsPPPIntlUSDof2017);
dldata_GDPpcLoIncCsPPPIntlUSDof2017 = diff(ldata_GDPpcLoIncCsPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcLoIncCsMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI141:BM141');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcLoIncCsMetricTons = log(data_CO2pcLoIncCsMetricTons);
dldata_CO2pcLoIncCsMetricTons = diff(ldata_CO2pcLoIncCsMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017 = data_GDPpcLoIncCsPPPIntlUSDof2017 ./ data_CO2pcLoIncCsMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProsppcLoIncCsGDP = 1991:2020;

%% Creating the LoIncCs GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig31 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcLoIncCsPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average Low-Income Countries GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Low-Income Cs');

saveas(gcf,'GDPLoIncCspcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPLoIncCspcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPLoIncCspcPPPIntlUSDof2017Abs.epsc')

GDPLoIncCspcDev = imread('GDPLoIncCspcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig32 = figure
plot(ticksGDP,data_GDPpcLoIncCsPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average low-income countries GDP per capita in PPP international USD of 2017')
title('Average Low-Income Countries GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig33 = figure
plot(ticksdlGDP,dldata_GDPpcLoIncCsPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of average low-income countries GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Average Low-Income Countries GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig34 = figure
histogram(data_GDPpcLoIncCsPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average Low-Income Countries GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig35 = figure
histogram(dldata_GDPpcLoIncCsPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Average Low-Income Countries GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcLoIncCsPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcLoIncCsPPPIntlUSDof2017Abs_min = min(data_GDPpcLoIncCsPPPIntlUSDof2017)
data_GDPpcLoIncCsPPPIntlUSDof2017Abs_max = max(data_GDPpcLoIncCsPPPIntlUSDof2017)
data_GDPpcLoIncCsPPPIntlUSDof2017Abs_range = data_GDPpcLoIncCsPPPIntlUSDof2017Abs_max - data_GDPpcLoIncCsPPPIntlUSDof2017Abs_min
stripe_GDPpcLoIncCsPPPIntlUSDof2017Abs_range = data_GDPpcLoIncCsPPPIntlUSDof2017Abs_range/16
data_GDPpcLoIncCsPPPIntlUSDof2017Abs_mean = mean(data_GDPpcLoIncCsPPPIntlUSDof2017)
data_GDPpcLoIncCsPPPIntlUSDof2017Abs_median = median(data_GDPpcLoIncCsPPPIntlUSDof2017)
%data_GDPpcLoIncCsPPPIntlUSDof2017Abs_mode = mode(data_GDPpcLoIncCsPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcLoIncCsPPPIntlUSDof2017Abs_std = std(data_GDPpcLoIncCsPPPIntlUSDof2017);

tabGDPpcLoIncCsPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcLoIncCsPPPIntlUSDof2017Abs_min';'data_GDPpcLoIncCsPPPIntlUSDof2017Abs_max';'data_GDPpcLoIncCsPPPIntlUSDof2017Abs_range';'stripe_GDPpcLoIncCsPPPIntlUSDof2017Abs_range';'data_GDPpcLoIncCsPPPIntlUSDof2017Abs_mean';'data_GDPpcLoIncCsPPPIntlUSDof2017Abs_median';'data_GDPpcLoIncCsPPPIntlUSDof2017Abs_std'}),{data_GDPpcLoIncCsPPPIntlUSDof2017Abs_min; data_GDPpcLoIncCsPPPIntlUSDof2017Abs_max; data_GDPpcLoIncCsPPPIntlUSDof2017Abs_range; stripe_GDPpcLoIncCsPPPIntlUSDof2017Abs_range; data_GDPpcLoIncCsPPPIntlUSDof2017Abs_mean; data_GDPpcLoIncCsPPPIntlUSDof2017Abs_median; data_GDPpcLoIncCsPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcLoIncCsPPPIntlUSDof2017Abs,'tabGDPpcLoIncCsUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_min = min(dldata_GDPpcLoIncCsPPPIntlUSDof2017);
dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_max = max(dldata_GDPpcLoIncCsPPPIntlUSDof2017);
dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_range = dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_max - dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcLoIncCsPPPIntlUSDof2017Abs_range = dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcLoIncCsPPPIntlUSDof2017);
dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_median = median(dldata_GDPpcLoIncCsPPPIntlUSDof2017);
%dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcLoIncCsPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_std = std(dldata_GDPpcLoIncCsPPPIntlUSDof2017);

tabdlGDPpcLoIncCsPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_min';'dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_max';'dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcLoIncCsPPPIntlUSDof2017Abs_range';'dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_mean';'dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_min; dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_max; dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_range; stripe_GDPpcLoIncCsPPPIntlUSDof2017Abs_range; dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_mean; dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_median; dldata_GDPpcLoIncCsPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcLoIncCsPPPIntlUSDof2017Abs,'tabdlGDPpcLoIncCsUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the LoIncCs CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig36 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcLoIncCsMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average CO2 Emissions in the Low-Income Countries per capita for 1990-2020');
title('Low-Income Cs');

saveas(gcf,'CO2LoIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2LoIncCspcAbs.png')
saveas(gcf,'CO2LoIncCspcAbs.epsc')

CO2LoIncCspcAbs = imread('CO2LoIncCspcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig37 = figure
plot(ticksCO2,data_CO2pcLoIncCsMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average low-income countries CO2 emissions pc, in metric tons')
title('Average Low-Income Countries CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcLoIncCsMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcLoIncCsMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcLoIncCsMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig38 = figure
plot(ticksdlCO2,dldata_CO2pcLoIncCsMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of average low-income countries CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Average Low-Income Countries CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcLoIncCsMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcLoIncCsMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcLoIncCsMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig39 = figure
histogram(data_CO2pcLoIncCsMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average Low-Income Countries CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcLoIncCsMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcLoIncCsMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcLoIncCsMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig40 = figure
histogram(dldata_CO2pcLoIncCsMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Average Low-Income Countries CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcLoIncCsMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcLoIncCsMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcLoIncCsMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcLoIncCsMetricTonsAbs_min = min(data_CO2pcLoIncCsMetricTons)
data_CO2pcLoIncCsMetricTonsAbs_max = max(data_CO2pcLoIncCsMetricTons)
data_CO2pcLoIncCsMetricTonsAbs_range = data_CO2pcLoIncCsMetricTonsAbs_max - data_CO2pcLoIncCsMetricTonsAbs_min
stripe_CO2pcLoIncCsMetricTonsAbs_range = data_CO2pcLoIncCsMetricTonsAbs_range/16
data_CO2pcLoIncCsMetricTonsAbs_mean = mean(data_CO2pcLoIncCsMetricTons)
data_CO2pcLoIncCsMetricTonsAbs_median = median(data_CO2pcLoIncCsMetricTons)
%data_CO2pcLoIncCsMetricTonsAbs_mode = mode(data_CO2pcLoIncCsMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcLoIncCsMetricTonsAbs_std = std(data_CO2pcLoIncCsMetricTons);

tabCO2pcLoIncCsMetricTonsAbs = table(categorical({'data_CO2pcLoIncCsMetricTonsAbs_min';'data_CO2pcLoIncCsMetricTonsAbs_max';'data_CO2pcLoIncCsMetricTons_range';'stripe_CO2pcLoIncCsMetricTonsAbs_range';'data_CO2pcLoIncCsMetricTonsAbs_mean';'data_CO2pcLoIncCsMetricTonsAbs_median';'data_CO2pcLoIncCsMetricTonsAbs_std'}),{data_CO2pcLoIncCsMetricTonsAbs_min; data_CO2pcLoIncCsMetricTonsAbs_max; data_CO2pcLoIncCsMetricTonsAbs_range; stripe_CO2pcLoIncCsMetricTonsAbs_range; data_CO2pcLoIncCsMetricTonsAbs_mean; data_CO2pcLoIncCsMetricTonsAbs_median; data_CO2pcLoIncCsMetricTonsAbs_std})
writetable(tabCO2pcLoIncCsMetricTonsAbs,'tabCO2pcLoIncCsMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcLoIncCsMetricTonsAbs_min = min(dldata_CO2pcLoIncCsMetricTons);
dldata_CO2pcLoIncCsMetricTonsAbs_max = max(dldata_CO2pcLoIncCsMetricTons);
dldata_CO2pcLoIncCsMetricTonsAbs_range = dldata_CO2pcLoIncCsMetricTonsAbs_max - dldata_CO2pcLoIncCsMetricTonsAbs_min;
dlstripe_CO2pcLoIncCsMetricTonsAbs_range = dldata_CO2pcLoIncCsMetricTonsAbs_range/16;
dldata_CO2pcLoIncCsMetricTonsAbs_mean = mean(dldata_CO2pcLoIncCsMetricTons);
dldata_CO2pcLoIncCsMetricTonsAbs_median = median(dldata_CO2pcLoIncCsMetricTons);
%dldata_CO2pcLoIncCsMetricTonsAbs_mode = mode(dldata_CO2pcLoIncCsMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcLoIncCsMetricTonsAbs_std = std(dldata_CO2pcLoIncCsMetricTons);

tabdlCO2pcLoIncCsMetricTonsAbs = table(categorical({'data_CO2pcLoIncCsMetricTonsAbs_min';'data_CO2pcLoIncCsMetricTonsAbs_max';'data_CO2pcLoIncCsMetricTons_range';'stripe_CO2pcLoIncCsMetricTonsAbs_range';'data_CO2pcLoIncCsMetricTonsAbs_mean';'data_CO2pcLoIncCsMetricTonsAbs_median'; 'dldata_CO2pcLoIncCsMetricTonsAbs_std'}),{data_CO2pcLoIncCsMetricTonsAbs_min; data_CO2pcLoIncCsMetricTonsAbs_max; data_CO2pcLoIncCsMetricTonsAbs_range; stripe_CO2pcLoIncCsMetricTonsAbs_range; data_CO2pcLoIncCsMetricTonsAbs_mean; data_CO2pcLoIncCsMetricTonsAbs_median; dldata_CO2pcLoIncCsMetricTonsAbs_std})
writetable(tabdlCO2pcLoIncCsMetricTonsAbs,'tabdlCO2pcLoIncCsMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the LoIncCs Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig41 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average Low-Income Countries Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Low-Income Cs');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.epsc')

CO2LoIncCspcAbs = imread('CO2LoIncCspcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig42 = figure
plot(ticksGreenProspGDP,data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average low-income countries greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Average Low-Income Countries Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.epsc')


%% Plot - growth rates

fig43 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of average low-income countries greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Average Low-Income Countries Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.epsc')


%% Histogram - absolute level

fig44 = figure
histogram(data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average Low-Income Countries Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017LoIncCspcAbs.epsc')

%% Histogram - growth rates

fig45 = figure
histogram(dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Average Low-Income Countries Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017LoIncCsAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017LoIncCsAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017LoIncCsAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcLoIncCsDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcLoIncCsDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcLoIncCsDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% United States - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcUSPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI256:BM256');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcUSPPPIntlUSDof2017 = log(data_GDPpcUSPPPIntlUSDof2017);
dldata_GDPpcUSPPPIntlUSDof2017 = diff(ldata_GDPpcUSPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcUSMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI256:BM256');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcUSMetricTons = log(data_CO2pcUSMetricTons);
dldata_CO2pcUSMetricTons = diff(ldata_CO2pcUSMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017 = data_GDPpcUSPPPIntlUSDof2017 ./ data_CO2pcUSMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the US GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig46 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcUSPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('US GDP per capita in PPP International USD of 2017 for 1990-1990');
title('US');

saveas(gcf,'GDPUSpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPUSpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPUSpcPPPIntlUSDof2017Abs.epsc')

GDPUSpcDev = imread('GDPUSpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig47 = figure
plot(ticksGDP,data_GDPpcUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('US GDP per capita in PPP international USD of 2017')
title('US GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcUSPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig48 = figure
plot(ticksdlGDP,dldata_GDPpcUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of US GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of US GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcUSPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig49 = figure
histogram(data_GDPpcUSPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('US GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcUSPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig50 = figure
histogram(dldata_GDPpcUSPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of US GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcUSPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcUSPPPIntlUSDof2017Abs_min = min(data_GDPpcUSPPPIntlUSDof2017)
data_GDPpcUSPPPIntlUSDof2017Abs_max = max(data_GDPpcUSPPPIntlUSDof2017)
data_GDPpcUSPPPIntlUSDof2017Abs_range = data_GDPpcUSPPPIntlUSDof2017Abs_max - data_GDPpcUSPPPIntlUSDof2017Abs_min
stripe_GDPpcUSPPPIntlUSDof2017Abs_range = data_GDPpcUSPPPIntlUSDof2017Abs_range/16
data_GDPpcUSPPPIntlUSDof2017Abs_mean = mean(data_GDPpcUSPPPIntlUSDof2017)
data_GDPpcUSPPPIntlUSDof2017Abs_median = median(data_GDPpcUSPPPIntlUSDof2017)
%data_GDPpcUSPPPIntlUSDof2017Abs_mode = mode(data_GDPpcUSPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcUSPPPIntlUSDof2017Abs_std = std(data_GDPpcUSPPPIntlUSDof2017);

tabGDPpcUSPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcUSPPPIntlUSDof2017Abs_min';'data_GDPpcUSPPPIntlUSDof2017Abs_max';'data_GDPpcUSPPPIntlUSDof2017Abs_range';'stripe_GDPpcUSPPPIntlUSDof2017Abs_range';'data_GDPpcUSPPPIntlUSDof2017Abs_mean';'data_GDPpcUSPPPIntlUSDof2017Abs_median';'data_GDPpcUSPPPIntlUSDof2017Abs_std'}),{data_GDPpcUSPPPIntlUSDof2017Abs_min; data_GDPpcUSPPPIntlUSDof2017Abs_max; data_GDPpcUSPPPIntlUSDof2017Abs_range; stripe_GDPpcUSPPPIntlUSDof2017Abs_range; data_GDPpcUSPPPIntlUSDof2017Abs_mean; data_GDPpcUSPPPIntlUSDof2017Abs_median; data_GDPpcUSPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcUSPPPIntlUSDof2017Abs,'tabGDPpcUSUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcUSPPPIntlUSDof2017Abs_min = min(dldata_GDPpcUSPPPIntlUSDof2017);
dldata_GDPpcUSPPPIntlUSDof2017Abs_max = max(dldata_GDPpcUSPPPIntlUSDof2017);
dldata_GDPpcUSPPPIntlUSDof2017Abs_range = dldata_GDPpcUSPPPIntlUSDof2017Abs_max - dldata_GDPpcUSPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcUSPPPIntlUSDof2017Abs_range = dldata_GDPpcUSPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcUSPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcUSPPPIntlUSDof2017);
dldata_GDPpcUSPPPIntlUSDof2017Abs_median = median(dldata_GDPpcUSPPPIntlUSDof2017);
%dldata_GDPpcUSPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcUSPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcUSPPPIntlUSDof2017Abs_std = std(dldata_GDPpcUSPPPIntlUSDof2017);

tabdlGDPpcUSPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcUSPPPIntlUSDof2017Abs_min';'dldata_GDPpcUSPPPIntlUSDof2017Abs_max';'dldata_GDPpcUSPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcUSPPPIntlUSDof2017Abs_range';'dldata_GDPpcUSPPPIntlUSDof2017Abs_mean';'dldata_GDPpcUSPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcUSPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcUSPPPIntlUSDof2017Abs_min; dldata_GDPpcUSPPPIntlUSDof2017Abs_max; dldata_GDPpcUSPPPIntlUSDof2017Abs_range; stripe_GDPpcUSPPPIntlUSDof2017Abs_range; dldata_GDPpcUSPPPIntlUSDof2017Abs_mean; dldata_GDPpcUSPPPIntlUSDof2017Abs_median; dldata_GDPpcUSPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcUSPPPIntlUSDof2017Abs,'tabdlGDPpcUSUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the US CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig51 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcUSMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the US per capita for 1990-2020');
title('US');

saveas(gcf,'CO2USpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2USpcAbs.png')
saveas(gcf,'CO2USpcAbs.epsc')

CO2USpcAbs = imread('CO2USpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig52 = figure
plot(ticksCO2,data_CO2pcUSMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('US CO2 emissions pc, in metric tons')
title('US CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcUSMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcUSMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig53 = figure
plot(ticksdlCO2,dldata_CO2pcUSMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of US CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of US CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcUSMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcUSMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig54 = figure
histogram(data_CO2pcUSMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('US CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcUSMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcUSMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig55 = figure
histogram(dldata_CO2pcUSMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of US CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcUSMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcUSMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcUSMetricTonsAbs_min = min(data_CO2pcUSMetricTons)
data_CO2pcUSMetricTonsAbs_max = max(data_CO2pcUSMetricTons)
data_CO2pcUSMetricTonsAbs_range = data_CO2pcUSMetricTonsAbs_max - data_CO2pcUSMetricTonsAbs_min
stripe_CO2pcUSMetricTonsAbs_range = data_CO2pcUSMetricTonsAbs_range/16
data_CO2pcUSMetricTonsAbs_mean = mean(data_CO2pcUSMetricTons)
data_CO2pcUSMetricTonsAbs_median = median(data_CO2pcUSMetricTons)
%data_CO2pcUSMetricTonsAbs_mode = mode(data_CO2pcUSMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcUSMetricTonsAbs_std = std(data_CO2pcUSMetricTons);

tabCO2pcUSMetricTonsAbs = table(categorical({'data_CO2pcUSMetricTonsAbs_min';'data_CO2pcUSMetricTonsAbs_max';'data_CO2pcUSMetricTons_range';'stripe_CO2pcUSMetricTonsAbs_range';'data_CO2pcUSMetricTonsAbs_mean';'data_CO2pcUSMetricTonsAbs_median';'data_CO2pcUSMetricTonsAbs_std'}),{data_CO2pcUSMetricTonsAbs_min; data_CO2pcUSMetricTonsAbs_max; data_CO2pcUSMetricTonsAbs_range; stripe_CO2pcUSMetricTonsAbs_range; data_CO2pcUSMetricTonsAbs_mean; data_CO2pcUSMetricTonsAbs_median; data_CO2pcUSMetricTonsAbs_std})
writetable(tabCO2pcUSMetricTonsAbs,'tabCO2pcUSMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcUSMetricTonsAbs_min = min(dldata_CO2pcUSMetricTons);
dldata_CO2pcUSMetricTonsAbs_max = max(dldata_CO2pcUSMetricTons);
dldata_CO2pcUSMetricTonsAbs_range = dldata_CO2pcUSMetricTonsAbs_max - dldata_CO2pcUSMetricTonsAbs_min;
dlstripe_CO2pcUSMetricTonsAbs_range = dldata_CO2pcUSMetricTonsAbs_range/16;
dldata_CO2pcUSMetricTonsAbs_mean = mean(dldata_CO2pcUSMetricTons);
dldata_CO2pcUSMetricTonsAbs_median = median(dldata_CO2pcUSMetricTons);
%dldata_CO2pcUSMetricTonsAbs_mode = mode(dldata_CO2pcUSMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcUSMetricTonsAbs_std = std(dldata_CO2pcUSMetricTons);

tabdlCO2pcUSMetricTonsAbs = table(categorical({'data_CO2pcUSMetricTonsAbs_min';'data_CO2pcUSMetricTonsAbs_max';'data_CO2pcUSMetricTons_range';'stripe_CO2pcUSMetricTonsAbs_range';'data_CO2pcUSMetricTonsAbs_mean';'data_CO2pcUSMetricTonsAbs_median'; 'dldata_CO2pcUSMetricTonsAbs_std'}),{data_CO2pcUSMetricTonsAbs_min; data_CO2pcUSMetricTonsAbs_max; data_CO2pcUSMetricTonsAbs_range; stripe_CO2pcUSMetricTonsAbs_range; data_CO2pcUSMetricTonsAbs_mean; data_CO2pcUSMetricTonsAbs_median; dldata_CO2pcUSMetricTonsAbs_std})
writetable(tabdlCO2pcUSMetricTonsAbs,'tabdlCO2pcUSMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the US Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig56 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('US Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('US');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017USpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017USpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017USpcAbs.epsc')

CO2USpcAbs = imread('CO2USpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig57 = figure
plot(ticksGreenProspGDP,data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('US greening prosperity ratio pc (GDP pc / CO2 pc)')
title('US Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017USpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017USpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017USpcAbs.epsc')

%% Plot - growth rates

fig58 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of US greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of US Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017USpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017USpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017USpcAbs.epsc')


%% Histogram - absolute level

fig59 = figure
histogram(data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('US Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017USpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017USpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017USpcAbs.epsc')

%% Histogram - growth rates

fig60 = figure
histogram(dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of US Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017USAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017USAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017USAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcUSDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcUSDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcUSDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcUSDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mozambique - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcMOZPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI170:BM170');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcMOZPPPIntlUSDof2017 = log(data_GDPpcMOZPPPIntlUSDof2017);
dldata_GDPpcMOZPPPIntlUSDof2017 = diff(ldata_GDPpcMOZPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcMOZMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI170:BM170');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcMOZMetricTons = log(data_CO2pcMOZMetricTons);
dldata_CO2pcMOZMetricTons = diff(ldata_CO2pcMOZMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017 = data_GDPpcMOZPPPIntlUSDof2017 ./ data_CO2pcMOZMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the MOZ GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig61 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcMOZPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Mozambique GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Mozambique');

saveas(gcf,'GDPMOZpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPMOZpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPMOZpcPPPIntlUSDof2017Abs.epsc')

GDPMOZpcDev = imread('GDPMOZpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig62 = figure
plot(ticksGDP,data_GDPpcMOZPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Mozambique GDP per capita in PPP international USD of 2017')
title('Mozambique GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig63 = figure
plot(ticksdlGDP,dldata_GDPpcMOZPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Mozambique GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Mozambique GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig64 = figure
histogram(data_GDPpcMOZPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Mozambique GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig65 = figure
histogram(dldata_GDPpcMOZPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Mozambique GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcMOZPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcMOZPPPIntlUSDof2017Abs_min = min(data_GDPpcMOZPPPIntlUSDof2017)
data_GDPpcMOZPPPIntlUSDof2017Abs_max = max(data_GDPpcMOZPPPIntlUSDof2017)
data_GDPpcMOZPPPIntlUSDof2017Abs_range = data_GDPpcMOZPPPIntlUSDof2017Abs_max - data_GDPpcMOZPPPIntlUSDof2017Abs_min
stripe_GDPpcMOZPPPIntlUSDof2017Abs_range = data_GDPpcMOZPPPIntlUSDof2017Abs_range/16
data_GDPpcMOZPPPIntlUSDof2017Abs_mean = mean(data_GDPpcMOZPPPIntlUSDof2017)
data_GDPpcMOZPPPIntlUSDof2017Abs_median = median(data_GDPpcMOZPPPIntlUSDof2017)
%data_GDPpcMOZPPPIntlUSDof2017Abs_mode = mode(data_GDPpcMOZPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcMOZPPPIntlUSDof2017Abs_std = std(data_GDPpcMOZPPPIntlUSDof2017);

tabGDPpcMOZPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcMOZPPPIntlUSDof2017Abs_min';'data_GDPpcMOZPPPIntlUSDof2017Abs_max';'data_GDPpcMOZPPPIntlUSDof2017Abs_range';'stripe_GDPpcMOZPPPIntlUSDof2017Abs_range';'data_GDPpcMOZPPPIntlUSDof2017Abs_mean';'data_GDPpcMOZPPPIntlUSDof2017Abs_median';'data_GDPpcMOZPPPIntlUSDof2017Abs_std'}),{data_GDPpcMOZPPPIntlUSDof2017Abs_min; data_GDPpcMOZPPPIntlUSDof2017Abs_max; data_GDPpcMOZPPPIntlUSDof2017Abs_range; stripe_GDPpcMOZPPPIntlUSDof2017Abs_range; data_GDPpcMOZPPPIntlUSDof2017Abs_mean; data_GDPpcMOZPPPIntlUSDof2017Abs_median; data_GDPpcMOZPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcMOZPPPIntlUSDof2017Abs,'tabGDPpcMOZUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcMOZPPPIntlUSDof2017Abs_min = min(dldata_GDPpcMOZPPPIntlUSDof2017);
dldata_GDPpcMOZPPPIntlUSDof2017Abs_max = max(dldata_GDPpcMOZPPPIntlUSDof2017);
dldata_GDPpcMOZPPPIntlUSDof2017Abs_range = dldata_GDPpcMOZPPPIntlUSDof2017Abs_max - dldata_GDPpcMOZPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcMOZPPPIntlUSDof2017Abs_range = dldata_GDPpcMOZPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcMOZPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcMOZPPPIntlUSDof2017);
dldata_GDPpcMOZPPPIntlUSDof2017Abs_median = median(dldata_GDPpcMOZPPPIntlUSDof2017);
%dldata_GDPpcMOZPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcMOZPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcMOZPPPIntlUSDof2017Abs_std = std(dldata_GDPpcMOZPPPIntlUSDof2017);

tabdlGDPpcMOZPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcMOZPPPIntlUSDof2017Abs_min';'dldata_GDPpcMOZPPPIntlUSDof2017Abs_max';'dldata_GDPpcMOZPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcMOZPPPIntlUSDof2017Abs_range';'dldata_GDPpcMOZPPPIntlUSDof2017Abs_mean';'dldata_GDPpcMOZPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcMOZPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcMOZPPPIntlUSDof2017Abs_min; dldata_GDPpcMOZPPPIntlUSDof2017Abs_max; dldata_GDPpcMOZPPPIntlUSDof2017Abs_range; stripe_GDPpcMOZPPPIntlUSDof2017Abs_range; dldata_GDPpcMOZPPPIntlUSDof2017Abs_mean; dldata_GDPpcMOZPPPIntlUSDof2017Abs_median; dldata_GDPpcMOZPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcMOZPPPIntlUSDof2017Abs,'tabdlGDPpcMOZUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the MOZ CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig66 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcMOZMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Mozambique per capita for 1990-2020');
title('Mozambique');

saveas(gcf,'CO2MOZpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2MOZpcAbs.png')
saveas(gcf,'CO2MOZpcAbs.epsc')

CO2MOZpcAbs = imread('CO2MOZpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig67 = figure
plot(ticksCO2,data_CO2pcMOZMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Mozambique CO2 emissions pc, in metric tons')
title('Mozambique CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcMOZMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcMOZMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcMOZMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig68 = figure
plot(ticksdlCO2,dldata_CO2pcMOZMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Mozambique CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Mozambique CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcMOZMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcMOZMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcMOZMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig69 = figure
histogram(data_CO2pcMOZMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Mozambique CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcMOZMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcMOZMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcMOZMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig70 = figure
histogram(dldata_CO2pcMOZMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Mozambique CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcMOZMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcMOZMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcMOZMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcMOZMetricTonsAbs_min = min(data_CO2pcMOZMetricTons)
data_CO2pcMOZMetricTonsAbs_max = max(data_CO2pcMOZMetricTons)
data_CO2pcMOZMetricTonsAbs_range = data_CO2pcMOZMetricTonsAbs_max - data_CO2pcMOZMetricTonsAbs_min
stripe_CO2pcMOZMetricTonsAbs_range = data_CO2pcMOZMetricTonsAbs_range/16
data_CO2pcMOZMetricTonsAbs_mean = mean(data_CO2pcMOZMetricTons)
data_CO2pcMOZMetricTonsAbs_median = median(data_CO2pcMOZMetricTons)
%data_CO2pcMOZMetricTonsAbs_mode = mode(data_CO2pcMOZMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcMOZMetricTonsAbs_std = std(data_CO2pcMOZMetricTons);

tabCO2pcMOZMetricTonsAbs = table(categorical({'data_CO2pcMOZMetricTonsAbs_min';'data_CO2pcMOZMetricTonsAbs_max';'data_CO2pcMOZMetricTons_range';'stripe_CO2pcMOZMetricTonsAbs_range';'data_CO2pcMOZMetricTonsAbs_mean';'data_CO2pcMOZMetricTonsAbs_median';'data_CO2pcMOZMetricTonsAbs_std'}),{data_CO2pcMOZMetricTonsAbs_min; data_CO2pcMOZMetricTonsAbs_max; data_CO2pcMOZMetricTonsAbs_range; stripe_CO2pcMOZMetricTonsAbs_range; data_CO2pcMOZMetricTonsAbs_mean; data_CO2pcMOZMetricTonsAbs_median; data_CO2pcMOZMetricTonsAbs_std})
writetable(tabCO2pcMOZMetricTonsAbs,'tabCO2pcMOZMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcMOZMetricTonsAbs_min = min(dldata_CO2pcMOZMetricTons);
dldata_CO2pcMOZMetricTonsAbs_max = max(dldata_CO2pcMOZMetricTons);
dldata_CO2pcMOZMetricTonsAbs_range = dldata_CO2pcMOZMetricTonsAbs_max - dldata_CO2pcMOZMetricTonsAbs_min;
dlstripe_CO2pcMOZMetricTonsAbs_range = dldata_CO2pcMOZMetricTonsAbs_range/16;
dldata_CO2pcMOZMetricTonsAbs_mean = mean(dldata_CO2pcMOZMetricTons);
dldata_CO2pcMOZMetricTonsAbs_median = median(dldata_CO2pcMOZMetricTons);
%dldata_CO2pcMOZMetricTonsAbs_mode = mode(dldata_CO2pcMOZMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcMOZMetricTonsAbs_std = std(dldata_CO2pcMOZMetricTons);

tabdlCO2pcMOZMetricTonsAbs = table(categorical({'data_CO2pcMOZMetricTonsAbs_min';'data_CO2pcMOZMetricTonsAbs_max';'data_CO2pcMOZMetricTons_range';'stripe_CO2pcMOZMetricTonsAbs_range';'data_CO2pcMOZMetricTonsAbs_mean';'data_CO2pcMOZMetricTonsAbs_median'; 'dldata_CO2pcMOZMetricTonsAbs_std'}),{data_CO2pcMOZMetricTonsAbs_min; data_CO2pcMOZMetricTonsAbs_max; data_CO2pcMOZMetricTonsAbs_range; stripe_CO2pcMOZMetricTonsAbs_range; data_CO2pcMOZMetricTonsAbs_mean; data_CO2pcMOZMetricTonsAbs_median; dldata_CO2pcMOZMetricTonsAbs_std})
writetable(tabdlCO2pcMOZMetricTonsAbs,'tabdlCO2pcMOZMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the MOZ Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig71 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Mozambique Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Mozambique');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017MOZpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017MOZpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017MOZpcAbs.epsc')

CO2MOZpcAbs = imread('CO2MOZpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig72 = figure
plot(ticksGreenProspGDP,data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Mozambique greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Mozambique Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017MOZpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017MOZpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017MOZpcAbs.epsc')

%% Plot - growth rates

fig73 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Mozambique greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Mozambique Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017MOZpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017MOZpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017MOZpcAbs.epsc')


%% Histogram - absolute level

fig74 = figure
histogram(data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Mozambique Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017MOZpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017MOZpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017MOZpcAbs.epsc')

%% Histogram - growth rates

fig75 = figure
histogram(dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Mozambique Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017MOZAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017MOZAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017MOZAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcMOZDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcMOZDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcMOZDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcMOZDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% United Kingdom - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcUKPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI86:BM86');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcUKPPPIntlUSDof2017 = log(data_GDPpcUKPPPIntlUSDof2017);
dldata_GDPpcUKPPPIntlUSDof2017 = diff(ldata_GDPpcUKPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcUKMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI86:BM86');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcUKMetricTons = log(data_CO2pcUKMetricTons);
dldata_CO2pcUKMetricTons = diff(ldata_CO2pcUKMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017 = data_GDPpcUKPPPIntlUSDof2017 ./ data_CO2pcUKMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the UK GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig76 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcUKPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('UK GDP per capita in PPP International USD of 2017 for 1990-1990');
title('UK');

saveas(gcf,'GDPUKpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPUKpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPUKpcPPPIntlUSDof2017Abs.epsc')

GDPUKpcDev = imread('GDPUKpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig77 = figure
plot(ticksGDP,data_GDPpcUKPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('UK GDP per capita in PPP international USD of 2017')
title('UK GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcUKPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcUKPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcUKPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig78 = figure
plot(ticksdlGDP,dldata_GDPpcUKPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of UK GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of UK GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcUKPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcUKPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcUKPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig79 = figure
histogram(data_GDPpcUKPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('UK GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcUKPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcUKPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcUKPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig80 = figure
histogram(dldata_GDPpcUKPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of UK GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcUKPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcUKPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcUKPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcUKPPPIntlUSDof2017Abs_min = min(data_GDPpcUKPPPIntlUSDof2017)
data_GDPpcUKPPPIntlUSDof2017Abs_max = max(data_GDPpcUKPPPIntlUSDof2017)
data_GDPpcUKPPPIntlUSDof2017Abs_range = data_GDPpcUKPPPIntlUSDof2017Abs_max - data_GDPpcUKPPPIntlUSDof2017Abs_min
stripe_GDPpcUKPPPIntlUSDof2017Abs_range = data_GDPpcUKPPPIntlUSDof2017Abs_range/16
data_GDPpcUKPPPIntlUSDof2017Abs_mean = mean(data_GDPpcUKPPPIntlUSDof2017)
data_GDPpcUKPPPIntlUSDof2017Abs_median = median(data_GDPpcUKPPPIntlUSDof2017)
%data_GDPpcUKPPPIntlUSDof2017Abs_mode = mode(data_GDPpcUKPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcUKPPPIntlUSDof2017Abs_std = std(data_GDPpcUKPPPIntlUSDof2017);

tabGDPpcUKPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcUKPPPIntlUSDof2017Abs_min';'data_GDPpcUKPPPIntlUSDof2017Abs_max';'data_GDPpcUKPPPIntlUSDof2017Abs_range';'stripe_GDPpcUKPPPIntlUSDof2017Abs_range';'data_GDPpcUKPPPIntlUSDof2017Abs_mean';'data_GDPpcUKPPPIntlUSDof2017Abs_median';'data_GDPpcUKPPPIntlUSDof2017Abs_std'}),{data_GDPpcUKPPPIntlUSDof2017Abs_min; data_GDPpcUKPPPIntlUSDof2017Abs_max; data_GDPpcUKPPPIntlUSDof2017Abs_range; stripe_GDPpcUKPPPIntlUSDof2017Abs_range; data_GDPpcUKPPPIntlUSDof2017Abs_mean; data_GDPpcUKPPPIntlUSDof2017Abs_median; data_GDPpcUKPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcUKPPPIntlUSDof2017Abs,'tabGDPpcUKUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcUKPPPIntlUSDof2017Abs_min = min(dldata_GDPpcUKPPPIntlUSDof2017);
dldata_GDPpcUKPPPIntlUSDof2017Abs_max = max(dldata_GDPpcUKPPPIntlUSDof2017);
dldata_GDPpcUKPPPIntlUSDof2017Abs_range = dldata_GDPpcUKPPPIntlUSDof2017Abs_max - dldata_GDPpcUKPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcUKPPPIntlUSDof2017Abs_range = dldata_GDPpcUKPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcUKPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcUKPPPIntlUSDof2017);
dldata_GDPpcUKPPPIntlUSDof2017Abs_median = median(dldata_GDPpcUKPPPIntlUSDof2017);
%dldata_GDPpcUKPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcUKPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcUKPPPIntlUSDof2017Abs_std = std(dldata_GDPpcUKPPPIntlUSDof2017);

tabdlGDPpcUKPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcUKPPPIntlUSDof2017Abs_min';'dldata_GDPpcUKPPPIntlUSDof2017Abs_max';'dldata_GDPpcUKPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcUKPPPIntlUSDof2017Abs_range';'dldata_GDPpcUKPPPIntlUSDof2017Abs_mean';'dldata_GDPpcUKPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcUKPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcUKPPPIntlUSDof2017Abs_min; dldata_GDPpcUKPPPIntlUSDof2017Abs_max; dldata_GDPpcUKPPPIntlUSDof2017Abs_range; stripe_GDPpcUKPPPIntlUSDof2017Abs_range; dldata_GDPpcUKPPPIntlUSDof2017Abs_mean; dldata_GDPpcUKPPPIntlUSDof2017Abs_median; dldata_GDPpcUKPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcUKPPPIntlUSDof2017Abs,'tabdlGDPpcUKUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the UK CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig81 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcUKMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the UK per capita for 1990-2020');
title('UK');

saveas(gcf,'CO2UKpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2UKpcAbs.png')
saveas(gcf,'CO2UKpcAbs.epsc')

CO2UKpcAbs = imread('CO2UKpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig82 = figure
plot(ticksCO2,data_CO2pcUKMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('UK CO2 emissions pc, in metric tons')
title('UK CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcUKMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcUKMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcUKMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig83 = figure
plot(ticksdlCO2,dldata_CO2pcUKMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of UK CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of UK CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcUKMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcUKMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcUKMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig84 = figure
histogram(data_CO2pcUKMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('UK CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcUKMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcUKMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcUKMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig85 = figure
histogram(dldata_CO2pcUKMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of UK CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcUKMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcUKMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcUKMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcUKMetricTonsAbs_min = min(data_CO2pcUKMetricTons)
data_CO2pcUKMetricTonsAbs_max = max(data_CO2pcUKMetricTons)
data_CO2pcUKMetricTonsAbs_range = data_CO2pcUKMetricTonsAbs_max - data_CO2pcUKMetricTonsAbs_min
stripe_CO2pcUKMetricTonsAbs_range = data_CO2pcUKMetricTonsAbs_range/16
data_CO2pcUKMetricTonsAbs_mean = mean(data_CO2pcUKMetricTons)
data_CO2pcUKMetricTonsAbs_median = median(data_CO2pcUKMetricTons)
%data_CO2pcUKMetricTonsAbs_mode = mode(data_CO2pcUKMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcUKMetricTonsAbs_std = std(data_CO2pcUKMetricTons);

tabCO2pcUKMetricTonsAbs = table(categorical({'data_CO2pcUKMetricTonsAbs_min';'data_CO2pcUKMetricTonsAbs_max';'data_CO2pcUKMetricTons_range';'stripe_CO2pcUKMetricTonsAbs_range';'data_CO2pcUKMetricTonsAbs_mean';'data_CO2pcUKMetricTonsAbs_median';'data_CO2pcUKMetricTonsAbs_std'}),{data_CO2pcUKMetricTonsAbs_min; data_CO2pcUKMetricTonsAbs_max; data_CO2pcUKMetricTonsAbs_range; stripe_CO2pcUKMetricTonsAbs_range; data_CO2pcUKMetricTonsAbs_mean; data_CO2pcUKMetricTonsAbs_median; data_CO2pcUKMetricTonsAbs_std})
writetable(tabCO2pcUKMetricTonsAbs,'tabCO2pcUKMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcUKMetricTonsAbs_min = min(dldata_CO2pcUKMetricTons);
dldata_CO2pcUKMetricTonsAbs_max = max(dldata_CO2pcUKMetricTons);
dldata_CO2pcUKMetricTonsAbs_range = dldata_CO2pcUKMetricTonsAbs_max - dldata_CO2pcUKMetricTonsAbs_min;
dlstripe_CO2pcUKMetricTonsAbs_range = dldata_CO2pcUKMetricTonsAbs_range/16;
dldata_CO2pcUKMetricTonsAbs_mean = mean(dldata_CO2pcUKMetricTons);
dldata_CO2pcUKMetricTonsAbs_median = median(dldata_CO2pcUKMetricTons);
%dldata_CO2pcUKMetricTonsAbs_mode = mode(dldata_CO2pcUKMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcUKMetricTonsAbs_std = std(dldata_CO2pcUKMetricTons);

tabdlCO2pcUKMetricTonsAbs = table(categorical({'data_CO2pcUKMetricTonsAbs_min';'data_CO2pcUKMetricTonsAbs_max';'data_CO2pcUKMetricTons_range';'stripe_CO2pcUKMetricTonsAbs_range';'data_CO2pcUKMetricTonsAbs_mean';'data_CO2pcUKMetricTonsAbs_median'; 'dldata_CO2pcUKMetricTonsAbs_std'}),{data_CO2pcUKMetricTonsAbs_min; data_CO2pcUKMetricTonsAbs_max; data_CO2pcUKMetricTonsAbs_range; stripe_CO2pcUKMetricTonsAbs_range; data_CO2pcUKMetricTonsAbs_mean; data_CO2pcUKMetricTonsAbs_median; dldata_CO2pcUKMetricTonsAbs_std})
writetable(tabdlCO2pcUKMetricTonsAbs,'tabdlCO2pcUKMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the UK Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig86 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('UK Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('UK');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017UKpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017UKpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017UKpcAbs.epsc')

CO2UKpcAbs = imread('CO2UKpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig87 = figure
plot(ticksGreenProspGDP,data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('UK greening prosperity ratio pc (GDP pc / CO2 pc)')
title('UK Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017UKpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017UKpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017UKpcAbs.epsc')

%% Plot - growth rates

fig88 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of UK greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of UK Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017UKpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017UKpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017UKpcAbs.epsc')


%% Histogram - absolute level

fig89 = figure
histogram(data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('UK Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017UKpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017UKpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017UKpcAbs.epsc')

%% Histogram - growth rates

fig90 = figure
histogram(dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of UK Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017UKAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017UKAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017UKAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcUKDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcUKDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcUKDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcUKDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% China - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcCHNPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI45:BM45');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcCHNPPPIntlUSDof2017 = log(data_GDPpcCHNPPPIntlUSDof2017);
dldata_GDPpcCHNPPPIntlUSDof2017 = diff(ldata_GDPpcCHNPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcCHNMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI45:BM45');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcCHNMetricTons = log(data_CO2pcCHNMetricTons);
dldata_CO2pcCHNMetricTons = diff(ldata_CO2pcCHNMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017 = data_GDPpcCHNPPPIntlUSDof2017 ./ data_CO2pcCHNMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the CHN GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig91 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcCHNPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('China GDP per capita in PPP International USD of 2017 for 1990-1990');
title('China');

saveas(gcf,'GDPCHNpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPCHNpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPCHNpcPPPIntlUSDof2017Abs.epsc')

GDPCHNpcDev = imread('GDPCHNpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig92 = figure
plot(ticksGDP,data_GDPpcCHNPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('China GDP per capita in PPP international USD of 2017')
title('China GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig93 = figure
plot(ticksdlGDP,dldata_GDPpcCHNPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of China GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of China GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig94 = figure
histogram(data_GDPpcCHNPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('China GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig95 = figure
histogram(dldata_GDPpcCHNPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of China GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcCHNPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcCHNPPPIntlUSDof2017Abs_min = min(data_GDPpcCHNPPPIntlUSDof2017)
data_GDPpcCHNPPPIntlUSDof2017Abs_max = max(data_GDPpcCHNPPPIntlUSDof2017)
data_GDPpcCHNPPPIntlUSDof2017Abs_range = data_GDPpcCHNPPPIntlUSDof2017Abs_max - data_GDPpcCHNPPPIntlUSDof2017Abs_min
stripe_GDPpcCHNPPPIntlUSDof2017Abs_range = data_GDPpcCHNPPPIntlUSDof2017Abs_range/16
data_GDPpcCHNPPPIntlUSDof2017Abs_mean = mean(data_GDPpcCHNPPPIntlUSDof2017)
data_GDPpcCHNPPPIntlUSDof2017Abs_median = median(data_GDPpcCHNPPPIntlUSDof2017)
%data_GDPpcCHNPPPIntlUSDof2017Abs_mode = mode(data_GDPpcCHNPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcCHNPPPIntlUSDof2017Abs_std = std(data_GDPpcCHNPPPIntlUSDof2017);

tabGDPpcCHNPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcCHNPPPIntlUSDof2017Abs_min';'data_GDPpcCHNPPPIntlUSDof2017Abs_max';'data_GDPpcCHNPPPIntlUSDof2017Abs_range';'stripe_GDPpcCHNPPPIntlUSDof2017Abs_range';'data_GDPpcCHNPPPIntlUSDof2017Abs_mean';'data_GDPpcCHNPPPIntlUSDof2017Abs_median';'data_GDPpcCHNPPPIntlUSDof2017Abs_std'}),{data_GDPpcCHNPPPIntlUSDof2017Abs_min; data_GDPpcCHNPPPIntlUSDof2017Abs_max; data_GDPpcCHNPPPIntlUSDof2017Abs_range; stripe_GDPpcCHNPPPIntlUSDof2017Abs_range; data_GDPpcCHNPPPIntlUSDof2017Abs_mean; data_GDPpcCHNPPPIntlUSDof2017Abs_median; data_GDPpcCHNPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcCHNPPPIntlUSDof2017Abs,'tabGDPpcCHNUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcCHNPPPIntlUSDof2017Abs_min = min(dldata_GDPpcCHNPPPIntlUSDof2017);
dldata_GDPpcCHNPPPIntlUSDof2017Abs_max = max(dldata_GDPpcCHNPPPIntlUSDof2017);
dldata_GDPpcCHNPPPIntlUSDof2017Abs_range = dldata_GDPpcCHNPPPIntlUSDof2017Abs_max - dldata_GDPpcCHNPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcCHNPPPIntlUSDof2017Abs_range = dldata_GDPpcCHNPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcCHNPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcCHNPPPIntlUSDof2017);
dldata_GDPpcCHNPPPIntlUSDof2017Abs_median = median(dldata_GDPpcCHNPPPIntlUSDof2017);
%dldata_GDPpcCHNPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcCHNPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcCHNPPPIntlUSDof2017Abs_std = std(dldata_GDPpcCHNPPPIntlUSDof2017);

tabdlGDPpcCHNPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcCHNPPPIntlUSDof2017Abs_min';'dldata_GDPpcCHNPPPIntlUSDof2017Abs_max';'dldata_GDPpcCHNPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcCHNPPPIntlUSDof2017Abs_range';'dldata_GDPpcCHNPPPIntlUSDof2017Abs_mean';'dldata_GDPpcCHNPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcCHNPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcCHNPPPIntlUSDof2017Abs_min; dldata_GDPpcCHNPPPIntlUSDof2017Abs_max; dldata_GDPpcCHNPPPIntlUSDof2017Abs_range; stripe_GDPpcCHNPPPIntlUSDof2017Abs_range; dldata_GDPpcCHNPPPIntlUSDof2017Abs_mean; dldata_GDPpcCHNPPPIntlUSDof2017Abs_median; dldata_GDPpcCHNPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcCHNPPPIntlUSDof2017Abs,'tabdlGDPpcCHNUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the CHN CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig96 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcCHNMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in China per capita for 1990-2020');
title('China');

saveas(gcf,'CO2CHNpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2CHNpcAbs.png')
saveas(gcf,'CO2CHNpcAbs.epsc')

CO2CHNpcAbs = imread('CO2CHNpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig97 = figure
plot(ticksCO2,data_CO2pcCHNMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('China CO2 emissions pc, in metric tons')
title('China CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcCHNMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcCHNMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcCHNMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig98 = figure
plot(ticksdlCO2,dldata_CO2pcCHNMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of China CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of China CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcCHNMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcCHNMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcCHNMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig99 = figure
histogram(data_CO2pcCHNMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('China CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcCHNMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcCHNMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcCHNMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig100 = figure
histogram(dldata_CO2pcCHNMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of China CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcCHNMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcCHNMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcCHNMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcCHNMetricTonsAbs_min = min(data_CO2pcCHNMetricTons)
data_CO2pcCHNMetricTonsAbs_max = max(data_CO2pcCHNMetricTons)
data_CO2pcCHNMetricTonsAbs_range = data_CO2pcCHNMetricTonsAbs_max - data_CO2pcCHNMetricTonsAbs_min
stripe_CO2pcCHNMetricTonsAbs_range = data_CO2pcCHNMetricTonsAbs_range/16
data_CO2pcCHNMetricTonsAbs_mean = mean(data_CO2pcCHNMetricTons)
data_CO2pcCHNMetricTonsAbs_median = median(data_CO2pcCHNMetricTons)
%data_CO2pcCHNMetricTonsAbs_mode = mode(data_CO2pcCHNMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcCHNMetricTonsAbs_std = std(data_CO2pcCHNMetricTons);

tabCO2pcCHNMetricTonsAbs = table(categorical({'data_CO2pcCHNMetricTonsAbs_min';'data_CO2pcCHNMetricTonsAbs_max';'data_CO2pcCHNMetricTons_range';'stripe_CO2pcCHNMetricTonsAbs_range';'data_CO2pcCHNMetricTonsAbs_mean';'data_CO2pcCHNMetricTonsAbs_median';'data_CO2pcCHNMetricTonsAbs_std'}),{data_CO2pcCHNMetricTonsAbs_min; data_CO2pcCHNMetricTonsAbs_max; data_CO2pcCHNMetricTonsAbs_range; stripe_CO2pcCHNMetricTonsAbs_range; data_CO2pcCHNMetricTonsAbs_mean; data_CO2pcCHNMetricTonsAbs_median; data_CO2pcCHNMetricTonsAbs_std})
writetable(tabCO2pcCHNMetricTonsAbs,'tabCO2pcCHNMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcCHNMetricTonsAbs_min = min(dldata_CO2pcCHNMetricTons);
dldata_CO2pcCHNMetricTonsAbs_max = max(dldata_CO2pcCHNMetricTons);
dldata_CO2pcCHNMetricTonsAbs_range = dldata_CO2pcCHNMetricTonsAbs_max - dldata_CO2pcCHNMetricTonsAbs_min;
dlstripe_CO2pcCHNMetricTonsAbs_range = dldata_CO2pcCHNMetricTonsAbs_range/16;
dldata_CO2pcCHNMetricTonsAbs_mean = mean(dldata_CO2pcCHNMetricTons);
dldata_CO2pcCHNMetricTonsAbs_median = median(dldata_CO2pcCHNMetricTons);
%dldata_CO2pcCHNMetricTonsAbs_mode = mode(dldata_CO2pcCHNMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcCHNMetricTonsAbs_std = std(dldata_CO2pcCHNMetricTons);

tabdlCO2pcCHNMetricTonsAbs = table(categorical({'data_CO2pcCHNMetricTonsAbs_min';'data_CO2pcCHNMetricTonsAbs_max';'data_CO2pcCHNMetricTons_range';'stripe_CO2pcCHNMetricTonsAbs_range';'data_CO2pcCHNMetricTonsAbs_mean';'data_CO2pcCHNMetricTonsAbs_median'; 'dldata_CO2pcCHNMetricTonsAbs_std'}),{data_CO2pcCHNMetricTonsAbs_min; data_CO2pcCHNMetricTonsAbs_max; data_CO2pcCHNMetricTonsAbs_range; stripe_CO2pcCHNMetricTonsAbs_range; data_CO2pcCHNMetricTonsAbs_mean; data_CO2pcCHNMetricTonsAbs_median; dldata_CO2pcCHNMetricTonsAbs_std})
writetable(tabdlCO2pcCHNMetricTonsAbs,'tabdlCO2pcCHNMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the CHN Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig101 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('China Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('China');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017CHNpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017CHNpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017CHNpcAbs.epsc')

CO2CHNpcAbs = imread('CO2CHNpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig102 = figure
plot(ticksGreenProspGDP,data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('China greening prosperity ratio pc (GDP pc / CO2 pc)')
title('China Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CHNpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CHNpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CHNpcAbs.epsc')

%% Plot - growth rates

fig103 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of China greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of China Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017CHNpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017CHNpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017CHNpcAbs.epsc')


%% Histogram - absolute level

fig104 = figure
histogram(data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('China Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017CHNpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017CHNpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017CHNpcAbs.epsc')

%% Histogram - growth rates

fig105 = figure
histogram(dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of China Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017CHNAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017CHNAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017CHNAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcCHNDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcCHNDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcCHNDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcCHNDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Brazil - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcBRAPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI34:BM34');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcBRAPPPIntlUSDof2017 = log(data_GDPpcBRAPPPIntlUSDof2017);
dldata_GDPpcBRAPPPIntlUSDof2017 = diff(ldata_GDPpcBRAPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcBRAMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI34:BM34');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcBRAMetricTons = log(data_CO2pcBRAMetricTons);
dldata_CO2pcBRAMetricTons = diff(ldata_CO2pcBRAMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017 = data_GDPpcBRAPPPIntlUSDof2017 ./ data_CO2pcBRAMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the BRA GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig106 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcBRAPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Brazil GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Brazil');

saveas(gcf,'GDPBRApcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPBRApcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPBRApcPPPIntlUSDof2017Abs.epsc')

GDPBRApcDev = imread('GDPBRApcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig107 = figure
plot(ticksGDP,data_GDPpcBRAPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Brazil GDP per capita in PPP international USD of 2017')
title('Brazil GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig108 = figure
plot(ticksdlGDP,dldata_GDPpcBRAPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Brazil GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Brazil GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig109 = figure
histogram(data_GDPpcBRAPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Brazil GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig110 = figure
histogram(dldata_GDPpcBRAPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Brazil GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcBRAPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcBRAPPPIntlUSDof2017Abs_min = min(data_GDPpcBRAPPPIntlUSDof2017)
data_GDPpcBRAPPPIntlUSDof2017Abs_max = max(data_GDPpcBRAPPPIntlUSDof2017)
data_GDPpcBRAPPPIntlUSDof2017Abs_range = data_GDPpcBRAPPPIntlUSDof2017Abs_max - data_GDPpcBRAPPPIntlUSDof2017Abs_min
stripe_GDPpcBRAPPPIntlUSDof2017Abs_range = data_GDPpcBRAPPPIntlUSDof2017Abs_range/16
data_GDPpcBRAPPPIntlUSDof2017Abs_mean = mean(data_GDPpcBRAPPPIntlUSDof2017)
data_GDPpcBRAPPPIntlUSDof2017Abs_median = median(data_GDPpcBRAPPPIntlUSDof2017)
%data_GDPpcBRAPPPIntlUSDof2017Abs_mode = mode(data_GDPpcBRAPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcBRAPPPIntlUSDof2017Abs_std = std(data_GDPpcBRAPPPIntlUSDof2017);

tabGDPpcBRAPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcBRAPPPIntlUSDof2017Abs_min';'data_GDPpcBRAPPPIntlUSDof2017Abs_max';'data_GDPpcBRAPPPIntlUSDof2017Abs_range';'stripe_GDPpcBRAPPPIntlUSDof2017Abs_range';'data_GDPpcBRAPPPIntlUSDof2017Abs_mean';'data_GDPpcBRAPPPIntlUSDof2017Abs_median';'data_GDPpcBRAPPPIntlUSDof2017Abs_std'}),{data_GDPpcBRAPPPIntlUSDof2017Abs_min; data_GDPpcBRAPPPIntlUSDof2017Abs_max; data_GDPpcBRAPPPIntlUSDof2017Abs_range; stripe_GDPpcBRAPPPIntlUSDof2017Abs_range; data_GDPpcBRAPPPIntlUSDof2017Abs_mean; data_GDPpcBRAPPPIntlUSDof2017Abs_median; data_GDPpcBRAPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcBRAPPPIntlUSDof2017Abs,'tabGDPpcBRAUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcBRAPPPIntlUSDof2017Abs_min = min(dldata_GDPpcBRAPPPIntlUSDof2017);
dldata_GDPpcBRAPPPIntlUSDof2017Abs_max = max(dldata_GDPpcBRAPPPIntlUSDof2017);
dldata_GDPpcBRAPPPIntlUSDof2017Abs_range = dldata_GDPpcBRAPPPIntlUSDof2017Abs_max - dldata_GDPpcBRAPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcBRAPPPIntlUSDof2017Abs_range = dldata_GDPpcBRAPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcBRAPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcBRAPPPIntlUSDof2017);
dldata_GDPpcBRAPPPIntlUSDof2017Abs_median = median(dldata_GDPpcBRAPPPIntlUSDof2017);
%dldata_GDPpcBRAPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcBRAPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcBRAPPPIntlUSDof2017Abs_std = std(dldata_GDPpcBRAPPPIntlUSDof2017);

tabdlGDPpcBRAPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcBRAPPPIntlUSDof2017Abs_min';'dldata_GDPpcBRAPPPIntlUSDof2017Abs_max';'dldata_GDPpcBRAPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcBRAPPPIntlUSDof2017Abs_range';'dldata_GDPpcBRAPPPIntlUSDof2017Abs_mean';'dldata_GDPpcBRAPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcBRAPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcBRAPPPIntlUSDof2017Abs_min; dldata_GDPpcBRAPPPIntlUSDof2017Abs_max; dldata_GDPpcBRAPPPIntlUSDof2017Abs_range; stripe_GDPpcBRAPPPIntlUSDof2017Abs_range; dldata_GDPpcBRAPPPIntlUSDof2017Abs_mean; dldata_GDPpcBRAPPPIntlUSDof2017Abs_median; dldata_GDPpcBRAPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcBRAPPPIntlUSDof2017Abs,'tabdlGDPpcBRAUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the BRA CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig111 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcBRAMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Brzail per capita for 1990-2020');
title('Brazil');

saveas(gcf,'CO2BRApcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2BRApcAbs.png')
saveas(gcf,'CO2BRApcAbs.epsc')

CO2BRApcAbs = imread('CO2BRApcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig112 = figure
plot(ticksCO2,data_CO2pcBRAMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Brazil CO2 emissions pc, in metric tons')
title('Brazil CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcBRAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcBRAMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcBRAMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig113 = figure
plot(ticksdlCO2,dldata_CO2pcBRAMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Brazil CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Brazil CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcBRAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcBRAMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcBRAMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig114 = figure
histogram(data_CO2pcBRAMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Brazil CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcBRAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcBRAMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcBRAMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig115 = figure
histogram(dldata_CO2pcBRAMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Brazil CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcBRAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcBRAMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcBRAMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcBRAMetricTonsAbs_min = min(data_CO2pcBRAMetricTons)
data_CO2pcBRAMetricTonsAbs_max = max(data_CO2pcBRAMetricTons)
data_CO2pcBRAMetricTonsAbs_range = data_CO2pcBRAMetricTonsAbs_max - data_CO2pcBRAMetricTonsAbs_min
stripe_CO2pcBRAMetricTonsAbs_range = data_CO2pcBRAMetricTonsAbs_range/16
data_CO2pcBRAMetricTonsAbs_mean = mean(data_CO2pcBRAMetricTons)
data_CO2pcBRAMetricTonsAbs_median = median(data_CO2pcBRAMetricTons)
%data_CO2pcBRAMetricTonsAbs_mode = mode(data_CO2pcBRAMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcBRAMetricTonsAbs_std = std(data_CO2pcBRAMetricTons);

tabCO2pcBRAMetricTonsAbs = table(categorical({'data_CO2pcBRAMetricTonsAbs_min';'data_CO2pcBRAMetricTonsAbs_max';'data_CO2pcBRAMetricTons_range';'stripe_CO2pcBRAMetricTonsAbs_range';'data_CO2pcBRAMetricTonsAbs_mean';'data_CO2pcBRAMetricTonsAbs_median';'data_CO2pcBRAMetricTonsAbs_std'}),{data_CO2pcBRAMetricTonsAbs_min; data_CO2pcBRAMetricTonsAbs_max; data_CO2pcBRAMetricTonsAbs_range; stripe_CO2pcBRAMetricTonsAbs_range; data_CO2pcBRAMetricTonsAbs_mean; data_CO2pcBRAMetricTonsAbs_median; data_CO2pcBRAMetricTonsAbs_std})
writetable(tabCO2pcBRAMetricTonsAbs,'tabCO2pcBRAMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcBRAMetricTonsAbs_min = min(dldata_CO2pcBRAMetricTons);
dldata_CO2pcBRAMetricTonsAbs_max = max(dldata_CO2pcBRAMetricTons);
dldata_CO2pcBRAMetricTonsAbs_range = dldata_CO2pcBRAMetricTonsAbs_max - dldata_CO2pcBRAMetricTonsAbs_min;
dlstripe_CO2pcBRAMetricTonsAbs_range = dldata_CO2pcBRAMetricTonsAbs_range/16;
dldata_CO2pcBRAMetricTonsAbs_mean = mean(dldata_CO2pcBRAMetricTons);
dldata_CO2pcBRAMetricTonsAbs_median = median(dldata_CO2pcBRAMetricTons);
%dldata_CO2pcBRAMetricTonsAbs_mode = mode(dldata_CO2pcBRAMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcBRAMetricTonsAbs_std = std(dldata_CO2pcBRAMetricTons);

tabdlCO2pcBRAMetricTonsAbs = table(categorical({'data_CO2pcBRAMetricTonsAbs_min';'data_CO2pcBRAMetricTonsAbs_max';'data_CO2pcBRAMetricTons_range';'stripe_CO2pcBRAMetricTonsAbs_range';'data_CO2pcBRAMetricTonsAbs_mean';'data_CO2pcBRAMetricTonsAbs_median'; 'dldata_CO2pcBRAMetricTonsAbs_std'}),{data_CO2pcBRAMetricTonsAbs_min; data_CO2pcBRAMetricTonsAbs_max; data_CO2pcBRAMetricTonsAbs_range; stripe_CO2pcBRAMetricTonsAbs_range; data_CO2pcBRAMetricTonsAbs_mean; data_CO2pcBRAMetricTonsAbs_median; dldata_CO2pcBRAMetricTonsAbs_std})
writetable(tabdlCO2pcBRAMetricTonsAbs,'tabdlCO2pcBRAMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the BRA Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig116 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Brazil Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Brazil');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017BRApcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017BRApcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017BRApcAbs.epsc')

CO2BRApcAbs = imread('CO2BRApcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig117 = figure
plot(ticksGreenProspGDP,data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Brazil greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Brazil Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017BRApcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017BRApcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017BRApcAbs.epsc')

%% Plot - growth rates

fig118 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Brazil greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Brazil Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017BRApcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017BRApcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017BRApcAbs.epsc')


%% Histogram - absolute level

fig119 = figure
histogram(data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Brazil Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017BRApcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017BRApcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017BRApcAbs.epsc')

%% Histogram - growth rates

fig120 = figure
histogram(dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Brazil Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017BRAAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017BRAAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017BRAAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcBRADefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcBRADefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcBRADefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcBRADefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Australia - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcAUSPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI18:BM18');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcAUSPPPIntlUSDof2017 = log(data_GDPpcAUSPPPIntlUSDof2017);
dldata_GDPpcAUSPPPIntlUSDof2017 = diff(ldata_GDPpcAUSPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcAUSMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI18:BM18');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcAUSMetricTons = log(data_CO2pcAUSMetricTons);
dldata_CO2pcAUSMetricTons = diff(ldata_CO2pcAUSMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017 = data_GDPpcAUSPPPIntlUSDof2017 ./ data_CO2pcAUSMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the AUS GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig121 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcAUSPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Australia GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Australia');

saveas(gcf,'GDPAUSpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPAUSpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPAUSpcPPPIntlUSDof2017Abs.epsc')

GDPAUSpcDev = imread('GDPAUSpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig122 = figure
plot(ticksGDP,data_GDPpcAUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Australia GDP per capita in PPP international USD of 2017')
title('Australia GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig123 = figure
plot(ticksdlGDP,dldata_GDPpcAUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Australia GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Australia GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig124 = figure
histogram(data_GDPpcAUSPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Australia GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig125 = figure
histogram(dldata_GDPpcAUSPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Australia GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcAUSPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcAUSPPPIntlUSDof2017Abs_min = min(data_GDPpcAUSPPPIntlUSDof2017)
data_GDPpcAUSPPPIntlUSDof2017Abs_max = max(data_GDPpcAUSPPPIntlUSDof2017)
data_GDPpcAUSPPPIntlUSDof2017Abs_range = data_GDPpcAUSPPPIntlUSDof2017Abs_max - data_GDPpcAUSPPPIntlUSDof2017Abs_min
stripe_GDPpcAUSPPPIntlUSDof2017Abs_range = data_GDPpcAUSPPPIntlUSDof2017Abs_range/16
data_GDPpcAUSPPPIntlUSDof2017Abs_mean = mean(data_GDPpcAUSPPPIntlUSDof2017)
data_GDPpcAUSPPPIntlUSDof2017Abs_median = median(data_GDPpcAUSPPPIntlUSDof2017)
%data_GDPpcAUSPPPIntlUSDof2017Abs_mode = mode(data_GDPpcAUSPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcAUSPPPIntlUSDof2017Abs_std = std(data_GDPpcAUSPPPIntlUSDof2017);

tabGDPpcAUSPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcAUSPPPIntlUSDof2017Abs_min';'data_GDPpcAUSPPPIntlUSDof2017Abs_max';'data_GDPpcAUSPPPIntlUSDof2017Abs_range';'stripe_GDPpcAUSPPPIntlUSDof2017Abs_range';'data_GDPpcAUSPPPIntlUSDof2017Abs_mean';'data_GDPpcAUSPPPIntlUSDof2017Abs_median';'data_GDPpcAUSPPPIntlUSDof2017Abs_std'}),{data_GDPpcAUSPPPIntlUSDof2017Abs_min; data_GDPpcAUSPPPIntlUSDof2017Abs_max; data_GDPpcAUSPPPIntlUSDof2017Abs_range; stripe_GDPpcAUSPPPIntlUSDof2017Abs_range; data_GDPpcAUSPPPIntlUSDof2017Abs_mean; data_GDPpcAUSPPPIntlUSDof2017Abs_median; data_GDPpcAUSPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcAUSPPPIntlUSDof2017Abs,'tabGDPpcAUSUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcAUSPPPIntlUSDof2017Abs_min = min(dldata_GDPpcAUSPPPIntlUSDof2017);
dldata_GDPpcAUSPPPIntlUSDof2017Abs_max = max(dldata_GDPpcAUSPPPIntlUSDof2017);
dldata_GDPpcAUSPPPIntlUSDof2017Abs_range = dldata_GDPpcAUSPPPIntlUSDof2017Abs_max - dldata_GDPpcAUSPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcAUSPPPIntlUSDof2017Abs_range = dldata_GDPpcAUSPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcAUSPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcAUSPPPIntlUSDof2017);
dldata_GDPpcAUSPPPIntlUSDof2017Abs_median = median(dldata_GDPpcAUSPPPIntlUSDof2017);
%dldata_GDPpcAUSPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcAUSPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcAUSPPPIntlUSDof2017Abs_std = std(dldata_GDPpcAUSPPPIntlUSDof2017);

tabdlGDPpcAUSPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcAUSPPPIntlUSDof2017Abs_min';'dldata_GDPpcAUSPPPIntlUSDof2017Abs_max';'dldata_GDPpcAUSPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcAUSPPPIntlUSDof2017Abs_range';'dldata_GDPpcAUSPPPIntlUSDof2017Abs_mean';'dldata_GDPpcAUSPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcAUSPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcAUSPPPIntlUSDof2017Abs_min; dldata_GDPpcAUSPPPIntlUSDof2017Abs_max; dldata_GDPpcAUSPPPIntlUSDof2017Abs_range; stripe_GDPpcAUSPPPIntlUSDof2017Abs_range; dldata_GDPpcAUSPPPIntlUSDof2017Abs_mean; dldata_GDPpcAUSPPPIntlUSDof2017Abs_median; dldata_GDPpcAUSPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcAUSPPPIntlUSDof2017Abs,'tabdlGDPpcAUSUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the AUS CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig126 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcAUSMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Australia per capita for 1990-2020');
title('Australia');

saveas(gcf,'CO2AUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2AUSpcAbs.png')
saveas(gcf,'CO2AUSpcAbs.epsc')

CO2AUSpcAbs = imread('CO2AUSpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig127 = figure
plot(ticksCO2,data_CO2pcAUSMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Australia CO2 emissions pc, in metric tons')
title('Australia CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcAUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcAUSMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcAUSMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig128 = figure
plot(ticksdlCO2,dldata_CO2pcAUSMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Australia CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Australia CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcAUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcAUSMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcAUSMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig129 = figure
histogram(data_CO2pcAUSMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Australia CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcAUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcAUSMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcAUSMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig130 = figure
histogram(dldata_CO2pcAUSMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Australia CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcAUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcAUSMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcAUSMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcAUSMetricTonsAbs_min = min(data_CO2pcAUSMetricTons)
data_CO2pcAUSMetricTonsAbs_max = max(data_CO2pcAUSMetricTons)
data_CO2pcAUSMetricTonsAbs_range = data_CO2pcAUSMetricTonsAbs_max - data_CO2pcAUSMetricTonsAbs_min
stripe_CO2pcAUSMetricTonsAbs_range = data_CO2pcAUSMetricTonsAbs_range/16
data_CO2pcAUSMetricTonsAbs_mean = mean(data_CO2pcAUSMetricTons)
data_CO2pcAUSMetricTonsAbs_median = median(data_CO2pcAUSMetricTons)
%data_CO2pcAUSMetricTonsAbs_mode = mode(data_CO2pcAUSMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcAUSMetricTonsAbs_std = std(data_CO2pcAUSMetricTons);

tabCO2pcAUSMetricTonsAbs = table(categorical({'data_CO2pcAUSMetricTonsAbs_min';'data_CO2pcAUSMetricTonsAbs_max';'data_CO2pcAUSMetricTons_range';'stripe_CO2pcAUSMetricTonsAbs_range';'data_CO2pcAUSMetricTonsAbs_mean';'data_CO2pcAUSMetricTonsAbs_median';'data_CO2pcAUSMetricTonsAbs_std'}),{data_CO2pcAUSMetricTonsAbs_min; data_CO2pcAUSMetricTonsAbs_max; data_CO2pcAUSMetricTonsAbs_range; stripe_CO2pcAUSMetricTonsAbs_range; data_CO2pcAUSMetricTonsAbs_mean; data_CO2pcAUSMetricTonsAbs_median; data_CO2pcAUSMetricTonsAbs_std})
writetable(tabCO2pcAUSMetricTonsAbs,'tabCO2pcAUSMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcAUSMetricTonsAbs_min = min(dldata_CO2pcAUSMetricTons);
dldata_CO2pcAUSMetricTonsAbs_max = max(dldata_CO2pcAUSMetricTons);
dldata_CO2pcAUSMetricTonsAbs_range = dldata_CO2pcAUSMetricTonsAbs_max - dldata_CO2pcAUSMetricTonsAbs_min;
dlstripe_CO2pcAUSMetricTonsAbs_range = dldata_CO2pcAUSMetricTonsAbs_range/16;
dldata_CO2pcAUSMetricTonsAbs_mean = mean(dldata_CO2pcAUSMetricTons);
dldata_CO2pcAUSMetricTonsAbs_median = median(dldata_CO2pcAUSMetricTons);
%dldata_CO2pcAUSMetricTonsAbs_mode = mode(dldata_CO2pcAUSMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcAUSMetricTonsAbs_std = std(dldata_CO2pcAUSMetricTons);

tabdlCO2pcAUSMetricTonsAbs = table(categorical({'data_CO2pcAUSMetricTonsAbs_min';'data_CO2pcAUSMetricTonsAbs_max';'data_CO2pcAUSMetricTons_range';'stripe_CO2pcAUSMetricTonsAbs_range';'data_CO2pcAUSMetricTonsAbs_mean';'data_CO2pcAUSMetricTonsAbs_median'; 'dldata_CO2pcAUSMetricTonsAbs_std'}),{data_CO2pcAUSMetricTonsAbs_min; data_CO2pcAUSMetricTonsAbs_max; data_CO2pcAUSMetricTonsAbs_range; stripe_CO2pcAUSMetricTonsAbs_range; data_CO2pcAUSMetricTonsAbs_mean; data_CO2pcAUSMetricTonsAbs_median; dldata_CO2pcAUSMetricTonsAbs_std})
writetable(tabdlCO2pcAUSMetricTonsAbs,'tabdlCO2pcAUSMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the AUS Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig131 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Australia Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Australia');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017AUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017AUSpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017AUSpcAbs.epsc')

CO2AUSpcAbs = imread('CO2AUSpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig132 = figure
plot(ticksGreenProspGDP,data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Australia greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Australia Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017AUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017AUSpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017AUSpcAbs.epsc')

%% Plot - growth rates

fig133 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Australia greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Australia Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017AUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017AUSpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017AUSpcAbs.epsc')


%% Histogram - absolute level

fig134 = figure
histogram(data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Australia Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017AUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017AUSpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017AUSpcAbs.epsc')

%% Histogram - growth rates

fig135 = figure
histogram(dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Australia Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017AUSAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017AUSAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017AUSAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcAUSDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcAUSDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcAUSDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcAUSDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% European Union - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcEUPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI78:BM78');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcEUPPPIntlUSDof2017 = log(data_GDPpcEUPPPIntlUSDof2017);
dldata_GDPpcEUPPPIntlUSDof2017 = diff(ldata_GDPpcEUPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcEUMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI78:BM78');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcEUMetricTons = log(data_CO2pcEUMetricTons);
dldata_CO2pcEUMetricTons = diff(ldata_CO2pcEUMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017 = data_GDPpcEUPPPIntlUSDof2017 ./ data_CO2pcEUMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the EU GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig136 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcEUPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('EU GDP per capita in PPP International USD of 2017 for 1990-1990');
title('EU');

saveas(gcf,'GDPEUpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPEUpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPEUpcPPPIntlUSDof2017Abs.epsc')

GDPEUpcDev = imread('GDPEUpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig137 = figure
plot(ticksGDP,data_GDPpcEUPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('EU GDP per capita in PPP international USD of 2017')
title('EU GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcEUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcEUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcEUPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig138 = figure
plot(ticksdlGDP,dldata_GDPpcEUPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of EU GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of EU GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcEUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcEUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcEUPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig139 = figure
histogram(data_GDPpcEUPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('EU GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcEUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcEUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcEUPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig140 = figure
histogram(dldata_GDPpcEUPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of EU GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcEUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcEUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcEUPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcEUPPPIntlUSDof2017Abs_min = min(data_GDPpcEUPPPIntlUSDof2017)
data_GDPpcEUPPPIntlUSDof2017Abs_max = max(data_GDPpcEUPPPIntlUSDof2017)
data_GDPpcEUPPPIntlUSDof2017Abs_range = data_GDPpcEUPPPIntlUSDof2017Abs_max - data_GDPpcEUPPPIntlUSDof2017Abs_min
stripe_GDPpcEUPPPIntlUSDof2017Abs_range = data_GDPpcEUPPPIntlUSDof2017Abs_range/16
data_GDPpcEUPPPIntlUSDof2017Abs_mean = mean(data_GDPpcEUPPPIntlUSDof2017)
data_GDPpcEUPPPIntlUSDof2017Abs_median = median(data_GDPpcEUPPPIntlUSDof2017)
%data_GDPpcEUPPPIntlUSDof2017Abs_mode = mode(data_GDPpcEUPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcEUPPPIntlUSDof2017Abs_std = std(data_GDPpcEUPPPIntlUSDof2017);

tabGDPpcEUPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcEUPPPIntlUSDof2017Abs_min';'data_GDPpcEUPPPIntlUSDof2017Abs_max';'data_GDPpcEUPPPIntlUSDof2017Abs_range';'stripe_GDPpcEUPPPIntlUSDof2017Abs_range';'data_GDPpcEUPPPIntlUSDof2017Abs_mean';'data_GDPpcEUPPPIntlUSDof2017Abs_median'}),{data_GDPpcEUPPPIntlUSDof2017Abs_min; data_GDPpcEUPPPIntlUSDof2017Abs_max; data_GDPpcEUPPPIntlUSDof2017Abs_range; stripe_GDPpcEUPPPIntlUSDof2017Abs_range; data_GDPpcEUPPPIntlUSDof2017Abs_mean; data_GDPpcEUPPPIntlUSDof2017Abs_median})
writetable(tabGDPpcEUPPPIntlUSDof2017Abs,'tabGDPpcEUUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcEUPPPIntlUSDof2017Abs_min = min(dldata_GDPpcEUPPPIntlUSDof2017);
dldata_GDPpcEUPPPIntlUSDof2017Abs_max = max(dldata_GDPpcEUPPPIntlUSDof2017);
dldata_GDPpcEUPPPIntlUSDof2017Abs_range = dldata_GDPpcEUPPPIntlUSDof2017Abs_max - dldata_GDPpcEUPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcEUPPPIntlUSDof2017Abs_range = dldata_GDPpcEUPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcEUPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcEUPPPIntlUSDof2017);
dldata_GDPpcEUPPPIntlUSDof2017Abs_median = median(dldata_GDPpcEUPPPIntlUSDof2017);
%dldata_GDPpcEUPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcEUPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcEUPPPIntlUSDof2017Abs_std = std(dldata_GDPpcEUPPPIntlUSDof2017);

tabdlGDPpcEUPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcEUPPPIntlUSDof2017Abs_min';'dldata_GDPpcEUPPPIntlUSDof2017Abs_max';'dldata_GDPpcEUPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcEUPPPIntlUSDof2017Abs_range';'dldata_GDPpcEUPPPIntlUSDof2017Abs_mean';'dldata_GDPpcEUPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcEUPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcEUPPPIntlUSDof2017Abs_min; dldata_GDPpcEUPPPIntlUSDof2017Abs_max; dldata_GDPpcEUPPPIntlUSDof2017Abs_range; stripe_GDPpcEUPPPIntlUSDof2017Abs_range; dldata_GDPpcEUPPPIntlUSDof2017Abs_mean; dldata_GDPpcEUPPPIntlUSDof2017Abs_median; dldata_GDPpcEUPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcEUPPPIntlUSDof2017Abs,'tabdlGDPpcEUUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the EU CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig141 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcEUMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the EU per capita for 1990-2020');
title('EU');

saveas(gcf,'CO2EUpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2EUpcAbs.png')
saveas(gcf,'CO2EUpcAbs.epsc')

CO2EUpcAbs = imread('CO2EUpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig142 = figure
plot(ticksCO2,data_CO2pcEUMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('EU CO2 emissions pc, in metric tons')
title('EU CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcEUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcEUMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcEUMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig143 = figure
plot(ticksdlCO2,dldata_CO2pcEUMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of EU CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of EU CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcEUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcEUMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcEUMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig144 = figure
histogram(data_CO2pcEUMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('EU CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcEUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcEUMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcEUMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig145 = figure
histogram(dldata_CO2pcEUMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of EU CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcEUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcEUMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcEUMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcEUMetricTonsAbs_min = min(data_CO2pcEUMetricTons)
data_CO2pcEUMetricTonsAbs_max = max(data_CO2pcEUMetricTons)
data_CO2pcEUMetricTonsAbs_range = data_CO2pcEUMetricTonsAbs_max - data_CO2pcEUMetricTonsAbs_min
stripe_CO2pcEUMetricTonsAbs_range = data_CO2pcEUMetricTonsAbs_range/16
data_CO2pcEUMetricTonsAbs_mean = mean(data_CO2pcEUMetricTons)
data_CO2pcEUMetricTonsAbs_median = median(data_CO2pcEUMetricTons)
%data_CO2pcEUMetricTonsAbs_mode = mode(data_CO2pcEUMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcEUMetricTonsAbs_std = std(data_CO2pcEUMetricTons);

tabCO2pcEUMetricTonsAbs = table(categorical({'data_CO2pcEUMetricTonsAbs_min';'data_CO2pcEUMetricTonsAbs_max';'data_CO2pcEUMetricTons_range';'stripe_CO2pcEUMetricTonsAbs_range';'data_CO2pcEUMetricTonsAbs_mean';'data_CO2pcEUMetricTonsAbs_median';'data_CO2pcEUMetricTonsAbs_std'}),{data_CO2pcEUMetricTonsAbs_min; data_CO2pcEUMetricTonsAbs_max; data_CO2pcEUMetricTonsAbs_range; stripe_CO2pcEUMetricTonsAbs_range; data_CO2pcEUMetricTonsAbs_mean; data_CO2pcEUMetricTonsAbs_median; data_CO2pcEUMetricTonsAbs_std})
writetable(tabCO2pcEUMetricTonsAbs,'tabCO2pcEUMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcEUMetricTonsAbs_min = min(dldata_CO2pcEUMetricTons);
dldata_CO2pcEUMetricTonsAbs_max = max(dldata_CO2pcEUMetricTons);
dldata_CO2pcEUMetricTonsAbs_range = dldata_CO2pcEUMetricTonsAbs_max - dldata_CO2pcEUMetricTonsAbs_min;
dlstripe_CO2pcEUMetricTonsAbs_range = dldata_CO2pcEUMetricTonsAbs_range/16;
dldata_CO2pcEUMetricTonsAbs_mean = mean(dldata_CO2pcEUMetricTons);
dldata_CO2pcEUMetricTonsAbs_median = median(dldata_CO2pcEUMetricTons);
%dldata_CO2pcEUMetricTonsAbs_mode = mode(dldata_CO2pcEUMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcEUMetricTonsAbs_std = std(dldata_CO2pcEUMetricTons);

tabdlCO2pcEUMetricTonsAbs = table(categorical({'data_CO2pcEUMetricTonsAbs_min';'data_CO2pcEUMetricTonsAbs_max';'data_CO2pcEUMetricTons_range';'stripe_CO2pcEUMetricTonsAbs_range';'data_CO2pcEUMetricTonsAbs_mean';'data_CO2pcEUMetricTonsAbs_median'; 'dldata_CO2pcEUMetricTonsAbs_std'}),{data_CO2pcEUMetricTonsAbs_min; data_CO2pcEUMetricTonsAbs_max; data_CO2pcEUMetricTonsAbs_range; stripe_CO2pcEUMetricTonsAbs_range; data_CO2pcEUMetricTonsAbs_mean; data_CO2pcEUMetricTonsAbs_median; dldata_CO2pcEUMetricTonsAbs_std})
writetable(tabdlCO2pcEUMetricTonsAbs,'tabdlCO2pcEUMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the EU Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig146 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('EU Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('EU');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017EUpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017EUpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017EUpcAbs.epsc')

CO2EUpcAbs = imread('CO2EUpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig147 = figure
plot(ticksGreenProspGDP,data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('EU greening prosperity ratio pc (GDP pc / CO2 pc)')
title('EU Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017EUpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017EUpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017EUpcAbs.epsc')

%% Plot - growth rates

fig148 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of average EU greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of EU Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017EUpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017EUpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017EUpcAbs.epsc')


%% Histogram - absolute level

fig149 = figure
histogram(data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('EU Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017EUpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017EUpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017EUpcAbs.epsc')

%% Histogram - growth rates

fig150 = figure
histogram(dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of EU Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017EUAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017EUAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017EUAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcEUDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcEUDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcEUDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcEUDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% India - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcINDPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI114:BM114');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcINDPPPIntlUSDof2017 = log(data_GDPpcINDPPPIntlUSDof2017);
dldata_GDPpcINDPPPIntlUSDof2017 = diff(ldata_GDPpcINDPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcINDMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI114:BM114');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcINDMetricTons = log(data_CO2pcINDMetricTons);
dldata_CO2pcINDMetricTons = diff(ldata_CO2pcINDMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017 = data_GDPpcINDPPPIntlUSDof2017 ./ data_CO2pcINDMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the IND GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig151 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcINDPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('India GDP per capita in PPP International USD of 2017 for 1990-1990');
title('India');

saveas(gcf,'GDPINDpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPINDpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPINDpcPPPIntlUSDof2017Abs.epsc')

GDPINDpcDev = imread('GDPINDpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig152 = figure
plot(ticksGDP,data_GDPpcINDPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('India GDP per capita in PPP international USD of 2017')
title('India GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcINDPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcINDPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcINDPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig153 = figure
plot(ticksdlGDP,dldata_GDPpcINDPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of India GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of India GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcINDPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcINDPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcINDPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig154 = figure
histogram(data_GDPpcINDPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('India GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcINDPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcINDPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcINDPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig155 = figure
histogram(dldata_GDPpcINDPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of India GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcINDPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcINDPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcINDPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcINDPPPIntlUSDof2017Abs_min = min(data_GDPpcINDPPPIntlUSDof2017)
data_GDPpcINDPPPIntlUSDof2017Abs_max = max(data_GDPpcINDPPPIntlUSDof2017)
data_GDPpcINDPPPIntlUSDof2017Abs_range = data_GDPpcINDPPPIntlUSDof2017Abs_max - data_GDPpcINDPPPIntlUSDof2017Abs_min
stripe_GDPpcINDPPPIntlUSDof2017Abs_range = data_GDPpcINDPPPIntlUSDof2017Abs_range/16
data_GDPpcINDPPPIntlUSDof2017Abs_mean = mean(data_GDPpcINDPPPIntlUSDof2017)
data_GDPpcINDPPPIntlUSDof2017Abs_median = median(data_GDPpcINDPPPIntlUSDof2017)
%data_GDPpcINDPPPIntlUSDof2017Abs_mode = mode(data_GDPpcINDPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcINDPPPIntlUSDof2017Abs_std = std(data_GDPpcINDPPPIntlUSDof2017);

tabGDPpcINDPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcINDPPPIntlUSDof2017Abs_min';'data_GDPpcINDPPPIntlUSDof2017Abs_max';'data_GDPpcINDPPPIntlUSDof2017Abs_range';'stripe_GDPpcINDPPPIntlUSDof2017Abs_range';'data_GDPpcINDPPPIntlUSDof2017Abs_mean';'data_GDPpcINDPPPIntlUSDof2017Abs_median';'data_GDPpcINDPPPIntlUSDof2017Abs_std'}),{data_GDPpcINDPPPIntlUSDof2017Abs_min; data_GDPpcINDPPPIntlUSDof2017Abs_max; data_GDPpcINDPPPIntlUSDof2017Abs_range; stripe_GDPpcINDPPPIntlUSDof2017Abs_range; data_GDPpcINDPPPIntlUSDof2017Abs_mean; data_GDPpcINDPPPIntlUSDof2017Abs_median; data_GDPpcINDPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcINDPPPIntlUSDof2017Abs,'tabGDPpcINDUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcINDPPPIntlUSDof2017Abs_min = min(dldata_GDPpcINDPPPIntlUSDof2017);
dldata_GDPpcINDPPPIntlUSDof2017Abs_max = max(dldata_GDPpcINDPPPIntlUSDof2017);
dldata_GDPpcINDPPPIntlUSDof2017Abs_range = dldata_GDPpcINDPPPIntlUSDof2017Abs_max - dldata_GDPpcINDPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcINDPPPIntlUSDof2017Abs_range = dldata_GDPpcINDPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcINDPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcINDPPPIntlUSDof2017);
dldata_GDPpcINDPPPIntlUSDof2017Abs_median = median(dldata_GDPpcINDPPPIntlUSDof2017);
%dldata_GDPpcINDPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcINDPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcINDPPPIntlUSDof2017Abs_std = std(dldata_GDPpcINDPPPIntlUSDof2017);

tabdlGDPpcINDPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcINDPPPIntlUSDof2017Abs_min';'dldata_GDPpcINDPPPIntlUSDof2017Abs_max';'dldata_GDPpcINDPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcINDPPPIntlUSDof2017Abs_range';'dldata_GDPpcINDPPPIntlUSDof2017Abs_mean';'dldata_GDPpcINDPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcINDPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcINDPPPIntlUSDof2017Abs_min; dldata_GDPpcINDPPPIntlUSDof2017Abs_max; dldata_GDPpcINDPPPIntlUSDof2017Abs_range; stripe_GDPpcINDPPPIntlUSDof2017Abs_range; dldata_GDPpcINDPPPIntlUSDof2017Abs_mean; dldata_GDPpcINDPPPIntlUSDof2017Abs_median; dldata_GDPpcINDPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcINDPPPIntlUSDof2017Abs,'tabdlGDPpcINDUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the IND CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig156 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcINDMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in India per capita for 1990-2020');
title('India');

saveas(gcf,'CO2INDpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2INDpcAbs.png')
saveas(gcf,'CO2INDpcAbs.epsc')

CO2INDpcAbs = imread('CO2INDpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig157 = figure
plot(ticksCO2,data_CO2pcINDMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('India CO2 emissions pc, in metric tons')
title('India CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcINDMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcINDMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcINDMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig158 = figure
plot(ticksdlCO2,dldata_CO2pcINDMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of India CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of India CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcINDMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcINDMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcINDMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig159 = figure
histogram(data_CO2pcINDMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('India CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcINDMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcINDMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcINDMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig160 = figure
histogram(dldata_CO2pcINDMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of India CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcINDMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcINDMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcINDMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcINDMetricTonsAbs_min = min(data_CO2pcINDMetricTons)
data_CO2pcINDMetricTonsAbs_max = max(data_CO2pcINDMetricTons)
data_CO2pcINDMetricTonsAbs_range = data_CO2pcINDMetricTonsAbs_max - data_CO2pcINDMetricTonsAbs_min
stripe_CO2pcINDMetricTonsAbs_range = data_CO2pcINDMetricTonsAbs_range/16
data_CO2pcINDMetricTonsAbs_mean = mean(data_CO2pcINDMetricTons)
data_CO2pcINDMetricTonsAbs_median = median(data_CO2pcINDMetricTons)
%data_CO2pcINDMetricTonsAbs_mode = mode(data_CO2pcINDMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcINDMetricTonsAbs_std = std(data_CO2pcINDMetricTons);

tabCO2pcINDMetricTonsAbs = table(categorical({'data_CO2pcINDMetricTonsAbs_min';'data_CO2pcINDMetricTonsAbs_max';'data_CO2pcINDMetricTons_range';'stripe_CO2pcINDMetricTonsAbs_range';'data_CO2pcINDMetricTonsAbs_mean';'data_CO2pcINDMetricTonsAbs_median';'data_CO2pcINDMetricTonsAbs_std'}),{data_CO2pcINDMetricTonsAbs_min; data_CO2pcINDMetricTonsAbs_max; data_CO2pcINDMetricTonsAbs_range; stripe_CO2pcINDMetricTonsAbs_range; data_CO2pcINDMetricTonsAbs_mean; data_CO2pcINDMetricTonsAbs_median; data_CO2pcINDMetricTonsAbs_std})
writetable(tabCO2pcINDMetricTonsAbs,'tabCO2pcINDMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcINDMetricTonsAbs_min = min(dldata_CO2pcINDMetricTons);
dldata_CO2pcINDMetricTonsAbs_max = max(dldata_CO2pcINDMetricTons);
dldata_CO2pcINDMetricTonsAbs_range = dldata_CO2pcINDMetricTonsAbs_max - dldata_CO2pcINDMetricTonsAbs_min;
dlstripe_CO2pcINDMetricTonsAbs_range = dldata_CO2pcINDMetricTonsAbs_range/16;
dldata_CO2pcINDMetricTonsAbs_mean = mean(dldata_CO2pcINDMetricTons);
dldata_CO2pcINDMetricTonsAbs_median = median(dldata_CO2pcINDMetricTons);
%dldata_CO2pcINDMetricTonsAbs_mode = mode(dldata_CO2pcINDMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcINDMetricTonsAbs_std = std(dldata_CO2pcINDMetricTons);

tabdlCO2pcINDMetricTonsAbs = table(categorical({'data_CO2pcINDMetricTonsAbs_min';'data_CO2pcINDMetricTonsAbs_max';'data_CO2pcINDMetricTons_range';'stripe_CO2pcINDMetricTonsAbs_range';'data_CO2pcINDMetricTonsAbs_mean';'data_CO2pcINDMetricTonsAbs_median'; 'dldata_CO2pcINDMetricTonsAbs_std'}),{data_CO2pcINDMetricTonsAbs_min; data_CO2pcINDMetricTonsAbs_max; data_CO2pcINDMetricTonsAbs_range; stripe_CO2pcINDMetricTonsAbs_range; data_CO2pcINDMetricTonsAbs_mean; data_CO2pcINDMetricTonsAbs_median; dldata_CO2pcINDMetricTonsAbs_std})
writetable(tabdlCO2pcINDMetricTonsAbs,'tabdlCO2pcINDMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the IND Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig161 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('India Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('India');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017INDpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017INDpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017INDpcAbs.epsc')

CO2INDpcAbs = imread('CO2INDpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig162 = figure
plot(ticksGreenProspGDP,data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('India greening prosperity ratio pc (GDP pc / CO2 pc)')
title('India Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017INDpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017INDpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017INDpcAbs.epsc')

%% Plot - growth rates

fig163 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of India greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of India Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017INDpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017INDpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017INDpcAbs.epsc')


%% Histogram - absolute level

fig164 = figure
histogram(data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('India Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017INDpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017INDpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017INDpcAbs.epsc')

%% Histogram - growth rates

fig165 = figure
histogram(dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of India Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017INDAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017INDAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017INDAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcINDDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcINDDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcINDDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcINDDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Japan - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcJPNPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI124:BM124');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcJPNPPPIntlUSDof2017 = log(data_GDPpcJPNPPPIntlUSDof2017);
dldata_GDPpcJPNPPPIntlUSDof2017 = diff(ldata_GDPpcJPNPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcJPNMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI124:BM124');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcJPNMetricTons = log(data_CO2pcJPNMetricTons);
dldata_CO2pcJPNMetricTons = diff(ldata_CO2pcJPNMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017 = data_GDPpcJPNPPPIntlUSDof2017 ./ data_CO2pcJPNMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the JPN GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig166 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcJPNPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Japan GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Japan');

saveas(gcf,'GDPJPNpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPJPNpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPJPNpcPPPIntlUSDof2017Abs.epsc')

GDPJPNpcDev = imread('GDPJPNpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig167 = figure
plot(ticksGDP,data_GDPpcJPNPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Japan GDP per capita in PPP international USD of 2017')
title('Japan GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig168 = figure
plot(ticksdlGDP,dldata_GDPpcJPNPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Japan GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Japan GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig169 = figure
histogram(data_GDPpcJPNPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Japan GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig170 = figure
histogram(dldata_GDPpcJPNPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Japan GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcJPNPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcJPNPPPIntlUSDof2017Abs_min = min(data_GDPpcJPNPPPIntlUSDof2017)
data_GDPpcJPNPPPIntlUSDof2017Abs_max = max(data_GDPpcJPNPPPIntlUSDof2017)
data_GDPpcJPNPPPIntlUSDof2017Abs_range = data_GDPpcJPNPPPIntlUSDof2017Abs_max - data_GDPpcJPNPPPIntlUSDof2017Abs_min
stripe_GDPpcJPNPPPIntlUSDof2017Abs_range = data_GDPpcJPNPPPIntlUSDof2017Abs_range/16
data_GDPpcJPNPPPIntlUSDof2017Abs_mean = mean(data_GDPpcJPNPPPIntlUSDof2017)
data_GDPpcJPNPPPIntlUSDof2017Abs_median = median(data_GDPpcJPNPPPIntlUSDof2017)
%data_GDPpcJPNPPPIntlUSDof2017Abs_mode = mode(data_GDPpcJPNPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcJPNPPPIntlUSDof2017Abs_std = std(data_GDPpcJPNPPPIntlUSDof2017);

tabGDPpcJPNPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcJPNPPPIntlUSDof2017Abs_min';'data_GDPpcJPNPPPIntlUSDof2017Abs_max';'data_GDPpcJPNPPPIntlUSDof2017Abs_range';'stripe_GDPpcJPNPPPIntlUSDof2017Abs_range';'data_GDPpcJPNPPPIntlUSDof2017Abs_mean';'data_GDPpcJPNPPPIntlUSDof2017Abs_median';'data_GDPpcJPNPPPIntlUSDof2017Abs_std'}),{data_GDPpcJPNPPPIntlUSDof2017Abs_min; data_GDPpcJPNPPPIntlUSDof2017Abs_max; data_GDPpcJPNPPPIntlUSDof2017Abs_range; stripe_GDPpcJPNPPPIntlUSDof2017Abs_range; data_GDPpcJPNPPPIntlUSDof2017Abs_mean; data_GDPpcJPNPPPIntlUSDof2017Abs_median; data_GDPpcJPNPPPIntlUSDof2017Abs_std});
writetable(tabGDPpcJPNPPPIntlUSDof2017Abs,'tabGDPpcJPNUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcJPNPPPIntlUSDof2017Abs_min = min(dldata_GDPpcJPNPPPIntlUSDof2017);
dldata_GDPpcJPNPPPIntlUSDof2017Abs_max = max(dldata_GDPpcJPNPPPIntlUSDof2017);
dldata_GDPpcJPNPPPIntlUSDof2017Abs_range = dldata_GDPpcJPNPPPIntlUSDof2017Abs_max - dldata_GDPpcJPNPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcJPNPPPIntlUSDof2017Abs_range = dldata_GDPpcJPNPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcJPNPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcJPNPPPIntlUSDof2017);
dldata_GDPpcJPNPPPIntlUSDof2017Abs_median = median(dldata_GDPpcJPNPPPIntlUSDof2017);
%dldata_GDPpcJPNPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcJPNPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcJPNPPPIntlUSDof2017Abs_std = std(dldata_GDPpcJPNPPPIntlUSDof2017);

tabdlGDPpcJPNPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcJPNPPPIntlUSDof2017Abs_min';'dldata_GDPpcJPNPPPIntlUSDof2017Abs_max';'dldata_GDPpcJPNPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcJPNPPPIntlUSDof2017Abs_range';'dldata_GDPpcJPNPPPIntlUSDof2017Abs_mean';'dldata_GDPpcJPNPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcJPNPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcJPNPPPIntlUSDof2017Abs_min; dldata_GDPpcJPNPPPIntlUSDof2017Abs_max; dldata_GDPpcJPNPPPIntlUSDof2017Abs_range; stripe_GDPpcJPNPPPIntlUSDof2017Abs_range; dldata_GDPpcJPNPPPIntlUSDof2017Abs_mean; dldata_GDPpcJPNPPPIntlUSDof2017Abs_median; dldata_GDPpcJPNPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcJPNPPPIntlUSDof2017Abs,'tabdlGDPpcJPNUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the JPN CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig171 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksCO2) max(ticksCO2)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksCO2,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksCO2',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_CO2pcJPNMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the Japan per capita for 1990-2020');
title('Japan');

saveas(gcf,'CO2JPNpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2JPNpcAbs.png')
saveas(gcf,'CO2JPNpcAbs.epsc')

CO2JPNpcAbs = imread('CO2JPNpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig172 = figure
plot(ticksCO2,data_CO2pcJPNMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('JPN CO2 emissions pc, in metric tons')
title('JPN CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcJPNMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcJPNMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcJPNMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig173 = figure
plot(ticksdlCO2,dldata_CO2pcJPNMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Japan CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Japan CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcJPNMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcJPNMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcJPNMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig174 = figure
histogram(data_CO2pcJPNMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Japan CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcJPNMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcJPNMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcJPNMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig175 = figure
histogram(dldata_CO2pcJPNMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Japan CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcJPNMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcJPNMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcJPNMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcJPNMetricTonsAbs_min = min(data_CO2pcJPNMetricTons)
data_CO2pcJPNMetricTonsAbs_max = max(data_CO2pcJPNMetricTons)
data_CO2pcJPNMetricTonsAbs_range = data_CO2pcJPNMetricTonsAbs_max - data_CO2pcJPNMetricTonsAbs_min
stripe_CO2pcJPNMetricTonsAbs_range = data_CO2pcJPNMetricTonsAbs_range/16
data_CO2pcJPNMetricTonsAbs_mean = mean(data_CO2pcJPNMetricTons)
data_CO2pcJPNMetricTonsAbs_median = median(data_CO2pcJPNMetricTons)
%data_CO2pcJPNMetricTonsAbs_mode = mode(data_CO2pcJPNMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcJPNMetricTonsAbs_std = std(data_CO2pcJPNMetricTons);

tabCO2pcJPNMetricTonsAbs = table(categorical({'data_CO2pcJPNMetricTonsAbs_min';'data_CO2pcJPNMetricTonsAbs_max';'data_CO2pcJPNMetricTons_range';'stripe_CO2pcJPNMetricTonsAbs_range';'data_CO2pcJPNMetricTonsAbs_mean';'data_CO2pcJPNMetricTonsAbs_median';'data_CO2pcJPNMetricTonsAbs_std'}),{data_CO2pcJPNMetricTonsAbs_min; data_CO2pcJPNMetricTonsAbs_max; data_CO2pcJPNMetricTonsAbs_range; stripe_CO2pcJPNMetricTonsAbs_range; data_CO2pcJPNMetricTonsAbs_mean; data_CO2pcJPNMetricTonsAbs_median; data_CO2pcJPNMetricTonsAbs_std})
writetable(tabCO2pcJPNMetricTonsAbs,'tabCO2pcJPNMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcJPNMetricTonsAbs_min = min(dldata_CO2pcJPNMetricTons);
dldata_CO2pcJPNMetricTonsAbs_max = max(dldata_CO2pcJPNMetricTons);
dldata_CO2pcJPNMetricTonsAbs_range = dldata_CO2pcJPNMetricTonsAbs_max - dldata_CO2pcJPNMetricTonsAbs_min;
dlstripe_CO2pcJPNMetricTonsAbs_range = dldata_CO2pcJPNMetricTonsAbs_range/16;
dldata_CO2pcJPNMetricTonsAbs_mean = mean(dldata_CO2pcJPNMetricTons);
dldata_CO2pcJPNMetricTonsAbs_median = median(dldata_CO2pcJPNMetricTons);
%dldata_CO2pcJPNMetricTonsAbs_mode = mode(dldata_CO2pcJPNMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcJPNMetricTonsAbs_std = std(dldata_CO2pcJPNMetricTons);

tabdlCO2pcJPNMetricTonsAbs = table(categorical({'data_CO2pcJPNMetricTonsAbs_min';'data_CO2pcJPNMetricTonsAbs_max';'data_CO2pcJPNMetricTons_range';'stripe_CO2pcJPNMetricTonsAbs_range';'data_CO2pcJPNMetricTonsAbs_mean';'data_CO2pcJPNMetricTonsAbs_median'; 'dldata_CO2pcJPNMetricTonsAbs_std'}),{data_CO2pcJPNMetricTonsAbs_min; data_CO2pcJPNMetricTonsAbs_max; data_CO2pcJPNMetricTonsAbs_range; stripe_CO2pcJPNMetricTonsAbs_range; data_CO2pcJPNMetricTonsAbs_mean; data_CO2pcJPNMetricTonsAbs_median; dldata_CO2pcJPNMetricTonsAbs_std})
writetable(tabdlCO2pcJPNMetricTonsAbs,'tabdlCO2pcJPNMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the JPN Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig176 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProspGDP) max(ticksGreenProspGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProspGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProspGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Japan Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020 ');
title('Japan');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017JPNpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017JPNpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017JPNpcAbs.epsc')

CO2JPNpcAbs = imread('CO2JPNpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig177 = figure
plot(ticksGreenProspGDP,data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Japan greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Japan Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017JPNpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017JPNpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017JPNpcAbs.epsc')

%% Plot - growth rates

fig178 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Japan greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Japan Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017JPNpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017JPNpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017JPNpcAbs.epsc')


%% Histogram - absolute level

fig179 = figure
histogram(data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Japan Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017JPNpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017JPNpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017JPNpcAbs.epsc')

%% Histogram - growth rates

fig180 = figure
histogram(dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Japan Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017JPNAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017JPNAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017JPNAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcJPNDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcJPNDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcJPNDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcJPNDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231006 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% MULTIPLOT FIGURES %%%

fig181 = figure

subplot(3,4,1)
plot(ticksGDP,data_GDPpcWorldPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average world GDP per capita in PPP international USD of 2017')
title('World');

subplot(3,4,2)
plot(ticksGDP,data_GDPpcHiIncCsPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average HiIncCs GDP per capita in PPP international USD of 2017')
title('High-Income Countries')

subplot(3,4,3)
plot(ticksGDP,data_GDPpcLoIncCsPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average LoIncCs GDP per capita in PPP international USD of 2017')
title('Low-Income Countries')

subplot(3,4,4)
plot(ticksGDP,data_GDPpcUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('USGDP per capita in PPP international USD of 2017')
title('US');

subplot(3,4,5)
plot(ticksGDP,data_GDPpcUKPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('UK GDP per capita in PPP international USD of 2017')
title('UK');

subplot(3,4,6)
plot(ticksGDP,data_GDPpcEUPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('EU GDP per capita in PPP international USD of 2017')
title('EU');

subplot(3,4,7)
plot(ticksGDP,data_GDPpcAUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('AUS GDP per capita in PPP international USD of 2017')
title('Australia');

subplot(3,4,8)
plot(ticksGDP,data_GDPpcJPNPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('JAP GDP per capita in PPP international USD of 2017')
title('Japan');

subplot(3,4,9)
plot(ticksGDP,data_GDPpcCHNPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHN GDP per capita in PPP international USD of 2017')
title('China');

subplot(3,4,10)
plot(ticksGDP,data_GDPpcINDPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('IND GDP per capita in PPP international USD of 2017')
title('India');

subplot(3,4,11)
plot(ticksGDP,data_GDPpcBRAPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BRA GDP per capita in PPP international USD of 2017')
title('Brazil');

subplot(3,4,12)
plot(ticksGDP,data_GDPpcMOZPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MOZ GDP per capita in PPP international USD of 2017')
title('Mozambique');

saveas(gcf,'MultiPlot12_GDPpcPPPUSDof2017.fig')
saveas(gcf,'MultiPlot12_GDPpcPPPUSDof2017.png')
saveas(gcf,'MultiPlot12_GDPpcPPPUSDof2017.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig182 = figure

subplot(3,4,1)
plot(ticksdlGDP,dldata_GDPpcWorldPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average world GDP per capita in PPP international USD of 2017')
title('World');

subplot(3,4,2)
plot(ticksdlGDP,dldata_GDPpcHiIncCsPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average HiIncCs GDP per capita in PPP international USD of 2017')
title('High-Income Css')

subplot(3,4,3)
plot(ticksdlGDP,dldata_GDPpcLoIncCsPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average LoIncCs GDP per capita in PPP international USD of 2017')
title('Low-Income Cs')

subplot(3,4,4)
plot(ticksdlGDP,dldata_GDPpcUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('US GDP per capita in PPP international USD of 2017')
title('US');

subplot(3,4,5)
plot(ticksdlGDP,dldata_GDPpcUKPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('UK GDP per capita in PPP international USD of 2017')
title('UK');

subplot(3,4,6)
plot(ticksdlGDP,dldata_GDPpcEUPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('EU GDP per capita in PPP international USD of 2017')
title('EU');

subplot(3,4,7)
plot(ticksdlGDP,dldata_GDPpcAUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('AUS GDP per capita in PPP international USD of 2017')
title('Australia');

subplot(3,4,8)
plot(ticksdlGDP,dldata_GDPpcJPNPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('JAP GDP per capita in PPP international USD of 2017')
title('Japan');

subplot(3,4,9)
plot(ticksdlGDP,dldata_GDPpcCHNPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHN GDP per capita in PPP international USD of 2017')
title('China');

subplot(3,4,10)
plot(ticksdlGDP,dldata_GDPpcINDPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('IND GDP per capita in PPP international USD of 2017')
title('India');

subplot(3,4,11)
plot(ticksdlGDP,dldata_GDPpcBRAPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BRA GDP per capita in PPP international USD of 2017')
title('Brazil');

subplot(3,4,12)
plot(ticksdlGDP,dldata_GDPpcMOZPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MOZ GDP per capita in PPP international USD of 2017')
title('Mozambique');

saveas(gcf,'MultiPlot12_dlGDPpcPPPUSDof2017.fig')
saveas(gcf,'MultiPlot12_dlGDPpcPPPUSDof2017.png')
saveas(gcf,'MultiPlot12_dlGDPpcPPPUSDof2017.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig183 = figure

subplot(3,4,1)
plot(ticksCO2,data_CO2pcWorldMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average world GDP per capita in PPP international USD of 2017')
title('World');

subplot(3,4,2)
plot(ticksCO2,data_CO2pcHiIncCsMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average HiIncCs GDP per capita in PPP international USD of 2017')
title('High-Income Cs')

subplot(3,4,3)
plot(ticksCO2,data_CO2pcLoIncCsMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average LoIncCs GDP per capita in PPP international USD of 2017')
title('Low-Income Cs')

subplot(3,4,4)
plot(ticksCO2,data_CO2pcUSMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('USGDP per capita in PPP international USD of 2017')
title('US');

subplot(3,4,5)
plot(ticksCO2,data_CO2pcUKMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('UK GDP per capita in PPP international USD of 2017')
title('UK');

subplot(3,4,6)
plot(ticksCO2,data_CO2pcEUMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('EU GDP per capita in PPP international USD of 2017')
title('EU');

subplot(3,4,7)
plot(ticksCO2,data_CO2pcAUSMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('AUS GDP per capita in PPP international USD of 2017')
title('Australia');

subplot(3,4,8)
plot(ticksCO2, data_CO2pcJPNMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('JPN GDP per capita in PPP international USD of 2017')
title('Japan');

subplot(3,4,9)
plot(ticksCO2,data_CO2pcCHNMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHN GDP per capita in PPP international USD of 2017')
title('China');

subplot(3,4,10)
plot(ticksCO2,data_CO2pcINDMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('IND GDP per capita in PPP international USD of 2017')
title('India');

subplot(3,4,11)
plot(ticksCO2,data_CO2pcBRAMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BRA GDP per capita in PPP international USD of 2017')
title('Brazil');

subplot(3,4,12)
plot(ticksCO2,data_CO2pcMOZMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MOZ GDP per capita in PPP international USD of 2017')
title('Mozambique');

saveas(gcf,'MultiPlot12_CO2pcMetricTons.fig')
saveas(gcf,'MultiPlot12_CO2pcMetricTons.png')
saveas(gcf,'MultiPlot12_CO2pcMetricTons.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig184 = figure

subplot(3,4,1)
plot(ticksdlCO2,dldata_CO2pcWorldMetricTons,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average world GDP per capita in PPP international USD of 2017')
title('World');

subplot(3,4,2)
plot(ticksdlCO2,dldata_CO2pcHiIncCsMetricTons, 'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average HiIncCs GDP per capita in PPP international USD of 2017')
title('High-Income Cs')

subplot(3,4,3)
plot(ticksdlCO2,dldata_CO2pcLoIncCsMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average LoIncCs GDP per capita in PPP international USD of 2017')
title('Low-Income Cs')

subplot(3,4,4)
plot(ticksdlCO2,dldata_CO2pcUSMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('US GDP per capita in PPP international USD of 2017')
title('US');

subplot(3,4,5)
plot(ticksdlCO2,dldata_CO2pcUKMetricTons,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('UK GDP per capita in PPP international USD of 2017')
title('UK');

subplot(3,4,6)
plot(ticksdlCO2,dldata_CO2pcEUMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('EU GDP per capita in PPP international USD of 2017')
title('EU');

subplot(3,4,7)
plot(ticksdlCO2,dldata_CO2pcAUSMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('AUS GDP per capita in PPP international USD of 2017')
title('Australia');

subplot(3,4,8)
plot(ticksdlCO2,dldata_CO2pcJPNMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('JPN GDP per capita in PPP international USD of 2017')
title('Japan');

subplot(3,4,9)
plot(ticksdlCO2,dldata_CO2pcCHNMetricTons,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHN GDP per capita in PPP international USD of 2017')
title('China');

subplot(3,4,10)
plot(ticksdlCO2,dldata_CO2pcINDMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('IND GDP per capita in PPP international USD of 2017')
title('India');

subplot(3,4,11)
plot(ticksdlCO2,dldata_CO2pcBRAMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BRA GDP per capita in PPP international USD of 2017')
title('Brazil');

subplot(3,4,12)
plot(ticksdlCO2,dldata_CO2pcMOZMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MOZ GDP per capita in PPP international USD of 2017')
title('Mozambique');

saveas(gcf,'MultiPlot12_dlCO2pcMetricTons.fig')
saveas(gcf,'MultiPlot12_dlCO2pcMetricTons.png')
saveas(gcf,'MultiPlot12_dlCO2pcMetricTons.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig185 = figure

subplot(3,4,1)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average world greening prosperity ratio')
title('World)');

subplot(3,4,2)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average HiIncCs GDP per capita in PPP international USD of 2017')
title('High-Income Cs')

subplot(3,4,3)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017 ,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average LoIncCs GDP per capita in PPP international USD of 2017')
title('Low-Income Cs')

subplot(3,4,4)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('USGDP per capita in PPP international USD of 2017')
title('US');

subplot(3,4,5)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017 ,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('UK GDP per capita in PPP international USD of 2017')
title('UK');

subplot(3,4,6)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('EU GDP per capita in PPP international USD of 2017')
title('EU');

subplot(3,4,7)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('AUS GDP per capita in PPP international USD of 2017')
title('Australia');

subplot(3,4,8)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('JPN GDP per capita in PPP international USD of 2017')
title('Japan');

subplot(3,4,9)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHN GDP per capita in PPP international USD of 2017')
title('China');

subplot(3,4,10)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('IND GDP per capita in PPP international USD of 2017')
title('India');

subplot(3,4,11)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BRA GDP per capita in PPP international USD of 2017')
title('Brazil');

subplot(3,4,12)
plot(ticksGreenProsppcWorldGDP,data_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MOZ GDP per capita in PPP international USD of 2017')
title('Mozambique');

saveas(gcf,'MultiPlot12_GreenProsppcDefByGDPpc.fig')
saveas(gcf,'MultiPlot12_GreenProsppcDefByGDPpc.png')
saveas(gcf,'MultiPlot12_GreenProsppcDefByGDPpc.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig186 = figure

subplot(3,4,1)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcWorldDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average world GDP per capita in PPP international USD of 2017')
title('World');

subplot(3,4,2)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcHiIncCsDefByGDPpcPPPIntlUSDof2017, 'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average HiIncCs GDP per capita in PPP international USD of 2017')
title('High-Income Cs')

subplot(3,4,3)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcLoIncCsDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average LoIncCs GDP per capita in PPP international USD of 2017')
title('Low-Income Cs')

subplot(3,4,4)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('US GDP per capita in PPP international USD of 2017')
title('US');

subplot(3,4,5)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcUKDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('UK GDP per capita in PPP international USD of 2017')
title('UK');

subplot(3,4,6)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcEUDefByGDPpcPPPIntlUSDof2017 ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('EU GDP per capita in PPP international USD of 2017')
title('EU');

subplot(3,4,7)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcAUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('AUS GDP per capita in PPP international USD of 2017')
title('Australia');

subplot(3,4,8)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcJPNDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('JPN GDP per capita in PPP international USD of 2017')
title('Japan');

subplot(3,4,9)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcCHNDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHN GDP per capita in PPP international USD of 2017')
title('China');

subplot(3,4,10)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcINDDefByGDPpcPPPIntlUSDof2017 ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('IND GDP per capita in PPP international USD of 2017')
title('India');

subplot(3,4,11)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcBRADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BRA GDP per capita in PPP international USD of 2017')
title('Brazil');

subplot(3,4,12)
plot(ticksdlGreenProsppcWorldGDP,dldata_GreenProsppcMOZDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MOZ GDP per capita in PPP international USD of 2017')
title('Mozambique');

saveas(gcf,'MultiPlot12_dlGreenProsppcDefByGDPpc.fig')
saveas(gcf,'MultiPlot12_dlGreenProsppcDefByGDPpc.png')
saveas(gcf,'MultiPlot12_dlGreenProsppcDefByGDPpc.epsc')


%%% AM231007 Trying (again) to fix the stripe colourmaps in multiplots %%%


fig187 = figure

subplot(3,4,1)
%fig1 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcWorldPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Average World GDP per capita in PPP IntlUSD of 2017 for 1990-1990');

subplot(3,4,2)
%fig16 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcHiIncCsPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Average High-Income Countries GDP per capita in PPP Intl USD of 2017 for 1990-1990');

subplot(3,4,3)
%fig31 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcLoIncCsPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Average Low-Income Countries GDP per capita in PPP Intl USD of 2017 for 1990-1990');

subplot(3,4,4)
%fig46 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcUSPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('US GDP per capita in PPP Intl USD of 2017 for 1990-1990');

subplot(3,4,5)
%fig76 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcUKPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('UK');

subplot(3,4,6)
%fig136 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcEUPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('EU');

subplot(3,4,7)
%fig121 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcAUSPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Australia');

subplot(3,4,8)
%fig166 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcJPNPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Japan');

subplot(3,4,9)
%fig91 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcCHNPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('China');

subplot(3,4,10)
%fig151 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcINDPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('India');

subplot(3,4,11)
%fig106 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcBRAPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Brazil');

subplot(3,4,12)
%fig61 = figure('Position',[100 100 800 300],...
   %'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGDP) max(ticksGDP)],...
   'XTickMode','manual',...
   'XTick',ticksGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGDP',...
   'YData',[2000 2040],...
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcMOZPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Mozambique');

saveas(gcf,'MultiPlot12_StripesGDPpcPPPUSDof2017.fig')
saveas(gcf,'MultiPlot12_StripesGDPpcPPPUSDof2017.png')
saveas(gcf,'MultiPlot12_StripesGDPpcPPPUSDof2017.epsc')


%%%%%%%%%%%%%%%%%%%%%%%



%%% END of (long) program %%%