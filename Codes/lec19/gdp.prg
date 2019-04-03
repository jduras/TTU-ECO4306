
%codepath = "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\codes\lec19\"
%figpath = %codepath + "figures"

' import data -  Johnson & Johnson earnings per share
cd %codepath

import "GDPC1.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 namepos=all names=(,rGDP) eoltype=pad badfield=NA @id @date(date) @smpl @all

range 1947q1 2035q4

genr lrGDP = log(rGDP)
genr t = @trend

' compare the forecasts from deterministic and stochastic trend models
smpl 1947q1 2018q4
group grp_rgdp rGDP log(rGDP) d(rGDP) d(log(rGDP))
freeze(gph_rgdp) grp_rgdp.line(m)
gph_rgdp.datelabel format("YYYY:Q")


' Augmented Dickey Fuller test - levels
freeze(adf_lrGDP) lrGDP.uroot(exog=trend)

' Augmented Dickey Fuller test - first differences
freeze(adf_lrGDP_d) lrGDP.uroot(exog=trend,dif=1)


' estimate models

' smpl 1947q1 2005q4
' smpl 1950q1 2005q4
smpl 1950q1 2009q4
' smpl 1960q1 2005q4

' deterministic trend model
equation eq_det_01.ls log(rGDP) c @trend
equation eq_det_02.ls log(rGDP) c @trend ar(1)
equation eq_det_03.ls log(rGDP) c @trend ar(1) ar(2)

' predicted exponential trend from the deterministic trend model
smpl 1950q1 2035q4
genr rgdp_trend = exp(c(1) + c(2)*@trend)

' stochastic trend model
smpl 1950q1 2009q4

equation eq_sto_01.ls d(log(rGDP)) c
freeze(gph_eq_sto_01_resid) eq_sto_01.resids(g)
freeze(gph_eq_sto_01_resid_corr) eq_sto_01.correl(24)

equation eq_sto_02.ls d(log(rGDP)) c ar(1)
freeze(gph_eq_sto_02_resid) eq_sto_02.resids(g)
freeze(gph_eq_sto_02_resid_corr) eq_sto_02.correl(24)
freeze(gph_eq_sto_02_arma) eq_sto_02.arma

equation eq_sto_03.ls(optmethod=opg) d(log(rGDP)) c ar(1) ar(2)
freeze(gph_eq_sto_03_resid) eq_sto_03.resids(g)
freeze(gph_eq_sto_03_resid_corr) eq_sto_03.correl(24)
freeze(gph_eq_sto_03_arma) eq_sto_03.arma

equation eq_sto_04.ls(optmethod=opg) d(log(rGDP)) c ma(1) ma(2)
freeze(gph_eq_sto_04_resid) eq_sto_04.resids(g)
freeze(gph_eq_sto_04_resid_corr) eq_sto_04.correl(24)
freeze(gph_eq_sto_04_arma) eq_sto_04.arma


' multistep and fixed one step ahead forecasts
' smpl 2006q1 2017q4
smpl 2010q1 2035q4

eq_det_03.forecast(f=na, e, g) rGDP_f_det_multi @se rGDP_f_det_multi_se
eq_det_03.fit(f=na, e, g) rGDP_f_det_fixed @se rGDP_f_det_fixed_se

genr rGDP_f_det_multi_lb = rGDP_f_det_multi - 1.96*rGDP_f_det_multi_se
genr rGDP_f_det_multi_ub = rGDP_f_det_multi + 1.96*rGDP_f_det_multi_se
genr rGDP_f_det_fixed_lb = rGDP_f_det_fixed - 1.96*rGDP_f_det_fixed_se
genr rGDP_f_det_fixed_ub = rGDP_f_det_fixed + 1.96*rGDP_f_det_fixed_se

eq_sto_03.forecast(f=na, e, g) rGDP_f_sto_multi @se rGDP_f_sto_multi_se
eq_sto_03.fit(f=na, e, g) rGDP_f_sto_fixed @se rGDP_f_sto_fixed_se

genr rGDP_f_sto_multi_lb = rGDP_f_sto_multi - 1.96*rGDP_f_sto_multi_se
genr rGDP_f_sto_multi_ub = rGDP_f_sto_multi + 1.96*rGDP_f_sto_multi_se
genr rGDP_f_sto_fixed_lb = rGDP_f_sto_fixed - 1.96*rGDP_f_sto_fixed_se
genr rGDP_f_sto_fixed_ub = rGDP_f_sto_fixed + 1.96*rGDP_f_sto_fixed_se


