
%hwpath = "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\HWs\Hw02\"
%codepath = %hwpath + "codes"
%figpath = %hwpath + "figures"

' import real GDP data
cd %codepath
import "GDPC1.csv" ftype=ascii rectype=crlf skip=0 fieldtype=delimited na="." delim=comma colhead=1 namepos=all names=(,RGDP) eoltype=pad badfield=NA @id @date(date) @smpl @all

' percentage changes
genr gRGDPQ = 100*( RGDP - RGDP(-1) ) / RGDP(-1)
genr gRGDPA = 100*( RGDP - RGDP(-4) ) / RGDP(-4)

' log differences
genr dlRGDPQ = 100* ( log(RGDP) - log(RGDP(-1)) )
genr dlRGDPA = 100* ( log(RGDP) - log(RGDP(-4)) )

' time series plots
graph gph_RGDPQ_ts gRGDPQ dlRGDPQ
gph_RGDPQ_ts.datelabel format("YYYY")
gph_RGDPQ_ts.recshade 

graph gph_RGDPA_ts gRGDPA dlRGDPA
gph_RGDPA_ts.datelabel format("YYYY")
gph_RGDPA_ts.recshade 

' correlograms
freeze(tbl_dlRGDPQ_correl) dlRGDPQ.correl
freeze(tbl_dlRGDPA_correl) dlRGDPA.correl

tbl_dlRGDPQ_correl.setmerge(r1c4:r1c5)
tbl_dlRGDPQ_correl(1,3) = "Time Series:"
tbl_dlRGDPQ_correl(1,4) = "DLRGDPQ"

tbl_dlRGDPA_correl.setmerge(r1c4:r1c5)
tbl_dlRGDPA_correl(1,3) = "Time Series:"
tbl_dlRGDPA_correl(1,4) = "DLRGDPA"

' save figures
cd %figpath
gph_RGDPQ_ts.save(t=png) hw02q02_fig1_dlrgdpq_ts
gph_RGDPA_ts.save(t=png) hw02q02_fig2_dlrgdpa_ts
tbl_dlRGDPQ_correl.save(t=png) hw02q02_fig3_dlrgdpq_corr
tbl_dlRGDPA_correl.save(t=png) hw02q02_fig4_dlrgdpa_corr

cd %codepath
wfsave "hw02q02.wf1"


