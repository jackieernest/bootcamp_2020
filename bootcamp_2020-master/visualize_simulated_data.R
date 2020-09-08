library(tidyverse)
library(xpose)

# visualize simulated data
setwd("~/Dropbox/PSPG_paperwork/Bootcamp_2020/bootcamp_2020/nm")
df <- read_nm_tables("sdtab01") #%>%
  #filter(EVID==0)


ggplot(df, mapping=aes(x=TIME, y=DV, group=ID, color=factor(HIV)))+
  geom_line()+
  facet_wrap(~DOSE)+
  scale_y_log10()+
  scale_x_continuous(breaks=seq(0,24,4))+
  xlab("Time (h)")+
  ylab("Plasma concentration (mg/L)")+
  scale_color_brewer(palette="Paired")+
  theme_bw()

# compare with simtab (made by Vincent with extra patient info columns)

simtab <- read.csv("../bootcamp_2020-master/simtab.csv")

# add the new DVs to simtab.csv

simtab$DV <- df$DV
simtab$IPRED <- df$IPRED

# write.csv(simtab, "../simtab.csv", row.names=F)
# write.csv(simtab, "../bootcamp_2020-master/simtab.csv", row.names=F)
# write.csv(simtab, "~/Dropbox/apps/bootcamp_PK_app/simtab.csv", row.names=F)
