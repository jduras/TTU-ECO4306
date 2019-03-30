
' import data on Unemployment Rate in Lubbock County, TX (TXLUBB3URN) obtained from FRED; source: https://fred.stlouisfed.org/series/txlubb3urn
import "../data/txlubb3urn.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series dtxlubb3urn = txlubb3urn - txlubb3urn(-1)

%series_code = "txlubb3urn"
%series_code_trans = "dtxlubb3urn"
%series_code_fcst = "txlubb3urn"

%series_title = "Unemployment Rate in Lubbock County, in %"
%series_title_trans = "Change in Unemployment Rate in Lubbock County, in %"
%series_title_fcst = "Unemployment Rate in Lubbock County, in %"

%sample_estimation = "1990m1 2013m12"
%sample_prediction = "2014m1 2019m2"
%sample_prediction_plot = "2011m1 2019m2"

%equation_spec_rhs = "c ar(1) sar(12) sma(12)"
%equation_spec_lhs = "d(txlubb3urn)"

%in_diff = "true"

include f_SARMA

' auto ARIMA based on AIC and SIC
' txlubb3urn.autoarma(tform=none, diff=1, maxar=12, maxma=12, maxsar=1, maxsma=1, select=aic, agraph, atable, etable, fgraph, eqname=eq2_auto_aic) txlubb3urn_f_auto_aic c
' txlubb3urn.autoarma(tform=none, diff=1, maxar=12, maxma=12, maxsar=1, maxsma=1, select=sic, agraph, atable, etable, fgraph, eqname=eq2_auto_sic) txlubb3urn_f_auto_sic c


