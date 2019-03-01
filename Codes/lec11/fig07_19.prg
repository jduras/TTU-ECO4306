cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\codes\lec11\"

' import data on Monthly Changes in U.S. Residential Construction, January 2002-January 2011
import "Figure07_19_constructionchanges.xls" range=figure7_19 colhead=1 namepos=all na="#N/A" names=(, CONST) @id @date(obs) @smpl @all

range @first 2011m12

' time series plot and correlogram
graph gph_const_ts.line const
freeze(gph_const_corr) const.correl(48)

' freeze(gph_const) gph_const_ts gph_const_corr

' estimate seasonal AR model
smpl @first 2008m12
equation eq_add.ls(optmethod=opg) const  c ar(1) ar(12)
equation eq_mul.ls(optmethod=opg) const  c ar(1) sar(12)

' create multistep forecast
smpl 2006m01 @last
eq_add.forecast(f=na, e, g) const_fm_add @se const_f_add_se
eq_add.forecast(f=na, e, g) const_fm_add @se const_f_add_se
genr const_fm_add_lb = const_fm_add - 1.96*const_f_add_se
genr const_fm_add_ub = const_fm_add + 1.96*const_f_add_se

eq_mul.forecast(f=na, e, g) const_fm_mul @se const_f_mul_se
eq_mul.forecast(f=na, e, g) const_fm_mul @se const_f_mul_se
genr const_fm_mul_lb = const_fm_mul - 1.96*const_f_mul_se
genr const_fm_mul_ub = const_fm_mul + 1.96*const_f_mul_se

smpl @all

string lastm = "2006m12"

smpl {lastm}+1 @last

' create fixed scheme forecast
eq_add.fit(f=na, e, g) const_f1_add_fix @se const_f1_add_fix_se
eq_mul.fit(f=na, e, g) const_f1_mul_fix @se const_f1_mul_fix_se

series const_f1_add_fix_lb = const_f1_add_fix - 1.96*const_f1_add_fix_se
series const_f1_add_fix_ub = const_f1_add_fix + 1.96*const_f1_add_fix_se
series const_f1_mul_fix_lb = const_f1_mul_fix - 1.96*const_f1_mul_fix_se
series const_f1_mul_fix_ub = const_f1_mul_fix + 1.96*const_f1_mul_fix_se

' create rolling scheme forecast
series const_f1_add_roll_man
series const_f1_add_roll
series const_f1_add_roll_lb
series const_f1_add_roll_ub
series const_f1_mul_roll_man
series const_f1_mul_roll
series const_f1_mul_roll_lb
series const_f1_mul_roll_ub

for !i = 1 to 48
	' construct one step ahead forecast manually
	smpl @first+(!i)  {lastm}+(!i-1)
	equation eq_add_roll.ls const c ar(1) ar(12)
	const_f1_add_roll_man(@dtoo(lastm)  + !i) = (1-c(2)-c(3))*c(1) + c(2)*const(@dtoo(lastm)  + !i-1) + c(3)*const(@dtoo(lastm)  + !i-12)
	equation eq_mul_roll.ls const c ar(1) sar(12)
	const_f1_mul_roll_man(@dtoo(lastm)  + !i) = (1-c(2)-c(3)+c(2)*c(3))*c(1) + c(2)*const(@dtoo(lastm)  + !i-1) + c(3)*const(@dtoo(lastm)  + !i-12) - c(2)*c(3)*const(@dtoo(lastm)  + !i-13)

	' construct one step ahead forecast using built in forecast command
	smpl {lastm}+(!i) {lastm}+(!i)
	eq_add_roll.forecast(f=na, e, g) tmpf @se tmpf_se
	series const_f1_add_roll = tmpf
	series const_f1_add_roll_lb = tmpf - 1.96*tmpf_se
	series const_f1_add_roll_ub = tmpf + 1.96*tmpf_se
	eq_mul_roll.forecast(f=na, e, g) tmpf @se tmpf_se
	series const_f1_mul_roll = tmpf
	series const_f1_mul_roll_lb = tmpf - 1.96*tmpf_se
	series const_f1_mul_roll_ub = tmpf + 1.96*tmpf_se
next

smpl @all

' construct 1 step ahead forecast errors
genr const_e1_add = const - const_f1_add_roll
genr const_e1_mul = const - const_f1_mul_roll
graph gph_const_e1.line const_e1_add const_e1_mul
gph_const_e1.axis(l) zeroline

' plot forecasts
smpl 2005m1 @last
graph gph_const_f.line const const_fm_add const_fm_mul const_f1_add_roll const_f1_mul_roll
gph_const_f.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_const_f.setelem(2) linecolor(@rgb(0,0,255)) legend("Multistep Forecast - Additive Model")
gph_const_f.setelem(3) linecolor(@rgb(0,255,0)) legend("Multistep Forecast - Multiplicative Model")
gph_const_f.setelem(4) linecolor(@rgb(255,0,0)) legend("One Step Rolling Forecast - Additive Model")
gph_const_f.setelem(5) linecolor(@rgb(255,128,0)) legend("One Step Rolling Forecast - Multiplicative Model")

