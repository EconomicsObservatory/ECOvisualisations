%% MATLAB program to create stripes colormap of GDP pc in PPP international USD of 2017, CO2 pc and GPR pc for 2nd Subsample
% File name: GDPpcCO2pcStripes2ndSmpl2Groups10Countries_am231204.m
% AM230630 in R2017a 1st trial -> and success! -> based on:
% http://mres.uni-potsdam.de/index.php/2022/11/16/ed-hawkins-warming-stripes-with-matlab/
% AM230701 in R2023a minor edits and development
% AM230709 in R2023a further minor edits and development
% AM230720 in R2023a major development and addition of CO2 emissions and a brown-to-green colormap
% AM230720 in R2023a further improvenets and addition of greening prosperity ratio stripes
% AM231005 in R2023a switching to GDP pc in PPP inernational USD of 2017 and addition of greening prosperity ratio stripes
% AM231006 in R2023a adding together World, HiIncCs, LoIncCs, US, EU, China
% AM231007 in R2023a trying (again) to fix the stripe colormaps in multiplots -> unsuccessful again (see the figure at the bottom of the code), but just fixed it in Overleaf/Beamer!
% AM231115 in R2023a 2nd sample
% AM231116 in R2023a Reordering the countries by logic in the multiplot 4x3 figures at the end and increasing the upper bound of the figures for Switzerland
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

diary GDPpcCO2pcStripes2ndSmpl2Groups10Countries_am231204.txt % create a diary log (*.txt) file saving the output from the command window
tic                          % start stopwatch timer
t = datetime('now')          % return a datetime scalar representing the current date and time

