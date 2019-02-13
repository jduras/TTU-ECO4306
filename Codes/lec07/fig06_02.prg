cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\codes\lec07"

' create monthly workfile
wfcreate m 1986m1 2004m12

' import data
import(link) "Figure06_02_MSFT_DJ.xls" range=figure6_2 colhead=1 na="#N/A" @freq M @id @date(obs) @smpl @all

' generate time series with mean of returns for DJ and MSFT
genr return_dj_mean = @mean(return_dj)
genr return_msft_mean = @mean(return_msft)

' time series plots
graph fig6_2a.line return_msft  return_msft_mean
fig6_2a.setelem(1) legend("Monthly Return For Microsoft")
fig6_2a.setelem(2) legend("Monthly Return For Microsoft - Mean")
fig6_2a.options linepat

graph fig6_2b.line return_dj  return_dj_mean
fig6_2b.setelem(1) legend("Monthly Return For Dow Jones Index")
fig6_2b.setelem(2) legend("Monthly Return For Dow Jones Index - Mean")
fig6_2b.options linepat

' ACF and PACF
freeze(fig6_2c) return_msft.correl(20)
freeze(fig6_2d) return_dj.correl(20)

' save workfile
wfsave "fig06_02.wf1"


