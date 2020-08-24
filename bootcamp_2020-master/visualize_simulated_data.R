
library(xpose)

# visualize simulated data
setwd("./nm/")
df <- read_nm_tables("sdtab01") %>%
  filter(EVID==0)


ggplot(df, mapping=aes(x=TIME, y=IPRED, group=ID, color=factor(HIV)))+
  geom_line()+
  facet_wrap(~DOSE)+
  scale_y_log10()+
  scale_x_continuous(breaks=seq(0,24,4))+
  xlab("Time (h)")+
  ylab("Plasma concentration (mg/L)")+
  scale_color_brewer(palette="Paired")+
  theme_bw()



