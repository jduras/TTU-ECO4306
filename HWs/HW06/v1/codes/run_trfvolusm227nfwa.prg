
' import data on  Vehicle Miles Traveled (TRFVOLUSM227NFWA)	 obtained from FRED; source: https://fred.stlouisfed.org/series/trfvolusm227nfwa
import "../data/TRFVOLUSM227NFWA.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series dtrfvolusm227nfwa = trfvolusm227nfwa - trfvolusm227nfwa(-1)
series gtrfvolusm227nfwa = 100* (trfvolusm227nfwa - trfvolusm227nfwa(-1))/trfvolusm227nfwa(-1)

%series_code = "trfvolusm227nfwa"
%series_code_trans = "gtrfvolusm227nfwa"
%series_code_fcst = "gtrfvolusm227nfwa"

%series_title = "Vehicle Miles Traveled"
%series_title_trans = "Percentage Chaneg in Vehicle Miles Traveled"
%series_title_fcst = "Percentage Chaneg in Vehicle Miles Traveled"

%sample_estimation = "1970m1 2006m12"
%sample_prediction = "2007m1 2019m2"
%sample_prediction_plot = "2005m1 2019m2"

%equation_spec_rhs = "c ar(1) ar(4) ar(6) ma(1) sar(12) sma(12)"
%equation_spec_lhs = "gtrfvolusm227nfwa"

' %in_diff = "true"

include f_SARMA


