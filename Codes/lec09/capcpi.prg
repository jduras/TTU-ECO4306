' create workfile

cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\Codes\lec09\"

' import data - source: https://alfred.stlouisfed.org/graph/?g=n8A1
import(link) "CAPCPI.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 namepos=all names=(,CAPCPI) eoltype=pad badfield=NA @id @date(date) @smpl @all

series dlIncome_CA = 100*dlog(CAPCPI)
series grIncome_CA = 100*d(CAPCPI)/CAPCPI(-1)

' generate time series with mean of IncomeGrowth_CA
genr grIncome_CA_mean = @mean(grIncome_CA)

' time series plots
graph fig7_7a.line grIncome_CA grIncome_CA_mean
fig7_7a.setelem(1) legend(Per Capita Personal Income Growth in CA)
fig7_7a.setelem(2) legend(Per Capita Personal Income Growth in CA - average)
fig7_7a.options linepat

' ACF and PACF
freeze(fig7_5b) grIncome_CA.correl

' estimate an AR(1) model
smpl 1969 2002
equation eq_ar1.ls grIncome_CA c AR(1)

range 1969 2020

' sample mean
smpl 1969 2002
genr grIncome_CA_avg = @mean(grIncome_CA)
smpl 1970 2020
grIncome_CA_avg = grIncome_CA_avg(-1)

' forecast
smpl 2003 2020
eq_ar1.forecast(f=na, e, g) grincome_ca_f @se grincome_ca_f_se
genr grIncome_CA_f_lb = grIncome_CA_f - 1.96*grIncome_CA_f_se
genr grIncome_CA_f_ub = grIncome_CA_f + 1.96*grIncome_CA_f_se

smpl 1980 2020
graph gph_fcst grIncome_CA grIncome_CA_avg grIncome_CA_f grIncome_CA_f_lb grIncome_CA_f_ub
gph_fcst.setelem(1) symbol(CIRCLE) legend("Per Capita Personal Income Growth in CA")
gph_fcst.setelem(2) linecolor(@rgb(128,128,128)) legend("Per Capita Personal Income Growth in CA - average")
gph_fcst.setelem(3) linecolor(@rgb(255,0,0)) symbol(CIRCLE) legend("Multistep Forecast")
gph_fcst.setelem(4) linecolor(@rgb(255,128,0)) legend("95% confidence interval")
gph_fcst.setelem(5) linecolor(@rgb(255,128,0)) legend("")
gph_fcst.datelabel format("YYYY")

' save workfile
wfsave "CAPCPI.wf1"


