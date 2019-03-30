
' import data on Industrial Production: Utilities: Electric power generation (IPG22111N) obtained from FRED; source: https://fred.stlouisfed.org/series/ipg22111n
import "../data/ipg22111n.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series gipg22111n = 100* d(ipg22111n) / ipg22111n(-1)

%series_code = "ipg22111n"
%series_code_trans = "gipg22111n"
%series_code_fcst = "gipg22111n"

%series_title = "Electric power generation, Index 2012=100"
%series_title_trans = "Percentage Change in Electric power generation"
%series_title_fcst = "Electric power generation"

%sample_estimation = "1980m1 2006m12"
%sample_prediction = "2007m1 2019m2"
%sample_prediction_plot = "2005m1 2019m2"

' %equation_spec_rhs = "c ar(1) sar(12)"
' %equation_spec_rhs = "c ar(1) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(3) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(3) ar(4) sar(12) sma(12) sar(24) sma(24)"
%equation_spec_rhs = "c ar(1) ar(2) ar(3) ar(4) sar(12) sma(12)"
%equation_spec_lhs = %series_code_trans

include f_SARMA


