%% MATLAB program to create stripes colormap of GDP pc for the World in USD of 2015 since 1960 annually
% File name: GDPpcWorldUSDof2015Stripes_am231204.m
% AM230630 in R2017a 1st trial -> and success! -> based on:
% http://mres.uni-potsdam.de/index.php/2022/11/16/ed-hawkins-warming-stripes-with-matlab/
% AM230701 in R2023a minor edits and development
% AM230709 in R2023a further minor edits and development
% AM231204 in R2023a final checks and minor edits

%% Acknowledgement

% "NOVEMBER 16, 2022 BY MARTIN H. TRAUTH
% Ed Hawkins, Warming Stripes with MATLAB"

% "Ed Hawkins, climatologist at U Reading, published a visualization graphics for climate data to display global warming.
% Here's a script to display the warming stripes with MATLAB. To display the popular warming stripes, Python scripts and
% R scripts exist, but I was not able to find a MATLAB script, inspired by a discussion on Twitter. In following script
% I used the HadCRUT.4.6.0.0 dataset by the Met Office Hadley Centre. The hex colormap was taken from the Python script
% and converted to RGB colors using a script by Jos van der Geest published on the MathWorks File Exchange."

%% Housekeeping

% Clear the Workspace and the Command Window and close all Figure Windows (respectively, the 3 commands in the next line).
clear; clc; close all

diary GDPpcWorldUSDof2015Stripes_am231204.txt % create a diary log (*.txt) file saving the output from the command window
tic                                           % start stopwatch timer
t = datetime('now')                           % return a datetime scalar representing the current date and time

%% Loading the Dataset and Defining the Time Interval

data_GDPpcWorldUSDof2015 = load('GDPpcWorldUSDof2015.txt'); %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
ticks = 1960:2021; %AM230630 Select the date range, i.e., data vector (from the *.txt datafile), to be displayed!

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

%% Creating the World GDP pc Figures

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2022), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

fig1 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticks) max(ticks)],...
   'XTickMode','manual',...
   'XTick',ticks,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticks',...
   'YData',[2000 2040],...
   'XData',[1960 2022],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcWorldUSDof2015(:,3)')   %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Deviation from Average World GDP per capita for 1960-1990 Normalized to 0');

saveas(gcf,'GDPpcWorldUSDof2015DevSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'GDPpcWorldUSDof2015DevSince1960Annual.png')
saveas(gcf,'GDPpcWorldUSDof2015DevSince1960Annual.epsc')

GDPpcWorldUSDof2015DevSince1960Annual = imread('GDPpcWorldUSDof2015DevSince1960Annual.png'); %AM230701 checking online

fig2 = figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticks) max(ticks)],...
   'XTickMode','manual',...
   'XTick',ticks,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticks',...
   'YData',[2000 2040],...
   'XData',[1960 2022],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_GDPpcWorldUSDof2015(:,2)')    %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
colormap(wscolors_EHWarming_BlueToRed)
colorbar
title('Average World GDP per capita in USD of 2015');

