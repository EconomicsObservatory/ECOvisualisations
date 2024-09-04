%% MATLAB program to create stripes colormap of GDP pc in PPP international USD of 2017, CO2 pc and GPR pc for 2nd Subsample
% File name: GDPpcCO2pcStripes2ndSmpl2Groups10CountriesMinMaxWorld_am231204.m
% AM230630 in R2017a 1st trial -> and success! -> based on:
% http://mres.uni-potsdam.de/index.php/2022/11/16/ed-hawkins-warming-stripes-with-matlab/
% AM230701 in R2023a minor edits and development
% AM230709 in R2023a further minor edits and development
% AM230720 in R2023a major development and addition of CO2 emissions and a brown-to-green colormap
% AM230720 in R2023a further improvenets and addition of greening prosperity ratio stripes
% AM231005 in R2023a switching to GDP pc in PPP inernational USD of 2017 and addition of greening prosperity ratio stripes
% AM231006 in R2023a adding together World, HiIncCs, LoIncCs, US, EU, China
% AM231007 in R2023a trying (again) to fix the stripe colormaps in multiplots -> unsuccessful again (see the figure at the bottom of the code), but just fixed it otherwise in Overleaf/Beamer! 
% AM231021 in R2023a scaling colours from Min to Max in the World from 1990 to 2020 (1989/2021 in the code below is not a year but the min/max value in the data vector; 2020 is the last year for CO2 emissions)
% AM231117 in R2023a run with the updated file name and log file for the 2nd subsample
% AM231119 in R2023a cross-check of rows with 31 elements entered manually in-between the min and max values for each country via the lines of code defining "dataMinMax[...]"
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

diary GDPpcCO2pcStripes2Groups10CountriesMinMaxWorld_am231204.txt % create a diary log (*.txt) file saving the output from the command window
tic                          % start stopwatch timer
t = datetime('now')          % return a datetime scalar representing the current date and time

%% Upper Middle-Income Countries (UMC) - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcUMCPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI254:BM254');
% AM231021 -> DO NOT FORGET: in the next line, the vector is entered manually, via copy/paste from the Excel file above, and is inserted below in-between the kept min, 1st element, and max, last element!!! 
dataMinMaxW_GDPpcUMCPPPIntlUSDof2017 = [436.4 5830.193002	5789.041099	5712.866696	5835.168545	5915.093133	6038.075584	6263.941881	6522.536988	6515.222434	6662.394636	7019.682033	7188.477994	7451.521648	7813.597949	8353.506118	8891.282917	9557.453964	10335.72513	10877.6648	10983.72929	11763.31277	12426.44064	13030.48508	13591.82759	14063.48728	14499.33754	14958.94872	15586.79804	16211.1085	16738.5635	16470.56943	 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcUMCMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI254:BM254');
% AM231021 -> DO NOT FORGET: in the next line, the vector is entered manually, via copy/paste from the Excel file above, and is inserted below in-between the kept min, 1st element, and max, last element!!! 
dataMinMaxW_CO2pcUMCMetricTons = [0.001 3.090486539	3.092312602	3.067611552	3.071418009	3.017162791	3.130518499	3.116704866	3.110897024	3.12433917	3.055905213	3.167140886	3.243556127	3.347641763	3.646680369	3.955406019	4.246087066	4.524939703	4.770239147	4.867460292	4.943769467	5.315552945	5.67402714	5.764257247	5.884629953	5.855666778	5.732800691	5.683373701	5.769233106	5.9439703	6.010516851	5.922352264 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017 = dataMinMaxW_GDPpcUMCPPPIntlUSDof2017 ./ dataMinMaxW_CO2pcUMCMetricTons;
% AM231021 -> DO NOT FORGET: in the next line, the vector is entered manually, via copy/paste from the MATLAB mat file obtained in the preceding line), and is then inserted below in-between the kept min, 1st element, and max, last element!!! 
dataMinMaxW_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017 = [1000 1886.49681156239	1872.07499502342	1862.31750635942	1899.82885035561	1960.48193045610	1928.77811964017	2009.79629137589	2096.67402607024	2085.31215066513	2180.17057847795	2216.40977956798	2216.23357590815	2225.90174682320	2142.66049073631	2111.92127378921	2093.99448923123	2112.17266777356	2166.71005614050	2234.77217017634	2221.73168941577	2212.99889056039	2190.05660942256	2260.56619641354	2309.71661745202	2401.68845208835	2529.18919067999	2632.05439356697	2701.71056596582	2727.31990265833	2784.87922335916	2781.08574022506	3304.03563941300 120000] 
ticksGreenProsppcUMCGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

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

%% Creating the UMC GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcUMCPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average UMC GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Upper Mid-Income Cs (min-max scale)'); % (within a min-max scale across all countries in the world over 1990-2020)

saveas(gcf,'MinMaxWGDPUMCpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPUMCpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPUMCpcPPPIntlUSDof2017Abs.epsc')

GDPUMCpcDev = imread('MinMaxWGDPUMCpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Creating the UMC CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcUMCMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average Upper Middle-Income Cs CO2 Emissions per capita for 1990-2020');
title('Upper Mid-Income Cs (min - max scale)');

saveas(gcf,'MinMaxWCO2UMCpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2UMCpcAbs.png')
saveas(gcf,'MinMaxWCO2UMCpcAbs.epsc')

CO2UMCpcAbs = imread('MinMaxWCO2UMCpcAbs.png'); %AM230701 checking online

%% Creating the UMC Greening Prosperity (Ratio) (min-max) Figure

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above in ticksCO2 using min() and max() (i.e., now running from 1990
% to 2020), rotate the tick labels of the x-axis by 90 degrees, and display annual tick labels. We also hide the tick
% labels of the y-axis. Then use imagesc to display the CO2 emissions stripes and the colormap wscolors_AMCO2WpcEmissions.

fig3 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticksGreenProsppcUMCGDPMinMaxW) max(ticksGreenProsppcUMCGDPMinMaxW)],... %AM230720 Select the relevant x-axis ticks variable name/length
   'XTickMode','manual',...
   'XTick',ticksGreenProsppcUMCGDPMinMaxW,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticksGreenProsppcUMCGDPMinMaxW',...
   'YData',[2000 2040],...c
   'XData',[1989 2021],... %AM230630 Select the x-axis data vector (corresponding to the data) to be displayed!
   'CData',dataMinMaxW_GreenProsppcUMCDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average Upper Middle-Income Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020');
