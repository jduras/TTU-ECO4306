cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\08 4306 Economic and Business Forecasting Spring 2018\Codes\lec03"

' import data for  Nonfarm Business Sector: Employment (PRS85006013) from https://fred.stlouisfed.org/series/PRS85006013
import(link) "Table02_3_Data.xls" range="Table2_3_Data" colhead=1 namepos=all na="#N/A" names=(obs, D_Price, D_Rate) @freq A @id @date(obs) @smpl @all

' time series plot, histogram and scatter plot
graph gph_d_rate_ts d_rate
graph gph_d_price_ts d_price
freeze(gph_d_rate_hist) d_rate.hist
group g1 d_rate d_price
freeze(gph_d_rate_scat) g1.scat 

' estimate OLS model
equation eq_d_price.ls(cov=hac) d_price c d_price(-1) d_rate(-1)

wfsave "Table02_3_Data.wf1"


