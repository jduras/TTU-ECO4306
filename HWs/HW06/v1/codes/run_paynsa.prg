
' import data on All Employees: Total Nonfarm Payrolls (PAYNSA) obtained from FRED; source: https://fred.stlouisfed.org/series/PAYNSA
import "../data/paynsa.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series dpaynsa = paynsa - paynsa(-1)
series gpaynsa = 100* (paynsa - paynsa(-1))/paynsa(-1)

%series_code = "paynsa"
%series_code_trans = "gpaynsa"
%series_code_fcst = "gpaynsa"

%series_title = "Nonfarm Payrolls, in Thousands of Persons"
%series_title_trans = "Percentage Change in Nonfarm Payrolls"
%series_title_fcst = "Percentage Change in Nonfarm Payrolls"

%sample_estimation = "1970m1 2006m12"
%sample_prediction = "2007m1 2019m2"
%sample_prediction_plot = "2005m1 2019m2"

' %equation_spec_rhs = "c sar(12)"
' %equation_spec_rhs = "c ar(1) ma(1) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(3) sar(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(3) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(3) ar(6) sar(12) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ar(3) sar(12) sar(24) sma(12)"
' %equation_spec_rhs = "c ar(1) ar(2) ma(1) sar(12) sar(24) sma(12)"
%equation_spec_rhs = "c ar(1) ar(6) ma(1) sar(12) sar(24) sma(12)"
%equation_spec_lhs = %series_code_trans

include f_SARMA


