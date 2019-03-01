cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\codes\lec11\"

import "Figure07_17_clothingsales.xls" range=figure7_17 colhead=1 na="#N/A" @id @date(obs) 

' time series plot - clothing sales time series
freeze(gph_sales_ts) sales.line

' correlogram - clothing sales time series
freeze(gph_sales_corr) sales.correl(48)

' estimate seasonal AR models
smpl 2003m1 2007m12

equation eq0_ar12.ls(optmethod=opg) sales c ar(12)
equation eq1_sar12.ls(optmethod=opg) sales c sar(12)
equation eq2_ar1ar12.ls(optmethod=opg) sales c ar(1) ar(12)
equation eq3_ar1sar12.ls(optmethod=opg) sales c ar(1) sar(12)
equation eq4_ar3sar12.ls(optmethod=opg) sales c ar(1) ar(3) sar(12)

' time series plot  - residuals of the estimated models
freeze(gph_eq1_resid) eq1_sar12.resids(g)
freeze(gph_eq2_resid) eq2_ar1ar12.resids(g)
freeze(gph_eq3_resid) eq3_ar1sar12.resids(g)
freeze(gph_eq4_resid) eq4_ar3sar12.resids(g)

' correlogram - residuals of the estimated models
freeze(gph_eq1_corr) eq1_sar12.correl(g)
freeze(gph_eq2_corr) eq2_ar1ar12.correl(g)
freeze(gph_eq3_corr) eq3_ar1sar12.correl(g)
freeze(gph_eq4_corr) eq4_ar3sar12.correl(g)


' change range and sample for forecast
range 2003m1 2012m01
smpl 2008m01 2012m01

' create forecasts
freeze(tbl_eq1_f) eq1_sar12.forecast(f=na, e, g) sales_eq1_f @se sales_eq1_f_se
freeze(tbl_eq3_f) eq3_ar1sar12.forecast(f=na, e, g) sales_eq3_f @se sales_eq3_f_se
freeze(tbl_eq4_f) eq4_ar3sar12.forecast(f=na, e, g) sales_eq4_f @se sales_eq4_f_se

' lower and upper bounds for forecasts
series sales_eq1_f_lb = sales_eq1_f - 1.96*sales_eq1_f_se
series sales_eq1_f_ub = sales_eq1_f + 1.96*sales_eq1_f_se

series sales_eq3_f_lb = sales_eq3_f - 1.96*sales_eq3_f_se
series sales_eq3_f_ub = sales_eq3_f + 1.96*sales_eq3_f_se

series sales_eq4_f_lb = sales_eq4_f - 1.96*sales_eq4_f_se
series sales_eq4_f_ub = sales_eq4_f + 1.96*sales_eq4_f_se

' plot forecasts
smpl 2003m01 2012m01
graph gph_eq1_f sales sales_eq1_f sales_eq1_f_lb sales_eq1_f_ub
graph gph_eq3_f sales sales_eq3_f sales_eq3_f_lb sales_eq3_f_ub
graph gph_eq4_f sales sales_eq4_f sales_eq4_f_lb sales_eq4_f_ub


' format forecast plot - SAR(12)
gph_eq1_f.options linepat
gph_eq1_f.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_eq1_f.setelem(2) linecolor(@rgb(255,0,0)) linepattern(SOLID) legend("Multistep Forecast")
gph_eq1_f.setelem(3) linecolor(@rgb(255,128,0)) linepattern(DASH1) legend("95% confidence interval")
gph_eq1_f.setelem(4) linecolor(@rgb(255,128,0)) linepattern(DASH1) legend("")

' format forecast plot - AR(1)-SAR(12)
gph_eq3_f.options linepat
gph_eq3_f.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_eq3_f.setelem(2) linecolor(@rgb(255,0,0)) linepattern(SOLID) legend("Multistep Forecast")
gph_eq3_f.setelem(3) linecolor(@rgb(255,128,0)) linepattern(DASH1) legend("95% confidence interval")
gph_eq3_f.setelem(4) linecolor(@rgb(255,128,0)) linepattern(DASH1) legend("")

' format forecast plot - AR(3)-SAR(12)
gph_eq4_f.options linepat
gph_eq4_f.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_eq4_f.setelem(2) linecolor(@rgb(255,0,0)) linepattern(SOLID) legend("Multistep Forecast")
gph_eq4_f.setelem(3) linecolor(@rgb(255,128,0)) linepattern(DASH1) legend("95% confidence interval")
gph_eq4_f.setelem(4) linecolor(@rgb(255,128,0)) linepattern(DASH1) legend("")

show gph_eq1_f
show gph_eq3_f
show gph_eq4_f



 wfsave "fig07_17.wf1"


