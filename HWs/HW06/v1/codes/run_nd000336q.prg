
' import data on Real Private Nonresidential Fixed Investment (ND000336Q) obtained from FRED; source: https://fred.stlouisfed.org/series/nd000336q
import "../data/nd000336q.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series gnd000336q = 100* d(nd000336q)/nd000336q(-1)

%series_code = "nd000336q"
%series_code_trans = "gnd000336q"
%series_code_fcst = "gnd000336q"

%series_title = " Real Private Nonresidential Fixed Investment, bn. of Chained 2012 Dollars"
%series_title_trans = "Percentage Change in Real Private Nonresidential Fixed Investment"
%series_title_fcst = "Percentage Change in Real Private Nonresidential Fixed Investment"

%sample_estimation = "2002q1 2014q4"
%sample_prediction = "2015q1 2018q4"
%sample_prediction_plot = "2013q1 2018q4"

%equation_spec_rhs = "c ar(1) sar(4)"
%equation_spec_lhs = %series_code_trans

include f_SARMA


