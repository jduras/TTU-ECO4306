
' import data on Advance Retail Sales: Retail (Excluding Food Services) (RSXFSN) obtained from FRED; source: https://fred.stlouisfed.org/series/rsxfsn
import "../data/rsxfsn.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series grsxfsn = 100* d(rsxfsn) / rsxfsn(-1)

%series_code = "rsxfsn"
%series_code_trans = "grsxfsn"
%series_code_fcst = "grsxfsn"

%series_title = "Retail Sales Excluding Food Services, in Millions of Dollars"
%series_title_trans = "Percentage Change in Retail Sales Excluding Food Services"
%series_title_fcst = "Percentage Change in Retail Sales Excluding Food Services"

%sample_estimation = "1992m1 2006m12"
%sample_prediction = "2007m1 2019m2"
%sample_prediction_plot = "2005m1 2019m2"

' %equation_spec_rhs = c ar(1) ar(2) sar(12) 
' %equation_spec_rhs = c ar(1) ar(2) sar(12) sma(12)
' %equation_spec_rhs = c ar(1) ma(1) sar(12) sma(12)
' %equation_spec_rhs = c ar(1) ar(2) ma(1) sar(12) sma(12)
' %equation_spec_rhs = c ar(1) ar(2) ar(9) ma(1) sar(12) sma(12)
%equation_spec_rhs = "c ar(1) ar(3) ar(9) ma(2) sar(12) sma(12) sma(24)"
%equation_spec_lhs = %series_code_trans

include f_SARMA


