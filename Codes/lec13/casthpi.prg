' create workfile
wfcreate Q 1975:1 2007:4

cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\codes\lec13\"

' import data from xls file
import "CASTHPI.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 namepos=all names=(,hpCA) eoltype=pad badfield=NA @id @date(date) @smpl @all

' genr ghpCA = 100*(hpCA - hpCA(-1))/hpCA(-1)
genr ghpCA = 100*dlog(hpCA)
genr ghpCA_mean = @mean(ghpCA)

' time series plot
graph gph_ghpCA.line ghpCA ghpCA_mean
gph_ghpCA.axis(l) zeroline

' correlogram
freeze(gph_ghpCA_corr) ghpCA.correl

' estimate AR(3) model
smpl 1975Q1 2002Q4
equation eq_ar3.ls ghpCA c ar(1) ar(3)

' set prediction sample
smpl 2003Q1 2007Q4

' fixed scheme one step ahead forecast using the AR(3) model
eq_ar3.fit(f=na, e, g) ghpCA_f_ar3_fix @se ghpCA_f_ar3_fix_se

' naive random walk forecast
series ghpCA_f_naive
ghpCA_f_naive = ghpCA(-1)

' moving average forecast
series ghpCA_f_ma
ghpCA_f_ma = 1/4*( ghpCA(-1)+ghpCA(-2)+ghpCA(-3)+ghpCA(-4) )

' calculate forecast errors
genr ghpCA_e_ar3_fix = ghpCA - ghpCA_f_ar3_fix
genr ghpCA_e_naive = ghpCA - ghpCA_f_naive
genr ghpCA_e_ma = ghpCA - ghpCA_f_ma

' Table 9.2
smpl 2002Q2 2007Q4
freeze(tbl_9_2) ghpCA ghpCA_f_ar3_fix ghpCA_e_ar3_fix ghpCA_f_naive ghpCA_e_naive ghpCA_f_ma ghpCA_e_ma

' Table 9.4 Optimality of Forecast (Mean Prediction Error)
equation eq_e_mpe_ar3_fix.ls(cov=hac) ghpCA_e_ar3_fix c 
equation eq_e_mpe_naive.ls(cov=hac) ghpCA_e_naive c 
equation eq_e_mpe_ma.ls(cov=hac) ghpCA_e_ma c 

' Table 9.4 Optimality of Forecast (Informational Efficiency Test)
equation eq_e_iet_ar3_fix.ls(cov=hac) ghpCA_e_ar3_fix c ghpCA_f_ar3_fix
equation eq_e_iet_naive.ls(cov=hac) ghpCA_e_naive c ghpCA_f_naive
equation eq_e_iet_ma.ls(cov=hac) ghpCA_e_ma c ghpCA_f_ma

' correlograms for forecast errors
smpl @all
freeze(gph_ghpCA_e_ar3_fix_corr) ghpCA_e_ar3_fix.correl
freeze(gph_ghpCA_e_naive_corr) ghpCA_e_naive.correl
freeze(gph_ghpCA_e_ma_corr) ghpCA_e_ma.correl

' loss based on symmetric quadratic loss function
smpl 2003Q1 2007Q4
genr ghpCA_l_ar3_fix = ghpCA_e_ar3_fix^2
genr ghpCA_l_naive = ghpCA_e_naive^2
genr ghpCA_l_ma = ghpCA_e_ma^2

' test for equal predictive ability
genr dl_naive = ghpCA_l_naive - ghpCA_l_ar3_fix
genr dl_ma = ghpCA_l_ma - ghpCA_l_ar3_fix

equation eq_e_epa_naive.ls(cov=hac) dl_naive c 
equation eq_e_epa_ma.ls(cov=hac)  dl_ma c


' next, construct combined forecasts with
' 1) weights based on MSE
' 2) equal weights 
' 3) weight based on OLS to get the best fit

' mean square error (MSE)
scalar ghpca_MSE_ar3_fix = @mean(ghpCA_l_ar3_fix)
scalar ghpca_MSE_naive = @mean(ghpca_l_naive)
scalar ghpca_MSE_ma = @mean(ghpca_l_ma)

' weights based on 1/MSE
scalar ghpca_w_ar3_fix = 1/ghpca_MSE_ar3_fix / ( 1/ghpca_MSE_ar3_fix + 1/ghpca_MSE_naive + 1/ghpca_MSE_ma )
scalar ghpca_w_naive = 1/ghpca_MSE_naive / ( 1/ghpca_MSE_ar3_fix + 1/ghpca_MSE_naive + 1/ghpca_MSE_ma )
scalar ghpca_w_ma = 1/ghpca_MSE_ma / ( 1/ghpca_MSE_ar3_fix + 1/ghpca_MSE_naive + 1/ghpca_MSE_ma )

' combined forecast - equal weights
genr ghpca_f_combined1 = 1/3* (ghpCA_f_ar3_fix + ghpca_f_naive + ghpca_f_ma)

' combined forecast - weights based on 1/MSE
genr ghpca_f_combined2 = ghpca_w_ar3_fix*ghpCA_f_ar3_fix + ghpca_w_naive*ghpca_f_naive + ghpca_w_ma*ghpca_f_ma

' combined forecast - weights based on OLS
equation eq_f_weights.ls ghpca c ghpCA_f_ar3_fix ghpca_f_naive ghpca_f_ma
genr ghpca_f_combined3 = c(1) + c(2)*ghpCA_f_ar3_fix + c(3)*ghpca_f_naive + c(4)*ghpca_f_ma

' forecast errors - combined forecasts
genr ghpCA_e_combined1 = ghpCA - ghpCA_f_combined1
genr ghpCA_e_combined2 = ghpCA - ghpCA_f_combined2
genr ghpCA_e_combined3 = ghpCA - ghpCA_f_combined3

' loss based on symmetric quadratic loss function
genr ghpCA_l_combined1 = ghpCA_e_combined1^2
genr ghpCA_l_combined2 = ghpCA_e_combined2^2
genr ghpCA_l_combined3 = ghpCA_e_combined3^2

group grp_fcsts ghpCA_l_ar3_fix ghpCA_l_naive ghpCA_l_ma ghpCA_l_combined1 ghpCA_l_combined2 ghpCA_l_combined3
grp_fcsts.stats

' test for equal predictive ability
genr dl_naive1 = ghpCA_l_naive - ghpCA_l_combined1
genr dl_naive2 = ghpCA_l_naive - ghpCA_l_combined2
genr dl_naive3 = ghpCA_l_naive - ghpCA_l_combined3

equation eq_e_epa_naive1.ls(cov=hac) dl_naive1 c 
equation eq_e_epa_naive2.ls(cov=hac) dl_naive2 c 
equation eq_e_epa_naive3.ls(cov=hac) dl_naive3 c 


' optimal forecast - linex loss function
genr ghpca_f_ar3_fix_linex = ghpca_f_ar3_fix - 1/4*ghpca_f_ar3_fix_se^2
genr ghpca_e_ar3_fix_linex = ghpca - ghpca_f_ar3_fix_linex
genr ghpca_l_ar3_fix_linex = exp(-1/2*ghpca_e_ar3_fix_linex) + 1/2*ghpca_e_ar3_fix_linex - 1

ghpca_l_ar3_fix_linex.stats


