' create workfile
wfcreate Q 1975:1 2020:4

cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\Codes\lec10\"

' import data, source: https://fred.stlouisfed.org/series/ATNHPIUS41740Q
import(link) "ATNHPIUS41740Q.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 namepos=all names=(,sdi) eoltype=pad badfield=NA @freq Q @id @date(date) @smpl @all

genr sdg = 100* d(sdi) / sdi(-1)

' plot time series
graph gph_sdg_ts.line(m) sdi sdg
' graph1.setupdate(auto)
gph_sdg_ts.align(2,0.75,0.75)
gph_sdg_ts.axis(l) zeroline

' plot time histogram
freeze(mode=overwrite, gph_sdg_hist) sdg.hist

smpl 1975Q1 2008Q4

' plot ACF and PACF
freeze(mode=overwrite, gph_sdg_correl) sdg.correl

show gph_sdg_ts
show gph_sdg_hist
show gph_sdg_correl

' estimate models
equation eq_ma4.ls(optmethod=opg) sdg c ma(1) ma(2) ma(3) ma(4)
equation eq_ar2.ls(optmethod=opg) sdg c ar(1) ar(2)
equation eq_ar3.ls(optmethod=opg) sdg c ar(1) ar(2) ar(3)
equation eq_ar4.ls(optmethod=opg) sdg c ar(1) ar(2) ar(3) ar(4)
equation eq_ar5.ls(optmethod=opg) sdg c ar(1) ar(2) ar(3) ar(4) ar(5)
equation eq_arma22.ls(optmethod=opg) sdg c ar(1) ar(2) ma(1) ma(2)
equation eq_arma24.ls(optmethod=opg) sdg c ar(1) ar(2) ma(1) ma(2) ma(3) ma(4)

' plot ACF and PACF for residuals
freeze(gph_eq_ar4_correl) eq_ar4.correl(12) 
freeze(gph_eq_ma4_correl) eq_ma4.correl(12) 
freeze(gph_eq_arma24_correl) eq_arma24.correl(12) 

' forecast using AR(4)
smpl 2008q4 2018q4
eq_ar4.forecast(f=na, e, g) sdg_f_ar4 @se sdg_f_ar4_se
series sdg_f_ar4_lb = sdg_f_ar4 - 1.96*sdg_f_ar4_se
series sdg_f_ar4_ub = sdg_f_ar4 + 1.96*sdg_f_ar4_se

' linex forecast with a = -1/2
series sdg_f_ar4_linex = sdg_f_ar4 - 1/4*sdg_f_ar4_se^2

' random walk and moving average forecasts
series sdg_f_rw
series sdg_f_ma
smpl 2008q4 2018q4
sdg_f_rw = sdg(-1)
sdg_f_ma = 1/4*( sdg(-1)+sdg(-2)+sdg(-3)+sdg(-4) )



' plot forecast based on symmetric quadratic loss function 
smpl 1975q1 2020q4
graph gph_sdg_fcst sdg sdg_f_ar4 sdg_f_ar4_lb sdg_f_ar4_ub

gph_sdg_fcst.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_sdg_fcst.setelem(2) linecolor(@rgb(0,0,255)) legend("Multistep Forecast - Quadratic Loss Function")
gph_sdg_fcst.setelem(3) linecolor(@rgb(255,0,0)) legend("95% confidence interval")
gph_sdg_fcst.setelem(4) linecolor(@rgb(255,0,0)) legend("")

' plot forecasts based on symmetric quadratic loss function and asymmetric linex function
smpl 1975q1 2020q4
graph gph_sdg_fcst_linex sdg sdg_f_ar4 sdg_f_ar4_lb sdg_f_ar4_ub sdg_f_ar4_linex

gph_sdg_fcst_linex.options linepat
gph_sdg_fcst_linex.setelem(1) linepattern(SOLID) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_sdg_fcst_linex.setelem(2) linepattern(SOLID) linecolor(@rgb(0,0,255)) legend("Multistep Forecast - Symmetric Quadratic Loss Function")
gph_sdg_fcst_linex.setelem(3) linepattern(DASH1) linecolor(@rgb(0,0,255)) legend("95% confidence interval")
gph_sdg_fcst_linex.setelem(4) linepattern(DASH1) linecolor(@rgb(0,0,255)) legend("")
gph_sdg_fcst_linex.setelem(5) linepattern(SOLID) linecolor(@rgb(255,0,0)) legend("Forecast - Asymmetric Linex Loss Function, a=-0.5")

show gph_sdg_fcst
show gph_sdg_fcst_linex



' save workfile
save "ATNHPIUS41740Q.wf1"


