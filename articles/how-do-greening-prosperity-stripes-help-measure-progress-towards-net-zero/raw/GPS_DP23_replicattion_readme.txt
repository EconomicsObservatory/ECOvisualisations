Alexander Mihailov, 4 December 2023

This is the readme.txt file for the replication of "Greening Prosperity Stripes across the Globe", Discussion Paper 2023-17 (November 2023) at the Department of Economics, University of Reading.

All data sources and links to the data are from the World Bank and provided in the paper (with respective URLs).

In particular, there are 3 original *.xls files downloaded from the World Bank database online:

API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xls    -> World Bank CO2 emissions data
API_NY.GDP.PCAP.CD_DS2_en_excel_v2_5607109.xls    -> World Bank GDP pc data in USD of 2015
API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xls -> World Bank GDP pc daua at PPP in international USD of 2017

There are 3 corresponding *.xlsx files with the same name, containing some minimal notes, marks and manipulations by me: MATLAB R2023a, that were used for all 7 codes herein: note that MATLAB in Mac OS allows only working with *.xlsx files, not *.xls ones, so I had created the former from the latter:

API_EN.ATM.CO2E.PC_DS2_en_excel_v2_5607813.xlsx
API_NY.GDP.PCAP.CD_DS2_en_excel_v2_5607109.xlsx
API_NY.GDP.PCAP.PP.KD_DS2_en_excel_v2_5607670.xlsx

The 7 code (*.m) files can be executed in arbitrary order. The first 5 use the above *.xlsx files to read from.

GDPpcCO2pcStripes1stSmpl4Groups8Countries_am231204.m
GDPpcCO2pcStripes2ndSmpl2Groups10Countries_am231204.m

GDPpcCO2pcStripes1stSmpl4Groups8CountriesMinMaxWorld_am231204.m
GDPpcCO2pcStripes2ndSmpl2Groups10CountriesMinMaxWorld_am231204.m

GDPpcCO2pcStripesWorldCrossSectionByYear_am231204.m

The last 2 *.m codes,

GDPpcWorldUSDof2015Stripes_am231204.m
LifeExpectancyWorldStripes_am231204.m

use 2 *.txt files to read from (based, again, on the World Bank original data), namely,

GDPpcWorldUSDof2015.txt
LifeExpectancyWorld.txt

The filenames of the *.m programs are self-explanatory. Each of them contains very detailed annotation and guidance.

The 7 MATLAB R2023a generate all graphs for the figures in the paper, as well as the necessary ingredients to compile (manually) Table 1.