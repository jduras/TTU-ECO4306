%hwpath = "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\HWs\HW04\"

%codepath = %hwpath + "codes"
%figpath = %hwpath + "figures"

' import data
cd %codepath
import(link) "TXPCPI.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 namepos=all names=(,gTXPCPI) eoltype=pad badfield=NA @id @date(date) @smpl @all

' time series plots and correlograms
smpl 1930 2015
graph gph_gtxpcpi_1930_2015_ts.line gtxpcpi
freeze(gph_gtxpcpi_1930_2015_corr) gtxpcpi.correl

smpl 1950 2015
graph gph_gtxpcpi_1950_2015_ts.line gtxpcpi
freeze(gph_gtxpcpi_1950_2015_corr) gtxpcpi.correl

smpl 1947 2010
graph gph_gtxpcpi_1947_2010_ts.line gtxpcpi
freeze(gph_gtxpcpi_1947_2010_corr) gtxpcpi.correl

' estimate AR model
smpl 1930 2010
equation eq_ar2_1930_2010.ls(optmethod=opg) gtxpcpi c ar(1) ar(2)

smpl 1947 2010
equation eq_ar1_1947_2010.ls(optmethod=opg) gtxpcpi c ar(1)
freeze(tbl_ar1_1947_2010_res) eq_ar1_1947_2010.results

smpl 1950 2010
equation eq_ar1_1950_2010.ls(optmethod=opg) gtxpcpi c ar(1)

' create forecast
smpl 2011 2017
eq_ar1_1947_2010.forecast(f=na, e, g) gtxpcpi_f @se gtxpcpi_f_se
series gtxpcpi_f_lb = gtxpcpi_f - 1.96*gtxpcpi_f_se
series gtxpcpi_f_ub = gtxpcpi_f + 1.96*gtxpcpi_f_se

' plot forecast
smpl 1947  2017
graph gph_gtxpcpi_f gtxpcpi gtxpcpi_f gtxpcpi_f_lb gtxpcpi_f_ub

gph_gtxpcpi_f.setelem(1) symbol(CIRCLE) linecolor(@rgb(0,0,0)) legend("Per Capita Personal Income in Texas, Percentage Change, Actual Data")
gph_gtxpcpi_f.setelem(2) symbol(CIRCLE) linecolor(@rgb(255,0,0)) legend("Multistep Forecast, AR(1) model")
gph_gtxpcpi_f.setelem(3) linepattern(DASH1) linecolor(@rgb(255,128,0)) legend("95% confidence interval")
gph_gtxpcpi_f.setelem(4) linepattern(DASH1) linecolor(@rgb(255,128,0)) legend("")
gph_gtxpcpi_f.datelabel format("YYYY")
gph_gtxpcpi_f.options linepat

' plot forecast error
series gtxpcpi_f_err = gtxpcpi - gtxpcpi_f

smpl 2011 2015
freeze(gph_gtxpcpi_f_err) gtxpcpi_f_err.line 
gph_gtxpcpi_f_err.axis(l) zeroline

' save figures
cd %figpath
gph_gtxpcpi_1947_2010_ts.save(t=png) hw04q01_fig01A_gtxpcpi_ts
gph_gtxpcpi_1947_2010_corr.save(t=png) hw04q01_fig01B_gtxpcpi_corr
tbl_ar1_1947_2010_res.save(t=png) hw04q01_fig02_gtxpcpi_ar1
gph_gtxpcpi_f.save(t=png) hw04q01_fig03_gtxpcpi_f

' save workfile
cd %codepath
wfsave "hw04q01.wf1"


