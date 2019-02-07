%hwpath = "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\HWs\HW01"
%codepath = %hwpath + "\codes"
%figpath = %hwpath + "\figures"

cd %codepath
import(link) "TSLA.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

delete date high low open volume close
rename adj_close tsla

genr rtsla = 100*( tsla/tsla(-1) - 1 )

graph gph_tsla_ts tsla
graph gph_rtsla_ts rtsla
freeze(gph_rtsla_hist) rtsla.hist

cd %figpath
gph_tsla_ts.save(t=png) hw01q01_fig01_ts_TSLA
gph_rtsla_ts.save(t=png) hw01q01_fig02_ts_rTSLA
gph_rtsla_hist.save(t=png) hw01q01_fig03_hist_rTSLA

cd %codepath
wfsave "hw01q01.wf1"


