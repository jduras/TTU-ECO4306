
%hwpath = "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\HWs\Hw03\"
%codepath = %hwpath + "codes"
%figpath = %hwpath + "figures"

cd %codepath

' import(link) "hw03.xlsx" range=HW03 colhead=1 na="#N/A" @id @date(series01) @smpl @all
import(link) "hw03.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(obs) @smpl @all

' time series plot - actual data vs forecast
graph gph_gpgdp_f1 gpgdp gpgdp_f1(-1)
gph_gpgdp_f1.setelem(1) legend(Inflation)
gph_gpgdp_f1.setelem(2) legend(1-quarter Ahead Inflation Forecast)

' construct 1 quarter ahead forecast error
genr gpgdp_e1 = gpgdp - gpgdp_f1(-1)

' time series plot - forecast error
graph gph_gpgdp_e1 gpgdp_e1
gph_gpgdp_e1.axis(l) zeroline
gph_gpgdp_e1.setelem(1) legend(1-quarter Ahead Forecast Error)

' histogram for forecast errors
freeze(gph_gpgdp_e1_hist) gpgdp_e1.hist

' OLS: forecast error on constant
equation eq_gpgdp_e1.ls gpgdp_e1 c
freeze(tbl_eq_gpgdp_e1) eq_gpgdp_e1

' OLS: actual data on constant and forecast
equation eq_gpgdp_f1.ls gpgdp c gpgdp_f1(-1)
freeze(tbl_eq_gpgdp_f1) eq_gpgdp_f1

' test for unbiased forecast beta=0, beta=1
freeze(tbl_test_eq_gpgdp_f1) eq_gpgdp_f1.wald c(1)=0, c(2)=1

' correlogram for forecast errors
freeze(tbl_e1_correl) gpgdp_e1.correl

' save output
cd %figpath

gph_gpgdp_f1.save(t=png) hw03q01_fig01_f1_ts
gph_gpgdp_e1.save(t=png) hw03q01_fig02_e1_ts
gph_gpgdp_e1_hist.save(t=png) hw03q01_fig03_e1_hist
tbl_eq_gpgdp_e1.save(t=png) hw03q01_fig04_e1_ols
tbl_eq_gpgdp_f1.save(t=png) hw03q01_fig05_f1_ols
tbl_test_eq_gpgdp_f1.save(t=png) hw03q01_fig06_f1_ols_ftest
tbl_e1_correl.save(t=png) hw03q01_fig07_e1_corr

' save workfile
cd %codepath
wfsave "hw03q01.wf1"


