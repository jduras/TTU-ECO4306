
' import data on  Air Revenue Passenger Miles (AIRRPMTSI) obtained from FRED; source: https://fred.stlouisfed.org/series/AIRRPMTSI
import "../data/airrpmtsi.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series gairrpmtsi = 100* d(airrpmtsi) / airrpmtsi(-1)

%series_code = "airrpmtsi"
%series_code_trans = "gairrpmtsi"
%series_code_fcst = "gairrpmtsi"

%series_title = "Air Revenue Passenger Miles, in Thousands"
%series_title_trans = "Percentage Change in Air Revenue Passenger Miles"
%series_title_fcst = "Percentage Change in Air Revenue Passenger Miles"

%sample_estimation = "2000m1 2012m12"
%sample_prediction = "2013m1 2019m2"
%sample_prediction_plot = "2010m1 2019m2"

%equation_spec_rhs = "c ma(1) sar(12) sma(12)"
%equation_spec_lhs = %series_code_trans

include f_SARMA


