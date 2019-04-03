
' 1. Plots

' time series plot - original time series before transformation, whole sample
freeze(gph_{%series_code}_ts_whole) {%series_code}.line
gph_{%series_code}_ts_whole.recshade
gph_{%series_code}_ts_whole.options size(9,3)
gph_{%series_code}_ts_whole.datelabel format("YYYY")
' gph_{%series_code}raw_ts_whole.axis(l) format(suffix="%")
gph_{%series_code}_ts_whole.addtext(ac) ""
gph_{%series_code}_ts_whole.addtext(0, -0.75, font(Calibri,13,-b,-i,-u,-s))  %series_title

' time series plot - transformed time series y, whole sample
freeze(gph_{%series_code_trans}_ts_whole) {%series_code_trans}.line
gph_{%series_code_trans}_ts_whole.recshade
gph_{%series_code_trans}_ts_whole.options size(9,3)
gph_{%series_code_trans}_ts_whole.datelabel format("YYYY")
gph_{%series_code_trans}_ts_whole.axis(l) format(suffix="%")
gph_{%series_code_trans}_ts_whole.addtext(ac) ""
gph_{%series_code_trans}_ts_whole.addtext(0, -0.75, font(Calibri,13,-b,-i,-u,-s))  %series_title_trans



' 2. Estimation

' estimation sample
smpl %sample_estimation

' time series plot - transformed time series y, estimation sample
freeze(gph_{%series_code_trans}_ts) {%series_code_trans}.line
gph_{%series_code_trans}_ts.recshade
gph_{%series_code_trans}_ts.options size(9,3)
gph_{%series_code_trans}_ts.datelabel format("YYYY")
gph_{%series_code_trans}_ts.axis(l) format(suffix="%")
gph_{%series_code_trans}_ts.addtext(ac) ""
gph_{%series_code_trans}_ts.addtext(0, -0.75, font(Calibri,13,-b,-i,-u,-s))  %series_title_trans

' correlogram - transformed time series y, estimation sample
freeze(gph_{%series_code_trans}_corr) {%series_code_trans}.correl(48)

' estimate seasonal ARMA model
equation eq1.ls {%equation_spec_lhs} {%equation_spec_rhs}
freeze(tbl_eq1) eq1

' time series plot - residuals 
freeze(gph_eq1_resid_ts) eq1.resid
gph_eq1_resid_ts.recshade
' gph_eq1_resid_ts.options size(9,3)
gph_eq1_resid_ts.options size(7.5,3)
gph_eq1_resid_ts.datelabel format("YYYY")
gph_eq1_resid_ts.legend position(0,-0.45)
gph_eq1_resid_ts.legend -inbox
gph_eq1_resid_ts.addtext(0, -0.75, font(Calibri,13,-b,-i,-u,-s)) {%series_title_trans}, Actual vs Fitted Values, Seasonal ARMA model
gph_eq1_resid_ts.axis(l) format(suffix="%")
gph_eq1_resid_ts.axis(r) format(suffix="%")

' correlogram - residuals
freeze(gph_eq1_resid_corr) eq1.correl(48)



' 3. Forecasts

' fixed scheme forecast
smpl %sample_prediction
freeze(tbl_eq1_f_fixed) eq1.fit(f=na, e, g) {%series_code_fcst}_f @se {%series_code_fcst}_f_se

' lower and upper bounds of 95% confidence intevrals
series {%series_code_fcst}_f_lb = {%series_code_fcst}_f - 1.96* {%series_code_fcst}_f_se
series {%series_code_fcst}_f_ub = {%series_code_fcst}_f + 1.96* {%series_code_fcst}_f_se

' plot forecast based on the estimated seasonal ARMA model
smpl %sample_prediction_plot

graph gph_eq1_f.line {%series_code_fcst} {%series_code_fcst}_f {%series_code_fcst}_f_lb {%series_code_fcst}_f_ub

