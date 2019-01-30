cd "C:\Drive\Dropbox\User\Academic\06TexasTech\02Teaching\13 4306 Economic and Business Forecasting Spring 2019\Codes\lec05\"

' import data for Annual Working Hours per Employee in the United States from 1977 to 2006
import(link) "Figure03_10_HoursWorkedUSA.XLS" range="Figure03_10_HoursWorkedUSA" colhead=1 na="#N/A" @id @date(obs) @smpl @all

' correlogram
freeze(usa_correl) usa.correl