' plot forecasts
smpl 2005m1 @last
graph gph_const_f_add.line const const_f1_add_roll const_f1_add_roll_lb const_f1_add_roll_ub const_f1_add_fix const_f1_add_fix_lb const_f1_add_fix_ub
gph_const_f_add.options linepat
gph_const_f_add.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_const_f_add.setelem(2) linecolor(@rgb(0,0,255)) linepattern(SOLID) legend("One Step Rolling Forecast - Additive Model")
gph_const_f_add.setelem(3) linecolor(@rgb(0,0,255)) linepattern(DASH1) legend("One Step Rolling Forecast - Additive Model - 95% confidence interval")
gph_const_f_add.setelem(4) linecolor(@rgb(0,0,255)) linepattern(DASH1) legend("")
gph_const_f_add.setelem(5) linecolor(@rgb(255,0,0)) linepattern(SOLID) legend("One Step Fixed Forecast - Additive Model")
gph_const_f_add.setelem(6) linecolor(@rgb(255,0,0)) linepattern(DASH1) legend("One Step Fixed Forecast - Additive Model - 95% confidence interval")
gph_const_f_add.setelem(7) linecolor(@rgb(255,0,0)) linepattern(DASH1) legend("")

smpl 2005m1 @last
graph gph_const_f_add_rol.line const const_f1_add_roll const_f1_add_roll_lb const_f1_add_roll_ub
gph_const_f_add_rol.options linepat
gph_const_f_add_rol.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_const_f_add_rol.setelem(2) linecolor(@rgb(0,0,255)) linepattern(SOLID) legend("One Step Rolling Forecast - Additive Model")
gph_const_f_add_rol.setelem(3) linecolor(@rgb(0,0,255)) linepattern(DASH1) legend("One Step Rolling Forecast - Additive Model - 95% confidence interval")
gph_const_f_add_rol.setelem(4) linecolor(@rgb(0,0,255)) linepattern(DASH1) legend("")

smpl 2005m1 @last
graph gph_const_f1_add_fix.line const const_f1_add_fix const_f1_add_fix_lb const_f1_add_fix_ub
gph_const_f1_add_fix.options linepat
gph_const_f1_add_fix.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_const_f1_add_fix.setelem(2) linecolor(@rgb(255,0,0)) linepattern(SOLID) legend("One Step Fixed Forecast - Additive Model")
gph_const_f1_add_fix.setelem(3) linecolor(@rgb(255,0,0)) linepattern(DASH1) legend("One Step Fixed Forecast - Additive Model - 95% confidence interval")
gph_const_f1_add_fix.setelem(4) linecolor(@rgb(255,0,0)) linepattern(DASH1) legend("")

smpl 2005m1 @last
graph gph_const_f_mul.line const const_f1_mul_roll const_f1_mul_roll_lb const_f1_mul_roll_ub const_f1_mul_fix const_f1_mul_fix_lb const_f1_mul_fix_ub
gph_const_f_mul.options linepat
gph_const_f_mul.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_const_f_mul.setelem(2) linecolor(@rgb(0,0,255)) linepattern(SOLID) legend("One Step Rolling Forecast - Multiplicative Model")
gph_const_f_mul.setelem(3) linecolor(@rgb(0,0,255)) linepattern(DASH1) legend("One Step Rolling Forecast - Multiplicative Model - 95% confidence interval")
gph_const_f_mul.setelem(4) linecolor(@rgb(0,0,255)) linepattern(DASH1) legend("")
gph_const_f_mul.setelem(5) linecolor(@rgb(255,0,0)) linepattern(SOLID) legend("One Step Fixed Forecast - Multiplicative Model")
gph_const_f_mul.setelem(6) linecolor(@rgb(255,0,0)) linepattern(DASH1) legend("One Step Fixed Forecast - Multiplicative Model - 95% confidence interval")
gph_const_f_mul.setelem(7) linecolor(@rgb(255,0,0)) linepattern(DASH1) legend("")

smpl 2005m1 @last
graph gph_const_f_mul_rol.line const const_f1_mul_roll const_f1_mul_roll_lb const_f1_mul_roll_ub
gph_const_f_mul_rol.options linepat
gph_const_f_mul_rol.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_const_f_mul_rol.setelem(2) linecolor(@rgb(0,0,255)) linepattern(SOLID) legend("One Step Rolling Forecast - Multiplicative Model")
gph_const_f_mul_rol.setelem(3) linecolor(@rgb(0,0,255)) linepattern(DASH1) legend("One Step Rolling Forecast - Multiplicative Model - 95% confidence interval")
gph_const_f_mul_rol.setelem(4) linecolor(@rgb(0,0,255)) linepattern(DASH1) legend("")

smpl 2005m1 @last
graph gph_const_f1_mul_fix.line const const_f1_mul_fix const_f1_mul_fix_lb const_f1_mul_fix_ub
gph_const_f1_mul_fix.options linepat
gph_const_f1_mul_fix.setelem(1) linecolor(@rgb(0,0,0)) legend("Actual Data")
gph_const_f1_mul_fix.setelem(2) linecolor(@rgb(255,0,0)) linepattern(SOLID) legend("One Step Fixed Forecast - Multiplicative Model")
gph_const_f1_mul_fix.setelem(3) linecolor(@rgb(255,0,0)) linepattern(DASH1) legend("One Step Fixed Forecast - Multiplicative Model - 95% confidence interval")
gph_const_f1_mul_fix.setelem(4) linecolor(@rgb(255,0,0)) linepattern(DASH1) legend("")

' save workfile
wfsave "fig07_19.wf1"