gph_eq1_f.recshade
gph_eq1_f.setelem(1) linepattern(SOLID) linecolor(@rgb(55,105,175)) linewidth(1) legend("Actual")
gph_eq1_f.setelem(2) linepattern(SOLID) linecolor(@rgb(255,0,0)) linewidth(1) legend("Forecast")
gph_eq1_f.setelem(3) linepattern(DASH1) linecolor(@rgb(255,150,150)) linewidth(0.5) legend("95% confidence interval")
gph_eq1_f.setelem(4) linepattern(DASH1) linecolor(@rgb(255,150,150)) linewidth(0.5) legend("")
gph_eq1_f.datelabel format("YYYY")
gph_eq1_f.options linepat
gph_eq1_f.options size(9,3)
gph_eq1_f.axis(l) format(suffix="%")
gph_eq1_f.legend columns(3)
gph_eq1_f.legend position(0,-0.45)
gph_eq1_f.legend -inbox
gph_eq1_f.addtext(0, -0.75, font(Calibri,13,-b,-i,-u,-s))  {%series_title_fcst}, Forecast using Seasonal ARMA model

show gph_eq1_f
	
' naive forecast
smpl %sample_prediction
if @pagefreq = "Q" then !f = 4 endif
if @pagefreq = "M" then !f = 12 endif

series {%series_code_trans}_f_naive = {%series_code_trans}(-!f)

if %in_diff = "true" then
	series {%series_code}_f_naive = {%series_code}(-1) + {%series_code_trans}_f_naive
endif



' 4. Forecast errors

' calculate forecast errors
smpl %sample_prediction

series {%series_code_fcst}_e = {%series_code_fcst} - {%series_code_fcst}_f
series {%series_code_fcst}_e_naive = {%series_code_fcst} - {%series_code_fcst}_f_naive 

' plot forecast errors
graph gph_eq1_e.line {%series_code_fcst}_e {%series_code_fcst}_e_naive

gph_eq1_e.recshade
gph_eq1_e.options linepat
gph_eq1_e.options size(9,3)
gph_eq1_e.setelem(1) linepattern(DASH1) linecolor(@rgb(255,0,0)) linewidth(1.5) legend("Forecast using Seasonal ARMA model")
gph_eq1_e.setelem(2) linepattern(SOLID) linecolor(@rgb(80,80,80)) linewidth(1) legend("Naive Forecast")
gph_eq1_e.datelabel format("YYYY")
gph_eq1_e.axis(l) format(suffix="%")
gph_eq1_e.legend position(0,-0.5)
gph_eq1_e.legend -inbox
gph_eq1_e.addtext(0, -0.75, font(Calibri,13,-b,-i,-u,-s))  {%series_title_fcst}, Forecast errors, Seasonal ARMA model vs Naive Forecast

show gph_eq1_e



' 5. Equal predictive ability test

series {%series_code_fcst}_l_ar = {%series_code_fcst}_e^2
series {%series_code_fcst}_l_naive = {%series_code_fcst}_e_naive^2
series {%series_code_fcst}_dl = {%series_code_fcst}_l_ar - {%series_code_fcst}_l_naive

equation eq1_dL.ls {%series_code_fcst}_dl c 
freeze(tbl_eq1_dl) eq1_dl



' 6. Save figures and tables

cd %figpath

gph_{%series_code}_ts_whole.save(t=png, w=12) hw07q01_{%series_code}_fig00_ts_whole
gph_{%series_code_trans}_ts_whole.save(t=png, w=12) hw07q01_{%series_code}_fig01_ts_whole
gph_{%series_code_trans}_ts.save(t=png, w=12) hw07q01_{%series_code}_fig01_ts
gph_{%series_code_trans}_corr.save(t=png) hw07q01_{%series_code}_fig02_corr

tbl_eq1.save(t=png) hw07q01_{%series_code}_fig03_eq1
gph_eq1_resid_ts.save(t=png, w=12) hw07q01_{%series_code}_fig04_eq1_resid_ts
gph_eq1_resid_corr.save(t=png) hw07q01_{%series_code}_fig05_eq1_resid_corr

gph_eq1_f.save(t=png, w=12) hw07q01_{%series_code}_fig06_eq1_f
gph_eq1_e.save(t=png, w=12) hw07q01_{%series_code}_fig07_eq1_e
tbl_eq1_dl.save(t=png) hw07q01_{%series_code}_fig08_eq1_dl

cd %codepath

wfsave {%series_code}.wf1

' wfclose