%% Upper Middle-Income Countries (UMC) - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcUMCPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI254:BM254');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcUMCPPPIntlUSDof2017 = log(data_GDPpcUMCPPPIntlUSDof2017);
dldata_GDPpcUMCPPPIntlUSDof2017 = diff(ldata_GDPpcUMCPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcUMCMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI254:BM254');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcUMCMetricTons = log(data_CO2pcUMCMetricTons);
dldata_CO2pcUMCMetricTons = diff(ldata_CO2pcUMCMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017 = data_GDPpcUMCPPPIntlUSDof2017 ./ data_CO2pcUMCMetricTons;
ticksGreenProsppcUMCGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProsppcUMCGDP = 1991:2020;

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

%% Creating the UMC GDP pc Figures

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
   'CData',data_GDPpcUMCPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average Upper Middle-Income Cs GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Upper Middle-Income Cs');

saveas(gcf,'GDPUMCpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPUMCpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPUMCpcPPPIntlUSDof2017Abs.epsc')

GDPWpcDev = imread('GDPUMCpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Plot - absolute level

fig2 = figure
plot(ticksGDP,data_GDPpcUMCPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average UMC GDP per capita in PPP international USD of 2017')
title('Average UMC GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Plot - growth rates

fig3 = figure
plot(ticksdlGDP,dldata_GDPpcUMCPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of average UMC GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Average UMC GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - absolute level

fig4 = figure
histogram(data_GDPpcUMCPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average UMC GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig5 = figure
histogram(dldata_GDPpcUMCPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Average UMC GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcUMCPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcUMCPPPIntlUSDof2017Abs_min = min(data_GDPpcUMCPPPIntlUSDof2017);
data_GDPpcUMCPPPIntlUSDof2017Abs_max = max(data_GDPpcUMCPPPIntlUSDof2017);
data_GDPpcUMCPPPIntlUSDof2017Abs_range = data_GDPpcUMCPPPIntlUSDof2017Abs_max - data_GDPpcUMCPPPIntlUSDof2017Abs_min;
stripe_GDPpcUMCPPPIntlUSDof2017Abs_range = data_GDPpcUMCPPPIntlUSDof2017Abs_range/16;
data_GDPpcUMCPPPIntlUSDof2017Abs_mean = mean(data_GDPpcUMCPPPIntlUSDof2017);
data_GDPpcUMCPPPIntlUSDof2017Abs_median = median(data_GDPpcUMCPPPIntlUSDof2017);
%data_GDPpcUMCPPPIntlUSDof2017Abs_mode = mode(data_GDPpcUMCPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GDPpcUMCPPPIntlUSDof2017Abs_std = std(data_GDPpcUMCPPPIntlUSDof2017);

tabGDPpcUMCPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcUMCPPPIntlUSDof2017Abs_min';'data_GDPpcUMCPPPIntlUSDof2017Abs_max';'data_GDPpcUMCPPPIntlUSDof2017Abs_range';'stripe_GDPpcUMCPPPIntlUSDof2017Abs_range';'data_GDPpcUMCPPPIntlUSDof2017Abs_mean';'data_GDPpcUMCPPPIntlUSDof2017Abs_median'; 'data_GDPpcUMCPPPIntlUSDof2017Abs_std'}),{data_GDPpcUMCPPPIntlUSDof2017Abs_min; data_GDPpcUMCPPPIntlUSDof2017Abs_max; data_GDPpcUMCPPPIntlUSDof2017Abs_range; stripe_GDPpcUMCPPPIntlUSDof2017Abs_range; data_GDPpcUMCPPPIntlUSDof2017Abs_mean; data_GDPpcUMCPPPIntlUSDof2017Abs_median; data_GDPpcUMCPPPIntlUSDof2017Abs_std});
writetable(tabGDPpcUMCPPPIntlUSDof2017Abs,'tabGDPpcUMCUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcUMCPPPIntlUSDof2017Abs_min = min(dldata_GDPpcUMCPPPIntlUSDof2017);
dldata_GDPpcUMCPPPIntlUSDof2017Abs_max = max(dldata_GDPpcUMCPPPIntlUSDof2017);
dldata_GDPpcUMCPPPIntlUSDof2017Abs_range = dldata_GDPpcUMCPPPIntlUSDof2017Abs_max - dldata_GDPpcUMCPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcUMCPPPIntlUSDof2017Abs_range = dldata_GDPpcUMCPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcUMCPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcUMCPPPIntlUSDof2017);
dldata_GDPpcUMCPPPIntlUSDof2017Abs_median = median(dldata_GDPpcUMCPPPIntlUSDof2017);
%dldata_GDPpcUMCPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcUMCPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcUMCPPPIntlUSDof2017Abs_std = std(dldata_GDPpcUMCPPPIntlUSDof2017);

tabdlGDPpcUMCPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcUMCPPPIntlUSDof2017Abs_min';'dldata_GDPpcUMCPPPIntlUSDof2017Abs_max';'dldata_GDPpcUMCPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcUMCPPPIntlUSDof2017Abs_range';'dldata_GDPpcUMCPPPIntlUSDof2017Abs_mean';'dldata_GDPpcUMCPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcUMCPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcUMCPPPIntlUSDof2017Abs_min; dldata_GDPpcUMCPPPIntlUSDof2017Abs_max; dldata_GDPpcUMCPPPIntlUSDof2017Abs_range; stripe_GDPpcUMCPPPIntlUSDof2017Abs_range; dldata_GDPpcUMCPPPIntlUSDof2017Abs_mean; dldata_GDPpcUMCPPPIntlUSDof2017Abs_median; dldata_GDPpcUMCPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcUMCPPPIntlUSDof2017Abs,'tabdlGDPpcUMCUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the UMC CO2 pc Figures

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
   'CData',data_CO2pcUMCMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average UMC CO2 Emissions per capita for 1990-2020');
title('UMC');

saveas(gcf,'CO2UMCpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2UMCpcAbs.png')
saveas(gcf,'CO2UMCpcAbs.epsc')

CO2WpcAbs = imread('CO2UMCpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig7 = figure
plot(ticksCO2,data_CO2pcUMCMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average UMC CO2 emissions pc, in metric tons')
title('Average UMC CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcUMCMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcUMCMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcUMCMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig8 = figure
plot(ticksdlCO2,dldata_CO2pcUMCMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of average UMC CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Average UMC CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcUMCMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcUMCMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcUMCMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig9 = figure
histogram(data_CO2pcUMCMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average UMC CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcUMCMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcUMCMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcUMCMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig10 = figure
histogram(dldata_CO2pcUMCMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Average UMC CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcUMCMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcUMCMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcUMCMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcUMCMetricTonsAbs_min = min(data_CO2pcUMCMetricTons);
data_CO2pcUMCMetricTonsAbs_max = max(data_CO2pcUMCMetricTons);
data_CO2pcUMCMetricTonsAbs_range = data_CO2pcUMCMetricTonsAbs_max - data_CO2pcUMCMetricTonsAbs_min;
stripe_CO2pcUMCMetricTonsAbs_range = data_CO2pcUMCMetricTonsAbs_range/16;
data_CO2pcUMCMetricTonsAbs_mean = mean(data_CO2pcUMCMetricTons);
data_CO2pcUMCMetricTonsAbs_median = median(data_CO2pcUMCMetricTons);
%data_CO2pcUMCMetricTonsAbs_mode = mode(data_CO2pcUMCMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
data_CO2pcUMCMetricTonsAbs_std = std(data_CO2pcUMCMetricTons);

tabCO2pcUMCMetricTonsAbs = table(categorical({'data_CO2pcUMCMetricTonsAbs_min';'data_CO2pcUMCMetricTonsAbs_max';'data_CO2pcUMCMetricTons_range';'stripe_CO2pcUMCMetricTonsAbs_range';'data_CO2pcUMCMetricTonsAbs_mean';'data_CO2pcUMCMetricTonsAbs_median'; 'data_CO2pcUMCMetricTonsAbs_std'}),{data_CO2pcUMCMetricTonsAbs_min; data_CO2pcUMCMetricTonsAbs_max; data_CO2pcUMCMetricTonsAbs_range; stripe_CO2pcUMCMetricTonsAbs_range; data_CO2pcUMCMetricTonsAbs_mean; data_CO2pcUMCMetricTonsAbs_median; data_CO2pcUMCMetricTonsAbs_std});
writetable(tabCO2pcUMCMetricTonsAbs,'tabCO2pcUMCMetricTonsAbs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeneingProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcUMCMetricTonsAbs_min = min(dldata_CO2pcUMCMetricTons);
dldata_CO2pcUMCMetricTonsAbs_max = max(dldata_CO2pcUMCMetricTons);
dldata_CO2pcUMCMetricTonsAbs_range = dldata_CO2pcUMCMetricTonsAbs_max - dldata_CO2pcUMCMetricTonsAbs_min;
dlstripe_CO2pcUMCMetricTonsAbs_range = dldata_CO2pcUMCMetricTonsAbs_range/16;
dldata_CO2pcUMCMetricTonsAbs_mean = mean(dldata_CO2pcUMCMetricTons);
dldata_CO2pcUMCMetricTonsAbs_median = median(dldata_CO2pcUMCMetricTons);
%dldata_CO2pcUMCMetricTonsAbs_mode = mode(dldata_CO2pcUMCMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcUMCMetricTonsAbs_std = std(dldata_CO2pcUMCMetricTons);

tabdlCO2pcUMCMetricTonsAbs = table(categorical({'data_CO2pcUMCMetricTonsAbs_min';'data_CO2pcUMCMetricTonsAbs_max';'data_CO2pcUMCMetricTons_range';'stripe_CO2pcUMCMetricTonsAbs_range';'data_CO2pcUMCMetricTonsAbs_mean';'data_CO2pcUMCMetricTonsAbs_median'; 'dldata_CO2pcUMCMetricTonsAbs_std'}),{data_CO2pcUMCMetricTonsAbs_min; data_CO2pcUMCMetricTonsAbs_max; data_CO2pcUMCMetricTonsAbs_range; stripe_CO2pcUMCMetricTonsAbs_range; data_CO2pcUMCMetricTonsAbs_mean; data_CO2pcUMCMetricTonsAbs_median; dldata_CO2pcUMCMetricTonsAbs_std})
writetable(tabdlCO2pcUMCMetricTonsAbs,'tabdlCO2pcUMCMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the UMC Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig11 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProsppcUMCGDP) max(ticksGreenProsppcUMCGDP)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProsppcUMCGDP,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProsppcUMCGDP',...
   'YData',[2000 2040],...c
   'XData',[1990 2020],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average UMC Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('UMC');

saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017UMCAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017UMCAbs.png')
saveas(gcf,'GreenProsppcDefGDPpcPPPUSD2017UMCAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017WpcAbs = imread('GreenProsppcDefGDPpcPPPUSD2017UMCAbs.png'); %AM230701 after checking online

%% Plot - absolute level

fig12 = figure
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average UMC greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Average UMC Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017UMCAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017UMCAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017UMCAbs.epsc')

%% Plot - growth rates

fig13 = figure
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth ratess (in % pa) of average UMC greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa)of Average UMC Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017UMCAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017UMCAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017UMCAbs.epsc')

%% Histogram - absolute level

fig14 = figure
histogram(data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average UMC Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017UMCAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017UMCAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017UMCAbs.epsc')

%% Histogram - growth rates

fig15 = figure
histogram(dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Average UMC Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017UMCAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017UMCAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017UMCAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017_range';'stripe_CO2pcUMCMetricTonsAbs_range';'data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_CO2pcUMCMetricTonsAbs_range; data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs ,'tabGreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_CO2pcUMCMetricTonsAbs_range';'dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_mean';'dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_median'; 'dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_CO2pcUMCMetricTonsAbs_range; dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcUMCDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Lower Middle-Income Countries (LMC) - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcLMCPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI144:BM144');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcLMCPPPIntlUSDof2017 = log(data_GDPpcLMCPPPIntlUSDof2017);
dldata_GDPpcLMCPPPIntlUSDof2017 = diff(ldata_GDPpcLMCPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcLMCMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI144:BM144');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcLMCMetricTons = log(data_CO2pcLMCMetricTons);
dldata_CO2pcLMCMetricTons = diff(ldata_CO2pcLMCMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017 = data_GDPpcLMCPPPIntlUSDof2017 ./ data_CO2pcLMCMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the LMC GDP pc Figures

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
   'CData',data_GDPpcLMCPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average Lower Middle-Income Countries GDP per capita in PPP International USD of 2017 for 1990-1990');
title(['Lower Middle-Income Cs']);

saveas(gcf,'GDPLMCpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPLMCpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPLMCpcPPPIntlUSDof2017Abs.epsc')

GDPLMCpcDev = imread('GDPLMCpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig17 = figure
plot(ticksGDP,data_GDPpcLMCPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average LMC GDP per capita in PPP international USD of 2017')
title('Average LMC GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig18 = figure
plot(ticksdlGDP,dldata_GDPpcLMCPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of average LMC GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Average LMC GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig19 = figure
histogram(data_GDPpcLMCPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average LMC GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig20 = figure
histogram(dldata_GDPpcLMCPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of LMC GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcLMCPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcLMCPPPIntlUSDof2017Abs_min = min(data_GDPpcLMCPPPIntlUSDof2017)
data_GDPpcLMCPPPIntlUSDof2017Abs_max = max(data_GDPpcLMCPPPIntlUSDof2017)
data_GDPpcLMCPPPIntlUSDof2017Abs_range = data_GDPpcLMCPPPIntlUSDof2017Abs_max - data_GDPpcLMCPPPIntlUSDof2017Abs_min
stripe_GDPpcLMCPPPIntlUSDof2017Abs_range = data_GDPpcLMCPPPIntlUSDof2017Abs_range/16
data_GDPpcLMCPPPIntlUSDof2017Abs_mean = mean(data_GDPpcLMCPPPIntlUSDof2017)
data_GDPpcLMCPPPIntlUSDof2017Abs_median = median(data_GDPpcLMCPPPIntlUSDof2017)
%data_GDPpcLMCPPPIntlUSDof2017Abs_mode = mode(data_GDPpcLMCPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcLMCPPPIntlUSDof2017Abs_std = std(data_GDPpcLMCPPPIntlUSDof2017);

tabGDPpcLMCPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcLMCPPPIntlUSDof2017Abs_min';'data_GDPpcLMCPPPIntlUSDof2017Abs_max';'data_GDPpcLMCPPPIntlUSDof2017Abs_range';'stripe_GDPpcLMCPPPIntlUSDof2017Abs_range';'data_GDPpcLMCPPPIntlUSDof2017Abs_mean';'data_GDPpcLMCPPPIntlUSDof2017Abs_median';'data_GDPpcLMCPPPIntlUSDof2017Abs_std'}),{data_GDPpcLMCPPPIntlUSDof2017Abs_min; data_GDPpcLMCPPPIntlUSDof2017Abs_max; data_GDPpcLMCPPPIntlUSDof2017Abs_range; stripe_GDPpcLMCPPPIntlUSDof2017Abs_range; data_GDPpcLMCPPPIntlUSDof2017Abs_mean; data_GDPpcLMCPPPIntlUSDof2017Abs_median; data_GDPpcLMCPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcLMCPPPIntlUSDof2017Abs,'tabGDPpcLMCUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcLMCPPPIntlUSDof2017Abs_min = min(dldata_GDPpcLMCPPPIntlUSDof2017);
dldata_GDPpcLMCPPPIntlUSDof2017Abs_max = max(dldata_GDPpcLMCPPPIntlUSDof2017);
dldata_GDPpcLMCPPPIntlUSDof2017Abs_range = dldata_GDPpcLMCPPPIntlUSDof2017Abs_max - dldata_GDPpcLMCPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcLMCPPPIntlUSDof2017Abs_range = dldata_GDPpcLMCPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcLMCPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcLMCPPPIntlUSDof2017);
dldata_GDPpcLMCPPPIntlUSDof2017Abs_median = median(dldata_GDPpcLMCPPPIntlUSDof2017);
%dldata_GDPpcLMCPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcLMCPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcLMCPPPIntlUSDof2017Abs_std = std(dldata_GDPpcLMCPPPIntlUSDof2017);

tabdlGDPpcLMCPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcLMCPPPIntlUSDof2017Abs_min';'dldata_GDPpcLMCPPPIntlUSDof2017Abs_max';'dldata_GDPpcLMCPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcLMCPPPIntlUSDof2017Abs_range';'dldata_GDPpcLMCPPPIntlUSDof2017Abs_mean';'dldata_GDPpcLMCPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcLMCPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcLMCPPPIntlUSDof2017Abs_min; dldata_GDPpcLMCPPPIntlUSDof2017Abs_max; dldata_GDPpcLMCPPPIntlUSDof2017Abs_range; stripe_GDPpcLMCPPPIntlUSDof2017Abs_range; dldata_GDPpcLMCPPPIntlUSDof2017Abs_mean; dldata_GDPpcLMCPPPIntlUSDof2017Abs_median; dldata_GDPpcLMCPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcLMCPPPIntlUSDof2017Abs,'tabdlGDPpcLMCUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the LMC CO2 pc Figures

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
   'CData',data_CO2pcLMCMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average CO2 Emissions in the LMC per capita for 1990-2020');
title('LMC');

saveas(gcf,'CO2LMCpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2LMCpcAbs.png')
saveas(gcf,'CO2LMCpcAbs.epsc')

CO2LMCpcAbs = imread('CO2LMCpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig22 = figure
plot(ticksCO2,data_CO2pcLMCMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average LMC CO2 emissions pc, in metric tons')
title('Average LMC CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcLMCMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcLMCMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcLMCMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig23 = figure
plot(ticksdlCO2,dldata_CO2pcLMCMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of average LMC CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Average LMC CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcLMCMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcLMCMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcLMCMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig24 = figure
histogram(data_CO2pcLMCMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average LMC CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcLMCMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcLMCMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcLMCMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig25 = figure
histogram(dldata_CO2pcLMCMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Average LMC CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcLMCMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcLMCMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcLMCMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcLMCMetricTonsAbs_min = min(data_CO2pcLMCMetricTons)
data_CO2pcLMCMetricTonsAbs_max = max(data_CO2pcLMCMetricTons)
data_CO2pcLMCMetricTonsAbs_range = data_CO2pcLMCMetricTonsAbs_max - data_CO2pcLMCMetricTonsAbs_min
stripe_CO2pcLMCMetricTonsAbs_range = data_CO2pcLMCMetricTonsAbs_range/16
data_CO2pcLMCMetricTonsAbs_mean = mean(data_CO2pcLMCMetricTons)
data_CO2pcLMCMetricTonsAbs_median = median(data_CO2pcLMCMetricTons)
%data_CO2pcLMCMetricTonsAbs_mode = mode(data_CO2pcLMCMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcLMCMetricTonsAbs_std = std(data_CO2pcLMCMetricTons);

tabCO2pcLMCMetricTonsAbs = table(categorical({'data_CO2pcLMCMetricTonsAbs_min';'data_CO2pcLMCMetricTonsAbs_max';'data_CO2pcLMCMetricTons_range';'stripe_CO2pcLMCMetricTonsAbs_range';'data_CO2pcLMCMetricTonsAbs_mean';'data_CO2pcLMCMetricTonsAbs_median';'data_CO2pcLMCMetricTonsAbs_std'}),{data_CO2pcLMCMetricTonsAbs_min; data_CO2pcLMCMetricTonsAbs_max; data_CO2pcLMCMetricTonsAbs_range; stripe_CO2pcLMCMetricTonsAbs_range; data_CO2pcLMCMetricTonsAbs_mean; data_CO2pcLMCMetricTonsAbs_median; data_CO2pcLMCMetricTonsAbs_std})
writetable(tabCO2pcLMCMetricTonsAbs,'tabCO2pcLMCMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcLMCMetricTonsAbs_min = min(dldata_CO2pcLMCMetricTons);
dldata_CO2pcLMCMetricTonsAbs_max = max(dldata_CO2pcLMCMetricTons);
dldata_CO2pcLMCMetricTonsAbs_range = dldata_CO2pcLMCMetricTonsAbs_max - dldata_CO2pcLMCMetricTonsAbs_min;
dlstripe_CO2pcLMCMetricTonsAbs_range = dldata_CO2pcLMCMetricTonsAbs_range/16;
dldata_CO2pcLMCMetricTonsAbs_mean = mean(dldata_CO2pcLMCMetricTons);
dldata_CO2pcLMCMetricTonsAbs_median = median(dldata_CO2pcLMCMetricTons);
%dldata_CO2pcLMCMetricTonsAbs_mode = mode(dldata_CO2pcLMCMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcLMCMetricTonsAbs_std = std(dldata_CO2pcLMCMetricTons);

tabdlCO2pcLMCMetricTonsAbs = table(categorical({'data_CO2pcLMCMetricTonsAbs_min';'data_CO2pcLMCMetricTonsAbs_max';'data_CO2pcLMCMetricTons_range';'stripe_CO2pcLMCMetricTonsAbs_range';'data_CO2pcLMCMetricTonsAbs_mean';'data_CO2pcLMCMetricTonsAbs_median'; 'dldata_CO2pcLMCMetricTonsAbs_std'}),{data_CO2pcLMCMetricTonsAbs_min; data_CO2pcLMCMetricTonsAbs_max; data_CO2pcLMCMetricTonsAbs_range; stripe_CO2pcLMCMetricTonsAbs_range; data_CO2pcLMCMetricTonsAbs_mean; data_CO2pcLMCMetricTonsAbs_median; dldata_CO2pcLMCMetricTonsAbs_std})
writetable(tabdlCO2pcLMCMetricTonsAbs,'tabdlCO2pcLMCMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the LMC Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average LMC Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('LMC');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017LMCpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017LMCpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017LMCpcAbs.epsc')

CO2LMCpcAbs = imread('CO2LMCpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig27 = figure
plot(ticksGreenProspGDP,data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('average LMC greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Average LMC Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017LMCpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017LMCpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017LMCpcAbs.epsc')

%% Plot - growth rates

fig28 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of average LMC greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Average LMC Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017LMCpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017LMCpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017LMCpcAbs.epsc')


%% Histogram - absolute level

fig29 = figure
histogram(data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average LMC Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017LMCpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017LMCpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017LMCpcAbs.epsc')

%% Histogram - growth rates

fig30 = figure
histogram(dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Average LMC Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017LMCAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017LMCAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017LMCAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcLMCDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcLMCDefByGDPpcPPPIntUSDof2017Abs,'tabGreenProsppcLMCDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcLMCDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Germany - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcDEUPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI60:BM60');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcDEUPPPIntlUSDof2017 = log(data_GDPpcDEUPPPIntlUSDof2017);
dldata_GDPpcDEUPPPIntlUSDof2017 = diff(ldata_GDPpcDEUPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcDEUMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI60:BM60');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcDEUMetricTons = log(data_CO2pcDEUMetricTons);
dldata_CO2pcDEUMetricTons = diff(ldata_CO2pcDEUMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017 = data_GDPpcDEUPPPIntlUSDof2017 ./ data_CO2pcDEUMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProsppcDEUGDP = 1991:2020;

%% Creating the DEU GDP pc Figures

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
   'CData',data_GDPpcDEUPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average Low-Income Countries GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Germany');

saveas(gcf,'GDPDEUpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPDEUpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPDEUpcPPPIntlUSDof2017Abs.epsc')

GDPDEUpcDev = imread('GDPDEUpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig32 = figure
plot(ticksGDP,data_GDPpcDEUPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Germany GDP per capita in PPP international USD of 2017')
title('Germany GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig33 = figure
plot(ticksdlGDP,dldata_GDPpcDEUPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Germany GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Germany GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig34 = figure
histogram(data_GDPpcDEUPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Germany GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig35 = figure
histogram(dldata_GDPpcDEUPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Germany GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcDEUPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcDEUPPPIntlUSDof2017Abs_min = min(data_GDPpcDEUPPPIntlUSDof2017)
data_GDPpcDEUPPPIntlUSDof2017Abs_max = max(data_GDPpcDEUPPPIntlUSDof2017)
data_GDPpcDEUPPPIntlUSDof2017Abs_range = data_GDPpcDEUPPPIntlUSDof2017Abs_max - data_GDPpcDEUPPPIntlUSDof2017Abs_min
stripe_GDPpcDEUPPPIntlUSDof2017Abs_range = data_GDPpcDEUPPPIntlUSDof2017Abs_range/16
data_GDPpcDEUPPPIntlUSDof2017Abs_mean = mean(data_GDPpcDEUPPPIntlUSDof2017)
data_GDPpcDEUPPPIntlUSDof2017Abs_median = median(data_GDPpcDEUPPPIntlUSDof2017)
%data_GDPpcDEUPPPIntlUSDof2017Abs_mode = mode(data_GDPpcDEUPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcDEUPPPIntlUSDof2017Abs_std = std(data_GDPpcDEUPPPIntlUSDof2017);

tabGDPpcDEUPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcDEUPPPIntlUSDof2017Abs_min';'data_GDPpcDEUPPPIntlUSDof2017Abs_max';'data_GDPpcDEUPPPIntlUSDof2017Abs_range';'stripe_GDPpcDEUPPPIntlUSDof2017Abs_range';'data_GDPpcDEUPPPIntlUSDof2017Abs_mean';'data_GDPpcDEUPPPIntlUSDof2017Abs_median';'data_GDPpcDEUPPPIntlUSDof2017Abs_std'}),{data_GDPpcDEUPPPIntlUSDof2017Abs_min; data_GDPpcDEUPPPIntlUSDof2017Abs_max; data_GDPpcDEUPPPIntlUSDof2017Abs_range; stripe_GDPpcDEUPPPIntlUSDof2017Abs_range; data_GDPpcDEUPPPIntlUSDof2017Abs_mean; data_GDPpcDEUPPPIntlUSDof2017Abs_median; data_GDPpcDEUPPPIntlUSDof2017Abs_std});
writetable(tabGDPpcDEUPPPIntlUSDof2017Abs,'tabGDPpcDEUUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcDEUPPPIntlUSDof2017Abs_min = min(dldata_GDPpcDEUPPPIntlUSDof2017);
dldata_GDPpcDEUPPPIntlUSDof2017Abs_max = max(dldata_GDPpcDEUPPPIntlUSDof2017);
dldata_GDPpcDEUPPPIntlUSDof2017Abs_range = dldata_GDPpcDEUPPPIntlUSDof2017Abs_max - dldata_GDPpcDEUPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcDEUPPPIntlUSDof2017Abs_range = dldata_GDPpcDEUPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcDEUPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcDEUPPPIntlUSDof2017);
dldata_GDPpcDEUPPPIntlUSDof2017Abs_median = median(dldata_GDPpcDEUPPPIntlUSDof2017);
%dldata_GDPpcDEUPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcDEUPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcDEUPPPIntlUSDof2017Abs_std = std(dldata_GDPpcDEUPPPIntlUSDof2017);

tabdlGDPpcDEUPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcDEUPPPIntlUSDof2017Abs_min';'dldata_GDPpcDEUPPPIntlUSDof2017Abs_max';'dldata_GDPpcDEUPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcDEUPPPIntlUSDof2017Abs_range';'dldata_GDPpcDEUPPPIntlUSDof2017Abs_mean';'dldata_GDPpcDEUPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcDEUPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcDEUPPPIntlUSDof2017Abs_min; dldata_GDPpcDEUPPPIntlUSDof2017Abs_max; dldata_GDPpcDEUPPPIntlUSDof2017Abs_range; stripe_GDPpcDEUPPPIntlUSDof2017Abs_range; dldata_GDPpcDEUPPPIntlUSDof2017Abs_mean; dldata_GDPpcDEUPPPIntlUSDof2017Abs_median; dldata_GDPpcDEUPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcDEUPPPIntlUSDof2017Abs,'tabdlGDPpcDEUUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the DEU CO2 pc Figures

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
   'CData',data_CO2pcDEUMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Germany CO2 Emissions per capita for 1990-2020');
title('Germany');

saveas(gcf,'CO2DEUpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2DEUpcAbs.png')
saveas(gcf,'CO2DEUpcAbs.epsc')

CO2DEUpcAbs = imread('CO2DEUpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig37 = figure
plot(ticksCO2,data_CO2pcDEUMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel(['Germany CO2 emissions pc, in metric tons'])
title('Germany CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcDEUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcDEUMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcDEUMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig38 = figure
plot(ticksdlCO2,dldata_CO2pcDEUMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Germany CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Germany CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcDEUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcDEUMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcDEUMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig39 = figure
histogram(data_CO2pcDEUMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Germany CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcDEUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcDEUMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcDEUMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig40 = figure
histogram(dldata_CO2pcDEUMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Germany CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcDEUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcDEUMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcDEUMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcDEUMetricTonsAbs_min = min(data_CO2pcDEUMetricTons)
data_CO2pcDEUMetricTonsAbs_max = max(data_CO2pcDEUMetricTons)
data_CO2pcDEUMetricTonsAbs_range = data_CO2pcDEUMetricTonsAbs_max - data_CO2pcDEUMetricTonsAbs_min
stripe_CO2pcDEUMetricTonsAbs_range = data_CO2pcDEUMetricTonsAbs_range/16
data_CO2pcDEUMetricTonsAbs_mean = mean(data_CO2pcDEUMetricTons)
data_CO2pcDEUMetricTonsAbs_median = median(data_CO2pcDEUMetricTons)
%data_CO2pcDEUMetricTonsAbs_mode = mode(data_CO2pcDEUMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcDEUMetricTonsAbs_std = std(data_CO2pcDEUMetricTons);

tabCO2pcDEUMetricTonsAbs = table(categorical({'data_CO2pcDEUMetricTonsAbs_min';'data_CO2pcDEUMetricTonsAbs_max';'data_CO2pcDEUMetricTons_range';'stripe_CO2pcDEUMetricTonsAbs_range';'data_CO2pcDEUMetricTonsAbs_mean';'data_CO2pcDEUMetricTonsAbs_median';'data_CO2pcDEUMetricTonsAbs_std'}),{data_CO2pcDEUMetricTonsAbs_min; data_CO2pcDEUMetricTonsAbs_max; data_CO2pcDEUMetricTonsAbs_range; stripe_CO2pcDEUMetricTonsAbs_range; data_CO2pcDEUMetricTonsAbs_mean; data_CO2pcDEUMetricTonsAbs_median; data_CO2pcDEUMetricTonsAbs_std})
writetable(tabCO2pcDEUMetricTonsAbs,'tabCO2pcDEUMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcDEUMetricTonsAbs_min = min(dldata_CO2pcDEUMetricTons);
dldata_CO2pcDEUMetricTonsAbs_max = max(dldata_CO2pcDEUMetricTons);
dldata_CO2pcDEUMetricTonsAbs_range = dldata_CO2pcDEUMetricTonsAbs_max - dldata_CO2pcDEUMetricTonsAbs_min;
dlstripe_CO2pcDEUMetricTonsAbs_range = dldata_CO2pcDEUMetricTonsAbs_range/16;
dldata_CO2pcDEUMetricTonsAbs_mean = mean(dldata_CO2pcDEUMetricTons);
dldata_CO2pcDEUMetricTonsAbs_median = median(dldata_CO2pcDEUMetricTons);
%dldata_CO2pcDEUMetricTonsAbs_mode = mode(dldata_CO2pcDEUMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcDEUMetricTonsAbs_std = std(dldata_CO2pcDEUMetricTons);

tabdlCO2pcDEUMetricTonsAbs = table(categorical({'data_CO2pcDEUMetricTonsAbs_min';'data_CO2pcDEUMetricTonsAbs_max';'data_CO2pcDEUMetricTons_range';'stripe_CO2pcDEUMetricTonsAbs_range';'data_CO2pcDEUMetricTonsAbs_mean';'data_CO2pcDEUMetricTonsAbs_median'; 'dldata_CO2pcDEUMetricTonsAbs_std'}),{data_CO2pcDEUMetricTonsAbs_min; data_CO2pcDEUMetricTonsAbs_max; data_CO2pcDEUMetricTonsAbs_range; stripe_CO2pcDEUMetricTonsAbs_range; data_CO2pcDEUMetricTonsAbs_mean; data_CO2pcDEUMetricTonsAbs_median; dldata_CO2pcDEUMetricTonsAbs_std})
writetable(tabdlCO2pcDEUMetricTonsAbs,'tabdlCO2pcDEUMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the DEU Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Germany Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Germany');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017DEUpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017DEUpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017DEUpcAbs.epsc')

CO2DEUpcAbs = imread('CO2DEUpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig42 = figure
plot(ticksGreenProspGDP,data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Germany greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Germany Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017DEUpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017DEUpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017DEUpcAbs.epsc')


%% Plot - growth rates

fig43 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Germany greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Germany Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017DEUpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017DEUpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017DEUpcAbs.epsc')


%% Histogram - absolute level

fig44 = figure
histogram(data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Germany Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017DEUpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017DEUpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017DEUpcAbs.epsc')

%% Histogram - growth rates

fig45 = figure
histogram(dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Germany Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017DEUAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017DEUAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017DEUAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcDEUDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcDEUDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcDEUDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcDEUDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% France - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcFRAPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI82:BM82');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcFRAPPPIntlUSDof2017 = log(data_GDPpcFRAPPPIntlUSDof2017);
dldata_GDPpcFRAPPPIntlUSDof2017 = diff(ldata_GDPpcFRAPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcFRAMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI82:BM82');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcFRAMetricTons = log(data_CO2pcFRAMetricTons);
dldata_CO2pcFRAMetricTons = diff(ldata_CO2pcFRAMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017 = data_GDPpcFRAPPPIntlUSDof2017 ./ data_CO2pcFRAMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the FRA GDP pc Figures

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
   'CData',data_GDPpcFRAPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('France GDP per capita in PPP International USD of 2017 for 1990-1990');
title('France');

saveas(gcf,'GDPFRApcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPFRApcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPFRApcPPPIntlUSDof2017Abs.epsc')

GDPFRApcDev = imread('GDPFRApcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig47 = figure
plot(ticksGDP,data_GDPpcFRAPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('France GDP per capita in PPP international USD of 2017')
title('France GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig48 = figure
plot(ticksdlGDP,dldata_GDPpcFRAPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of France GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of France GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig49 = figure
histogram(data_GDPpcFRAPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('France GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig50 = figure
histogram(dldata_GDPpcFRAPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of France GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcFRAPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcFRAPPPIntlUSDof2017Abs_min = min(data_GDPpcFRAPPPIntlUSDof2017)
data_GDPpcFRAPPPIntlUSDof2017Abs_max = max(data_GDPpcFRAPPPIntlUSDof2017)
data_GDPpcFRAPPPIntlUSDof2017Abs_range = data_GDPpcFRAPPPIntlUSDof2017Abs_max - data_GDPpcFRAPPPIntlUSDof2017Abs_min
stripe_GDPpcFRAPPPIntlUSDof2017Abs_range = data_GDPpcFRAPPPIntlUSDof2017Abs_range/16
data_GDPpcFRAPPPIntlUSDof2017Abs_mean = mean(data_GDPpcFRAPPPIntlUSDof2017)
data_GDPpcFRAPPPIntlUSDof2017Abs_median = median(data_GDPpcFRAPPPIntlUSDof2017)
%data_GDPpcFRAPPPIntlUSDof2017Abs_mode = mode(data_GDPpcFRAPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcFRAPPPIntlUSDof2017Abs_std = std(data_GDPpcFRAPPPIntlUSDof2017);

tabGDPpcFRAPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcFRAPPPIntlUSDof2017Abs_min';'data_GDPpcFRAPPPIntlUSDof2017Abs_max';'data_GDPpcFRAPPPIntlUSDof2017Abs_range';'stripe_GDPpcFRAPPPIntlUSDof2017Abs_range';'data_GDPpcFRAPPPIntlUSDof2017Abs_mean';'data_GDPpcFRAPPPIntlUSDof2017Abs_median';'data_GDPpcFRAPPPIntlUSDof2017Abs_std'}),{data_GDPpcFRAPPPIntlUSDof2017Abs_min; data_GDPpcFRAPPPIntlUSDof2017Abs_max; data_GDPpcFRAPPPIntlUSDof2017Abs_range; stripe_GDPpcFRAPPPIntlUSDof2017Abs_range; data_GDPpcFRAPPPIntlUSDof2017Abs_mean; data_GDPpcFRAPPPIntlUSDof2017Abs_median; data_GDPpcFRAPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcFRAPPPIntlUSDof2017Abs,'tabGDPpcFRCANDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcFRAPPPIntlUSDof2017Abs_min = min(dldata_GDPpcFRAPPPIntlUSDof2017);
dldata_GDPpcFRAPPPIntlUSDof2017Abs_max = max(dldata_GDPpcFRAPPPIntlUSDof2017);
dldata_GDPpcFRAPPPIntlUSDof2017Abs_range = dldata_GDPpcFRAPPPIntlUSDof2017Abs_max - dldata_GDPpcFRAPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcFRAPPPIntlUSDof2017Abs_range = dldata_GDPpcFRAPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcFRAPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcFRAPPPIntlUSDof2017);
dldata_GDPpcFRAPPPIntlUSDof2017Abs_median = median(dldata_GDPpcFRAPPPIntlUSDof2017);
%dldata_GDPpcFRAPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcFRAPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcFRAPPPIntlUSDof2017Abs_std = std(dldata_GDPpcFRAPPPIntlUSDof2017);

tabdlGDPpcFRAPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcFRAPPPIntlUSDof2017Abs_min';'dldata_GDPpcFRAPPPIntlUSDof2017Abs_max';'dldata_GDPpcFRAPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcFRAPPPIntlUSDof2017Abs_range';'dldata_GDPpcFRAPPPIntlUSDof2017Abs_mean';'dldata_GDPpcFRAPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcFRAPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcFRAPPPIntlUSDof2017Abs_min; dldata_GDPpcFRAPPPIntlUSDof2017Abs_max; dldata_GDPpcFRAPPPIntlUSDof2017Abs_range; stripe_GDPpcFRAPPPIntlUSDof2017Abs_range; dldata_GDPpcFRAPPPIntlUSDof2017Abs_mean; dldata_GDPpcFRAPPPIntlUSDof2017Abs_median; dldata_GDPpcFRAPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcFRAPPPIntlUSDof2017Abs,'tabdlGDPpcFRCANDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the FRA CO2 pc Figures

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
   'CData',data_CO2pcFRAMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the FRA per capita for 1990-2020');
title('France');

saveas(gcf,'CO2FRApcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2FRApcAbs.png')
saveas(gcf,'CO2FRApcAbs.epsc')

CO2FRApcAbs = imread('CO2FRApcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig52 = figure
plot(ticksCO2,data_CO2pcFRAMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('France CO2 emissions pc, in metric tons')
title('France CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcFRAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcFRAMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcFRAMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig53 = figure
plot(ticksdlCO2,dldata_CO2pcFRAMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of France CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of France CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcFRAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcFRAMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcFRAMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig54 = figure
histogram(data_CO2pcFRAMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('France CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcFRAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcFRAMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcFRAMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig55 = figure
histogram(dldata_CO2pcFRAMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of France CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcFRAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcFRAMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcFRAMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcFRAMetricTonsAbs_min = min(data_CO2pcFRAMetricTons)
data_CO2pcFRAMetricTonsAbs_max = max(data_CO2pcFRAMetricTons)
data_CO2pcFRAMetricTonsAbs_range = data_CO2pcFRAMetricTonsAbs_max - data_CO2pcFRAMetricTonsAbs_min
stripe_CO2pcFRAMetricTonsAbs_range = data_CO2pcFRAMetricTonsAbs_range/16
data_CO2pcFRAMetricTonsAbs_mean = mean(data_CO2pcFRAMetricTons)
data_CO2pcFRAMetricTonsAbs_median = median(data_CO2pcFRAMetricTons)
%data_CO2pcFRAMetricTonsAbs_mode = mode(data_CO2pcFRAMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcFRAMetricTonsAbs_std = std(data_CO2pcFRAMetricTons);

tabCO2pcFRAMetricTonsAbs = table(categorical({'data_CO2pcFRAMetricTonsAbs_min';'data_CO2pcFRAMetricTonsAbs_max';'data_CO2pcFRAMetricTons_range';'stripe_CO2pcFRAMetricTonsAbs_range';'data_CO2pcFRAMetricTonsAbs_mean';'data_CO2pcFRAMetricTonsAbs_median';'data_CO2pcFRAMetricTonsAbs_std'}),{data_CO2pcFRAMetricTonsAbs_min; data_CO2pcFRAMetricTonsAbs_max; data_CO2pcFRAMetricTonsAbs_range; stripe_CO2pcFRAMetricTonsAbs_range; data_CO2pcFRAMetricTonsAbs_mean; data_CO2pcFRAMetricTonsAbs_median; data_CO2pcFRAMetricTonsAbs_std})
writetable(tabCO2pcFRAMetricTonsAbs,'tabCO2pcFRAMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcFRAMetricTonsAbs_min = min(dldata_CO2pcFRAMetricTons);
dldata_CO2pcFRAMetricTonsAbs_max = max(dldata_CO2pcFRAMetricTons);
dldata_CO2pcFRAMetricTonsAbs_range = dldata_CO2pcFRAMetricTonsAbs_max - dldata_CO2pcFRAMetricTonsAbs_min;
dlstripe_CO2pcFRAMetricTonsAbs_range = dldata_CO2pcFRAMetricTonsAbs_range/16;
dldata_CO2pcFRAMetricTonsAbs_mean = mean(dldata_CO2pcFRAMetricTons);
dldata_CO2pcFRAMetricTonsAbs_median = median(dldata_CO2pcFRAMetricTons);
%dldata_CO2pcFRAMetricTonsAbs_mode = mode(dldata_CO2pcFRAMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcFRAMetricTonsAbs_std = std(dldata_CO2pcFRAMetricTons);

tabdlCO2pcFRAMetricTonsAbs = table(categorical({'data_CO2pcFRAMetricTonsAbs_min';'data_CO2pcFRAMetricTonsAbs_max';'data_CO2pcFRAMetricTons_range';'stripe_CO2pcFRAMetricTonsAbs_range';'data_CO2pcFRAMetricTonsAbs_mean';'data_CO2pcFRAMetricTonsAbs_median'; 'dldata_CO2pcFRAMetricTonsAbs_std'}),{data_CO2pcFRAMetricTonsAbs_min; data_CO2pcFRAMetricTonsAbs_max; data_CO2pcFRAMetricTonsAbs_range; stripe_CO2pcFRAMetricTonsAbs_range; data_CO2pcFRAMetricTonsAbs_mean; data_CO2pcFRAMetricTonsAbs_median; dldata_CO2pcFRAMetricTonsAbs_std})
writetable(tabdlCO2pcFRAMetricTonsAbs,'tabdlCO2pcFRAMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the FRA Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('FRA Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('France');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017FRApcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017FRApcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017FRApcAbs.epsc')

CO2FRApcAbs = imread('CO2FRApcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig57 = figure
plot(ticksGreenProspGDP,data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('France greening prosperity ratio pc (GDP pc / CO2 pc)')
title('France Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017FRApcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017FRApcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017FRApcAbs.epsc')

%% Plot - growth rates

fig58 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of France greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of France Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017FRApcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017FRApcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017FRApcAbs.epsc')


%% Histogram - absolute level

fig59 = figure
histogram(data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('France Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017FRApcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017FRApcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017FRApcAbs.epsc')

%% Histogram - growth rates

fig60 = figure
histogram(dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of France Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017FRAAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017FRAAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017FRAAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcFRADefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcFRADefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcFRADefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcFRADefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Italy - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcITAPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI121:BM121');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcITAPPPIntlUSDof2017 = log(data_GDPpcITAPPPIntlUSDof2017);
dldata_GDPpcITAPPPIntlUSDof2017 = diff(ldata_GDPpcITAPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcITAMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI121:BM121');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcITAMetricTons = log(data_CO2pcITAMetricTons);
dldata_CO2pcITAMetricTons = diff(ldata_CO2pcITAMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017 = data_GDPpcITAPPPIntlUSDof2017 ./ data_CO2pcITAMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the ITA GDP pc Figures

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
   'CData',data_GDPpcITAPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('ITA GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Italy');

saveas(gcf,'GDPITApcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPITApcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPITApcPPPIntlUSDof2017Abs.epsc')

GDPITApcDev = imread('GDPITApcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig62 = figure
plot(ticksGDP,data_GDPpcITAPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('ITA GDP per capita in PPP international USD of 2017')
title('ITA GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcITAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcITAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcITAPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig63 = figure
plot(ticksdlGDP,dldata_GDPpcITAPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Italy GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Italy GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcITAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcITAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcITAPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig64 = figure
histogram(data_GDPpcITAPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Italy GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcITAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcITAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcITAPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig65 = figure
histogram(dldata_GDPpcITAPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Italy GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcITAPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcITAPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcITAPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcITAPPPIntlUSDof2017Abs_min = min(data_GDPpcITAPPPIntlUSDof2017)
data_GDPpcITAPPPIntlUSDof2017Abs_max = max(data_GDPpcITAPPPIntlUSDof2017)
data_GDPpcITAPPPIntlUSDof2017Abs_range = data_GDPpcITAPPPIntlUSDof2017Abs_max - data_GDPpcITAPPPIntlUSDof2017Abs_min
stripe_GDPpcITAPPPIntlUSDof2017Abs_range = data_GDPpcITAPPPIntlUSDof2017Abs_range/16
data_GDPpcITAPPPIntlUSDof2017Abs_mean = mean(data_GDPpcITAPPPIntlUSDof2017)
data_GDPpcITAPPPIntlUSDof2017Abs_median = median(data_GDPpcITAPPPIntlUSDof2017)
%data_GDPpcITAPPPIntlUSDof2017Abs_mode = mode(data_GDPpcITAPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcITAPPPIntlUSDof2017Abs_std = std(data_GDPpcITAPPPIntlUSDof2017);

tabGDPpcITAPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcITAPPPIntlUSDof2017Abs_min';'data_GDPpcITAPPPIntlUSDof2017Abs_max';'data_GDPpcITAPPPIntlUSDof2017Abs_range';'stripe_GDPpcITAPPPIntlUSDof2017Abs_range';'data_GDPpcITAPPPIntlUSDof2017Abs_mean';'data_GDPpcITAPPPIntlUSDof2017Abs_median';'data_GDPpcITAPPPIntlUSDof2017Abs_std'}),{data_GDPpcITAPPPIntlUSDof2017Abs_min; data_GDPpcITAPPPIntlUSDof2017Abs_max; data_GDPpcITAPPPIntlUSDof2017Abs_range; stripe_GDPpcITAPPPIntlUSDof2017Abs_range; data_GDPpcITAPPPIntlUSDof2017Abs_mean; data_GDPpcITAPPPIntlUSDof2017Abs_median; data_GDPpcITAPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcITAPPPIntlUSDof2017Abs,'tabGDPpcITCANDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcITAPPPIntlUSDof2017Abs_min = min(dldata_GDPpcITAPPPIntlUSDof2017);
dldata_GDPpcITAPPPIntlUSDof2017Abs_max = max(dldata_GDPpcITAPPPIntlUSDof2017);
dldata_GDPpcITAPPPIntlUSDof2017Abs_range = dldata_GDPpcITAPPPIntlUSDof2017Abs_max - dldata_GDPpcITAPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcITAPPPIntlUSDof2017Abs_range = dldata_GDPpcITAPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcITAPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcITAPPPIntlUSDof2017);
dldata_GDPpcITAPPPIntlUSDof2017Abs_median = median(dldata_GDPpcITAPPPIntlUSDof2017);
%dldata_GDPpcITAPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcITAPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcITAPPPIntlUSDof2017Abs_std = std(dldata_GDPpcITAPPPIntlUSDof2017);

tabdlGDPpcITAPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcITAPPPIntlUSDof2017Abs_min';'dldata_GDPpcITAPPPIntlUSDof2017Abs_max';'dldata_GDPpcITAPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcITAPPPIntlUSDof2017Abs_range';'dldata_GDPpcITAPPPIntlUSDof2017Abs_mean';'dldata_GDPpcITAPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcITAPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcITAPPPIntlUSDof2017Abs_min; dldata_GDPpcITAPPPIntlUSDof2017Abs_max; dldata_GDPpcITAPPPIntlUSDof2017Abs_range; stripe_GDPpcITAPPPIntlUSDof2017Abs_range; dldata_GDPpcITAPPPIntlUSDof2017Abs_mean; dldata_GDPpcITAPPPIntlUSDof2017Abs_median; dldata_GDPpcITAPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcITAPPPIntlUSDof2017Abs,'tabdlGDPpcITCANDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the ITA CO2 pc Figures

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
   'CData',data_CO2pcITAMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Italy per capita for 1990-2020');
title('Italy');

saveas(gcf,'CO2ITApcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2ITApcAbs.png')
saveas(gcf,'CO2ITApcAbs.epsc')

CO2ITApcAbs = imread('CO2ITApcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig67 = figure
plot(ticksCO2,data_CO2pcITAMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Italy CO2 emissions pc, in metric tons')
title('Italy CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcITAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcITAMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcITAMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig68 = figure
plot(ticksdlCO2,dldata_CO2pcITAMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Italy CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Italy CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcITAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcITAMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcITAMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig69 = figure
histogram(data_CO2pcITAMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Italy CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcITAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcITAMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcITAMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig70 = figure
histogram(dldata_CO2pcITAMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Italy CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcITAMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcITAMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcITAMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcITAMetricTonsAbs_min = min(data_CO2pcITAMetricTons)
data_CO2pcITAMetricTonsAbs_max = max(data_CO2pcITAMetricTons)
data_CO2pcITAMetricTonsAbs_range = data_CO2pcITAMetricTonsAbs_max - data_CO2pcITAMetricTonsAbs_min
stripe_CO2pcITAMetricTonsAbs_range = data_CO2pcITAMetricTonsAbs_range/16
data_CO2pcITAMetricTonsAbs_mean = mean(data_CO2pcITAMetricTons)
data_CO2pcITAMetricTonsAbs_median = median(data_CO2pcITAMetricTons)
%data_CO2pcITAMetricTonsAbs_mode = mode(data_CO2pcITAMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcITAMetricTonsAbs_std = std(data_CO2pcITAMetricTons);

tabCO2pcITAMetricTonsAbs = table(categorical({'data_CO2pcITAMetricTonsAbs_min';'data_CO2pcITAMetricTonsAbs_max';'data_CO2pcITAMetricTons_range';'stripe_CO2pcITAMetricTonsAbs_range';'data_CO2pcITAMetricTonsAbs_mean';'data_CO2pcITAMetricTonsAbs_median';'data_CO2pcITAMetricTonsAbs_std'}),{data_CO2pcITAMetricTonsAbs_min; data_CO2pcITAMetricTonsAbs_max; data_CO2pcITAMetricTonsAbs_range; stripe_CO2pcITAMetricTonsAbs_range; data_CO2pcITAMetricTonsAbs_mean; data_CO2pcITAMetricTonsAbs_median; data_CO2pcITAMetricTonsAbs_std})
writetable(tabCO2pcITAMetricTonsAbs,'tabCO2pcITAMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcITAMetricTonsAbs_min = min(dldata_CO2pcITAMetricTons);
dldata_CO2pcITAMetricTonsAbs_max = max(dldata_CO2pcITAMetricTons);
dldata_CO2pcITAMetricTonsAbs_range = dldata_CO2pcITAMetricTonsAbs_max - dldata_CO2pcITAMetricTonsAbs_min;
dlstripe_CO2pcITAMetricTonsAbs_range = dldata_CO2pcITAMetricTonsAbs_range/16;
dldata_CO2pcITAMetricTonsAbs_mean = mean(dldata_CO2pcITAMetricTons);
dldata_CO2pcITAMetricTonsAbs_median = median(dldata_CO2pcITAMetricTons);
%dldata_CO2pcITAMetricTonsAbs_mode = mode(dldata_CO2pcITAMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcITAMetricTonsAbs_std = std(dldata_CO2pcITAMetricTons);

tabdlCO2pcITAMetricTonsAbs = table(categorical({'data_CO2pcITAMetricTonsAbs_min';'data_CO2pcITAMetricTonsAbs_max';'data_CO2pcITAMetricTons_range';'stripe_CO2pcITAMetricTonsAbs_range';'data_CO2pcITAMetricTonsAbs_mean';'data_CO2pcITAMetricTonsAbs_median'; 'dldata_CO2pcITAMetricTonsAbs_std'}),{data_CO2pcITAMetricTonsAbs_min; data_CO2pcITAMetricTonsAbs_max; data_CO2pcITAMetricTonsAbs_range; stripe_CO2pcITAMetricTonsAbs_range; data_CO2pcITAMetricTonsAbs_mean; data_CO2pcITAMetricTonsAbs_median; dldata_CO2pcITAMetricTonsAbs_std})
writetable(tabdlCO2pcITAMetricTonsAbs,'tabdlCO2pcITAMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the Italy Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Italy Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Italy');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017ITApcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017ITApcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017ITApcAbs.epsc')

CO2ITApcAbs = imread('CO2ITApcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig72 = figure
plot(ticksGreenProspGDP,data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Italy greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Italy Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017ITApcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017ITApcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017ITApcAbs.epsc')

%% Plot - growth rates

fig73 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Italy greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Italy Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017ITApcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017ITApcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017ITApcAbs.epsc')


%% Histogram - absolute level

fig74 = figure
histogram(data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Italy Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017ITApcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017ITApcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017ITApcAbs.epsc')

%% Histogram - growth rates

fig75 = figure
histogram(dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Italy Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017ITAAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017ITAAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017ITAAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcITADefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcITADefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcITADefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcITADefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Poland - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcPOLPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI195:BM195');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcPOLPPPIntlUSDof2017 = log(data_GDPpcPOLPPPIntlUSDof2017);
dldata_GDPpcPOLPPPIntlUSDof2017 = diff(ldata_GDPpcPOLPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcPOLMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI195:BM195');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcPOLMetricTons = log(data_CO2pcPOLMetricTons);
dldata_CO2pcPOLMetricTons = diff(ldata_CO2pcPOLMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017 = data_GDPpcPOLPPPIntlUSDof2017 ./ data_CO2pcPOLMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the POL GDP pc Figures

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
   'CData',data_GDPpcPOLPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Poland GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Poland');

saveas(gcf,'GDPPOLpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPPOLpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPPOLpcPPPIntlUSDof2017Abs.epsc')

GDPPOLpcDev = imread('GDPPOLpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig77 = figure
plot(ticksGDP,data_GDPpcPOLPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Poland GDP per capita in PPP international USD of 2017')
title('Poland GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig78 = figure
plot(ticksdlGDP,dldata_GDPpcPOLPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Poland GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Poland GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig79 = figure
histogram(data_GDPpcPOLPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Poland GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig80 = figure
histogram(dldata_GDPpcPOLPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Poland GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcPOLPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcPOLPPPIntlUSDof2017Abs_min = min(data_GDPpcPOLPPPIntlUSDof2017)
data_GDPpcPOLPPPIntlUSDof2017Abs_max = max(data_GDPpcPOLPPPIntlUSDof2017)
data_GDPpcPOLPPPIntlUSDof2017Abs_range = data_GDPpcPOLPPPIntlUSDof2017Abs_max - data_GDPpcPOLPPPIntlUSDof2017Abs_min
stripe_GDPpcPOLPPPIntlUSDof2017Abs_range = data_GDPpcPOLPPPIntlUSDof2017Abs_range/16
data_GDPpcPOLPPPIntlUSDof2017Abs_mean = mean(data_GDPpcPOLPPPIntlUSDof2017)
data_GDPpcPOLPPPIntlUSDof2017Abs_median = median(data_GDPpcPOLPPPIntlUSDof2017)
%data_GDPpcPOLPPPIntlUSDof2017Abs_mode = mode(data_GDPpcPOLPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcPOLPPPIntlUSDof2017Abs_std = std(data_GDPpcPOLPPPIntlUSDof2017);

tabGDPpcPOLPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcPOLPPPIntlUSDof2017Abs_min';'data_GDPpcPOLPPPIntlUSDof2017Abs_max';'data_GDPpcPOLPPPIntlUSDof2017Abs_range';'stripe_GDPpcPOLPPPIntlUSDof2017Abs_range';'data_GDPpcPOLPPPIntlUSDof2017Abs_mean';'data_GDPpcPOLPPPIntlUSDof2017Abs_median';'data_GDPpcPOLPPPIntlUSDof2017Abs_std'}),{data_GDPpcPOLPPPIntlUSDof2017Abs_min; data_GDPpcPOLPPPIntlUSDof2017Abs_max; data_GDPpcPOLPPPIntlUSDof2017Abs_range; stripe_GDPpcPOLPPPIntlUSDof2017Abs_range; data_GDPpcPOLPPPIntlUSDof2017Abs_mean; data_GDPpcPOLPPPIntlUSDof2017Abs_median; data_GDPpcPOLPPPIntlUSDof2017Abs_std});
writetable(tabGDPpcPOLPPPIntlUSDof2017Abs,'tabGDPpcPOLUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcPOLPPPIntlUSDof2017Abs_min = min(dldata_GDPpcPOLPPPIntlUSDof2017);
dldata_GDPpcPOLPPPIntlUSDof2017Abs_max = max(dldata_GDPpcPOLPPPIntlUSDof2017);
dldata_GDPpcPOLPPPIntlUSDof2017Abs_range = dldata_GDPpcPOLPPPIntlUSDof2017Abs_max - dldata_GDPpcPOLPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcPOLPPPIntlUSDof2017Abs_range = dldata_GDPpcPOLPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcPOLPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcPOLPPPIntlUSDof2017);
dldata_GDPpcPOLPPPIntlUSDof2017Abs_median = median(dldata_GDPpcPOLPPPIntlUSDof2017);
%dldata_GDPpcPOLPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcPOLPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcPOLPPPIntlUSDof2017Abs_std = std(dldata_GDPpcPOLPPPIntlUSDof2017);

tabdlGDPpcPOLPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcPOLPPPIntlUSDof2017Abs_min';'dldata_GDPpcPOLPPPIntlUSDof2017Abs_max';'dldata_GDPpcPOLPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcPOLPPPIntlUSDof2017Abs_range';'dldata_GDPpcPOLPPPIntlUSDof2017Abs_mean';'dldata_GDPpcPOLPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcPOLPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcPOLPPPIntlUSDof2017Abs_min; dldata_GDPpcPOLPPPIntlUSDof2017Abs_max; dldata_GDPpcPOLPPPIntlUSDof2017Abs_range; stripe_GDPpcPOLPPPIntlUSDof2017Abs_range; dldata_GDPpcPOLPPPIntlUSDof2017Abs_mean; dldata_GDPpcPOLPPPIntlUSDof2017Abs_median; dldata_GDPpcPOLPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcPOLPPPIntlUSDof2017Abs,'tabdlGDPpcPOLUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the POL CO2 pc Figures

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
   'CData',data_CO2pcPOLMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the POL per capita for 1990-2020');
title('Poland');

saveas(gcf,'CO2POLpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2POLpcAbs.png')
saveas(gcf,'CO2POLpcAbs.epsc')

CO2POLpcAbs = imread('CO2POLpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig82 = figure
plot(ticksCO2,data_CO2pcPOLMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Poland CO2 emissions pc, in metric tons')
title('Poland CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcPOLMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcPOLMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcPOLMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig83 = figure
plot(ticksdlCO2,dldata_CO2pcPOLMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Poland CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Poland CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcPOLMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcPOLMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcPOLMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig84 = figure
histogram(data_CO2pcPOLMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('POL CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcPOLMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcPOLMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcPOLMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig85 = figure
histogram(dldata_CO2pcPOLMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Poland CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcPOLMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcPOLMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcPOLMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcPOLMetricTonsAbs_min = min(data_CO2pcPOLMetricTons)
data_CO2pcPOLMetricTonsAbs_max = max(data_CO2pcPOLMetricTons)
data_CO2pcPOLMetricTonsAbs_range = data_CO2pcPOLMetricTonsAbs_max - data_CO2pcPOLMetricTonsAbs_min
stripe_CO2pcPOLMetricTonsAbs_range = data_CO2pcPOLMetricTonsAbs_range/16
data_CO2pcPOLMetricTonsAbs_mean = mean(data_CO2pcPOLMetricTons)
data_CO2pcPOLMetricTonsAbs_median = median(data_CO2pcPOLMetricTons)
%data_CO2pcPOLMetricTonsAbs_mode = mode(data_CO2pcPOLMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcPOLMetricTonsAbs_std = std(data_CO2pcPOLMetricTons);

tabCO2pcPOLMetricTonsAbs = table(categorical({'data_CO2pcPOLMetricTonsAbs_min';'data_CO2pcPOLMetricTonsAbs_max';'data_CO2pcPOLMetricTons_range';'stripe_CO2pcPOLMetricTonsAbs_range';'data_CO2pcPOLMetricTonsAbs_mean';'data_CO2pcPOLMetricTonsAbs_median';'data_CO2pcPOLMetricTonsAbs_std'}),{data_CO2pcPOLMetricTonsAbs_min; data_CO2pcPOLMetricTonsAbs_max; data_CO2pcPOLMetricTonsAbs_range; stripe_CO2pcPOLMetricTonsAbs_range; data_CO2pcPOLMetricTonsAbs_mean; data_CO2pcPOLMetricTonsAbs_median; data_CO2pcPOLMetricTonsAbs_std});
writetable(tabCO2pcPOLMetricTonsAbs,'tabCO2pcPOLMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcPOLMetricTonsAbs_min = min(dldata_CO2pcPOLMetricTons);
dldata_CO2pcPOLMetricTonsAbs_max = max(dldata_CO2pcPOLMetricTons);
dldata_CO2pcPOLMetricTonsAbs_range = dldata_CO2pcPOLMetricTonsAbs_max - dldata_CO2pcPOLMetricTonsAbs_min;
dlstripe_CO2pcPOLMetricTonsAbs_range = dldata_CO2pcPOLMetricTonsAbs_range/16;
dldata_CO2pcPOLMetricTonsAbs_mean = mean(dldata_CO2pcPOLMetricTons);
dldata_CO2pcPOLMetricTonsAbs_median = median(dldata_CO2pcPOLMetricTons);
%dldata_CO2pcPOLMetricTonsAbs_mode = mode(dldata_CO2pcPOLMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcPOLMetricTonsAbs_std = std(dldata_CO2pcPOLMetricTons);

tabdlCO2pcPOLMetricTonsAbs = table(categorical({'data_CO2pcPOLMetricTonsAbs_min';'data_CO2pcPOLMetricTonsAbs_max';'data_CO2pcPOLMetricTons_range';'stripe_CO2pcPOLMetricTonsAbs_range';'data_CO2pcPOLMetricTonsAbs_mean';'data_CO2pcPOLMetricTonsAbs_median'; 'dldata_CO2pcPOLMetricTonsAbs_std'}),{data_CO2pcPOLMetricTonsAbs_min; data_CO2pcPOLMetricTonsAbs_max; data_CO2pcPOLMetricTonsAbs_range; stripe_CO2pcPOLMetricTonsAbs_range; data_CO2pcPOLMetricTonsAbs_mean; data_CO2pcPOLMetricTonsAbs_median; dldata_CO2pcPOLMetricTonsAbs_std});
writetable(tabdlCO2pcPOLMetricTonsAbs,'tabdlCO2pcPOLMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the Poland Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('POL Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('POL');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017POLpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017POLpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017POLpcAbs.epsc')

CO2POLpcAbs = imread('CO2POLpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig87 = figure
plot(ticksGreenProspGDP,data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Poland greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Poland Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017POLpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017POLpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017POLpcAbs.epsc')

%% Plot - growth rates

fig88 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Poland greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Poland Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017POLpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017POLpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017POLpcAbs.epsc')


%% Histogram - absolute level

fig89 = figure
histogram(data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Poland Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017POLpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017POLpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017POLpcAbs.epsc')

%% Histogram - growth rates

fig90 = figure
histogram(dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Poland Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017POLAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017POLAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017POLAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcPOLDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcPOLDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcPOLDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcPOLDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Bulgaria - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcBGRPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI26:BM26');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcBGRPPPIntlUSDof2017 = log(data_GDPpcBGRPPPIntlUSDof2017);
dldata_GDPpcBGRPPPIntlUSDof2017 = diff(ldata_GDPpcBGRPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcBGRMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI26:BM26');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcBGRMetricTons = log(data_CO2pcBGRMetricTons);
dldata_CO2pcBGRMetricTons = diff(ldata_CO2pcBGRMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017 = data_GDPpcBGRPPPIntlUSDof2017 ./ data_CO2pcBGRMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the BGR GDP pc Figures

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
   'CData',data_GDPpcBGRPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Bulgaria GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Bulgaria');

saveas(gcf,'GDPBGRpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPBGRpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPBGRpcPPPIntlUSDof2017Abs.epsc')

GDPBGRpcDev = imread('GDPBGRpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig92 = figure
plot(ticksGDP,data_GDPpcBGRPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Bulgaria GDP per capita in PPP international USD of 2017')
title('Bulgaria GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig93 = figure
plot(ticksdlGDP,dldata_GDPpcBGRPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Bulgaria GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Bulgaria GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig94 = figure
histogram(data_GDPpcBGRPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Bulgaria GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig95 = figure
histogram(dldata_GDPpcBGRPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Bulgaria GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcBGRPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcBGRPPPIntlUSDof2017Abs_min = min(data_GDPpcBGRPPPIntlUSDof2017)
data_GDPpcBGRPPPIntlUSDof2017Abs_max = max(data_GDPpcBGRPPPIntlUSDof2017)
data_GDPpcBGRPPPIntlUSDof2017Abs_range = data_GDPpcBGRPPPIntlUSDof2017Abs_max - data_GDPpcBGRPPPIntlUSDof2017Abs_min
stripe_GDPpcBGRPPPIntlUSDof2017Abs_range = data_GDPpcBGRPPPIntlUSDof2017Abs_range/16
data_GDPpcBGRPPPIntlUSDof2017Abs_mean = mean(data_GDPpcBGRPPPIntlUSDof2017)
data_GDPpcBGRPPPIntlUSDof2017Abs_median = median(data_GDPpcBGRPPPIntlUSDof2017)
%data_GDPpcBGRPPPIntlUSDof2017Abs_mode = mode(data_GDPpcBGRPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcBGRPPPIntlUSDof2017Abs_std = std(data_GDPpcBGRPPPIntlUSDof2017);

tabGDPpcBGRPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcBGRPPPIntlUSDof2017Abs_min';'data_GDPpcBGRPPPIntlUSDof2017Abs_max';'data_GDPpcBGRPPPIntlUSDof2017Abs_range';'stripe_GDPpcBGRPPPIntlUSDof2017Abs_range';'data_GDPpcBGRPPPIntlUSDof2017Abs_mean';'data_GDPpcBGRPPPIntlUSDof2017Abs_median';'data_GDPpcBGRPPPIntlUSDof2017Abs_std'}),{data_GDPpcBGRPPPIntlUSDof2017Abs_min; data_GDPpcBGRPPPIntlUSDof2017Abs_max; data_GDPpcBGRPPPIntlUSDof2017Abs_range; stripe_GDPpcBGRPPPIntlUSDof2017Abs_range; data_GDPpcBGRPPPIntlUSDof2017Abs_mean; data_GDPpcBGRPPPIntlUSDof2017Abs_median; data_GDPpcBGRPPPIntlUSDof2017Abs_std});
writetable(tabGDPpcBGRPPPIntlUSDof2017Abs,'tabGDPpcBGRUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcBGRPPPIntlUSDof2017Abs_min = min(dldata_GDPpcBGRPPPIntlUSDof2017);
dldata_GDPpcBGRPPPIntlUSDof2017Abs_max = max(dldata_GDPpcBGRPPPIntlUSDof2017);
dldata_GDPpcBGRPPPIntlUSDof2017Abs_range = dldata_GDPpcBGRPPPIntlUSDof2017Abs_max - dldata_GDPpcBGRPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcBGRPPPIntlUSDof2017Abs_range = dldata_GDPpcBGRPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcBGRPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcBGRPPPIntlUSDof2017);
dldata_GDPpcBGRPPPIntlUSDof2017Abs_median = median(dldata_GDPpcBGRPPPIntlUSDof2017);
%dldata_GDPpcBGRPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcBGRPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcBGRPPPIntlUSDof2017Abs_std = std(dldata_GDPpcBGRPPPIntlUSDof2017);

tabdlGDPpcBGRPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcBGRPPPIntlUSDof2017Abs_min';'dldata_GDPpcBGRPPPIntlUSDof2017Abs_max';'dldata_GDPpcBGRPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcBGRPPPIntlUSDof2017Abs_range';'dldata_GDPpcBGRPPPIntlUSDof2017Abs_mean';'dldata_GDPpcBGRPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcBGRPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcBGRPPPIntlUSDof2017Abs_min; dldata_GDPpcBGRPPPIntlUSDof2017Abs_max; dldata_GDPpcBGRPPPIntlUSDof2017Abs_range; stripe_GDPpcBGRPPPIntlUSDof2017Abs_range; dldata_GDPpcBGRPPPIntlUSDof2017Abs_mean; dldata_GDPpcBGRPPPIntlUSDof2017Abs_median; dldata_GDPpcBGRPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcBGRPPPIntlUSDof2017Abs,'tabdlGDPpcBGRUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the BGR CO2 pc Figures

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
   'CData',data_CO2pcBGRMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Bulgaria per capita for 1990-2020');
title('Bulgaria');

saveas(gcf,'CO2BGRpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2BGRpcAbs.png')
saveas(gcf,'CO2BGRpcAbs.epsc')

CO2BGRpcAbs = imread('CO2BGRpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig97 = figure
plot(ticksCO2,data_CO2pcBGRMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Bulgaria CO2 emissions pc, in metric tons')
title('Bulgaria CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcBGRMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcBGRMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcBGRMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig98 = figure
plot(ticksdlCO2,dldata_CO2pcBGRMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Bulgaria CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Bulgaria CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcBGRMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcBGRMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcBGRMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig99 = figure
histogram(data_CO2pcBGRMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Bulgaria CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcBGRMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcBGRMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcBGRMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig100 = figure
histogram(dldata_CO2pcBGRMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Bulgaria CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcBGRMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcBGRMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcBGRMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcBGRMetricTonsAbs_min = min(data_CO2pcBGRMetricTons)
data_CO2pcBGRMetricTonsAbs_max = max(data_CO2pcBGRMetricTons)
data_CO2pcBGRMetricTonsAbs_range = data_CO2pcBGRMetricTonsAbs_max - data_CO2pcBGRMetricTonsAbs_min
stripe_CO2pcBGRMetricTonsAbs_range = data_CO2pcBGRMetricTonsAbs_range/16
data_CO2pcBGRMetricTonsAbs_mean = mean(data_CO2pcBGRMetricTons)
data_CO2pcBGRMetricTonsAbs_median = median(data_CO2pcBGRMetricTons)
%data_CO2pcBGRMetricTonsAbs_mode = mode(data_CO2pcBGRMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcBGRMetricTonsAbs_std = std(data_CO2pcBGRMetricTons);

tabCO2pcBGRMetricTonsAbs = table(categorical({'data_CO2pcBGRMetricTonsAbs_min';'data_CO2pcBGRMetricTonsAbs_max';'data_CO2pcBGRMetricTons_range';'stripe_CO2pcBGRMetricTonsAbs_range';'data_CO2pcBGRMetricTonsAbs_mean';'data_CO2pcBGRMetricTonsAbs_median';'data_CO2pcBGRMetricTonsAbs_std'}),{data_CO2pcBGRMetricTonsAbs_min; data_CO2pcBGRMetricTonsAbs_max; data_CO2pcBGRMetricTonsAbs_range; stripe_CO2pcBGRMetricTonsAbs_range; data_CO2pcBGRMetricTonsAbs_mean; data_CO2pcBGRMetricTonsAbs_median; data_CO2pcBGRMetricTonsAbs_std});
writetable(tabCO2pcBGRMetricTonsAbs,'tabCO2pcBGRMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcBGRMetricTonsAbs_min = min(dldata_CO2pcBGRMetricTons);
dldata_CO2pcBGRMetricTonsAbs_max = max(dldata_CO2pcBGRMetricTons);
dldata_CO2pcBGRMetricTonsAbs_range = dldata_CO2pcBGRMetricTonsAbs_max - dldata_CO2pcBGRMetricTonsAbs_min;
dlstripe_CO2pcBGRMetricTonsAbs_range = dldata_CO2pcBGRMetricTonsAbs_range/16;
dldata_CO2pcBGRMetricTonsAbs_mean = mean(dldata_CO2pcBGRMetricTons);
dldata_CO2pcBGRMetricTonsAbs_median = median(dldata_CO2pcBGRMetricTons);
%dldata_CO2pcBGRMetricTonsAbs_mode = mode(dldata_CO2pcBGRMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcBGRMetricTonsAbs_std = std(dldata_CO2pcBGRMetricTons);

tabdlCO2pcBGRMetricTonsAbs = table(categorical({'data_CO2pcBGRMetricTonsAbs_min';'data_CO2pcBGRMetricTonsAbs_max';'data_CO2pcBGRMetricTons_range';'stripe_CO2pcBGRMetricTonsAbs_range';'data_CO2pcBGRMetricTonsAbs_mean';'data_CO2pcBGRMetricTonsAbs_median'; 'dldata_CO2pcBGRMetricTonsAbs_std'}),{data_CO2pcBGRMetricTonsAbs_min; data_CO2pcBGRMetricTonsAbs_max; data_CO2pcBGRMetricTonsAbs_range; stripe_CO2pcBGRMetricTonsAbs_range; data_CO2pcBGRMetricTonsAbs_mean; data_CO2pcBGRMetricTonsAbs_median; dldata_CO2pcBGRMetricTonsAbs_std});
writetable(tabdlCO2pcBGRMetricTonsAbs,'tabdlCO2pcBGRMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the Bulgaria Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Bulgaria Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Bulgaria');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017BGRpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017BGRpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017BGRpcAbs.epsc')

CO2BGRpcAbs = imread('CO2BGRpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig102 = figure
plot(ticksGreenProspGDP,data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Bulgaria greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Bulgaria Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017BGRpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017BGRpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017BGRpcAbs.epsc')

%% Plot - growth rates

fig103 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Bulgaria greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Bulgaria Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017BGRpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017BGRpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017BGRpcAbs.epsc')


%% Histogram - absolute level

fig104 = figure
histogram(data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Bulgaria Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017BGRpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017BGRpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017BGRpcAbs.epsc')

%% Histogram - growth rates

fig105 = figure
histogram(dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Bulgaria Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017BGRAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017BGRAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017BGRAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcBGRDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcBGRDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcBGRDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcBGRDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Switzerland - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcCHEPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI42:BM42');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcCHEPPPIntlUSDof2017 = log(data_GDPpcCHEPPPIntlUSDof2017);
dldata_GDPpcCHEPPPIntlUSDof2017 = diff(ldata_GDPpcCHEPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcCHEMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI42:BM42');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcCHEMetricTons = log(data_CO2pcCHEMetricTons);
dldata_CO2pcCHEMetricTons = diff(ldata_CO2pcCHEMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017 = data_GDPpcCHEPPPIntlUSDof2017 ./ data_CO2pcCHEMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the CHE GDP pc Figures

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
   'CData',data_GDPpcCHEPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Switzerland GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Switzerland');

saveas(gcf,'GDPCHEpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPCHEpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPCHEpcPPPIntlUSDof2017Abs.epsc')

GDPCHEpcDev = imread('GDPCHEpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig107 = figure
plot(ticksGDP,data_GDPpcCHEPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Switzerland GDP per capita in PPP international USD of 2017')
title('Switzerland GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig108 = figure
plot(ticksdlGDP,dldata_GDPpcCHEPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Switzerland GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Switzerland GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig109 = figure
histogram(data_GDPpcCHEPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Switzerland GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig110 = figure
histogram(dldata_GDPpcCHEPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Switzerland GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcCHEPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcCHEPPPIntlUSDof2017Abs_min = min(data_GDPpcCHEPPPIntlUSDof2017)
data_GDPpcCHEPPPIntlUSDof2017Abs_max = max(data_GDPpcCHEPPPIntlUSDof2017)
data_GDPpcCHEPPPIntlUSDof2017Abs_range = data_GDPpcCHEPPPIntlUSDof2017Abs_max - data_GDPpcCHEPPPIntlUSDof2017Abs_min
stripe_GDPpcCHEPPPIntlUSDof2017Abs_range = data_GDPpcCHEPPPIntlUSDof2017Abs_range/16
data_GDPpcCHEPPPIntlUSDof2017Abs_mean = mean(data_GDPpcCHEPPPIntlUSDof2017)
data_GDPpcCHEPPPIntlUSDof2017Abs_median = median(data_GDPpcCHEPPPIntlUSDof2017)
%data_GDPpcCHEPPPIntlUSDof2017Abs_mode = mode(data_GDPpcCHEPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcCHEPPPIntlUSDof2017Abs_std = std(data_GDPpcCHEPPPIntlUSDof2017);

tabGDPpcCHEPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcCHEPPPIntlUSDof2017Abs_min';'data_GDPpcCHEPPPIntlUSDof2017Abs_max';'data_GDPpcCHEPPPIntlUSDof2017Abs_range';'stripe_GDPpcCHEPPPIntlUSDof2017Abs_range';'data_GDPpcCHEPPPIntlUSDof2017Abs_mean';'data_GDPpcCHEPPPIntlUSDof2017Abs_median';'data_GDPpcCHEPPPIntlUSDof2017Abs_std'}),{data_GDPpcCHEPPPIntlUSDof2017Abs_min; data_GDPpcCHEPPPIntlUSDof2017Abs_max; data_GDPpcCHEPPPIntlUSDof2017Abs_range; stripe_GDPpcCHEPPPIntlUSDof2017Abs_range; data_GDPpcCHEPPPIntlUSDof2017Abs_mean; data_GDPpcCHEPPPIntlUSDof2017Abs_median; data_GDPpcCHEPPPIntlUSDof2017Abs_std});
writetable(tabGDPpcCHEPPPIntlUSDof2017Abs,'tabGDPpcCHEUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcCHEPPPIntlUSDof2017Abs_min = min(dldata_GDPpcCHEPPPIntlUSDof2017);
dldata_GDPpcCHEPPPIntlUSDof2017Abs_max = max(dldata_GDPpcCHEPPPIntlUSDof2017);
dldata_GDPpcCHEPPPIntlUSDof2017Abs_range = dldata_GDPpcCHEPPPIntlUSDof2017Abs_max - dldata_GDPpcCHEPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcCHEPPPIntlUSDof2017Abs_range = dldata_GDPpcCHEPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcCHEPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcCHEPPPIntlUSDof2017);
dldata_GDPpcCHEPPPIntlUSDof2017Abs_median = median(dldata_GDPpcCHEPPPIntlUSDof2017);
%dldata_GDPpcCHEPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcCHEPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcCHEPPPIntlUSDof2017Abs_std = std(dldata_GDPpcCHEPPPIntlUSDof2017);

tabdlGDPpcCHEPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcCHEPPPIntlUSDof2017Abs_min';'dldata_GDPpcCHEPPPIntlUSDof2017Abs_max';'dldata_GDPpcCHEPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcCHEPPPIntlUSDof2017Abs_range';'dldata_GDPpcCHEPPPIntlUSDof2017Abs_mean';'dldata_GDPpcCHEPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcCHEPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcCHEPPPIntlUSDof2017Abs_min; dldata_GDPpcCHEPPPIntlUSDof2017Abs_max; dldata_GDPpcCHEPPPIntlUSDof2017Abs_range; stripe_GDPpcCHEPPPIntlUSDof2017Abs_range; dldata_GDPpcCHEPPPIntlUSDof2017Abs_mean; dldata_GDPpcCHEPPPIntlUSDof2017Abs_median; dldata_GDPpcCHEPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcCHEPPPIntlUSDof2017Abs,'tabdlGDPpcCHEUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the CHE CO2 pc Figures

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
   'CData',data_CO2pcCHEMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Brzail per capita for 1990-2020');
title('Switzerland');

saveas(gcf,'CO2CHEpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2CHEpcAbs.png')
saveas(gcf,'CO2CHEpcAbs.epsc')

CO2CHEpcAbs = imread('CO2CHEpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig112 = figure
plot(ticksCO2,data_CO2pcCHEMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Switzerland CO2 emissions pc, in metric tons')
title('Switzerland CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcCHEMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcCHEMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcCHEMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig113 = figure
plot(ticksdlCO2,dldata_CO2pcCHEMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Switzerland CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Switzerland CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcCHEMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcCHEMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcCHEMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig114 = figure
histogram(data_CO2pcCHEMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Switzerland CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcCHEMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcCHEMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcCHEMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig115 = figure
histogram(dldata_CO2pcCHEMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Switzerland CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcCHEMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcCHEMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcCHEMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcCHEMetricTonsAbs_min = min(data_CO2pcCHEMetricTons)
data_CO2pcCHEMetricTonsAbs_max = max(data_CO2pcCHEMetricTons)
data_CO2pcCHEMetricTonsAbs_range = data_CO2pcCHEMetricTonsAbs_max - data_CO2pcCHEMetricTonsAbs_min
stripe_CO2pcCHEMetricTonsAbs_range = data_CO2pcCHEMetricTonsAbs_range/16
data_CO2pcCHEMetricTonsAbs_mean = mean(data_CO2pcCHEMetricTons)
data_CO2pcCHEMetricTonsAbs_median = median(data_CO2pcCHEMetricTons)
%data_CO2pcCHEMetricTonsAbs_mode = mode(data_CO2pcCHEMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcCHEMetricTonsAbs_std = std(data_CO2pcCHEMetricTons);

tabCO2pcCHEMetricTonsAbs = table(categorical({'data_CO2pcCHEMetricTonsAbs_min';'data_CO2pcCHEMetricTonsAbs_max';'data_CO2pcCHEMetricTons_range';'stripe_CO2pcCHEMetricTonsAbs_range';'data_CO2pcCHEMetricTonsAbs_mean';'data_CO2pcCHEMetricTonsAbs_median';'data_CO2pcCHEMetricTonsAbs_std'}),{data_CO2pcCHEMetricTonsAbs_min; data_CO2pcCHEMetricTonsAbs_max; data_CO2pcCHEMetricTonsAbs_range; stripe_CO2pcCHEMetricTonsAbs_range; data_CO2pcCHEMetricTonsAbs_mean; data_CO2pcCHEMetricTonsAbs_median; data_CO2pcCHEMetricTonsAbs_std})
writetable(tabCO2pcCHEMetricTonsAbs,'tabCO2pcCHEMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcCHEMetricTonsAbs_min = min(dldata_CO2pcCHEMetricTons);
dldata_CO2pcCHEMetricTonsAbs_max = max(dldata_CO2pcCHEMetricTons);
dldata_CO2pcCHEMetricTonsAbs_range = dldata_CO2pcCHEMetricTonsAbs_max - dldata_CO2pcCHEMetricTonsAbs_min;
dlstripe_CO2pcCHEMetricTonsAbs_range = dldata_CO2pcCHEMetricTonsAbs_range/16;
dldata_CO2pcCHEMetricTonsAbs_mean = mean(dldata_CO2pcCHEMetricTons);
dldata_CO2pcCHEMetricTonsAbs_median = median(dldata_CO2pcCHEMetricTons);
%dldata_CO2pcCHEMetricTonsAbs_mode = mode(dldata_CO2pcCHEMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcCHEMetricTonsAbs_std = std(dldata_CO2pcCHEMetricTons);

tabdlCO2pcCHEMetricTonsAbs = table(categorical({'data_CO2pcCHEMetricTonsAbs_min';'data_CO2pcCHEMetricTonsAbs_max';'data_CO2pcCHEMetricTons_range';'stripe_CO2pcCHEMetricTonsAbs_range';'data_CO2pcCHEMetricTonsAbs_mean';'data_CO2pcCHEMetricTonsAbs_median'; 'dldata_CO2pcCHEMetricTonsAbs_std'}),{data_CO2pcCHEMetricTonsAbs_min; data_CO2pcCHEMetricTonsAbs_max; data_CO2pcCHEMetricTonsAbs_range; stripe_CO2pcCHEMetricTonsAbs_range; data_CO2pcCHEMetricTonsAbs_mean; data_CO2pcCHEMetricTonsAbs_median; dldata_CO2pcCHEMetricTonsAbs_std})
writetable(tabdlCO2pcCHEMetricTonsAbs,'tabdlCO2pcCHEMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the CHE Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Switzerland Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Switzerland');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017CHEpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017CHEpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017CHEpcAbs.epsc')

CO2CHEpcAbs = imread('CO2CHEpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig117 = figure
plot(ticksGreenProspGDP,data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Switzerland greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Switzerland Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CHEpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CHEpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CHEpcAbs.epsc')

%% Plot - growth rates

fig118 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Switzerland greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Switzerland Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017CHEpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017CHEpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017CHEpcAbs.epsc')


%% Histogram - absolute level

fig119 = figure
histogram(data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Switzerland Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017CHEpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017CHEpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017CHEpcAbs.epsc')

%% Histogram - growth rates

fig120 = figure
histogram(dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Switzerland Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017CHEAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017CHEAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017CHEAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcCHEDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcCHEDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcCHEDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcCHEDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Canada - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcCANPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI40:BM40');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcCANPPPIntlUSDof2017 = log(data_GDPpcCANPPPIntlUSDof2017);
dldata_GDPpcCANPPPIntlUSDof2017 = diff(ldata_GDPpcCANPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcCANMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI40:BM40');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcCANMetricTons = log(data_CO2pcCANMetricTons);
dldata_CO2pcCANMetricTons = diff(ldata_CO2pcCANMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017 = data_GDPpcCANPPPIntlUSDof2017 ./ data_CO2pcCANMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the CAN GDP pc Figures

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
   'CData',data_GDPpcCANPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Canada GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Canada');

saveas(gcf,'GDPCANpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPCANpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPCANpcPPPIntlUSDof2017Abs.epsc')

GDPCANpcDev = imread('GDPCANpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig122 = figure
plot(ticksGDP,data_GDPpcCANPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Canada GDP per capita in PPP international USD of 2017')
title('Canada GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcCANPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcCANPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcCANPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig123 = figure
plot(ticksdlGDP,dldata_GDPpcCANPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Canada GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Canada GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcCANPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcCANPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcCANPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig124 = figure
histogram(data_GDPpcCANPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Canada GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcCANPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcCANPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcCANPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig125 = figure
histogram(dldata_GDPpcCANPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Canada GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcCANPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcCANPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcCANPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcCANPPPIntlUSDof2017Abs_min = min(data_GDPpcCANPPPIntlUSDof2017)
data_GDPpcCANPPPIntlUSDof2017Abs_max = max(data_GDPpcCANPPPIntlUSDof2017)
data_GDPpcCANPPPIntlUSDof2017Abs_range = data_GDPpcCANPPPIntlUSDof2017Abs_max - data_GDPpcCANPPPIntlUSDof2017Abs_min
stripe_GDPpcCANPPPIntlUSDof2017Abs_range = data_GDPpcCANPPPIntlUSDof2017Abs_range/16
data_GDPpcCANPPPIntlUSDof2017Abs_mean = mean(data_GDPpcCANPPPIntlUSDof2017)
data_GDPpcCANPPPIntlUSDof2017Abs_median = median(data_GDPpcCANPPPIntlUSDof2017)
%data_GDPpcCANPPPIntlUSDof2017Abs_mode = mode(data_GDPpcCANPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcCANPPPIntlUSDof2017Abs_std = std(data_GDPpcCANPPPIntlUSDof2017);

tabGDPpcCANPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcCANPPPIntlUSDof2017Abs_min';'data_GDPpcCANPPPIntlUSDof2017Abs_max';'data_GDPpcCANPPPIntlUSDof2017Abs_range';'stripe_GDPpcCANPPPIntlUSDof2017Abs_range';'data_GDPpcCANPPPIntlUSDof2017Abs_mean';'data_GDPpcCANPPPIntlUSDof2017Abs_median';'data_GDPpcCANPPPIntlUSDof2017Abs_std'}),{data_GDPpcCANPPPIntlUSDof2017Abs_min; data_GDPpcCANPPPIntlUSDof2017Abs_max; data_GDPpcCANPPPIntlUSDof2017Abs_range; stripe_GDPpcCANPPPIntlUSDof2017Abs_range; data_GDPpcCANPPPIntlUSDof2017Abs_mean; data_GDPpcCANPPPIntlUSDof2017Abs_median; data_GDPpcCANPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcCANPPPIntlUSDof2017Abs,'tabGDPpcCANUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcCANPPPIntlUSDof2017Abs_min = min(dldata_GDPpcCANPPPIntlUSDof2017);
dldata_GDPpcCANPPPIntlUSDof2017Abs_max = max(dldata_GDPpcCANPPPIntlUSDof2017);
dldata_GDPpcCANPPPIntlUSDof2017Abs_range = dldata_GDPpcCANPPPIntlUSDof2017Abs_max - dldata_GDPpcCANPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcCANPPPIntlUSDof2017Abs_range = dldata_GDPpcCANPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcCANPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcCANPPPIntlUSDof2017);
dldata_GDPpcCANPPPIntlUSDof2017Abs_median = median(dldata_GDPpcCANPPPIntlUSDof2017);
%dldata_GDPpcCANPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcCANPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcCANPPPIntlUSDof2017Abs_std = std(dldata_GDPpcCANPPPIntlUSDof2017);

tabdlGDPpcCANPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcCANPPPIntlUSDof2017Abs_min';'dldata_GDPpcCANPPPIntlUSDof2017Abs_max';'dldata_GDPpcCANPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcCANPPPIntlUSDof2017Abs_range';'dldata_GDPpcCANPPPIntlUSDof2017Abs_mean';'dldata_GDPpcCANPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcCANPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcCANPPPIntlUSDof2017Abs_min; dldata_GDPpcCANPPPIntlUSDof2017Abs_max; dldata_GDPpcCANPPPIntlUSDof2017Abs_range; stripe_GDPpcCANPPPIntlUSDof2017Abs_range; dldata_GDPpcCANPPPIntlUSDof2017Abs_mean; dldata_GDPpcCANPPPIntlUSDof2017Abs_median; dldata_GDPpcCANPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcCANPPPIntlUSDof2017Abs,'tabdlGDPpcCANUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the CAN CO2 pc Figures

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
   'CData',data_CO2pcCANMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Canada per capita for 1990-2020');
title('Canada');

saveas(gcf,'CO2CANpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2CANpcAbs.png')
saveas(gcf,'CO2CANpcAbs.epsc')

CO2CANpcAbs = imread('CO2CANpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig127 = figure
plot(ticksCO2,data_CO2pcCANMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Canada CO2 emissions pc, in metric tons')
title('Canada CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcCANMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcCANMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcCANMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig128 = figure
plot(ticksdlCO2,dldata_CO2pcCANMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Canada CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Canada CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcCANMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcCANMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcCANMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig129 = figure
histogram(data_CO2pcCANMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Canada CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcCANMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcCANMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcCANMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig130 = figure
histogram(dldata_CO2pcCANMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Canada CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcCANMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcCANMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcCANMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcCANMetricTonsAbs_min = min(data_CO2pcCANMetricTons)
data_CO2pcCANMetricTonsAbs_max = max(data_CO2pcCANMetricTons)
data_CO2pcCANMetricTonsAbs_range = data_CO2pcCANMetricTonsAbs_max - data_CO2pcCANMetricTonsAbs_min
stripe_CO2pcCANMetricTonsAbs_range = data_CO2pcCANMetricTonsAbs_range/16
data_CO2pcCANMetricTonsAbs_mean = mean(data_CO2pcCANMetricTons)
data_CO2pcCANMetricTonsAbs_median = median(data_CO2pcCANMetricTons)
%data_CO2pcCANMetricTonsAbs_mode = mode(data_CO2pcCANMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcCANMetricTonsAbs_std = std(data_CO2pcCANMetricTons);

tabCO2pcCANMetricTonsAbs = table(categorical({'data_CO2pcCANMetricTonsAbs_min';'data_CO2pcCANMetricTonsAbs_max';'data_CO2pcCANMetricTons_range';'stripe_CO2pcCANMetricTonsAbs_range';'data_CO2pcCANMetricTonsAbs_mean';'data_CO2pcCANMetricTonsAbs_median';'data_CO2pcCANMetricTonsAbs_std'}),{data_CO2pcCANMetricTonsAbs_min; data_CO2pcCANMetricTonsAbs_max; data_CO2pcCANMetricTonsAbs_range; stripe_CO2pcCANMetricTonsAbs_range; data_CO2pcCANMetricTonsAbs_mean; data_CO2pcCANMetricTonsAbs_median; data_CO2pcCANMetricTonsAbs_std})
writetable(tabCO2pcCANMetricTonsAbs,'tabCO2pcCANMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcCANMetricTonsAbs_min = min(dldata_CO2pcCANMetricTons);
dldata_CO2pcCANMetricTonsAbs_max = max(dldata_CO2pcCANMetricTons);
dldata_CO2pcCANMetricTonsAbs_range = dldata_CO2pcCANMetricTonsAbs_max - dldata_CO2pcCANMetricTonsAbs_min;
dlstripe_CO2pcCANMetricTonsAbs_range = dldata_CO2pcCANMetricTonsAbs_range/16;
dldata_CO2pcCANMetricTonsAbs_mean = mean(dldata_CO2pcCANMetricTons);
dldata_CO2pcCANMetricTonsAbs_median = median(dldata_CO2pcCANMetricTons);
%dldata_CO2pcCANMetricTonsAbs_mode = mode(dldata_CO2pcCANMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcCANMetricTonsAbs_std = std(dldata_CO2pcCANMetricTons);

tabdlCO2pcCANMetricTonsAbs = table(categorical({'data_CO2pcCANMetricTonsAbs_min';'data_CO2pcCANMetricTonsAbs_max';'data_CO2pcCANMetricTons_range';'stripe_CO2pcCANMetricTonsAbs_range';'data_CO2pcCANMetricTonsAbs_mean';'data_CO2pcCANMetricTonsAbs_median'; 'dldata_CO2pcCANMetricTonsAbs_std'}),{data_CO2pcCANMetricTonsAbs_min; data_CO2pcCANMetricTonsAbs_max; data_CO2pcCANMetricTonsAbs_range; stripe_CO2pcCANMetricTonsAbs_range; data_CO2pcCANMetricTonsAbs_mean; data_CO2pcCANMetricTonsAbs_median; dldata_CO2pcCANMetricTonsAbs_std})
writetable(tabdlCO2pcCANMetricTonsAbs,'tabdlCO2pcCANMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the CAN Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Canada Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Canada');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017CANpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017CANpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017CANpcAbs.epsc')

CO2CANpcAbs = imread('CO2CANpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig132 = figure
plot(ticksGreenProspGDP,data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Canada greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Canada Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CANpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CANpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017CANpcAbs.epsc')

%% Plot - growth rates

fig133 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Canada greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Canada Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017CANpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017CANpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017CANpcAbs.epsc')


%% Histogram - absolute level

fig134 = figure
histogram(data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Canada Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017CANpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017CANpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017CANpcAbs.epsc')

%% Histogram - growth rates

fig135 = figure
histogram(dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Canada Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017CANAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017CANAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017CANAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcCANDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcCANDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcCANDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcCANDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mexico - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcMEXPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI159:BM159');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcMEXPPPIntlUSDof2017 = log(data_GDPpcMEXPPPIntlUSDof2017);
dldata_GDPpcMEXPPPIntlUSDof2017 = diff(ldata_GDPpcMEXPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcMEXMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI159:BM159');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcMEXMetricTons = log(data_CO2pcMEXMetricTons);
dldata_CO2pcMEXMetricTons = diff(ldata_CO2pcMEXMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017 = data_GDPpcMEXPPPIntlUSDof2017 ./ data_CO2pcMEXMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the MEX GDP pc Figures

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
   'CData',data_GDPpcMEXPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('MEX GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Mexico');

saveas(gcf,'GDPMEXpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPMEXpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPMEXpcPPPIntlUSDof2017Abs.epsc')

GDPMEXpcDev = imread('GDPMEXpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig137 = figure
plot(ticksGDP,data_GDPpcMEXPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Mexico GDP per capita in PPP international USD of 2017')
title('Mexico GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig138 = figure
plot(ticksdlGDP,dldata_GDPpcMEXPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Mexico GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Mexico GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig139 = figure
histogram(data_GDPpcMEXPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Mexico GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig140 = figure
histogram(dldata_GDPpcMEXPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Mexico GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcMEXPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcMEXPPPIntlUSDof2017Abs_min = min(data_GDPpcMEXPPPIntlUSDof2017)
data_GDPpcMEXPPPIntlUSDof2017Abs_max = max(data_GDPpcMEXPPPIntlUSDof2017)
data_GDPpcMEXPPPIntlUSDof2017Abs_range = data_GDPpcMEXPPPIntlUSDof2017Abs_max - data_GDPpcMEXPPPIntlUSDof2017Abs_min
stripe_GDPpcMEXPPPIntlUSDof2017Abs_range = data_GDPpcMEXPPPIntlUSDof2017Abs_range/16
data_GDPpcMEXPPPIntlUSDof2017Abs_mean = mean(data_GDPpcMEXPPPIntlUSDof2017)
data_GDPpcMEXPPPIntlUSDof2017Abs_median = median(data_GDPpcMEXPPPIntlUSDof2017)
%data_GDPpcMEXPPPIntlUSDof2017Abs_mode = mode(data_GDPpcMEXPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcMEXPPPIntlUSDof2017Abs_std = std(data_GDPpcMEXPPPIntlUSDof2017);

tabGDPpcMEXPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcMEXPPPIntlUSDof2017Abs_min';'data_GDPpcMEXPPPIntlUSDof2017Abs_max';'data_GDPpcMEXPPPIntlUSDof2017Abs_range';'stripe_GDPpcMEXPPPIntlUSDof2017Abs_range';'data_GDPpcMEXPPPIntlUSDof2017Abs_mean';'data_GDPpcMEXPPPIntlUSDof2017Abs_median';'data_GDPpcMEXPPPIntlUSDof2017Abs_std'}),{data_GDPpcMEXPPPIntlUSDof2017Abs_min; data_GDPpcMEXPPPIntlUSDof2017Abs_max; data_GDPpcMEXPPPIntlUSDof2017Abs_range; stripe_GDPpcMEXPPPIntlUSDof2017Abs_range; data_GDPpcMEXPPPIntlUSDof2017Abs_mean; data_GDPpcMEXPPPIntlUSDof2017Abs_median; data_GDPpcMEXPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcMEXPPPIntlUSDof2017Abs,'tabGDPpcMEXUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcMEXPPPIntlUSDof2017Abs_min = min(dldata_GDPpcMEXPPPIntlUSDof2017);
dldata_GDPpcMEXPPPIntlUSDof2017Abs_max = max(dldata_GDPpcMEXPPPIntlUSDof2017);
dldata_GDPpcMEXPPPIntlUSDof2017Abs_range = dldata_GDPpcMEXPPPIntlUSDof2017Abs_max - dldata_GDPpcMEXPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcMEXPPPIntlUSDof2017Abs_range = dldata_GDPpcMEXPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcMEXPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcMEXPPPIntlUSDof2017);
dldata_GDPpcMEXPPPIntlUSDof2017Abs_median = median(dldata_GDPpcMEXPPPIntlUSDof2017);
%dldata_GDPpcMEXPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcMEXPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcMEXPPPIntlUSDof2017Abs_std = std(dldata_GDPpcMEXPPPIntlUSDof2017);

tabdlGDPpcMEXPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcMEXPPPIntlUSDof2017Abs_min';'dldata_GDPpcMEXPPPIntlUSDof2017Abs_max';'dldata_GDPpcMEXPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcMEXPPPIntlUSDof2017Abs_range';'dldata_GDPpcMEXPPPIntlUSDof2017Abs_mean';'dldata_GDPpcMEXPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcMEXPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcMEXPPPIntlUSDof2017Abs_min; dldata_GDPpcMEXPPPIntlUSDof2017Abs_max; dldata_GDPpcMEXPPPIntlUSDof2017Abs_range; stripe_GDPpcMEXPPPIntlUSDof2017Abs_range; dldata_GDPpcMEXPPPIntlUSDof2017Abs_mean; dldata_GDPpcMEXPPPIntlUSDof2017Abs_median; dldata_GDPpcMEXPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcMEXPPPIntlUSDof2017Abs,'tabdlGDPpcMEXUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the MEX CO2 pc Figures

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
   'CData',data_CO2pcMEXMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the MEX per capita for 1990-2020');
title('Mexico');

saveas(gcf,'CO2MEXpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2MEXpcAbs.png')
saveas(gcf,'CO2MEXpcAbs.epsc')

CO2MEXpcAbs = imread('CO2MEXpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig142 = figure
plot(ticksCO2,data_CO2pcMEXMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Mexico CO2 emissions pc, in metric tons')
title('Mexico CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcMEXMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcMEXMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcMEXMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig143 = figure
plot(ticksdlCO2,dldata_CO2pcMEXMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Mexico CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Mexico CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcMEXMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcMEXMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcMEXMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig144 = figure
histogram(data_CO2pcMEXMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Mexico CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcMEXMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcMEXMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcMEXMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig145 = figure
histogram(dldata_CO2pcMEXMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Mexico CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcMEXMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcMEXMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcMEXMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcMEXMetricTonsAbs_min = min(data_CO2pcMEXMetricTons)
data_CO2pcMEXMetricTonsAbs_max = max(data_CO2pcMEXMetricTons)
data_CO2pcMEXMetricTonsAbs_range = data_CO2pcMEXMetricTonsAbs_max - data_CO2pcMEXMetricTonsAbs_min
stripe_CO2pcMEXMetricTonsAbs_range = data_CO2pcMEXMetricTonsAbs_range/16
data_CO2pcMEXMetricTonsAbs_mean = mean(data_CO2pcMEXMetricTons)
data_CO2pcMEXMetricTonsAbs_median = median(data_CO2pcMEXMetricTons)
%data_CO2pcMEXMetricTonsAbs_mode = mode(data_CO2pcMEXMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcMEXMetricTonsAbs_std = std(data_CO2pcMEXMetricTons);

tabCO2pcMEXMetricTonsAbs = table(categorical({'data_CO2pcMEXMetricTonsAbs_min';'data_CO2pcMEXMetricTonsAbs_max';'data_CO2pcMEXMetricTons_range';'stripe_CO2pcMEXMetricTonsAbs_range';'data_CO2pcMEXMetricTonsAbs_mean';'data_CO2pcMEXMetricTonsAbs_median';'data_CO2pcMEXMetricTonsAbs_std'}),{data_CO2pcMEXMetricTonsAbs_min; data_CO2pcMEXMetricTonsAbs_max; data_CO2pcMEXMetricTonsAbs_range; stripe_CO2pcMEXMetricTonsAbs_range; data_CO2pcMEXMetricTonsAbs_mean; data_CO2pcMEXMetricTonsAbs_median; data_CO2pcMEXMetricTonsAbs_std})
writetable(tabCO2pcMEXMetricTonsAbs,'tabCO2pcMEXMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcMEXMetricTonsAbs_min = min(dldata_CO2pcMEXMetricTons);
dldata_CO2pcMEXMetricTonsAbs_max = max(dldata_CO2pcMEXMetricTons);
dldata_CO2pcMEXMetricTonsAbs_range = dldata_CO2pcMEXMetricTonsAbs_max - dldata_CO2pcMEXMetricTonsAbs_min;
dlstripe_CO2pcMEXMetricTonsAbs_range = dldata_CO2pcMEXMetricTonsAbs_range/16;
dldata_CO2pcMEXMetricTonsAbs_mean = mean(dldata_CO2pcMEXMetricTons);
dldata_CO2pcMEXMetricTonsAbs_median = median(dldata_CO2pcMEXMetricTons);
%dldata_CO2pcMEXMetricTonsAbs_mode = mode(dldata_CO2pcMEXMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcMEXMetricTonsAbs_std = std(dldata_CO2pcMEXMetricTons);

tabdlCO2pcMEXMetricTonsAbs = table(categorical({'data_CO2pcMEXMetricTonsAbs_min';'data_CO2pcMEXMetricTonsAbs_max';'data_CO2pcMEXMetricTons_range';'stripe_CO2pcMEXMetricTonsAbs_range';'data_CO2pcMEXMetricTonsAbs_mean';'data_CO2pcMEXMetricTonsAbs_median'; 'dldata_CO2pcMEXMetricTonsAbs_std'}),{data_CO2pcMEXMetricTonsAbs_min; data_CO2pcMEXMetricTonsAbs_max; data_CO2pcMEXMetricTonsAbs_range; stripe_CO2pcMEXMetricTonsAbs_range; data_CO2pcMEXMetricTonsAbs_mean; data_CO2pcMEXMetricTonsAbs_median; dldata_CO2pcMEXMetricTonsAbs_std})
writetable(tabdlCO2pcMEXMetricTonsAbs,'tabdlCO2pcMEXMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the MEX Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('MEX Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Mexico');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017MEXpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017MEXpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017MEXpcAbs.epsc')

CO2MEXpcAbs = imread('CO2MEXpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig147 = figure
plot(ticksGreenProspGDP,data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Mexico greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Mexico Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017MEXpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017MEXpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017MEXpcAbs.epsc')

%% Plot - growth rates

fig148 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of average Mexico greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Mexico Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017MEXpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017MEXpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017MEXpcAbs.epsc')


%% Histogram - absolute level

fig149 = figure
histogram(data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Mexico Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017MEXpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017MEXpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017MEXpcAbs.epsc')

%% Histogram - growth rates

fig150 = figure
histogram(dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Mexico Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017MEXAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017MEXAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017MEXAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcMEXDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcMEXDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcMEXDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcMEXDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Russia - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcRUSPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI207:BM207');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcRUSPPPIntlUSDof2017 = log(data_GDPpcRUSPPPIntlUSDof2017);
dldata_GDPpcRUSPPPIntlUSDof2017 = diff(ldata_GDPpcRUSPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/RUSicator/EN.ATM.CO2E.PC
data_CO2pcRUSMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI207:BM207');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcRUSMetricTons = log(data_CO2pcRUSMetricTons);
dldata_CO2pcRUSMetricTons = diff(ldata_CO2pcRUSMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017 = data_GDPpcRUSPPPIntlUSDof2017 ./ data_CO2pcRUSMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the RUS GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure WRUSow with white background. We
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
   'CData',data_GDPpcRUSPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('RUSia GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Russia');

saveas(gcf,'GDPRUSpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPRUSpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPRUSpcPPPIntlUSDof2017Abs.epsc')

GDPRUSpcDev = imread('GDPRUSpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig152 = figure
plot(ticksGDP,data_GDPpcRUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Russia GDP per capita in PPP international USD of 2017')
title('Russia GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig153 = figure
plot(ticksdlGDP,dldata_GDPpcRUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Russia GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Russia GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig154 = figure
histogram(data_GDPpcRUSPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Russia GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig155 = figure
histogram(dldata_GDPpcRUSPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Russia GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcRUSPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcRUSPPPIntlUSDof2017Abs_min = min(data_GDPpcRUSPPPIntlUSDof2017)
data_GDPpcRUSPPPIntlUSDof2017Abs_max = max(data_GDPpcRUSPPPIntlUSDof2017)
data_GDPpcRUSPPPIntlUSDof2017Abs_range = data_GDPpcRUSPPPIntlUSDof2017Abs_max - data_GDPpcRUSPPPIntlUSDof2017Abs_min
stripe_GDPpcRUSPPPIntlUSDof2017Abs_range = data_GDPpcRUSPPPIntlUSDof2017Abs_range/16
data_GDPpcRUSPPPIntlUSDof2017Abs_mean = mean(data_GDPpcRUSPPPIntlUSDof2017)
data_GDPpcRUSPPPIntlUSDof2017Abs_median = median(data_GDPpcRUSPPPIntlUSDof2017)
%data_GDPpcRUSPPPIntlUSDof2017Abs_mode = mode(data_GDPpcRUSPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcRUSPPPIntlUSDof2017Abs_std = std(data_GDPpcRUSPPPIntlUSDof2017);

tabGDPpcRUSPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcRUSPPPIntlUSDof2017Abs_min';'data_GDPpcRUSPPPIntlUSDof2017Abs_max';'data_GDPpcRUSPPPIntlUSDof2017Abs_range';'stripe_GDPpcRUSPPPIntlUSDof2017Abs_range';'data_GDPpcRUSPPPIntlUSDof2017Abs_mean';'data_GDPpcRUSPPPIntlUSDof2017Abs_median';'data_GDPpcRUSPPPIntlUSDof2017Abs_std'}),{data_GDPpcRUSPPPIntlUSDof2017Abs_min; data_GDPpcRUSPPPIntlUSDof2017Abs_max; data_GDPpcRUSPPPIntlUSDof2017Abs_range; stripe_GDPpcRUSPPPIntlUSDof2017Abs_range; data_GDPpcRUSPPPIntlUSDof2017Abs_mean; data_GDPpcRUSPPPIntlUSDof2017Abs_median; data_GDPpcRUSPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcRUSPPPIntlUSDof2017Abs,'tabGDPpcRUSUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcRUSPPPIntlUSDof2017Abs_min = min(dldata_GDPpcRUSPPPIntlUSDof2017);
dldata_GDPpcRUSPPPIntlUSDof2017Abs_max = max(dldata_GDPpcRUSPPPIntlUSDof2017);
dldata_GDPpcRUSPPPIntlUSDof2017Abs_range = dldata_GDPpcRUSPPPIntlUSDof2017Abs_max - dldata_GDPpcRUSPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcRUSPPPIntlUSDof2017Abs_range = dldata_GDPpcRUSPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcRUSPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcRUSPPPIntlUSDof2017);
dldata_GDPpcRUSPPPIntlUSDof2017Abs_median = median(dldata_GDPpcRUSPPPIntlUSDof2017);
%dldata_GDPpcRUSPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcRUSPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcRUSPPPIntlUSDof2017Abs_std = std(dldata_GDPpcRUSPPPIntlUSDof2017);

tabdlGDPpcRUSPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcRUSPPPIntlUSDof2017Abs_min';'dldata_GDPpcRUSPPPIntlUSDof2017Abs_max';'dldata_GDPpcRUSPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcRUSPPPIntlUSDof2017Abs_range';'dldata_GDPpcRUSPPPIntlUSDof2017Abs_mean';'dldata_GDPpcRUSPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcRUSPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcRUSPPPIntlUSDof2017Abs_min; dldata_GDPpcRUSPPPIntlUSDof2017Abs_max; dldata_GDPpcRUSPPPIntlUSDof2017Abs_range; stripe_GDPpcRUSPPPIntlUSDof2017Abs_range; dldata_GDPpcRUSPPPIntlUSDof2017Abs_mean; dldata_GDPpcRUSPPPIntlUSDof2017Abs_median; dldata_GDPpcRUSPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcRUSPPPIntlUSDof2017Abs,'tabdlGDPpcRUSUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the RUS CO2 pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure WRUSow with white background. We
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
   'CData',data_CO2pcRUSMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Russia per capita for 1990-2020');
title('Russia');

saveas(gcf,'CO2RUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2RUSpcAbs.png')
saveas(gcf,'CO2RUSpcAbs.epsc')

CO2RUSpcAbs = imread('CO2RUSpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig157 = figure
plot(ticksCO2,data_CO2pcRUSMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Russia CO2 emissions pc, in metric tons')
title('Russia CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcRUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcRUSMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcRUSMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig158 = figure
plot(ticksdlCO2,dldata_CO2pcRUSMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Russia CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Russia CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcRUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcRUSMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcRUSMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig159 = figure
histogram(data_CO2pcRUSMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Russia CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcRUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcRUSMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcRUSMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig160 = figure
histogram(dldata_CO2pcRUSMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Russia CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcRUSMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcRUSMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcRUSMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcRUSMetricTonsAbs_min = min(data_CO2pcRUSMetricTons)
data_CO2pcRUSMetricTonsAbs_max = max(data_CO2pcRUSMetricTons)
data_CO2pcRUSMetricTonsAbs_range = data_CO2pcRUSMetricTonsAbs_max - data_CO2pcRUSMetricTonsAbs_min
stripe_CO2pcRUSMetricTonsAbs_range = data_CO2pcRUSMetricTonsAbs_range/16
data_CO2pcRUSMetricTonsAbs_mean = mean(data_CO2pcRUSMetricTons)
data_CO2pcRUSMetricTonsAbs_median = median(data_CO2pcRUSMetricTons)
%data_CO2pcRUSMetricTonsAbs_mode = mode(data_CO2pcRUSMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcRUSMetricTonsAbs_std = std(data_CO2pcRUSMetricTons);

tabCO2pcRUSMetricTonsAbs = table(categorical({'data_CO2pcRUSMetricTonsAbs_min';'data_CO2pcRUSMetricTonsAbs_max';'data_CO2pcRUSMetricTons_range';'stripe_CO2pcRUSMetricTonsAbs_range';'data_CO2pcRUSMetricTonsAbs_mean';'data_CO2pcRUSMetricTonsAbs_median';'data_CO2pcRUSMetricTonsAbs_std'}),{data_CO2pcRUSMetricTonsAbs_min; data_CO2pcRUSMetricTonsAbs_max; data_CO2pcRUSMetricTonsAbs_range; stripe_CO2pcRUSMetricTonsAbs_range; data_CO2pcRUSMetricTonsAbs_mean; data_CO2pcRUSMetricTonsAbs_median; data_CO2pcRUSMetricTonsAbs_std})
writetable(tabCO2pcRUSMetricTonsAbs,'tabCO2pcRUSMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcRUSMetricTonsAbs_min = min(dldata_CO2pcRUSMetricTons);
dldata_CO2pcRUSMetricTonsAbs_max = max(dldata_CO2pcRUSMetricTons);
dldata_CO2pcRUSMetricTonsAbs_range = dldata_CO2pcRUSMetricTonsAbs_max - dldata_CO2pcRUSMetricTonsAbs_min;
dlstripe_CO2pcRUSMetricTonsAbs_range = dldata_CO2pcRUSMetricTonsAbs_range/16;
dldata_CO2pcRUSMetricTonsAbs_mean = mean(dldata_CO2pcRUSMetricTons);
dldata_CO2pcRUSMetricTonsAbs_median = median(dldata_CO2pcRUSMetricTons);
%dldata_CO2pcRUSMetricTonsAbs_mode = mode(dldata_CO2pcRUSMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcRUSMetricTonsAbs_std = std(dldata_CO2pcRUSMetricTons);

tabdlCO2pcRUSMetricTonsAbs = table(categorical({'data_CO2pcRUSMetricTonsAbs_min';'data_CO2pcRUSMetricTonsAbs_max';'data_CO2pcRUSMetricTons_range';'stripe_CO2pcRUSMetricTonsAbs_range';'data_CO2pcRUSMetricTonsAbs_mean';'data_CO2pcRUSMetricTonsAbs_median'; 'dldata_CO2pcRUSMetricTonsAbs_std'}),{data_CO2pcRUSMetricTonsAbs_min; data_CO2pcRUSMetricTonsAbs_max; data_CO2pcRUSMetricTonsAbs_range; stripe_CO2pcRUSMetricTonsAbs_range; data_CO2pcRUSMetricTonsAbs_mean; data_CO2pcRUSMetricTonsAbs_median; dldata_CO2pcRUSMetricTonsAbs_std})
writetable(tabdlCO2pcRUSMetricTonsAbs,'tabdlCO2pcRUSMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the RUS Greening Prosperity (Ratio) Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure WRUSow with white background. We
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
   'CData',data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Russia Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Russia');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017RUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017RUSpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017RUSpcAbs.epsc')

CO2RUSpcAbs = imread('CO2RUSpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig162 = figure
plot(ticksGreenProspGDP,data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Russia greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Russia Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017RUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017RUSpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017RUSpcAbs.epsc')

%% Plot - growth rates

fig163 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Russia greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Russia Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017RUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017RUSpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017RUSpcAbs.epsc')


%% Histogram - absolute level

fig164 = figure
histogram(data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Russia Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017RUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017RUSpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017RUSpcAbs.epsc')

%% Histogram - growth rates

fig165 = figure
histogram(dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Russia Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017RUSAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017RUSAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017RUSAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcRUSDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcRUSDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcRUSDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcRUSDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Saudi Arabia - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/RUSicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcSAUPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI210:BM210');
ticksGDP = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!
ldata_GDPpcSAUPPPIntlUSDof2017 = log(data_GDPpcSAUPPPIntlUSDof2017);
dldata_GDPpcSAUPPPIntlUSDof2017 = diff(ldata_GDPpcSAUPPPIntlUSDof2017)*100;
ticksdlGDP = 1991:2020;

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcSAUMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI210:BM210');
ticksCO2 = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!
ldata_CO2pcSAUMetricTons = log(data_CO2pcSAUMetricTons);
dldata_CO2pcSAUMetricTons = diff(ldata_CO2pcSAUMetricTons)*100;
ticksdlCO2 = 1991:2020;

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017 = data_GDPpcSAUPPPIntlUSDof2017 ./ data_CO2pcSAUMetricTons;
ticksGreenProspGDP = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!
ldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017 = log(data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017 = diff(ldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017)*100;
ticksdlGreenProspGDP = 1991:2020;

%% Creating the SAU GDP pc Figures

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
   'CData',data_GDPpcSAUPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Saudi Arabia GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Saudi Arabia');

saveas(gcf,'GDPSAUpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'GDPSAUpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'GDPSAUpcPPPIntlUSDof2017Abs.epsc')

GDPSAUpcDev = imread('GDPSAUpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online


%% Plot - absolute level

fig167 = figure
plot(ticksGDP,data_GDPpcSAUPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Saudi Arabia GDP per capita in PPP international USD of 2017')
title('Saudi Arabia GDP per capita in PPP international USD of 2017');

saveas(gcf,'Plot_GDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_GDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Plot - growth rates

fig168 = figure
plot(ticksdlGDP,dldata_GDPpcSAUPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates of Saudi Arabia GDP per capita in PPP international USD of 2017, % pa')
title('Growth Rates of Saudi Arabia GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Plot_dlGDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Plot_dlGDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Histogram - absolute level

fig169 = figure
histogram(data_GDPpcSAUPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Saudi Arabia GDP per capita in PPP international USD of 2017');

saveas(gcf,'Hist_GDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_GDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.epsc')

%% Histogram - growth rates

fig170 = figure
histogram(dldata_GDPpcSAUPPPIntlUSDof2017,16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates of Saudi Arabia GDP per capita in PPP international USD of 2017, % pa');

saveas(gcf,'Hist_dlGDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.png')
saveas(gcf,'Hist_dlGDPpcSAUPPPIntlUSDof2017AbsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcSAUPPPIntlUSDof2017Abs_min = min(data_GDPpcSAUPPPIntlUSDof2017)
data_GDPpcSAUPPPIntlUSDof2017Abs_max = max(data_GDPpcSAUPPPIntlUSDof2017)
data_GDPpcSAUPPPIntlUSDof2017Abs_range = data_GDPpcSAUPPPIntlUSDof2017Abs_max - data_GDPpcSAUPPPIntlUSDof2017Abs_min
stripe_GDPpcSAUPPPIntlUSDof2017Abs_range = data_GDPpcSAUPPPIntlUSDof2017Abs_range/16
data_GDPpcSAUPPPIntlUSDof2017Abs_mean = mean(data_GDPpcSAUPPPIntlUSDof2017)
data_GDPpcSAUPPPIntlUSDof2017Abs_median = median(data_GDPpcSAUPPPIntlUSDof2017)
%data_GDPpcSAUPPPIntlUSDof2017Abs_mode = mode(data_GDPpcSAUPPPIntlUSDof2017,'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcSAUPPPIntlUSDof2017Abs_std = std(data_GDPpcSAUPPPIntlUSDof2017);

tabGDPpcSAUPPPIntlUSDof2017Abs = table(categorical({'data_GDPpcSAUPPPIntlUSDof2017Abs_min';'data_GDPpcSAUPPPIntlUSDof2017Abs_max';'data_GDPpcSAUPPPIntlUSDof2017Abs_range';'stripe_GDPpcSAUPPPIntlUSDof2017Abs_range';'data_GDPpcSAUPPPIntlUSDof2017Abs_mean';'data_GDPpcSAUPPPIntlUSDof2017Abs_median';'data_GDPpcSAUPPPIntlUSDof2017Abs_std'}),{data_GDPpcSAUPPPIntlUSDof2017Abs_min; data_GDPpcSAUPPPIntlUSDof2017Abs_max; data_GDPpcSAUPPPIntlUSDof2017Abs_range; stripe_GDPpcSAUPPPIntlUSDof2017Abs_range; data_GDPpcSAUPPPIntlUSDof2017Abs_mean; data_GDPpcSAUPPPIntlUSDof2017Abs_median; data_GDPpcSAUPPPIntlUSDof2017Abs_std})
writetable(tabGDPpcSAUPPPIntlUSDof2017Abs,'tabGDPpcSAUUSDPPPof2017Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GDPpcSAUPPPIntlUSDof2017Abs_min = min(dldata_GDPpcSAUPPPIntlUSDof2017);
dldata_GDPpcSAUPPPIntlUSDof2017Abs_max = max(dldata_GDPpcSAUPPPIntlUSDof2017);
dldata_GDPpcSAUPPPIntlUSDof2017Abs_range = dldata_GDPpcSAUPPPIntlUSDof2017Abs_max - dldata_GDPpcSAUPPPIntlUSDof2017Abs_min;
dlstripe_GDPpcSAUPPPIntlUSDof2017Abs_range = dldata_GDPpcSAUPPPIntlUSDof2017Abs_range/16;
dldata_GDPpcSAUPPPIntlUSDof2017Abs_mean = mean(dldata_GDPpcSAUPPPIntlUSDof2017);
dldata_GDPpcSAUPPPIntlUSDof2017Abs_median = median(dldata_GDPpcSAUPPPIntlUSDof2017);
%dldata_GDPpcSAUPPPIntlUSDof2017Abs_mode = mode(dldata_GDPpcSAUPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GDPpcSAUPPPIntlUSDof2017Abs_std = std(dldata_GDPpcSAUPPPIntlUSDof2017);

tabdlGDPpcSAUPPPIntlUSDof2017Abs = table(categorical({'dldata_GDPpcSAUPPPIntlUSDof2017Abs_min';'dldata_GDPpcSAUPPPIntlUSDof2017Abs_max';'dldata_GDPpcSAUPPPIntlUSDof2017Abs_range';'dlstripe_GDPpcSAUPPPIntlUSDof2017Abs_range';'dldata_GDPpcSAUPPPIntlUSDof2017Abs_mean';'dldata_GDPpcSAUPPPIntlUSDof2017Abs_median'; 'dldata_GDPpcSAUPPPIntlUSDof2017Abs_std'}),{dldata_GDPpcSAUPPPIntlUSDof2017Abs_min; dldata_GDPpcSAUPPPIntlUSDof2017Abs_max; dldata_GDPpcSAUPPPIntlUSDof2017Abs_range; stripe_GDPpcSAUPPPIntlUSDof2017Abs_range; dldata_GDPpcSAUPPPIntlUSDof2017Abs_mean; dldata_GDPpcSAUPPPIntlUSDof2017Abs_median; dldata_GDPpcSAUPPPIntlUSDof2017Abs_std});
writetable(tabdlGDPpcSAUPPPIntlUSDof2017Abs,'tabdlGDPpcSAUUSDPPPof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM230720 adding CO2 pc (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Creating the SAU CO2 pc Figures

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
   'CData',data_CO2pcSAUMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in the Saudi Arabia per capita for 1990-2020');
title('Saudi Arabia');

saveas(gcf,'CO2SAUpcAbs.fig') %AM230701 checking online
saveas(gcf,'CO2SAUpcAbs.png')
saveas(gcf,'CO2SAUpcAbs.epsc')

CO2SAUpcAbs = imread('CO2SAUpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig172 = figure
plot(ticksCO2,data_CO2pcSAUMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Saudi Arabia CO2 emissions pc, in metric tons')
title('Saudi Arabia CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_CO2pcSAUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_CO2pcSAUMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_CO2pcSAUMetricTonsSince1990Annual.epsc')

%% Plot - growth rates

fig173 = figure
plot(ticksdlCO2,dldata_CO2pcSAUMetricTons,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates, in % pa, of Saudi Arabia CO2 emissions pc, in metric tons')
title('Growth Rates, in % pa, of Saudi Arabia CO2 Emissions per capita, in Metric Tons');

saveas(gcf,'Plot_dlCO2pcSAUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_dlCO2pcSAUMetricTonsSince1990Annual.png')
saveas(gcf,'Plot_dlCO2pcSAUMetricTonsSince1990Annual.epsc')

%% Histogram - absolute level

fig174 = figure
histogram(data_CO2pcSAUMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Saudi Arabia CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_CO2pcSAUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_CO2pcSAUMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_CO2pcSAUMetricTonsSince1990Annual.epsc')

%% Histogram - growth rates

fig175 = figure
histogram(dldata_CO2pcSAUMetricTons,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates, in % pa, of Saudi Arabia CO2 Emissions per capita, in metric tons');

saveas(gcf,'Hist_dlCO2pcSAUMetricTonsSince1990Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_dlCO2pcSAUMetricTonsSince1990Annual.png')
saveas(gcf,'Hist_dlCO2pcSAUMetricTonsSince1990Annual.epsc')


%% Computation and Export of a Descriptive Stats Table - absolute level

data_CO2pcSAUMetricTonsAbs_min = min(data_CO2pcSAUMetricTons)
data_CO2pcSAUMetricTonsAbs_max = max(data_CO2pcSAUMetricTons)
data_CO2pcSAUMetricTonsAbs_range = data_CO2pcSAUMetricTonsAbs_max - data_CO2pcSAUMetricTonsAbs_min
stripe_CO2pcSAUMetricTonsAbs_range = data_CO2pcSAUMetricTonsAbs_range/16
data_CO2pcSAUMetricTonsAbs_mean = mean(data_CO2pcSAUMetricTons)
data_CO2pcSAUMetricTonsAbs_median = median(data_CO2pcSAUMetricTons)
%data_CO2pcSAUMetricTonsAbs_mode = mode(data_CO2pcSAUMetricTons,'all') %AM230708 Sth's wrong about the mode command?!
data_CO2pcSAUMetricTonsAbs_std = std(data_CO2pcSAUMetricTons);

tabCO2pcSAUMetricTonsAbs = table(categorical({'data_CO2pcSAUMetricTonsAbs_min';'data_CO2pcSAUMetricTonsAbs_max';'data_CO2pcSAUMetricTons_range';'stripe_CO2pcSAUMetricTonsAbs_range';'data_CO2pcSAUMetricTonsAbs_mean';'data_CO2pcSAUMetricTonsAbs_median';'data_CO2pcSAUMetricTonsAbs_std'}),{data_CO2pcSAUMetricTonsAbs_min; data_CO2pcSAUMetricTonsAbs_max; data_CO2pcSAUMetricTonsAbs_range; stripe_CO2pcSAUMetricTonsAbs_range; data_CO2pcSAUMetricTonsAbs_mean; data_CO2pcSAUMetricTonsAbs_median; data_CO2pcSAUMetricTonsAbs_std})
writetable(tabCO2pcSAUMetricTonsAbs,'tabCO2pcSAUMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_CO2pcSAUMetricTonsAbs_min = min(dldata_CO2pcSAUMetricTons);
dldata_CO2pcSAUMetricTonsAbs_max = max(dldata_CO2pcSAUMetricTons);
dldata_CO2pcSAUMetricTonsAbs_range = dldata_CO2pcSAUMetricTonsAbs_max - dldata_CO2pcSAUMetricTonsAbs_min;
dlstripe_CO2pcSAUMetricTonsAbs_range = dldata_CO2pcSAUMetricTonsAbs_range/16;
dldata_CO2pcSAUMetricTonsAbs_mean = mean(dldata_CO2pcSAUMetricTons);
dldata_CO2pcSAUMetricTonsAbs_median = median(dldata_CO2pcSAUMetricTons);
%dldata_CO2pcSAUMetricTonsAbs_mode = mode(dldata_CO2pcSAUMetricTons,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_CO2pcSAUMetricTonsAbs_std = std(dldata_CO2pcSAUMetricTons);

tabdlCO2pcSAUMetricTonsAbs = table(categorical({'data_CO2pcSAUMetricTonsAbs_min';'data_CO2pcSAUMetricTonsAbs_max';'data_CO2pcSAUMetricTons_range';'stripe_CO2pcSAUMetricTonsAbs_range';'data_CO2pcSAUMetricTonsAbs_mean';'data_CO2pcSAUMetricTonsAbs_median'; 'dldata_CO2pcSAUMetricTonsAbs_std'}),{data_CO2pcSAUMetricTonsAbs_min; data_CO2pcSAUMetricTonsAbs_max; data_CO2pcSAUMetricTonsAbs_range; stripe_CO2pcSAUMetricTonsAbs_range; data_CO2pcSAUMetricTonsAbs_mean; data_CO2pcSAUMetricTonsAbs_median; dldata_CO2pcSAUMetricTonsAbs_std})
writetable(tabdlCO2pcSAUMetricTonsAbs,'tabdlCO2pcSAUMetricTonsAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231005 adding the greening prosperity (ratio) stripes = CO2 pc / GDP pc at PPP intl USD of 2017 (World Bank data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Creating the SAU Greening Prosperity (Ratio) Figures

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
   'CData',data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Saudi Arabia Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020 ');
title('Saudi Arabia');

saveas(gcf,'GreenProspDefGDPpcPPPUSD2017SAUpcAbs.fig') %AM230701 checking online
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017SAUpcAbs.png')
saveas(gcf,'GreenProspDefGDPpcPPPUSD2017SAUpcAbs.epsc')

CO2SAUpcAbs = imread('CO2SAUpcAbs.png'); %AM230701 checking online

%% Plot - absolute level

fig177 = figure
plot(ticksGreenProspGDP,data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(12,"points")
grid on
xlabel('years (sample 1990-2020)')
ylabel('Saudi Arabia greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Saudi Arabia Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017SAUpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017SAUpcAbs.png')
saveas(gcf,'Plot_GreenProspDefGDPpcPPPUSD2017SAUpcAbs.epsc')

%% Plot - growth rates

fig178 = figure
plot(ticksdlGreenProspGDP,dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 -20 20])
fontsize(12,"points")
grid on
xlabel('years (sample 1991-2020)')
ylabel('growth rates (in % pa) of Saudi Arabia greening prosperity ratio pc (GDP pc / CO2 pc)')
title('Growth Rates (in % pa) of Saudi Arabia Greening Prosperity Ratio pc (GDP pc / CO2 pc)');

saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017SAUpcAbs.fig') %AM230701 checking online
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017SAUpcAbs.png')
saveas(gcf,'Plot_dlGreenProspDefGDPpcPPPUSD2017SAUpcAbs.epsc')


%% Histogram - absolute level

fig179 = figure
histogram(data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Saudi Arabia Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017SAUpcAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017SAUpcAbs.png')
saveas(gcf,'Hist_GreenProspDefGDPpcPPPUSD2017SAUpcAbs.epsc')

%% Histogram - growth rates

fig180 = figure
histogram(dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017,16)
%axis ([1990 2020 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Growth Rates (in % pa) of Japan Greening Prosperity Ratio (GDP pc / CO2 pc) per capita');

saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017SAUAbs.fig') %AM230701 checking online
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017SAUAbs.png')
saveas(gcf,'Hist_dlGreenProspDefGDPpcPPPUSD2017SAUAbs.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_min = min(data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_max = max(data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_max - data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_min;
stripe_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range = data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range/16;
data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);
data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_median = median(data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);
%data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_std = std(data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);

tabGreenProsppcSAUDefByGDPpcPPPIntUSDof2017Abs = table(categorical({'data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_min';'data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_max';'data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017_range';'stripe_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range';'data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_mean';'data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_median'; 'data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_std'}),{data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_min; data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_max; data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range; stripe_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range; data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_mean; data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_median; data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabGreenProsppcSAUDefByGDPpcPPPIntUSDof2017Abs ,'tabGreenProsppcSAUDefByGDPpcPPPIntUSDof2017Abs.xlsx');
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

%% Computation and Export of a Descriptive Stats Table - growth rates

dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_min = min(dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_max = max(dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_max - dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_min;
dlstripe_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range = dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range/16;
dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_mean = mean(dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);
dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_median = median(dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);
%dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_mode = mode(dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017,'all'); %AM230708 Sth's wrong about the mode command?!
dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_std = std(dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017);

tabdlGreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs = table(categorical({'dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_min';'dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_max';'dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017_range';'dlstripe_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range';'dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_mean'; 'dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_median';'dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_std'}),{dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_min; dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_max; dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range; dlstripe_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_range; dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_mean; dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_median; dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs_std});
writetable(tabdlGreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs ,'tabdlGreenProsppcSAUDefByGDPpcPPPIntlUSDof2017Abs .xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AM231006 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% MULTIPLOT FIGURES %%%

fig181 = figure

subplot(3,4,1)
plot(ticksGDP,data_GDPpcUMCPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average UMC GDP per capita in PPP international USD of 2017')
title('Upper Mid-Inc Cs');

subplot(3,4,2)
plot(ticksGDP,data_GDPpcLMCPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average LMC GDP per capita in PPP international USD of 2017')
title('Lower Mid-Inc Cs')

subplot(3,4,3)
plot(ticksGDP,data_GDPpcDEUPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Germany GDP per capita in PPP international USD of 2017')
title('Germany')

subplot(3,4,4)
plot(ticksGDP,data_GDPpcFRAPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('France GDP per capita in PPP international USD of 2017')
title('France');

subplot(3,4,5)
plot(ticksGDP,data_GDPpcITAPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('ITA GDP per capita in PPP international USD of 2017')
title('Italy');

subplot(3,4,6)
plot(ticksGDP,data_GDPpcPOLPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Poland GDP per capita in PPP international USD of 2017')
title('Poland');

subplot(3,4,7)
plot(ticksGDP,data_GDPpcBGRPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BGR GDP per capita in PPP international USD of 2017')
title('Bulgaria');

subplot(3,4,8)
plot(ticksGDP,data_GDPpcCHEPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHE GDP per capita in PPP international USD of 2017')
title('Switzerland');

subplot(3,4,9)
plot(ticksGDP,data_GDPpcCANPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CAN GDP per capita in PPP international USD of 2017')
title('Canada');

subplot(3,4,10)
plot(ticksGDP,data_GDPpcMEXPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MEX GDP per capita in PPP international USD of 2017')
title('Mexico');

subplot(3,4,11)
plot(ticksGDP,data_GDPpcRUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('RUS GDP per capita in PPP international USD of 2017')
title('Russia'); 

subplot(3,4,12)
plot(ticksGDP,data_GDPpcSAUPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 70000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('JAP GDP per capita in PPP international USD of 2017')
title('Saudi Arabia');

saveas(gcf,'MultiPlot12For2ndSmpl_GDPpcPPPUSDof2017.fig')
saveas(gcf,'MultiPlot12For2ndSmpl_GDPpcPPPUSDof2017.png')
saveas(gcf,'MultiPlot12For2ndSmpl_GDPpcPPPUSDof2017.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig182 = figure

subplot(3,4,1)
plot(ticksdlGDP,dldata_GDPpcUMCPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average UMC GDP per capita in PPP international USD of 2017')
title('Upper Mid-Income Cs');

subplot(3,4,2)
plot(ticksdlGDP,dldata_GDPpcLMCPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average LMC GDP per capita in PPP international USD of 2017')
title('Lower Mid-Income Cs')

subplot(3,4,3)
plot(ticksdlGDP,dldata_GDPpcDEUPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('DEU GDP per capita in PPP international USD of 2017')
title('Germany')

subplot(3,4,4)
plot(ticksdlGDP,dldata_GDPpcFRAPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('FRA GDP per capita in PPP international USD of 2017')
title('France');

subplot(3,4,5)
plot(ticksdlGDP,dldata_GDPpcITAPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('ITA GDP per capita in PPP international USD of 2017')
title('Italy');

subplot(3,4,6)
plot(ticksdlGDP,dldata_GDPpcPOLPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('POL GDP per capita in PPP international USD of 2017')
title('Poland');

subplot(3,4,7)
plot(ticksdlGDP,dldata_GDPpcBGRPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BGR GDP per capita in PPP international USD of 2017')
title('Bulgaria');

subplot(3,4,8)
plot(ticksdlGDP,dldata_GDPpcCHEPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHE GDP per capita in PPP international USD of 2017')
title('Switzerland');

subplot(3,4,9)
plot(ticksdlGDP,dldata_GDPpcCANPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CAN GDP per capita in PPP international USD of 2017')
title('Canada');

subplot(3,4,10)
plot(ticksdlGDP,dldata_GDPpcMEXPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MEX GDP per capita in PPP international USD of 2017')
title('Mexico');

subplot(3,4,11)
plot(ticksdlGDP,dldata_GDPpcRUSPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('RUS GDP per capita in PPP international USD of 2017')
title('Russia');

subplot(3,4,12)
plot(ticksdlGDP,dldata_GDPpcSAUPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('SAU GDP per capita in PPP international USD of 2017')
title('Saudi Arabia');

saveas(gcf,'MultiPlot12For2ndSmpl_dlGDPpcPPPUSDof2017.fig')
saveas(gcf,'MultiPlot12For2ndSmpl_dlGDPpcPPPUSDof2017.png')
saveas(gcf,'MultiPlot12For2ndSmpl_dlGDPpcPPPUSDof2017.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig183 = figure

subplot(3,4,1)
plot(ticksCO2,data_CO2pcUMCMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average UMC GDP per capita in PPP international USD of 2017')
title('Upper Mid-Income Cs');

subplot(3,4,2)
plot(ticksCO2,data_CO2pcLMCMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average LMC GDP per capita in PPP international USD of 2017')
title(['Lower Mid-Income Cs'])

subplot(3,4,3)
plot(ticksCO2,data_CO2pcDEUMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average DEU GDP per capita in PPP international USD of 2017')
title('Germany')

subplot(3,4,4)
plot(ticksCO2,data_CO2pcFRAMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('FRA GDP per capita in PPP international USD of 2017')
title('France');

subplot(3,4,5)
plot(ticksCO2,data_CO2pcITAMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('ITA GDP per capita in PPP international USD of 2017')
title('Italy');

subplot(3,4,6)
plot(ticksCO2,data_CO2pcPOLMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('POL GDP per capita in PPP international USD of 2017')
title('Poland');

subplot(3,4,7)
plot(ticksCO2,data_CO2pcBGRMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BGR GDP per capita in PPP international USD of 2017')
title('Bulgaria');

subplot(3,4,8)
plot(ticksCO2,data_CO2pcCHEMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHE GDP per capita in PPP international USD of 2017')
title('Switzerland');

subplot(3,4,9)
plot(ticksCO2,data_CO2pcCANMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CAN GDP per capita in PPP international USD of 2017')
title('Canada');

subplot(3,4,10)
plot(ticksCO2,data_CO2pcMEXMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MEX GDP per capita in PPP international USD of 2017')
title('Mexico');

subplot(3,4,11)
plot(ticksCO2,data_CO2pcRUSMetricTons ,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('RUS GDP per capita in PPP international USD of 2017')
title('Russia');

subplot(3,4,12)
plot(ticksCO2, data_CO2pcSAUMetricTons,'LineWidth',2)
axis ([1990 2020 0 22])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('SAU GDP per capita in PPP international USD of 2017')
title('Saudi Arabia');

saveas(gcf,'MultiPlot12For2ndSmpl_CO2pcMetricTons.fig')
saveas(gcf,'MultiPlot12For2ndSmpl_CO2pcMetricTons.png')
saveas(gcf,'MultiPlot12For2ndSmpl_CO2pcMetricTons.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig184 = figure

subplot(3,4,1)
plot(ticksdlCO2,dldata_CO2pcUMCMetricTons,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average UMC GDP per capita in PPP international USD of 2017')
title('Upper Mid-Income Cs');

subplot(3,4,2)
plot(ticksdlCO2,dldata_CO2pcLMCMetricTons, 'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average LMC GDP per capita in PPP international USD of 2017')
title('Lower Mid-Income Cs')

subplot(3,4,3)
plot(ticksdlCO2,dldata_CO2pcDEUMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average DMEX GDP per capita in PPP international USD of 2017')
title('Germany')

subplot(3,4,4)
plot(ticksdlCO2,dldata_CO2pcFRAMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('FRA GDP per capita in PPP international USD of 2017')
title('France');

subplot(3,4,5)
plot(ticksdlCO2,dldata_CO2pcITAMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('ITA GDP per capita in PPP international USD of 2017')
title('Italy');

subplot(3,4,6)
plot(ticksdlCO2,dldata_CO2pcPOLMetricTons,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('POL GDP per capita in PPP international USD of 2017')
title('Poland');

subplot(3,4,7)
plot(ticksdlCO2,dldata_CO2pcBGRMetricTons,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BGR GDP per capita in PPP international USD of 2017')
title('Bulgaria');

subplot(3,4,8)
plot(ticksdlCO2,dldata_CO2pcCHEMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHE GDP per capita in PPP international USD of 2017')
title('Switzerland');

subplot(3,4,9)
plot(ticksdlCO2,dldata_CO2pcCANMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CAN GDP per capita in PPP international USD of 2017')
title('Canada');

subplot(3,4,10)
plot(ticksdlCO2,dldata_CO2pcMEXMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MEX GDP per capita in PPP international USD of 2017')
title('Mexico');

subplot(3,4,11)
plot(ticksdlCO2,dldata_CO2pcRUSMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('RUS GDP per capita in PPP international USD of 2017')
title('Russia');

subplot(3,4,12)
plot(ticksdlCO2,dldata_CO2pcSAUMetricTons ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('SAU GDP per capita in PPP international USD of 2017')
title('Saudi Arabia');

saveas(gcf,'MultiPlot12For2ndSmpl_dlCO2pcMetricTons.fig')
saveas(gcf,'MultiPlot12For2ndSmpl_dlCO2pcMetricTons.png')
saveas(gcf,'MultiPlot12For2ndSmpl_dlCO2pcMetricTons.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig185 = figure

subplot(3,4,1)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average UMC greening prosperity ratio')
title('Upper Mid-Income Cs)');

subplot(3,4,2)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average LMC GDP per capita in PPP international USD of 2017')
title('Lower Mid-Income Cs')

subplot(3,4,3)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017 ,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average DMEX GDP per capita in PPP international USD of 2017')
title('Germany')

subplot(3,4,4)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('USGDP per capita in PPP international USD of 2017')
title('France');

subplot(3,4,5)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('ITA GDP per capita in PPP international USD of 2017')
title('Italy');

subplot(3,4,6)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017 ,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('POL GDP per capita in PPP international USD of 2017')
title('Poland');

subplot(3,4,7)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BGR GDP per capita in PPP international USD of 2017')
title('Bulgaria');

subplot(3,4,8)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHE GDP per capita in PPP international USD of 2017')
title('Switzerland');

subplot(3,4,9)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CAN GDP per capita in PPP international USD of 2017')
title('Canada');

subplot(3,4,10)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MEX GDP per capita in PPP international USD of 2017')
title('Mexico');

subplot(3,4,11)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('RUS GDP per capita in PPP international USD of 2017')
title('Russia');

subplot(3,4,12)
plot(ticksGreenProsppcUMCGDP,data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1990 2020 0 17000])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('SAU GDP per capita in PPP international USD of 2017')
title('Saudi Arabia');

saveas(gcf,'MultiPlot12For2ndSmpl_GreenProsppcDefByGDPpc.fig')
saveas(gcf,'MultiPlot12For2ndSmpl_GreenProsppcDefByGDPpc.png')
saveas(gcf,'MultiPlot12For2ndSmpl_GreenProsppcDefByGDPpc.epsc')


%%%%%%%%%%%%%%%%%%%%%%%


fig186 = figure

subplot(3,4,1)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('average UMC GDP per capita in PPP international USD of 2017')
title('Upper Mid-Income Cs');

subplot(3,4,2)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017, 'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average LMC GDP per capita in PPP international USD of 2017')
title('Lower Mid-Income Cs')

subplot(3,4,3)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('Average DMEX GDP per capita in PPP international USD of 2017')
title('Germany')

subplot(3,4,4)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('US GDP per capita in PPP international USD of 2017')
title('France');

subplot(3,4,5)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcITADefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('ITA GDP per capita in PPP international USD of 2017')
title('Italy');

subplot(3,4,6)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('POL GDP per capita in PPP international USD of 2017')
title('Poland');

subplot(3,4,7)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('BGR GDP per capita in PPP international USD of 2017')
title('Bulgaria');

subplot(3,4,8)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CHE GDP per capita in PPP international USD of 2017')
title('Switzerland');

subplot(3,4,9)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('CAN GDP per capita in PPP international USD of 2017')
title('Canada');

subplot(3,4,10)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017 ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('MEX GDP per capita in PPP international USD of 2017')
title('Mexico');

subplot(3,4,11)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017 ,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('RUS GDP per capita in PPP international USD of 2017')
title('Russia');

subplot(3,4,12)
plot(ticksdlGreenProsppcUMCGDP,dldata_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017,'LineWidth',2)
axis ([1991 2020 -20 20])
fontsize(6,"points")
grid on
%xlabel('years (sample 1990-2020)')
%ylabel('SAU GDP per capita in PPP international USD of 2017')
title('Saudi Arabia');

saveas(gcf,'MultiPlot12For2ndSmpl_dlGreenProsppcDefByGDPpc.fig')
saveas(gcf,'MultiPlot12For2ndSmpl_dlGreenProsppcDefByGDPpc.png')
saveas(gcf,'MultiPlot12For2ndSmpl_dlGreenProsppcDefByGDPpc.epsc')


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
   'CData',data_GDPpcUMCPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Average Upper Mid-Income Cs GDP per capita in PPP IntlUSD of 2017 for 1990-1990');

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
   'CData',data_GDPpcLMCPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Average Lower Mid-Income Cs GDP per capita in PPP Intl USD of 2017 for 1990-1990');

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
   'CData',data_GDPpcDEUPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Germany GDP per capita in PPP Intl USD of 2017 for 1990-1990');

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
   'CData',data_GDPpcFRAPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('France GDP per capita in PPP Intl USD of 2017 for 1990-1990');

subplot(3,4,5)
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
   'CData',data_GDPpcITAPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Italy');

subplot(3,4,6)
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
   'CData',data_GDPpcPOLPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Poland');

subplot(3,4,7)
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
   'CData',data_GDPpcBGRPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Bulgaria');

subplot(3,4,8)
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
   'CData',data_GDPpcCHEPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Switzerland');

subplot(3,4,9)
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
   'CData',data_GDPpcCANPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Canada');

subplot(3,4,10)
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
   'CData',data_GDPpcMEXPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Mexico');

subplot(3,4,11)
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
   'CData',data_GDPpcRUSPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Russia');

subplot(3,4,12)
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
   'CData',data_GDPpcSAUPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Saudi Arabia');


saveas(gcf,'MultiPlot12For2ndSmpl_StripesGDPpcPPPUSDof2017.fig')
saveas(gcf,'MultiPlot12For2ndSmpl_StripesGDPpcPPPUSDof2017.png')
saveas(gcf,'MultiPlot12For2ndSmpl_StripesGDPpcPPPUSDof2017.epsc')


%%%%%%%%%%%%%%%%%%%%%%%



%%% END of (long) program %%%