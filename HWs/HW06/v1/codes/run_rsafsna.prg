
' import data on Advance Retail Sales: Retail and Food Services, Total (RSAFSNA) obtained from FRED; source: https://fred.stlouisfed.org/series/rsafsna
import "../data/rsafsna.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series grsafsna = 100* d(rsafsna) / rsafsna(-1)

%series_code = "rsafsna"
%series_code_trans = "grsafsna"
%series_code_fcst = "grsafsna"

%series_title = "Retail Sales, in Millions of Dollars"
%series_title_trans = "Percentage Change in Retail Sales"
%series_title_fcst = "Percentage Change in Retail Sales"

%sample_estimation = "1992m1 2006m12"
%sample_prediction = "2007m1 2019m2"
%sample_prediction_plot = "2005m1 2019m2"

' %equation_spec_rhs = "c ar(1) ma(1)"
' %equation_spec_rhs = "c ar(1) ma(1) ar(2) ar(3) ar(9) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) sar(12) sma(12)'
' %equation_spec_rhs = "c ar(1) ar(2) sar(12)" 
' %equation_spec_rhs = "c ar(1) ma(1) sar(12) sma(12)"
' %equation_spec_rhs = "c ma(1) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(9) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(9) ma(1) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(9) ma(1) ma(2) ma(3) sar(12) sma(12)"
%equation_spec_rhs = "c ar(1) ar(2) ar(9) ma(1) ma(2) ma(3) sar(12) sma(12)"
%equation_spec_lhs = %series_code_trans

include f_SARMA


