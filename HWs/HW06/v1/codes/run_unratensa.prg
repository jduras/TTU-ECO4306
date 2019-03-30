
' import data on Civilian Unemployment Rate (UNRATENSA) obtained from FRED; source: https://fred.stlouisfed.org/series/UNRATENSA
cd %codepath

import "../data/UNRATENSA.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series dunratensa = unratensa - unratensa(-1)

%series_code = "unratensa"
%series_code_trans = "dunratensa"
%series_code_fcst = "unratensa"

%series_title = "Unemployment Rate, in %"
%series_title_trans = "Change in Unemployment Rate, in %"
%series_title_fcst = "Unemployment Rate, in %"

%sample_estimation = "1960m1 2006m12"
%sample_prediction = "2007m1 2019m2"
%sample_prediction_plot = "2005m1 2019m2"

' %equation_spec_rhs = "c sar(12) "
' %equation_spec_rhs = "c ar(1) ar(2) ar(3) sar(12) sar(24)"
' %equation_spec_rhs = "c sar(12) sma(12)"
%equation_spec_rhs = "c ar(1) ar(2) ar(3) sar(12) sma(12)"
%equation_spec_lhs = "d(unratensa)"

%in_diff = "true"

include f_SARMA


