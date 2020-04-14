library(tidyverse)

system("mv ~/projects/ibd/results/JRIAL1/neplot.pdf ~/projects/ibd/results/JRIAL1/old_neplot.pdf")
neplot<-read.table("~/projects/ibd/results/JRIAL1/JRIAL1_ne.ne",header=T) %>%  
  ggplot(aes(x=GEN)) +
  geom_ribbon(aes(ymin=log10(LWR.95.CI),ymax=log10(UPR.95.CI)),fill = "grey70") +
  geom_line(aes(y=log10(NE)))

ggsave(neplot,filename="neplot.pdf",device="pdf",path="~/projects/ibd/results/JRIAL1/")
