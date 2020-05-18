library(tidyverse)

datne<-read.table("~/projects/ibd/results/JRIAL1/JRIAL1_ne.ne",header=T) 

pdf("/home/jri/projects/ibd/results/JRIAL1/neplot.pdf")

filter(datne, GEN>200) %>%
  ggplot(aes(x=GEN)) +
  geom_ribbon(aes(ymin=log10(LWR.95.CI),ymax=log10(UPR.95.CI)),fill = "grey70") +
  geom_line(aes(y=log10(NE)))+
  theme_bw()

ggplot(data=datne, aes(x=GEN)) +
  geom_ribbon(aes(ymin=log10(LWR.95.CI),ymax=log10(UPR.95.CI)),fill = "grey70") +
  geom_line(aes(y=log10(NE)))+
  theme_bw()
dev.off()

#ggsave(list(c(longplot,shortplot)),filename="neplot.pdf",device="pdf",path="~/projects/ibd/results/JRIAL1/")
