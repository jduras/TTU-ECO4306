%hwpath = "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\HWs\HW06\v1\"

%codepath = %hwpath + "codes"
%figpath = %hwpath + "figures"

cd %codepath

' import data on Unemployment Rate in Lubbock County, TX (TXLUBB3URN) obtained from FRED; source: https://fred.stlouisfed.org/series/txlubb3urn
import "txlubb3urn.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

series dtxlubb3urn = txlubb3urn - txlubb3urn(-1)

' time series plot - txlubb3urn, whole sample
freeze(gph_txlubb3urn_ts_whole) txlubb3urn.line
gph_txlubb3urn_ts_whole.recshade
gph_txlubb3urn_ts_whole.options size(9,3)
gph_txlubb3urn_ts_whole.datelabel format("YYYY")
gph_txlubb3urn_ts_whole.axis(l) format(suffix="%")
gph_txlubb3urn_ts_whole.addtext(ac) ""
gph_txlubb3urn_ts_whole.addtext(al)  "Unemployment Rate in Lubbock County, in %"

' time series plot - dtxlubb3urn, whole sample
freeze(gph_dtxlubb3urn_ts_whole) dtxlubb3urn.line
gph_dtxlubb3urn_ts_whole.recshade
gph_dtxlubb3urn_ts_whole.options size(9,3)
gph_dtxlubb3urn_ts_whole.datelabel format("YYYY")
gph_dtxlubb3urn_ts_whole.axis(l) format(suffix="%")
gph_dtxlubb3urn_ts_whole.addtext(ac) ""
gph_dtxlubb3urn_ts_whole.addtext(al, font(Calibri,16,-b,-i,-u,-s))  "Change in Unemployment Rate in Lubbock County, in %"

' estimation sample
smpl 1990m1 2013m12

' time series plot - dtxlubb3urn
freeze(gph_dtxlubb3urn_ts) dtxlubb3urn.line
gph_dtxlubb3urn_ts.recshade
gph_dtxlubb3urn_ts.options size(9,3)
gph_dtxlubb3urn_ts.datelabel format("YYYY")
gph_dtxlubb3urn_ts.axis(l) format(suffix="%")
gph_dtxlubb3urn_ts.addtext(ac) ""
gph_dtxlubb3urn_ts.addtext(al, font(Calibri,16,-b,-i,-u,-s))  "Change in Unemployment Rate in Lubbock County, in %"

' correlogram - dtxlubb3urn
freeze(gph_dtxlubb3urn_corr) dtxlubb3urn.correl(48)

' estimate seasonal AR models
equation eq0.ls d(txlubb3urn) c ar(1) sar(12)
freeze(tbl_eq0) eq0

' equation eq1.ls d(txlubb3urn) c sar(12) sar(24)
' equation eq1.ls d(txlubb3urn) c ar(1) sar(12) sar(24)
equation eq1.ls d(txlubb3urn) c ar(1) sar(12) sma(12)
freeze(tbl_eq1) eq1

' auto ARIMA based on AIC and SIC
' txlubb3urn.autoarma(tform=none, diff=1, maxar=12, maxma=12, maxsar=1, maxsma=1, select=aic, agraph, atable, etable, fgraph, eqname=eq2_auto_aic) txlubb3urn_f_auto_aic c
' txlubb3urn.autoarma(tform=none, diff=1, maxar=12, maxma=12, maxsar=1, maxsma=1, select=sic, agraph, atable, etable, fgraph, eqname=eq2_auto_sic) txlubb3urn_f_auto_sic c

	 
' time series plot - residuals
freeze(gph_eq0_resid_ts) eq0.resid  
gph_eq0_resid_ts.recshade
' gph_eq0_resid_ts.options size(7.5,3)
gph_eq0_resid_ts.legend position(0,-0.35)
gph_eq0_resid_ts.legend -inbox
gph_eq0_resid_ts.addtext(al, font(Calibri,16,-b,-i,-u,-s))  "Actual vs Fitted Values, Seasonal ARMA model"
gph_eq0_resid_ts.axis(l) format(suffix="%")
gph_eq0_resid_ts.axis(r) format(suffix="%")

freeze(gph_eq1_resid_ts) eq1.resid  
gph_eq1_resid_ts.recshade
' gph_eq1_resid_ts.options size(9,3)
gph_eq1_resid_ts.options size(7.5,3)
gph_eq1_resid_ts.legend position(0,-0.35)
gph_eq1_resid_ts.legend -inbox
gph_eq1_resid_ts.addtext(al, font(Calibri,16,-b,-i,-u,-s))  "Actual vs Fitted Values, Seasonal ARMA model"
gph_eq1_resid_ts.axis(l) format(suffix="%")
gph_eq1_resid_ts.axis(r) format(suffix="%")

' correlogram - residuals
freeze(gph_eq0_resid_corr) eq0.correl(48)
freeze(gph_eq1_resid_corr) eq1.correl(48)

