cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\Codes\lec05\"

' import data for Dow Jones, 1988M1 to 2008M4
import(link) "Figure03_fig01_fig7_DJI.xls" range=figure3_7 colhead=1 na="#N/A" @id @date(obs) @smpl @all

' create first difference
' same as d_DJ = DJ - DJ(-1)
series d_DJ = d(DJ)

' create log transformed time series
series log_DJ = log(DJ)

' create first difference for log transformed time series
' same as d_log_DJ = log(DJ) - log(DJ(-1)) or d_log_DJ = d(log(DJ))
series d_log_DJ = dlog(DJ)

' create time series plots
group grp1 DJ d_DJ log_DJ d_log_DJ
freeze(gph_grp1_line) grp1.line(m)


' same plot as above, without creating variables
group grp2 DJ d(DJ) log(DJ) dlog(DJ)
freeze(gph_grp2_line) grp2.line(m)

' histogram
freeze(gph_d_log_DJ_hist) d_log_DJ.hist

gph_d_log_DJ_hist.save(t=png) fig_d_log_DJ_hist