title('Upper Mid-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWGreenProsppcDefGDPpcPPPUSD2017UMCAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProsppcDefGDPpcPPPUSD2017UMCAbs.png')
saveas(gcf,'MinMaxWGreenProsppcDefGDPpcPPPUSD2017UMCAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017WAbs = imread('MinMaxWGreenProsppcDefGDPpcPPPUSD2017UMCAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Lower Middle-Income Countries (LMC) - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcLMCPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI144:BM144');
dataMinMaxW_GDPpcLMCPPPIntlUSDof2017 = [436.4 3151.254616 3119.413806	3111.869701	3050.667072	3012.711466	3063.579575	3161.620593	3201.600524	3270.277214	3371.093986	3456.47063	3540.866933	3641.807862	3813.933621	4008.066614	4185.142821	4394.883889	4628.96872	4731.565008	4857.488901	5094.150892	5243.159284	5377.684875	5549.662996	5762.089138	5961.763675	6232.488996	6468.336365	6695.647993	6845.04333	6544.217963 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcLMCMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI144:BM144');
dataMinMaxW_CO2pcLMCMetricTons = [0.001  1.140232724	1.142007042	1.103079001	1.063491785	1.027683845	1.045066508	1.040450573	1.054045455	1.043773203	1.077444301	1.08853276	1.09671456	1.107551047	1.12907478	1.16486429	1.190849629	1.23061194	1.290686954	1.319753694	1.350227377	1.396223831	1.43667436	1.486154548	1.508235057	1.568248013	1.555548125	1.583104863	1.624198524	1.683221239	1.665768444	1.546117022 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017 = data_GDPpcLMCPPPIntlUSDof2017 ./ data_CO2pcLMCMetricTons;
dataMinMaxW_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017 = [1000 1.140232724	1.142007042	1.103079001	1.063491785	1.027683845	1.045066508	1.040450573	1.054045455	1.043773203	1.077444301	1.08853276	1.09671456	1.107551047	1.12907478	1.16486429	1.190849629	1.23061194	1.290686954	1.319753694	1.350227377	1.396223831	1.43667436	1.486154548	1.508235057	1.568248013	1.555548125	1.583104863	1.624198524	1.683221239	1.665768444	1.546117022  120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the LMC GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcLMCPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Average Lower Middle-Income Countries GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Lower Mid-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWGDPLMCpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPLMCpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPLMCpcPPPIntlUSDof2017Abs.epsc')

GDPLMCpcDev = imread('MinMaxWGDPLMCpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the LMC CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcLMCMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average CO2 Emissions in the Lower Middle-Income Countries per capita for 1990-2020');
title('Lower Mid-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWCO2LMCpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2LMCpcAbs.png')
saveas(gcf,'MinMaxWCO2LMCpcAbs.epsc')

CO2LMCpcAbs = imread('MinMaxWCO2LMCpcAbs.png'); %AM230701 checking online

%% Creating the LMC Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcLMCDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Average Lower Middle-Income Countries Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Lower Mid-Income Cs (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017LMCAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017LMCAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017LMCAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017LMCAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017LMCAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Germany - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcDEUPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI60:BM60');
dataMinMaxW_GDPpcDEUPPPIntlUSDof2017 = [436.4 36699.4817	38294.15494	38734.93841	38105.2306	38881.56912	39366.08864	39568.60247	40218.84688	41022.61463	41769.81203	42928.18134	43576.63653	43417.308	43089.47382	43605.27867	43949.28818	45678.08192	47100.6097	47643.22274	45044.48639	46999.23997	49757.92416	49872.44749	49954.17375	50845.527	51159.29746	51879.67259	53071.45557	53431.39287	53874.31665	51840.32969  157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcDEUMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI60:BM60');
dataMinMaxW_CO2pcDEUMetricTons = [0.001 12.02658028	11.65482681	11.0737594	10.93022121	10.75533973	10.70862232	11.0399715	10.63751979	10.54580477	10.1533792	10.09936589	10.29361229	10.10301134	10.13876361	9.95044613	9.729463121	9.886479572	9.527623267	9.617457887	8.971731407	9.453388627	9.299002904	9.451289047	9.624229367	9.088527768	9.087344804	9.072972388	8.858344511	8.537042688	7.927187624	7.255221028  47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017 = data_GDPpcDEUPPPIntlUSDof2017 ./ data_CO2pcDEUMetricTons;
dataMinMaxW_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017 = [1000 3051.53093021703	3285.69060510448	3497.90319692196	3486.22684556352	3615.09446365069	3676.11140443323	3584.12179411224	3780.84813688003	3889.94633834096	4113.88279602731	4250.58184708734	4233.36680083242	4297.46206935166	4249.97322041050	4382.24357998706	4517.13394977409	4620.25755356417	4943.58439479480	4953.82701923107	5020.71276375718	4971.68177742559	5350.88811915979	5276.78787961089	5190.45960376638	5594.47341653289	5629.72997830409	5718.04590347716	5991.12571218751	6258.77072652567	6796.14501472738	7145.24471283034  120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the DEU GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcDEUPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Germany GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Germany (min-max scale)');

saveas(gcf,'MinMaxWGDPDEUpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPDEUpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPDEUpcPPPIntlUSDof2017Abs.epsc')

GDPDEUpcDev = imread('MinMaxWGDPDEUpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the DEU CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcDEUMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Germany per capita for 1990-2020');
title('Germany (min-max scale)');

saveas(gcf,'MinMaxWCO2DEUpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2DEUpcAbs.png')
saveas(gcf,'MinMaxWCO2DEUpcAbs.epsc')

CO2DEUpcAbs = imread('MinMaxWCO2DEUpcAbs.png'); %AM230701 checking online

%% Creating the DEU Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcDEUDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Germany Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Germany (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017DEUAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017DEUAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017DEUAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017DEUAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017DEUAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% France - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcFRAPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI82:BM82');
dataMinMaxW_GDPpcFRAPPPIntlUSDof2017 = [436.4 33843.02039	33898.23404	34269.28344	33906.22186	34576.31943	35176.62211	35546.58328	36247.60429	37409.39549	38490.04018	39726.4884	40220.10086	40381.45953	40425.63805	41265.12692	41638.03178	42362.98541	43123.50113	42993.05952	41544.02261	42145.68195	42862.4158	42789.05191	42813.93354	43021.39464	43345.78643	43705.14756	44577.06457	45245.96087	45922.79474	42233.1396 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcFRAMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI82:BM82');
dataMinMaxW_CO2pcFRAMetricTons = [0.001 6.138336383	6.501145018	6.26433402	5.913504862	5.806327697	5.916383137	6.157646395	5.988674927	6.332690344	6.197953802	6.126515445	6.141051661	6.004364485	6.052955998	6.026319535	6.026677842	5.84238818	5.670764603	5.564039942	5.314137365	5.350407866	5.127105446	5.152358494	5.127899428	4.614807136	4.675935087	4.703475673	4.747916929	4.570517428	4.460164948	3.953682452 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017 = data_GDPpcFRAPPPIntlUSDof2017 ./ data_CO2pcFRAMetricTons;
dataMinMaxW_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017 = [1000  5513.38640997263	5214.19441409010	5470.53898067499	5733.69307255439	5954.93765262718	5945.62949996229	5772.75488143953	6052.69191208962	5907.34639775987	6210.12053482652	6484.35293407427	6549.38324598699	6725.35114019913	6678.66048640278	6847.48405434807	6908.95263912633	7250.97068272624	7604.53027979670	7726.95019525920	7817.64184005663	7877.09703680201	8359.96377413850	8304.75052597411	8349.21474912977	9322.46860318596	9269.97180778051	9292.09601435337	9388.76253375702	9899.52703972481	10296.2099542877	10681.9756300943 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the FRA GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcFRAPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('France GDP per capita in PPP International USD of 2017 for 1990-1990');
title('France (min-max scale)');

saveas(gcf,'MinMaxWGDPFRApcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPFRApcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPFRApcPPPIntlUSDof2017Abs.epsc')

GDPFRApcDev = imread('MinMaxWGDPFRApcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the FRA CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcFRAMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in France per capita for 1990-2020');
title('France (min-max scale)');

saveas(gcf,'MinMaxWCO2FRApcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2FRApcAbs.png')
saveas(gcf,'MinMaxWCO2FRApcAbs.epsc')

CO2FRApcAbs = imread('MinMaxWCO2FRApcAbs.png'); %AM230701 checking online

%% Creating the FRA Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcFRADefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('France Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('France (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017FRAAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017FRAAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017FRAAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017FRAAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017FRAAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Italy - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcITAPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI121:BM121');
dataMinMaxW_GDPpcITAPPPIntlUSDof2017 = [436.4 36585.6799	37122.82193	37407.11132	37065.43412	37855.00774	38947.20131	39429.49556	40129.90188	40844.74561	41501.78837	43053.93306	43869.42794	43915.38534	43781.21998	44118.03664	44260.82742	44918.17035	45356.53672	44623.60202	42074.92125	42664.35527	42892.30556	41501.71123	40268.11279	39898.52646	40247.82904	40837.73763	41581.12079	42045.92147	42739.04991	39091.40606 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcITAMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI121:BM121');
dataMinMaxW_CO2pcITAMetricTons = [0.001 7.145053425	7.119179515	7.08265725	6.984254473	6.901161788	7.325536211	7.248530833	7.303824626	7.492472245	7.607846446	7.662108329	7.66262916	7.772183978	8.064421038	8.189340766	8.173814347	8.025843914	7.860786871	7.564324796	6.718921188	6.836875163	6.68055037	6.32766192	5.751877662	5.38744256	5.563294289	5.498244377	5.437912061	5.376940361	5.311030987	4.732372771 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcITADefByGDPpcPPPIntlUSDof2017 = data_GDPpcITAPPPIntlUSDof2017 ./ data_CO2pcITAMetricTons;
dataMinMaxW_GreenProsppcITADefByGDPpcPPPIntlUSDof2017 = [1000 5120.42076230758	5214.48038423657	5281.50805626888	5306.99937563859	5485.30941595977	5316.63487716048	5439.65342271055	5494.36821616363	5451.43769200871	5455.12960393868	5619.07130693105	5725.11432142163	5650.32756113138	5428.93529178715	5387.25129379639	5414.95384395247	5596.69124316164	5769.97410880152	5899.21813457648	6262.15430563920	6240.32972039162	6420.47483923493	6558.77506643103	7000.86391870960	7405.83793131676	7234.53172778516	7427.41406608055	7646.52321050050	7819.67413621651	8047.22284966094	8260.42409343310  120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the ITA GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcITAPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Italy GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Italy (min-max scale)');

saveas(gcf,'MinMaxWGDPITApcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPITApcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPITApcPPPIntlUSDof2017Abs.epsc')

GDPITApcDev = imread('MinMaxWGDPITApcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the ITA CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcITAMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average CO2 Emissions in Italy per capita for 1990-2020');
title('Italy (min-max scale)');

saveas(gcf,'MinMaxWCO2ITApcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2ITApcAbs.png')
saveas(gcf,'MinMaxWCO2ITApcAbs.epsc')

CO2ITApcAbs = imread('MinMaxWCO2ITApcAbs.png'); %AM230701 checking online

%% Creating the ITA Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcITADefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Italy Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Italy (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017ITAAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017ITAAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017ITAAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017ITAAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017ITAAbs.png'); %AM230701 after checking online


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Poland - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcPOLPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI195:BM195');
dataMinMaxW_GDPpcPOLPPPIntlUSDof2017 = [436.4 11259.43745	10432.45531	10662.08052	11032.55399	11591.99886	12398.52413	13146.75609	13985.43358	14629.19836	15311.44294	16177.86767	16385.99717	16727.33977	17324.21619	18198.10004	18844.55748	20012.62111	21437.45774	22334.78086	22951.78482	23692.90923	24874.17186	25258.59332	25490.32891	26488.20025	27667.68908	28497.10361	29958.12071	31739.25696	33159.76442	32546.82594 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcPOLMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI195:BM195');
dataMinMaxW_CO2pcPOLMetricTons = [0.001 9.189383729	9.193722889	8.95035399	8.94445674	8.814966858	8.809530188	9.199378527	8.916689047	8.235525922	7.992134871	7.730919997	7.676919487	7.515499983	7.793067688	7.905616389	7.89596453	8.23499125	8.220639991	8.087059985	7.791554656	8.247004676	8.159932723	7.969684286	7.841820794	7.516889192	7.610021183	7.895752254	8.236243136	8.209531333	7.768855783	7.367563373 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017 = data_GDPpcPOLPPPIntlUSDof2017 ./ data_CO2pcPOLMetricTons;
dataMinMaxW_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017 = [1000 1225.26578347051	1134.73675807346	1191.24679639529	1233.45154566462	1315.03601211571	1407.39901695883	1429.09176384459	1568.45590357131	1776.35265755656	1915.81388258373	2092.61868909705	2134.44952767193	2225.71216865789	2223.02909214179	2301.92045118628	2386.60614670701	2430.19336689813	2607.76019415919	2761.79240687080	2945.72596015387	2872.91085188514	3048.33050794001	3169.33424352876	3250.56253908839	3523.82475989305	3635.69146745033	3609.16891721606	3637.35263917388	3866.14724679247	4268.29450143030	4417.58343898727  120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the POL GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcPOLPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Poland GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Poland (min-max scale)');

saveas(gcf,'MinMaxWGDPPOLpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPPOLpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPPOLpcPPPIntlUSDof2017Abs.epsc')

GDPPOLpcDev = imread('MinMaxWGDPPOLpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the POL CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcPOLMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Poland per capita for 1990-2020');
title('Poland (min-max scale)');

saveas(gcf,'MinMaxWCO2POLpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2POLpcAbs.png')
saveas(gcf,'MinMaxWCO2POLpcAbs.epsc')

CO2POLpcAbs = imread('MinMaxWCO2POLpcAbs.png'); %AM230701 checking online

%% Creating the POL Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcPOLDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Poland Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Poland (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017POLAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017POLAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017POLAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017POLAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017POLAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Bulgaria - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcBGRPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI26:BM26');
dataMinMaxW_GDPpcBGRPPPIntlUSDof2017 = [436.4 12507.72841	11565.38754	10840.09157	10765.16339	10998.16016	11362.65982	12015.94105	10382.86376	10848.43404	9993.461019	10503.63276	11124.51926	12036.19759	12767.28374	13701.51766	14779.21056	15904.92081	17078.38854	18250.56215	17767.5353	18160.62977	18661.50208	18911.60672	18911.14842	19202.83169	19988.24818	20740.81943	21469.97089	22206.15699	23266.06932	22479.58294 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcBGRMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI26:BM26');
dataMinMaxW_CO2pcBGRMetricTons = [0.001 8.442677227	6.814643075	6.482791197	6.600936486	6.362695682	6.528951054	6.612800505	6.375621566	6.113456253	5.398128084	5.314588236	5.766610206	5.563226275	6.164795384	6.124991253	6.265279466	6.440554967	6.971019721	6.678530879	5.763735447	6.049624919	6.754951603	6.162577362	5.45906018	5.821533906	6.207377524	5.834418985	6.20201084	5.821777166	5.613710103	4.923280379 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017 = data_GDPpcBGRPPPIntlUSDof2017 ./ data_CO2pcBGRMetricTons;
dataMinMaxW_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017 = [1000 1481.48840445171	1697.13768080447	1672.13338283604	1630.85395763524	1728.53782567485	1740.34997746540	1817.07296932466	1628.52572923945	1774.51732485731	1851.28267865370	1976.37752822652	1929.12627359122	2163.52831800674	2070.99878274235	2236.98567006651	2358.90683651281	2469.49539126273	2449.91252742429	2732.72108556107	3082.64240508411	3001.94309788497	2762.64038220226	3068.78203859786	3464.17657927736	3298.58624898270	3220.07935031518	3554.90743531192	3461.77577593105	3814.32616803400	4144.50851388357	4565.97658619924 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the BGR GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcBGRPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Bulgaria GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Bulgaria (min-max scale)');

saveas(gcf,'MinMaxWGDPBGRpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPBGRpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPBGRpcPPPIntlUSDof2017Abs.epsc')

GDPBGRpcDev = imread('MinMaxWGDPBGRpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the BGR CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcBGRMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Bulgaria per capita for 1990-2020');
title('Bulgaria (min-max scale)');

saveas(gcf,'MinMaxWCO2BGRpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2BGRpcAbs.png')
saveas(gcf,'MinMaxWCO2BGRpcAbs.epsc')

CO2BGRpcAbs = imread('MinMaxWCO2BGRpcAbs.png'); %AM230701 checking online

%% Creating the BGR Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcBGRDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Bulgaria Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Bulgaria (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017BGRAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017BGRAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017BGRAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017BGRAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017BGRAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Switzerland - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcCHEPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI42:BM42');
dataMinMaxW_GDPpcCHEPPPIntlUSDof2017 = [436.4 56232.02608	55025.01131	54397.88076	53836.80885	54087.51955	53985.64531	54001.05315	55089.32729	56590.11738	57257.31822	59190.41534	59743.81593	59250.16447	58793.1483	59967.91304	61223.39324	63318.79489	65213.18054	66197.86747	63873.95237	65262.34098	65710.91507	65783.58911	66196.94731	66930.86863	67261.59401	67907.39388	68193.50549	69629.33661	69923.93121	67765.88143 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcCHEMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI42:BM42');
dataMinMaxW_CO2pcCHEMetricTons = [0.001 6.451697925	6.71572761	6.647298965	6.262660766	6.090112736	6.16976724	6.222699859	6.030309895	6.22324807	6.232944582	6.083975363	6.245589468	5.981438218	6.109755265	6.12803762	6.165119136	6.076924249	5.766193267	5.879237808	5.639146825	5.77742182	5.206044994	5.316661125	5.381300293	4.85956841	4.719745349	4.737238602	4.57876628	4.402143727	4.358609865	4.042072815 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017 = data_GDPpcCHEPPPIntlUSDof2017 ./ data_CO2pcCHEMetricTons;
dataMinMaxW_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017 = [1000 8715.84918119247	8193.45490256630	8183.45632548506	8596.47534233240	8881.20169521094	8750.02949156015	8678.07452962418	9135.40568233085	9093.34108824665	9186.23893766284	9728.90450988088	9565.76096311574	9905.67189934719	9622.83197082713	9785.82651685991	9930.60991863614	10419.5465165560	11309.5724549345	11259.6002476133	11326.8823014915	11296.1010992954	12622.0413270034	12373.1017573276	12301.2921985873	13773.0067738171	14251.1065820336	14334.8054815580	14893.4235375041	15817.1429472897	16042.7139341742	16765.1312914708 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the CHE GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcCHEPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Switzerland GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Switzerland (min-max scale)');

saveas(gcf,'MinMaxWGDPCHEpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPCHEpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPCHEpcPPPIntlUSDof2017Abs.epsc')

GDPCHEpcDev = imread('MinMaxWGDPCHEpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the CHE CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcCHEMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average CO2 Emissions in Switzerland per capita for 1990-2020');
title('Switzerland (min-max scale)');

saveas(gcf,'MinMaxWCO2CHEpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2CHEpcAbs.png')
saveas(gcf,'MinMaxWCO2CHEpcAbs.epsc')

CO2CHEpcAbs = imread('MinMaxWCO2CHEpcAbs.png'); %AM230701 checking online

%% Creating the CHE Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcCHEDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Switzerland Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Switzerland (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017CHEAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017CHEAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017CHEAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017CHEAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017CHEAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Canada - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcCANPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI40:BM40');
dataMinMaxW_GDPpcCANPPPIntlUSDof2017 = [436.4 34562.86635	33423.88452	33327.94746	33840.81826	34976.59287	35549.09303	35749.04525	36910.47786	38031.62476	39671.38465	41338.64702	41623.95034	42416.40875	42793.07925	43704.41391	44680.79649	45396.83966	45889.56213	45851.20193	44004.3141	44862.4195	45823.16424	46126.51389	46704.76224	47564.60911	47522.14067	47457.58535	48317.17458	48962.48151	49175.67705	46181.75755 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcCANMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI40:BM40');
dataMinMaxW_CO2pcCANMetricTons = [0.001 15.14896932	14.74096404	15.02813904	14.71330913	15.06050396	15.29046634	15.59261401	15.94384836	16.07657167	16.25847341	16.75746674	16.33143678	16.72041069	17.20835919	16.79418597	17.0275681	16.59521392	17.38063077	16.55942629	15.50450587	15.79453766	15.99827172	15.73682394	15.84080976	15.85217722	15.64990728	15.42182253	15.54719472	15.63665416	15.05274694	13.59937492 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017 = data_GDPpcCANPPPIntlUSDof2017 ./ data_CO2pcCANMetricTons;
dataMinMaxW_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017 = [1000 2281.53253309379	2267.41510438304	2217.70289623461	2300.01408659581	2322.40521014549	2324.91882457463	2292.69096449267	2315.02940980146	2365.65516214008	2440.04364079807	2466.87925142031	2548.70106599117	2536.80424190457	2486.76115970614	2602.35381417246	2624.02688552721	2735.53808284314	2640.27023697902	2768.88831261247	2838.16294856040	2840.37560681394	2864.25715505812	2931.11964950811	2948.38224524772	3000.50954743639	3036.57649865308	3077.30070601744	3107.77445507238	3131.26331266758	3266.89057025152	3395.87354811922 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the CAN GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcCANPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Canada GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Canada (min-max scale)');

saveas(gcf,'MinMaxWGDPCANpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPCANpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPCANpcPPPIntlUSDof2017Abs.epsc')

GDPCANpcDev = imread('MinMaxWGDPCANpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the CAN CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcCANMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Canada per capita for 1990-2020');
title('Canada (min-max scale)');

saveas(gcf,'MinMaxWCO2CANpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2CANpcAbs.png')
saveas(gcf,'MinMaxWCO2CANpcAbs.epsc')

CO2CANpcAbs = imread('MinMaxWCO2CANpcAbs.png'); %AM230701 checking online

%% Creating the CAN Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcCANDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Canada Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Canada (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017CANAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017CANAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017CANAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017CANAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017CANAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mexico - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcMEXPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI159:BM159');
dataMinMaxW_GDPpcMEXPPPIntlUSDof2017 = [436.4 15218.30844	15522.91992	15757.14755	15930.48391	16402.25816	15087.58963	15825.09375	16618.91325	17184.94319	17370.81291	17942.78035	17596.78674	17324.35365	17315.455	17731.80283	17883.53541	18434.88654	18610.73143	18586.47129	17387.66191	18036.71759	18432.36879	18838.7839	18844.03034	19141.92066	19542.88989	19830.96249	20032.40861	20278.21631	20064.5005	18327.99076 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcMEXMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI159:BM159');
dataMinMaxW_CO2pcMEXMetricTons = [0.001 3.29875169	3.455192429	3.431834824	3.469969866	3.697072179	3.410509722	3.523433107	3.67532763	3.853042786	3.686915457	3.874145961	3.811392059	3.824967946	3.95094019	3.983825688	4.098800784	4.194183397	4.220761327	4.189727319	4.037593962	4.113210914	4.190989787	4.202413546	4.056055227	3.892355248	3.925368326	3.920323024	3.862759412	3.587489305	3.612165141	3.040766375 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017 = data_GDPpcMEXPPPIntlUSDof2017 ./ data_CO2pcMEXMetricTons;
dataMinMaxW_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017 = [1000 4613.35373638922	4492.63542966712	4591.46443914454	4590.95742366782	4436.55340396250	4423.85181648489	4491.38475844453	4521.75014812137	4460.09664107507	4711.47578821532	4631.41567879903	4616.89232277527	4529.28074118079	4382.61633117356	4450.94846383161	4363.11407885112	4395.34583805269	4409.33044655996	4436.20070652942	4306.44142895650	4385.06995253246	4398.09441775845	4482.84865133734	4645.90082833362	4917.82466995963	4978.61302845752	5058.50215973005	5186.03580395714	5652.48132704446	5554.70188059406	6027.42483450816 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the MEX GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcMEXPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Mexico GDP per capita in PPP International USD of 2017 for 1990-1990');
title(['Mexico (min-max scale)']);

saveas(gcf,'MinMaxWGDPMEXpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPMEXpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPMEXpcPPPIntlUSDof2017Abs.epsc')

GDPMEXpcDev = imread('MinMaxWGDPMEXpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the MEX CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcMEXMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Mexico per capita for 1990-2020');
title('Mexico (min-max scale)');

saveas(gcf,'MinMaxWCO2MEXpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2MEXpcAbs.png')
saveas(gcf,'MinMaxWCO2MEXpcAbs.epsc')

CO2MEXpcAbs = imread('MinMaxWCO2MEXpcAbs.png'); %AM230701 checking online

%% Creating the MEX Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcMEXDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Mexico Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Mexico (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017MEXAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017MEXAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017MEXAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017MEXAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017MEXAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Russia - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcRUSPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI207:BM207');
dataMinMaxW_GDPpcRUSPPPIntlUSDof2017 = [436.4 21482.74805	20340.13281	17367.64063	15870.60547	13880.46484	13308.20508	12827.11621	13028.20801	12358.15234	13189.79395	14569.93652	15378.08984	16175.09766	17434.80859	18765.51953	20042.81445	21757.46484	23647.26563	24887.85352	22939.69336	23961.2207	24972.07813	25933.29297	26332.39648	26057.15625	25488.0957	25490.70898	25926.44336	26656.41016	27254.57422	26586.55469 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcRUSMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI207:BM207');
dataMinMaxW_CO2pcRUSMetricTons = [0.001 14.62148929	14.39708607	13.67197624	12.6650949	11.35415408	11.02258551	10.8070674	10.06999199	10.07623146	10.35032856	10.6676603	10.73578414	10.77263875	11.13039808	11.11271137	11.23185215	11.5683691	11.61126905	11.59565409	10.83210855	11.32540095	11.8849497	11.70206537	11.37700431	11.20820771	11.0520055	10.88742693	11.03519921	11.49657125	11.79719417	11.23228807 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017 = data_GDPpcRUSPPPIntlUSDof2017 ./ data_CO2pcRUSMetricTons;
dataMinMaxW_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017 = [1000 1469.25854253235	1412.79511103885	1270.30945059599	1253.09802961271	1222.50101083296	1207.35784400087	1186.91923876630	1293.76547914271	1226.46570678275	1274.33577331060	1365.80431972612	1432.41421826740	1501.49819684701	1566.41374990425	1688.65355294451	1784.46209764647	1880.77201387841	2036.57890696069	2146.30872258903	2117.74958211502	2115.70617391038	2101.15135232750	2216.12955939597	2314.52812858592	2324.82810210073	2306.19643642853	2341.29782474181	2349.43138469692	2318.64001685783	2310.25901855107	2366.97585819884 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the RUS GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcRUSPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Russia GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Russia (min-max scale)');

saveas(gcf,'MinMaxWGDPRUSpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPRUSpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPRUSpcPPPIntlUSDof2017Abs.epsc')

GDPRUSpcDev = imread('MinMaxWGDPRUSpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the RUS CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcRUSMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('Average CO2 Emissions in Russia per capita for 1990-2020');
title('Russia (min-max scale)');

saveas(gcf,'MinMaxWCO2RUSpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2RUSpcAbs.png')
saveas(gcf,'MinMaxWCO2RUSpcAbs.epsc')

CO2RUSpcAbs = imread('MinMaxWCO2RUSpcAbs.png'); %AM230701 checking online

%% Creating the RUS Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcRUSDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Russia Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Russia (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017RUSAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017RUSAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017RUSAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017RUSAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017RUSAbs.png'); %AM230701 after checking online

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Saudi Arabia - Loading the Dataset and Defining the Time Interval

% NB: Read data from an *.xlsx source file (!!! To work in Mac OS, needs to be saved as *.xlsx if provided in *.xls or *csv formats!)

% GDP pc in PPP international USD of 2017 - data download source: https://data.worldbank.org/indicator/API_NY.GDP.PCAP.PP.KD
data_GDPpcSAUPPPIntlUSDof2017 = xlsread('API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx','Data','AI210:BM210');
dataMinMaxW_GDPpcSAUPPPIntlUSDof2017 = [436.4 42163.80172	46600.52947	46700.36207	44604.88222	43581.6362	42468.67276	42417.81674	41750.11827	41837.16971	39233.46255	40406.33158	38943.78324	36946.74925	40163.96117	42424.04789	43437.86791	42916.05371	42024.66465	42963.04962	40532.4503	41231.56775	44642.75611	46041.66528	46359.84336	47261.68228	48535.15827	48691.26856	47551.85952	47714.11258	47024.54432	44770.90828 157602.5]
ticksGDPMinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data)!

% CO2 emisions, metric ton per capita - data download source: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
data_CO2pcSAUMetricTons = xlsread('API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx','Data','AI210:BM210');
dataMinMaxW_CO2pcSAUMetricTons = [0.001 10.70951816	11.28388289	11.69073597	11.38895829	11.23501214	10.84398595	11.21325401	11.03764364	11.42497917	11.40049387	11.58631277	11.50434741	12.03404526	12.30314813	12.67398501	12.92310028	13.21498712	13.43244267	14.20375355	14.27220886	15.16838627	15.38139849	15.97801577	15.98391907	16.82523613	17.25779307	16.7951031	16.0777919	15.06550049	14.70301665	14.26658537 47.7]
ticksCO2MinMaxW = 1990:2020; %AM231005 Select the date range, i.e., data vector, to be displayed (NO earlier data again: but symmetry)!

% GDP pc (in PPP Intl USD of 2017) normalized by CO2 pc emitions (in metric tons): dividing the 1st series to the 2nd above 
data_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017 = data_GDPpcSAUPPPIntlUSDof2017 ./ data_CO2pcSAUMetricTons;
dataMinMaxW_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017 = [1000 3937.04003238480	4129.83100960609	3994.64689020933	3916.50237668986	3879.09115459096	3916.33417234367	3782.82849105614	3782.52094775405	3661.90336920756	3441.38271576926	3487.41936908740	3385.13623313877	3070.18533294604	3264.52715516134	3347.33296928228	3361.25751320407	3247.52898588278	3128.59437908083	3024.76732497967	2839.95635795950	2718.25670951778	2902.38603026469	2881.56339017264	2900.40528658670	2808.97586958639	2812.36181597895	2899.13484043101	2957.61133177155	3167.11101610358	3198.29225774733	3138.16565957144 120000]
ticksGreenProspGDPMinMaxW = 1990:2020 % AM231005 Keep the name/label "ticks" becuase it is used/called below in generating the graphs!

%% Creating the SAU GDP pc (min-max) Figure

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
   'CData',dataMinMaxW_GDPpcSAUPPPIntlUSDof2017)   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
fontsize(16,"points")
%title('Saudi Arabia GDP per capita in PPP International USD of 2017 for 1990-1990');
title('Saudi Arabia (min-max scale)');

saveas(gcf,'MinMaxWGDPSAUpcPPPIntlUSDof2017Abs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGDPSAUpcPPPIntlUSDof2017Abs.png')
saveas(gcf,'MinMaxWGDPSAUpcPPPIntlUSDof2017Abs.epsc')

GDPSAUpcDev = imread('MinMaxWGDPSAUpcPPPIntlUSDof2017Abs.png'); %AM230701 after checking online

%% Creating the SAU CO2 pc (min-max) Figure

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
   'CData',dataMinMaxW_CO2pcSAUMetricTons)    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_AMGreening_GreenToBrown)
colorbar
fontsize(16,"points")
%title('CO2 Emissions in Saudi Arabia per capita for 1990-2020');
title('Saudi Arabia (min-max scale)');

saveas(gcf,'MinMaxWCO2SAUpcAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWCO2SAUpcAbs.png')
saveas(gcf,'MinMaxWCO2SAUpcAbs.epsc')

CO2SAUpcAbs = imread('MinMaxWCO2SAUpcAbs.png'); %AM230701 checking online

%% Creating the SAU Greening Prosperity (Ratio) (min-max) Figure

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
   'CData',dataMinMaxW_GreenProsppcSAUDefByGDPpcPPPIntlUSDof2017)    %AM230630 Select the data vector to be displayed!
colormap(wscolors_AMGreening_BrownToGreen)
colorbar
fontsize(16,"points")
%title('Saudi Arabia Greening Prosperity (Ratio, with GDP in the numerator) Stripes per capita for 1990-2020')
title('Saud Arabia (min-max scale)');

saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017SAUAbs.fig') %AM230701 checking online
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017SAUAbs.png')
saveas(gcf,'MinMaxWGreenProspDefGDPpcPPPUSD2017SAUAbs.epsc')

GreenProsppcDefGDPpcPPPUSD2017SAUAbs = imread('MinMaxWGreenProspDefGDPpcPPPUSD2017SAUAbs.png'); %AM230701 after checking online

%%% end of program %%%
