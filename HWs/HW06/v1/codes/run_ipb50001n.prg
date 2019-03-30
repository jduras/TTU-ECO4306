
' import data on Industrial Production: Total index (IPB50001N) obtained from FRED; source: https://fred.stlouisfed.org/series/ipb50001n
import "../data/ipb50001n.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series gipb50001n = 100* d(ipb50001n) / ipb50001n(-1)

%series_code = "ipb50001n"
%series_code_trans = "gipb50001n"
%series_code_fcst = "gipb50001n"

%series_title = "Industrial Production, Index 2012 = 100"
%series_title_trans = "Percentage Change in Industrial Production"
%series_title_fcst = "Percentage Change in Industrial Production"

%sample_estimation = "1970m1 2006m12"
%sample_prediction = "2007m1 2019m2"
%sample_prediction_plot = "2005m1 2019m2"

' %equation_spec_rhs = "c ar(1) sar(12)"
%equation_spec_rhs = "c ar(1) ar(2) ar(3) sar(12) sma(12)"
%equation_spec_lhs = %series_code_trans

include f_SARMA