' fixed scheme forecast
smpl 2014m1 2019m2
freeze(tbl_eq1_f_fixed) eq1.fit(f=na, e, g) txlubb3urn_f @se txlubb3urn_f_se

' lower and upper bounds of 95% confidence intervals
genr txlubb3urn_f_lb = txlubb3urn_f - 1.96* txlubb3urn_f_se
genr txlubb3urn_f_ub = txlubb3urn_f + 1.96* txlubb3urn_f_se

' plot forecast based on the estimated seasonal AR model
smpl 2011m1 2019m2

graph gph_eq1_f.line txlubb3urn txlubb3urn_f txlubb3urn_f_lb txlubb3urn_f_ub

gph_eq1_f.setelem(1) linepattern(SOLID) linecolor(@rgb(55,105,175)) linewidth(1) legend("Actual")
gph_eq1_f.setelem(2) linepattern(SOLID) linecolor(@rgb(255,0,0)) linewidth(1) legend("Forecast")
gph_eq1_f.setelem(3) linepattern(DASH1) linecolor(@rgb(255,150,150)) linewidth(1) legend("95% confidence interval")
gph_eq1_f.setelem(4) linepattern(DASH1) linecolor(@rgb(255,150,150)) linewidth(1) legend("")
gph_eq1_f.datelabel format("YYYY")
gph_eq1_f.options linepat
gph_eq1_f.options size(9,3)
gph_eq1_f.axis(l) format(suffix="%")
gph_eq1_f.legend columns(3)
gph_eq1_f.legend position(0,-0.1)
gph_eq1_f.legend -inbox
gph_eq1_f.axis(l) range(2,7.75)
gph_eq1_f.addtext(al, font(Calibri,16,-b,-i,-u,-s))  "Forecast using Seasonal ARMA model"

show gph_eq1_f


' naive forecast
smpl 2014m1 2019m2
series dtxlubb3urn_f_naive = dtxlubb3urn(-12)
series txlubb3urn_f_naive = txlubb3urn(-1) + dtxlubb3urn_f_naive

' calculate forecast errors
smpl 2014m1 2019m2

series txlubb3urn_e = txlubb3urn - txlubb3urn_f
series txlubb3urn_e_naive = txlubb3urn - txlubb3urn_f_naive

' plot forecast errors
graph gph_eq1_e.line txlubb3urn_e txlubb3urn_e_naive

gph_eq1_e.axis(l) range(-0.7,0.7)
gph_eq1_e.options linepat
gph_eq1_e.options size(9,3)
gph_eq1_e.setelem(1) linepattern(DASH1) linecolor(@rgb(255,0,0)) linewidth(1) legend("Forecast using Seasonal ARMA model")
gph_eq1_e.setelem(2) linepattern(SOLID) linecolor(@rgb(40,40,40)) linewidth(1) legend("Naive Forecast")
gph_eq1_e.datelabel format("YYYY")
gph_eq1_e.axis(l) format(suffix="%")
gph_eq1_e.legend position(0,-0.35)
gph_eq1_e.legend -inbox
gph_eq1_e.addtext(al, font(Calibri,16,-b,-i,-u,-s))  "Forecast error, Seasonal ARMA model vs Naive Forecast"

show gph_eq1_e

' equal predictive ability test
series L_ar = txlubb3urn_e^2
series L_naive = txlubb3urn_e_naive^2
series dL_naive = L_ar - L_naive 

equation eq1_dL.ls dL_naive c 
freeze(tbl_eq1_dL) eq1_dL


' save figures
cd %figpath

gph_txlubb3urn_ts_whole.save(t=png) hw07q01_fig00_txlubb3urn_ts_whole
gph_dtxlubb3urn_ts_whole.save(t=png) hw07q01_fig01_txlubb3urn_ts_whole

gph_dtxlubb3urn_ts.save(t=png) hw07q01_fig01_txlubb3urn_ts
gph_dtxlubb3urn_corr.save(t=png) hw07q01_fig02_txlubb3urn_corr

tbl_eq0.save(t=png) hw07q01_fig03_txlubb3urn_eq0
gph_eq0_resid_ts.save(t=png) hw07q01_fig04_txlubb3urn_eq0_resid_ts
gph_eq0_resid_corr.save(t=png) hw07q01_fig05_txlubb3urn_eq0_resid_corr

tbl_eq1.save(t=png) hw07q01_fig03_txlubb3urn_eq1
gph_eq1_resid_ts.save(t=png) hw07q01_fig04_txlubb3urn_eq1_resid_ts
gph_eq1_resid_corr.save(t=png) hw07q01_fig05_txlubb3urn_eq1_resid_corr

gph_eq1_f.save(t=png) hw07q01_fig06_txlubb3urn_eq1_f
gph_eq1_e.save(t=png) hw07q01_fig07_txlubb3urn_eq1_e

tbl_eq1_dL.save(t=png) hw07q01_fig08_txlubb3urn_eq1_dL