' plot the forecasts
smpl 2000q1 2019q1

graph gph_f_sto.line rGDP_f_sto_multi rGDP_f_sto_multi_lb rGDP_f_sto_multi_ub rGDP_f_sto_fixed rGDP_f_sto_fixed_lb rGDP_f_sto_fixed_ub rGDP

gph_f_sto.setelem(1) linepattern(SOLID) linecolor(@rgb(0,0,255)) linewidth(1) legend("Stochastic trend model - Multistep Forecast")
gph_f_sto.setelem(2) linepattern(DASH1) linecolor(@rgb(0,0,255)) linewidth(1) legend("95% confidence interval") 
gph_f_sto.setelem(3) linepattern(DASH1) linecolor(@rgb(0,0,255)) linewidth(1) legend("")
gph_f_sto.setelem(4) linepattern(SOLID) linecolor(@rgb(255,0,0)) linewidth(1) legend("Stochastic trend model - Fixed Scheme One Step Ahead Forecast")
gph_f_sto.setelem(5) linepattern(DASH1) linecolor(@rgb(255,0,0)) linewidth(1) legend("95% confidence interval")
gph_f_sto.setelem(6) linepattern(DASH1) linecolor(@rgb(255,0,0)) linewidth(1) legend("")
gph_f_sto.setelem(7) linepattern(SOLID) linecolor(@rgb(0,0,0)) linewidth(1) legend("Actual real GDP")

gph_f_sto.options linepat
gph_f_sto.legend columns(2)

graph gph_f_det.line rGDP_f_det_multi rGDP_f_det_multi_lb rGDP_f_det_multi_ub rGDP_f_det_fixed rGDP_f_det_fixed_lb rGDP_f_det_fixed_ub rGDP

gph_f_det.setelem(1) linepattern(SOLID) linecolor(@rgb(0,0,255)) linewidth(1) legend("Deterministic trend model - Multistep Forecast")
gph_f_det.setelem(2) linepattern(DASH1) linecolor(@rgb(0,0,255)) linewidth(1) legend("95% confidence interval")
gph_f_det.setelem(3) linepattern(DASH1) linecolor(@rgb(0,0,255)) linewidth(1) legend("")
gph_f_det.setelem(4) linepattern(SOLID) linecolor(@rgb(255,0,0)) linewidth(1)  legend("Deterministic trend model - Fixed Scheme One Step Ahead Forecast")
gph_f_det.setelem(5) linepattern(DASH1) linecolor(@rgb(255,0,0)) linewidth(1) legend("95% confidence interval")
gph_f_det.setelem(6) linepattern(DASH1) linecolor(@rgb(255,0,0)) linewidth(1) legend("")
gph_f_det.setelem(7) linepattern(SOLID) linecolor(@rgb(0,0,0)) linewidth(1) legend("Actual real GDP")

gph_f_det.options linepat
gph_f_det.legend columns(2)

show gph_f_sto
show gph_f_det



' calculate predicted QoQ and YoY growth rates
genr g1_rgdp = 4*100* (rgdp/rgdp(-1) - 1)
genr g1_rGDP_f_det_fixed = 4*100* (rGDP_f_det_fixed/rGDP_f_det_fixed(-1) - 1)
genr g4_rgdp = 100* (rgdp/rgdp(-4) - 1)
genr g4_rGDP_f_det_fixed = 100* (rGDP_f_det_fixed/rGDP_f_det_fixed(-4) - 1)

genr g1_rGDP_e_det_fixed = g1_rgdp  - g1_rGDP_f_det_fixed
genr g4_rGDP_e_det_fixed = g4_rgdp  - g4_rGDP_f_det_fixed

group grp_g_rgdp g1_rgdp g1_rGDP_f_det_fixed g4_rgdp g4_rGDP_f_det_fixed
smpl 2009q1 2019q1
show grp_g_rgdp.line

group grp_g_rGDP_e_det_fixed g1_rGDP_e_det_fixed g4_rGDP_e_det_fixed
smpl 2009q1 2019q1
show grp_g_rGDP_e_det_fixed.line



' compare the forecasts from deterministic and stochastic trend models
smpl 1947q1 2035q4

group grp_rgdp_f rGDP rGDP_f_det_multi rGDP_f_sto_multi rGDP_trend
freeze(gph_f_comp) grp_rgdp_f.line