saveas(gcf,'GDPpcWorldUSDof2015AbsSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'GDPpcWorldUSDof2015AbsSince1960Annual.png')
saveas(gcf,'GDPpcWorldUSDof2015AbsSince1960Annual.epsc')

GDPpcWorldUSDof2015AbsSince1960Annual = imread('GDPpcWorldUSDof2015AbsSince1960Annual.png'); %AM230701 checking online

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Plot - absolute level

fig3 = figure
plot(data_GDPpcWorldUSDof2015(:,1),data_GDPpcWorldUSDof2015(:,2),'LineWidth',2)
axis ([1960 2022 3000 12000])
fontsize(12,"points")
grid on
xlabel('years (sample 1960-2022)')
ylabel('USD of 2015')
title('Average World GDP per capita in USD of 2015');

saveas(gcf,'Plot_GDPpcWorldUSDof2015AbsSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcWorldUSDof2015AbsSince1960Annual.png')
saveas(gcf,'Plot_GDPpcWorldUSDof2015AbsSince1860Annual.epsc')

%% Histogram - absolute level

fig4 = figure
histogram(data_GDPpcWorldUSDof2015(:,2),16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('frequency')
title('Average World GDP per capita in USD of 2015');

saveas(gcf,'Hist_GDPpcWorldUSDof2015AbsSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcWorldUSDof2015AbsSince1960Annual.png')
saveas(gcf,'Hist_GDPpcWorldUSDof2015AbsSince1960Annual.epsc')

%% Computation and Export of a Descriptive Stats Table - absolute level

data_GDPpcWorldUSDof2015Abs_min = min(data_GDPpcWorldUSDof2015(:,2))
data_GDPpcWorldUSDof2015Abs_max = max(data_GDPpcWorldUSDof2015(:,2))
data_GDPpcWorldUSDof2015Abs_range = data_GDPpcWorldUSDof2015Abs_max - data_GDPpcWorldUSDof2015Abs_min
stripe_GDPpcWorldUSDof2015Abs_range = data_GDPpcWorldUSDof2015Abs_range/16
data_GDPpcWorldUSDof2015Abs_mean = mean(data_GDPpcWorldUSDof2015(:,2))
data_GDPpcWorldUSDof2015Abs_median = median(data_GDPpcWorldUSDof2015(:,2))
%data_GDPpcWorldUSDof2015Abs_mode = mode(data_GDPpcWorldUSDof2015(:,2),'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcWorldUSDof2015Abs_std = std(data_GDPpcWorldUSDof2015(:,2))

tabGDPpcWorldUSDof2015Abs = table(categorical({'data_GDPpcWorldUSDof2015Abs_min';'data_GDPpcWorldUSDof2015Abs_max';'data_GDPpcWorldUSDof2015Abs_range';'stripe_GDPpcWorldUSDof2015Abs_range';'data_GDPpcWorldUSDof2015Abs_mean';'data_GDPpcWorldUSDof2015Abs_median';'data_GDPpcWorldUSDof2015Abs_std'}),{data_GDPpcWorldUSDof2015Abs_min; data_GDPpcWorldUSDof2015Abs_max; data_GDPpcWorldUSDof2015Abs_range; stripe_GDPpcWorldUSDof2015Abs_range; data_GDPpcWorldUSDof2015Abs_mean; data_GDPpcWorldUSDof2015Abs_median; data_GDPpcWorldUSDof2015Abs_std})
writetable(tabGDPpcWorldUSDof2015Abs,'tabGDPpcWorldUSDof2015Abs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Plot - relative/deviastion level

fig5 = figure
plot(data_GDPpcWorldUSDof2015(:,1),data_GDPpcWorldUSDof2015(:,3),'LineWidth',2)
axis ([1960 2022 -2000 +6000])
fontsize(12,"points")
grid on
xlabel('years (sample 1960-2022)')
ylabel('deviation from mean for 1960-1990 normalized to 0')
title('Deviation from Average World GDP per capita for 1960-1990 Normalized to 0')

saveas(gcf,'Plot_GDPpcWorldUSDof2015DevSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_GDPpcWorldUSDof2015DevSince1960Annual.png')
saveas(gcf,'Plot_GDPpcWorldUSDof2015DevSince1860Annual.epsc')

%% Histogram - relative/deviastion level

fig6 = figure
histogram(data_GDPpcWorldUSDof2015(:,3),16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('deviation from mean for 1960-1990 normalized to 0')
ylabel('frequency')
title('Deviation from Average World GDP per capita for 1960-1990 Normalized to 0');

saveas(gcf,'Hist_GDPpcWorldUSDof2015DevSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_GDPpcWorldUSDof2015DevSince1960Annual.png')
saveas(gcf,'Hist_GDPpcWorldUSDof2015DevSince1960Annual.epsc')

%% Computation and Export of a Descriptive Stats Table - relative/deviastion level

data_GDPpcWorldUSDof2015Dev_min = min(data_GDPpcWorldUSDof2015(:,3))
data_GDPpcWorldUSDof2015Dev_max = max(data_GDPpcWorldUSDof2015(:,3))
data_GDPpcWorldUSDof2015Dev_range = data_GDPpcWorldUSDof2015Dev_max - data_GDPpcWorldUSDof2015Dev_min
stripe_GDPpcWorldUSDof2015Dev_range = data_GDPpcWorldUSDof2015Dev_range/16
data_GDPpcWorldUSDof2015Dev_mean = mean(data_GDPpcWorldUSDof2015(:,3))
data_GDPpcWorldUSDof2015Dev_median = median(data_GDPpcWorldUSDof2015(:,3))
%data_GDPpcWorldUSDof2015Dev_mode = mode(data_GDPpcWorldUSDof2015(:,3),'all') %AM230708 Sth's wrong about the mode command?!
data_GDPpcWorldUSDof2015Dev_std = std(data_GDPpcWorldUSDof2015(:,3))

tabGDPpcWorldUSDof2015Dev = table(categorical({'data_GDPpcWorldUSDof2015Dev_min';'data_GDPpcWorldUSDof2015Dev_max';'data_GDPpcWorldUSDof2015Dev_range';'stripe_GDPpcWorldUSDof2015Dev_range';'data_GDPpcWorldUSDof2015Dev_mean';'data_GDPpcWorldUSDof2015Dev_median';'data_GDPpcWorldUSDof2015Dev_std'}),{data_GDPpcWorldUSDof2015Dev_min; data_GDPpcWorldUSDof2015Dev_max; data_GDPpcWorldUSDof2015Dev_range; stripe_GDPpcWorldUSDof2015Dev_range; data_GDPpcWorldUSDof2015Dev_mean; data_GDPpcWorldUSDof2015Dev_median; data_GDPpcWorldUSDof2015Dev_std})
writetable(tabGDPpcWorldUSDof2015Dev,'tabGDPpcWorldUSDof2015Dev.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//GreeningProsperityStripes",Format="tex")

