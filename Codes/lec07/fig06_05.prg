' create monthly workfile
wfcreate m 1953m5 2008m4

cd "D:\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\codes\lec07\"

' import data
import(link) "Figure06_05_Table6_1_treasury.xls" range=figure6_5 colhead=1 na="#N/A" @id @date(obs) @smpl @all

' generate time series with mean of returns for treasury yield
genr dy_mean = @mean(dy)

' time series plots
graph fig6_5a.line dy  dy_mean
fig6_5a.setelem(1) legend("Percentage Change in 5-Year Constant Maturity Yield Treasury")
fig6_5a.setelem(2) legend("Percentage Change in 5-Year Constant Maturity Yield Treasury - Mean")
fig6_5a.options linepat

' ACF and PACF
freeze(fig6_5b) dy.correl(12)

' estimate MA(1) model
smpl 1953M5 2007M11
equation eq_ma1.ls(optmethod=opg) dy c ma(1)

' forecast
smpl 2007m12 2008m4
eq_ma1.forecast(f=na, e, g) dyf @se dyf_se
series dyf_lb = dyf - 1.96*dyf_se
series dyf_ub = dyf + 1.96*dyf_se

' plot forecast
smpl 2007m01 2008m4
graph fig6_6.line dy dyf dyf_lb dyf_ub
fig6_6.setelem(1) symbol(CIRCLE) linecolor(@rgb(0,0,0)) legend("Actual Data")
fig6_6.setelem(2) symbol(CIRCLE) linecolor(@rgb(0,0,255)) legend("Multistep Forecast")
fig6_6.setelem(3) symbol(CIRCLE) linecolor(@rgb(255,0,0)) legend("Lower bound, 95% confidence interval")
fig6_6.setelem(4) symbol(CIRCLE) linecolor(@rgb(255,0,0)) legend("Upper bound, 95% confidence interval")
fig6_6.draw(shade, bottom, color(220,220,220)) 2007:12 2008:4
fig6_6.axis -duallevel
fig6_6.datelabel format("YYYY:MM")
fig6_6.options backcolor(@rgb(255,255,255))

' save workfile
wfsave "fig06_05.wf1"