gph_f_comp.setelem(1) linepattern(SOLID) linecolor(@rgb(0,0,155)) linewidth(1) symbol(none) legend("U.S. Real GDP")
gph_f_comp.setelem(2) linepattern(SOLID) linecolor(@rgb(155,0,0)) linewidth(1) symbol(none) legend("Multistep Forecast - Deterministic Trend Model")
gph_f_comp.setelem(3) linepattern(SOLID) linecolor(@rgb(0,155,0)) linewidth(1) symbol(none) legend("Multistep Forecast - Stochastic Trend Model")
gph_f_comp.setelem(4) linepattern(DASH6) linecolor(@rgb(0,0,0)) linewidth(1) symbol(none) legend()
gph_f_comp.datelabel format("YYYY:Q")
gph_f_comp.options linepat
gph_f_comp.legend columns(1)

graph gph_f_comp_log.line log(rGDP) log(rGDP_f_det_multi) log(rGDP_f_sto_multi) log(rGDP_trend)
gph_f_comp_log.setelem(1) linepattern(SOLID) linecolor(@rgb(0,0,155)) linewidth(1) symbol(none) legend("Log of U.S. Real GDP")
gph_f_comp_log.setelem(2) linepattern(SOLID) linecolor(@rgb(155,0,0)) linewidth(1) symbol(none) legend("Log Multistep Forecast - Deterministic Trend Model")
gph_f_comp_log.setelem(3) linepattern(SOLID) linecolor(@rgb(0,155,0)) linewidth(1) symbol(none) legend("Log Multistep Forecast - Stochastic Trend Model")
gph_f_comp_log.setelem(4) linepattern(DASH6) linecolor(@rgb(0,0,0)) linewidth(1) symbol(none) legend()
gph_f_comp_log.datelabel format("YYYY:Q")
gph_f_comp_log.options linepat
gph_f_comp_log.legend columns(1)


' test of equal predictive power - deterministic vs stochastic trend models
genr rGDP_e_sto_fixed = rGDP - rGDP_f_sto_fixed
genr rGDP_e_det_fixed = rGDP - rGDP_f_det_fixed
genr rGDP_e_sto_fixed_sq = rGDP_e_sto_fixed^2
genr rGDP_e_det_fixed_sq = rGDP_e_det_fixed^2

smpl 2009q1 2019q4
graph gph_l.line rGDP_e_sto_fixed_sq rGDP_e_det_fixed_sq

genr dloss_trend = rGDP_e_det_fixed_sq - rGDP_e_sto_fixed_sq
equation eq_epa_trend.ls dloss_trend c 



'save figures
cd %figpath

' save time series plot for rGDP and its growth rates
gph_rgdp.save(t=png,w=15,h=7,u=in) lec19_rGDP

' save results from ADF test
adf_lrGDP.save(t=png) lec19_adf_lrgdp
adf_lrGDP_d.save(t=png) lec19_adf_lrgdp_d

' save results from OLS estimation
freeze(tbl_eq_sto_01) eq_sto_01
tbl_eq_sto_01.save(t=png) lec19_rgdp_eq_sto_01
gph_eq_sto_01_resid.save(t=png,w=15,h=7,u=in) lec19_rgdp_eq_sto_01_resid
gph_eq_sto_01_resid_corr.save(t=png) lec19_rgdp_eqsto_01_resid_corr

freeze(tbl_eq_sto_02) eq_sto_02
tbl_eq_sto_02.save(t=png) lec19_rgdp_eq_sto_02
gph_eq_sto_02_resid.save(t=png,w=15,h=7,u=in) lec19_rgdp_eq_sto_02_resid
gph_eq_sto_02_resid_corr.save(t=png) lec19_rgdp_eq_sto_02_resid_corr

gph_f_sto.save(t=png,w=15,h=7,u=in) lec19_rGDP_f_sto
gph_f_det.save(t=png,w=15,h=7,u=in) lec19_rGDP_f_det

gph_f_comp.save(t=png,w=15,h=7,u=in) lec19_rgdp_f_comp
gph_f_comp_log.save(t=png,w=15,h=7,u=in) lec19_rgdp_f_comp_log

freeze(tbl_eq_epa_trend) eq_epa_trend
tbl_eq_epa_trend.save(t=png) lec19_rgdp_eq_epa_trend


' save workfile
smpl @all
wfsave "gdp.wf1"


