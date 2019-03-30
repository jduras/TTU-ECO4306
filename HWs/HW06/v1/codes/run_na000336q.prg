
' import data on Private Nonresidential Fixed Investment (NA000336Q) obtained from FRED; source: https://fred.stlouisfed.org/series/na000336q
import "../data/na000336q.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series gna000336q = 100* d(na000336q)/na000336q(-1)

%series_code = "na000336q"
%series_code_trans = "gna000336q"
%series_code_fcst = "gna000336q"

%series_title = " Private Nonresidential Fixed Investment, Millions of Dollars"
%series_title_trans = "Percentage Change in Private Nonresidential Fixed Investment"
%series_title_fcst = "Percentage Change in Private Nonresidential Fixed Investment"

%sample_estimation = "1960q1 2006q4"
%sample_prediction = "2007q1 2018q4"
%sample_prediction_plot = "2005q1 2018q4"

' '%equation_spec_rhs = "c ar(1) sar(4)"
' %equation_spec_rhs = "c sar(4) sma(4)"
' %equation_spec_rhs = "c ar(1) ar(2) sar(4) sma(4)"
' %equation_spec_rhs = "c ar(1) ar(2) ma(1) sar(4) sar(8) sma(4)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(6) ma(1) sar(4) sma(4)"
%equation_spec_rhs = "c ar(1) ar(2) ar(6) ma(1) sar(4) sar(8) sma(4)"
%equation_spec_lhs = %series_code_trans

include f_SARMA


