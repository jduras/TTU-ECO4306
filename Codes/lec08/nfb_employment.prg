cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\Codes\lec08"

' import data for  Nonfarm Business Sector: Employment (PRS85006013) from https://fred.stlouisfed.org/series/PRS85006013
import(link) "PRS85006013.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 namepos=all names=(,emp) eoltype=pad badfield=NA @freq Q @id @date(date) @smpl @all

' create time series for growth of employment and the mean growth of employment
genr gemp = 100*(emp/emp(-1)-1)
genr gemp_mean = @mean(gemp)

' time series plot, histogram and correlogram
graph gph_gemp_ts gemp gemp_mean
freeze(gph_gemp_hist) gemp.hist
freeze(tbl_gemp_corr) gemp.correl(24)

' estimate MA(3) model
smpl 1947Q2 2014Q4
equation eq_gemp.ls(optmethod=opg) gemp c ma(1) ma(2) ma(3)

' 1 to 8 step ahead forecasts
smpl 2015Q1 2018Q4
eq_gemp.forecast(f=na, e, g) gempf @se gempf_se

' construct 95% condidence interval
genr gempf_lb = gempf - 1.96*gempf_se
genr gempf_ub = gempf + 1.96*gempf_se

' import data on U.S. recessions
import(link) "USREC.xls" range="FRED" colhead=2 namepos=all na="#N/A" names=(date2, ) @freq Q @id @date(date2) @destid @date @smpl @all

smpl 1947Q2 2018Q4
group grp_gemp_fcst gemp gempf gempf_lb gempf_ub usrec

smpl 2006Q1 2018Q4
freeze(gph_gemp_fcst) grp_gemp_fcst.mixed line(1,2,3,4) bar(5)

gph_gemp_fcst.setelem(1) symbol(CIRCLE) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_gemp_fcst.setelem(2) symbol(CIRCLE) linecolor(@rgb(0,0,255)) legend("Forecast")
gph_gemp_fcst.setelem(3) linecolor(@rgb(255,0,0)) legend("Lower bound, 95% confidence interval")
gph_gemp_fcst.setelem(4) linecolor(@rgb(255,0,0)) legend("Upper bound, 95% confidence interval")
gph_gemp_fcst.setelem(5) axis(r) legend("U.S. recessions")

gph_gemp_fcst.axis overlap
gph_gemp_fcst.axis(r) range(0,1) -label
gph_gemp_fcst.options -outlinebars -barspace
gph_gemp_fcst.setelem(1) fillcolor(@rgb(222,222,222))

wfsave "nfb_employment.wf1"


