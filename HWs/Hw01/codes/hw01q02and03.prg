%hwpath = "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\HWs\HW01"
%codepath = %hwpath + "\codes"
%figpath = %hwpath + "\figures"

cd %codepath
' import(link) "A191RL1Q225SBEA.xls" range="FRED Graph" colhead=2 namepos=all na="#N/A" names=(, gRGDP) @id @date(frequency__quarterly_obs) @smpl @all
' delete frequency__quarterly_obs 
import(link) "A191RL1Q225SBEA.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 namepos=all names=(,gRGDP) eoltype=pad badfield=NA @id @date(date) @smpl @all

' import(link, resize) "MULTPL-SP500_INFLADJ_MONTH_Q.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 namepos=all names=(,SP500) eoltype=pad badfield=NA @freq Q @id @date(date) @destid @date @smpl @all
import(link) "MULTPL-SP500_INFLADJ_MONTH_Q.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 namepos=all names=(,SP500) eoltype=pad badfield=NA @freq Q @id @date(date) @destid @date @smpl @all

genr rSP500 = 100*( SP500/SP500(-1) - 1 )

graph gph_ts gRGDP rSP500
graph gph_gRGDP_ts gRGDP
graph gph_SP500_ts SP500
graph gph_rSP500_ts rSP500

graph gph_scat.scat rSP500 gRGDP

freeze(gph_gRGDP_hist) gRGDP.hist
freeze(gph_rSP500_hist) rSP500.hist

cd %figpath
gph_gRGDP_ts.save(t=png) "hw01q02_fig01_ts_gGDP"
gph_SP500_ts.save(t=png) "hw01q02_fig02_ts_SP500"
gph_rSP500_ts.save(t=png) "hw01q02_fig03_ts_rSP500"
gph_gRGDP_hist.save(t=png) "hw01q02_fig04_hist_gGDP"
gph_rSP500_hist.save(t=png) "hw01q02_fig05_hist_rSP500"
gph_scat.save(t=png) "hw01q02_fig06_gGDP_rSP500_scatter"

equation eq01.ls gRGDP c rSP500 
equation eq02.ls gRGDP c rSP500(-1)
equation eq03.ls gRGDP c rSP500(-1) rSP500(-2) rSP500(-3) rSP500(-4)
equation eq04.ls gRGDP c rSP500(-1) rSP500(-2) rSP500(-3) rSP500(-4) gRGDP(-1)

freeze(tbl_eq01) eq01
freeze(tbl_eq02) eq02
freeze(tbl_eq03) eq03
freeze(tbl_eq04) eq04

tbl_eq01.save(t=png) "hw01q03_eq01.png"
tbl_eq02.save(t=png) "hw01q03_eq02.png"
tbl_eq03.save(t=png) "hw01q03_eq03.png"
tbl_eq04.save(t=png) "hw01q03_eq04.png"

cd %codepath
wfsave "hw01q02and03.wf1"




smpl 1985q1 2007q4
freeze(gRGDP_hist_1985_2007) gRGDP.hist
freeze(rSP500_hist_1985_2007) rSP500.hist
freeze(gph_hist) gRGDP_hist_1985_2007 rSP500_hist_1985_2007

series lSP500 = log(SP500)
series dSP500 = SP500 - SP500(-1)
series dlSP500 = log(SP500) - log(SP500(-1))

graph gph_SP500.line(m) SP500 lSP500 dSP500 dlSP500


