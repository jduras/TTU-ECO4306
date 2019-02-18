' create workfile
wfcreate a 1969 2002

' import data from xls file
import(link) "D:\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\Sources\Books\rivera\xls\Figure07_07_CAincome.xls" range=figure7_7 colhead=1 na="#N/A" names=(, grIncome_CA) @id @date(obs) @destid @date @smpl @all

' generate time series with mean of IncomeGrowth_CA
genr grIncome_CA_mean = @mean(grIncome_CA)

' time series plots
graph fig7_7a.line grIncome_CA grIncome_CA_mean
fig7_7a.setelem(1) legend(Per Capita Personal Income Growth in CA)
fig7_7a.setelem(2) legend(Per Capita Personal Income Growth in CA - mean value)
fig7_7a.options linepat

' ACF and PACF
freeze(fig7_5b) grIncome_CA.correl

' estimate an AR(1) model
smpl 1969 2002
equation eq_ar1.ls grIncome_CA c grIncome_CA(-1)

range 1969 2010
smpl 2003 2010
eq_ar1.forecast(f=na, e, g) grincome_ca_f @se grincome_ca_f_se
genr grIncome_CA_f_lb = grIncome_CA_f - 1.96*grIncome_CA_f_se
genr grIncome_CA_f_ub = grIncome_CA_f + 1.96*grIncome_CA_f_se

smpl 1980 2010
graph gph_fcst grIncome_CA grIncome_CA_f grIncome_CA_f_lb grIncome_CA_f_ub
gph_fcst.setelem(1) symbol(CIRCLE) legend("Actual Data - Per Capita Personal Income Growth in CA")
gph_fcst.setelem(2) symbol(CIRCLE) legend("Multistep Forecast")
gph_fcst.setelem(3) linecolor(@rgb(0,128,0)) legend("Lower bound, 95% confidence interval")
gph_fcst.setelem(4) linecolor(@rgb(0,128,0)) legend("Upper bound, 95% confidence interval")
gph_fcst.datelabel format("YYYY")

' save workfile
wfsave "D:\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\Sources\Books\rivera\codes\fig07_07.wf1"


