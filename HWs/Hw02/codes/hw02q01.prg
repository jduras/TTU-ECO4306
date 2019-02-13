
%hwpath = "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\HWs\Hw02\"
%codepath = %hwpath + "codes"
%figpath = %hwpath + "figures"

' part (a)

cd %codepath
import "GDPC1.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited na="." delim=comma colhead=1 namepos=all names=(,RGDP) eoltype=pad badfield=NA @id @date(date) @smpl @all

genr dlrgdp = log(rgdp) - log(rgdp(-1))

freeze(gph_rgdp_ts) rgdp.line
gph_rgdp_ts.datelabel format("YYYY")
gph_rgdp_ts.recshade 

freeze(gph_dlrgdp_ts) dlrgdp.line
gph_dlrgdp_ts.datelabel format("YYYY")
gph_dlrgdp_ts.recshade 

cd %figpath
gph_rgdp_ts.save(t=png) hw02q01_figA1_gdp
gph_dlrgdp_ts.save(t=png) hw02q01_figA2_gdp

cd %codepath
wfsave "hw02q01_rgdp.wf1"
wfclose

' part (b)

cd %codepath
import "DEXJPUS.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited na="." delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

genr dldexjpus= log(dexjpus) - log(dexjpus(-1))

freeze(gph_dexjpus_ts) dexjpus.line
gph_dexjpus_ts.datelabel format("YYYY")
gph_dexjpus_ts.recshade

freeze(gph_dldexjpus_ts) dldexjpus.line
gph_dldexjpus_ts.datelabel format("YYYY")
gph_dldexjpus_ts.recshade 

cd %figpath
gph_dexjpus_ts.save(t=png) hw02q01_figB1_jpyusd
gph_dldexjpus_ts.save(t=png) hw02q01_figB2_jpyusd

cd %codepath
wfsave "hw02q01_jpyusd.wf1"
wfclose

' part (c)

cd %codepath
import "DGS10.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited na="." delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

genr ddgs10= dgs10 - dgs10(-1)

freeze(gph_dgs10_ts) dgs10.line
gph_dgs10_ts.datelabel format("YYYY")
gph_dgs10_ts.recshade

freeze(gph_ddgs10_ts) ddgs10.line
gph_ddgs10_ts.datelabel format("YYYY")
gph_ddgs10_ts.recshade 

cd %figpath
gph_dgs10_ts.save(t=png) hw02q01_figC1_tb10yr
gph_ddgs10_ts.save(t=png) hw02q01_figC2_tb10yr

cd %codepath
wfsave "hw02q01_tb10yr.wf1"
wfclose

' part (d)

cd %codepath
import "UNRATE.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited na="." delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

genr dunrate = unrate -unrate(-1)

freeze(gph_unrate_ts) unrate.line
gph_unrate_ts.datelabel format("YYYY")
gph_unrate_ts.recshade

freeze(gph_dunrate_ts) dunrate.line
gph_dunrate_ts.datelabel format("YYYY")
gph_dunrate_ts.recshade 

cd %figpath
gph_unrate_ts.save(t=png) hw02q01_figD1_u3rate
gph_dunrate_ts.save(t=png) hw02q01_figD2_u3rate

cd %codepath
wfsave "hw02q01_u3rate.wf1"
wfclose

' part (e)

cd %codepath
import "UMICH-SOC1.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited na="." delim=comma colhead=1 namepos=all names=(,CSENT) eoltype=pad badfield=NA @id @date(date) @smpl @all

genr dcsent = csent - csent(-1)

smpl 1952q1 2016q4
freeze(gph_csent_ts) csent.line
gph_csent_ts.datelabel format("YYYY")
gph_csent_ts.recshade

freeze(gph_dcsent_ts) dcsent.line
gph_dcsent_ts.datelabel format("YYYY")
gph_dcsent_ts.recshade 

cd %figpath
gph_csent_ts.save(t=png) hw02q01_figE1_csent
gph_dcsent_ts.save(t=png) hw02q01_figE2_csent

cd %codepath
wfsave "hw02q01_csent.wf1"
wfclose

' part (f)

cd %codepath
import(link) "PAYEMS.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited na="." delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

genr dlpayems = log(payems) - log(payems(-1))

smpl 1950m1 2017m1
freeze(gph_payems_ts) payems.line
gph_payems_ts.datelabel format("YYYY")
gph_payems_ts.recshade

freeze(gph_dlpayems_ts) dlpayems.line
gph_dlpayems_ts.datelabel format("YYYY")
gph_dlpayems_ts.recshade 

cd %figpath
gph_payems_ts.save(t=png) hw02q01_figF1_payems
gph_dlpayems_ts.save(t=png) hw02q01_figF2_payems

cd %codepath
wfsave "hw02q01_payems.wf1"
wfclose

' part (g)

cd %codepath
import(link) "AWHMAN.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited delim=comma colhead=1 eoltype=pad badfield=NA @id @date(date) @smpl @all

genr dlawhman = log(awhman) - log(awhman(-1))

smpl 1950m1 2017m1
freeze(gph_awhman_ts) awhman.line
gph_awhman_ts.datelabel format("YYYY")
gph_awhman_ts.recshade

freeze(gph_dlawhman_ts) dlawhman.line
gph_dlawhman_ts.datelabel format("YYYY")
gph_dlawhman_ts.recshade 

cd %figpath
gph_awhman_ts.save(t=png) hw02q01_figG1_awhman
gph_dlawhman_ts.save(t=png) hw02q01_figG2_awhman

cd %codepath
wfsave "hw02q01_awhman.wf1"
wfclose


