library(ggplot2)

# generate CPU t2 comparison plot (boxplot)

`t2micro_peak_cpu` <- read.csv("../data/t2micro_peak_cpu.csv")
`t2micro_base_cpu` <- read.csv("../data/t2micro_base_cpu.csv")
`t2small_peak_cpu` <- read.csv("../data/t2small_peak_cpu.csv")
`t2small_base_cpu` <- read.csv("../data/t2small_base_cpu.csv")
`t2medium_peak_cpu` <- read.csv("../data/t2medium_peak_cpu.csv")
`t2medium_base_cpu` <- read.csv("../data/t2medium_base_cpu.csv")

t2micro_peak_cpu <- cbind(Config = "t2.micro - Peak", t2micro_peak_cpu)
t2micro_base_cpu <- cbind(Config = "t2.micro - Base", t2micro_base_cpu)
t2small_peak_cpu <- cbind(Config = "t2.small - Peak", t2small_peak_cpu)
t2small_base_cpu <- cbind(Config = "t2.small - Base", t2small_base_cpu)
t2medium_peak_cpu <- cbind(Config = "t2.medium - Peak", t2medium_peak_cpu)
t2medium_base_cpu <- cbind(Config = "t2.medium - Base", t2medium_base_cpu)
`m3medium_cpu` <- read.csv("../data/m3medium_cpu.csv")


cpu <- t2micro_peak_cpu
cpu <- rbind(cpu, t2micro_base_cpu, t2small_peak_cpu, t2small_base_cpu, t2medium_peak_cpu, t2medium_base_cpu)
mie_basis <- mean(m3medium_cpu$Value)
cpu$TransformedValue <- mie_basis / cpu$Value

types <- c("t2.micro", "t2.small", "t2.medium")
cpu$Type <- NA
cpu$PrintName <- NA
for(type in types) {
  cpu[grep(type, cpu$Config),]$Type <- type
}
cpu$Type_f <- factor(cpu$Type, levels = c("t2.micro", "t2.small", "t2.medium"))
View(cpu)

configs = unique(cpu$Config)
cs = c(0.014, 0.014, 0.028, 0.028, 0.056, 0.056)
costs <- data.frame(configs, cs)

ggplot(cpu, aes(y = TransformedValue, x = Config)) + geom_boxplot() + labs(x= "Instance Types", y="Medium-Instance Equivalents") + geom_hline(aes(yintercept=1), linetype="dashed") + theme(legend.position="none") + facet_grid(. ~ Type_f, space = "free", scales = "free")
# EXPORT IN size 10x3 inches

# generate arithmetic mean and relative stddev values
for(c in unique(cpu$Config)) {
  mean <- mean(cpu[cpu$Config == c,]$TransformedValue)
  sd <- sd(cpu[cpu$Config == c,]$TransformedValue)
  cost <- costs[costs$configs == c,]$cs
  ratio <- mean / cost
  print(paste(c, " -> ", mean , " / ", sd/mean, " / ", cost, " / ", ratio))
}

# do Whitney-Mann tests for statistical significance
attach(cpu)
pairwise.wilcox.test(TransformedValue, Config, paired = FALSE)
detach(cpu)


##############################################################################################################################
##############################################################################################################################
##############################################################################################################################

# generate CPU comparison plot with other instance types (boxplot)

`t2micro_peak_cpu` <- read.csv("../data/t2micro_peak_cpu.csv")
`t2micro_base_cpu` <- read.csv("../data/t2micro_base_cpu.csv")
`m3medium_cpu` <- read.csv("../data/m3medium_cpu.csv")
`m3large_cpu` <- read.csv("../data/m3large_cpu.csv")
`c4large_cpu` <- read.csv("../data/c4large_cpu.csv")
`t1micro_cpu` <- read.csv("../data/t1micro_cpu.csv")

t2micro_peak_cpu <- cbind(Config = "t2.micro - Peak", t2micro_peak_cpu)
t2micro_base_cpu <- cbind(Config = "t2.micro - Base", t2micro_base_cpu)
m3medium_cpu <- cbind(Config = "m3.medium", m3medium_cpu)
m3large_cpu <- cbind(Config = "m3.large", m3large_cpu)
c4large_cpu <- cbind(Config = "c4.large", c4large_cpu)
t1micro_cpu <- cbind(Config = "t1.micro - Peak", t1micro_cpu)

cpu_cp <- t2micro_peak_cpu
cpu_cp <- rbind(cpu_cp, t2micro_base_cpu, m3medium_cpu, m3large_cpu, c4large_cpu, t1micro_cpu)
mie_basis <- mean(m3medium_cpu$Value)
cpu_cp$TransformedValue <- mie_basis / cpu_cp$Value

types <- c("t2.micro", "m3.medium", "m3.large", "c4.large", "t1.micro")
cpu_cp$Type <- NA
for(type in types) {
  cpu_cp[grep(type, cpu_cp$Config),]$Type <- type
}
cpu_cp$Type_f <- factor(cpu_cp$Type, levels = c("t2.micro", "m3.medium", "m3.large", "c4.large", "t1.micro"))

configs = unique(cpu_cp$Config)
cs = c(0.014, 0.014, 0.077, 0.154, 0.132, 0.02)
costs <- data.frame(configs, cs)

ggplot(cpu_cp, aes(y = TransformedValue, x = Config)) + geom_boxplot() + labs(x= "Instance Types", y="Medium-Instance Equivalents") + geom_hline(aes(yintercept=1), linetype="dashed") + theme(legend.position="none") + facet_grid(. ~ Type_f, space = "free", scales = "free")
# EXPORT IN size 10x3 inches

# generate arithmetic mean and relative stddev values
for(c in unique(cpu_cp$Config)) {
  mean <- mean(cpu_cp[cpu_cp$Config == c,]$TransformedValue)
  sd <- sd(cpu_cp[cpu_cp$Config == c,]$TransformedValue)
  cost <- costs[costs$configs == c,]$cs
  ratio <- mean / cost
  print(paste(c, " -> ", mean , " / ", sd/mean, " / ", cost, " / ", ratio))
}

# do Whitney-Mann tests for statistical significance
attach(cpu_cp)
pairwise.wilcox.test(TransformedValue, Config, paired = FALSE)
detach(cpu_cp)

##############################################################################################################################
##############################################################################################################################
##############################################################################################################################

# generate CPU t2 comparison plot for IO (beanplot)

`t2micro_peak_io` <- read.csv("../data/t2micro_peak_io.csv")
`t2micro_base_io` <- read.csv("../data/t2micro_base_io.csv")
`t2small_peak_io` <- read.csv("../data/t2small_peak_io.csv")
`t2small_base_io` <- read.csv("../data/t2small_base_io.csv")
`t2medium_peak_io` <- read.csv("../data/t2medium_peak_io.csv")
`t2medium_base_io` <- read.csv("../data/t2medium_base_io.csv")

t2micro_peak_io <- cbind(Config = "t2.micro - Peak", t2micro_peak_io)
t2micro_base_io <- cbind(Config = "t2.micro - Base", t2micro_base_io)
t2small_peak_io <- cbind(Config = "t2.small - Peak", t2small_peak_io)
t2small_base_io <- cbind(Config = "t2.small - Base", t2small_base_io)
t2medium_peak_io <- cbind(Config = "t2.medium - Peak", t2medium_peak_io)
t2medium_base_io <- cbind(Config = "t2.medium - Base", t2medium_base_io)

io <- t2micro_peak_io
io <- rbind(io, t2micro_base_io, t2small_peak_io, t2small_base_io, t2medium_peak_io, t2medium_base_io)

ggplot(io, aes(y = Value, x = Config)) + geom_violin(trim=FALSE) + labs(x= "Instance Types", y="Sysbench Benchmark Value [MBit/s]")
# EXPORT IN size 10x3 inches

# generate arithmetic mean and relative stddev values
for(c in unique(io$Config)) {
  mean <- mean(io[io$Config == c,]$Value)
  sd <- sd(io[io$Config == c,]$Value)
  print(paste(c, " -> ", mean , " / ", sd/mean))
}

# do Whitney-Mann tests for statistical significance
attach(io)
pairwise.wilcox.test(Value, Config, paired = FALSE)
detach(io)

##############################################################################################################################
##############################################################################################################################
##############################################################################################################################

# generate IO comparison plot with other instance types (boxplot)

`t2micro_peak_io` <- read.csv("../data/t2micro_peak_io.csv")
`t2micro_base_io` <- read.csv("../data/t2micro_base_io.csv")
`m3medium_io` <- read.csv("../data/m3medium_io.csv")
`m3large_io` <- read.csv("../data/m3large_io.csv")
`c4large_io` <- read.csv("../data/c4large_io.csv")
`t1micro_io` <- read.csv("../data/t1micro_io.csv")

t2micro_peak_io <- cbind(Config = "t2.micro - Peak", t2micro_peak_io)
t2micro_base_io <- cbind(Config = "t2.micro - Base", t2micro_base_io)
m3medium_io <- cbind(Config = "m3.medium", m3medium_io)
m3large_io <- cbind(Config = "m3.large", m3large_io)
c4large_io <- cbind(Config = "c4.large", c4large_io)
t1micro_io <- cbind(Config = "t1.micro - Peak", t1micro_io)

io_cp <- t2micro_peak_io
io_cp <- rbind(io_cp, t2micro_base_io, m3medium_io, m3large_io, c4large_io, t1micro_io)

ggplot(io_cp, aes(y = Value, x = Config)) + geom_violin(trim=FALSE) + labs(x= "Instance Types", y="Sysbench Benchmark Value [MBit/s]")
# EXPORT IN size 10x3 inches

##############################################################################################################################
##############################################################################################################################
##############################################################################################################################

# generate plot that compares over-time performance from t1.micro and t2.micro

`t2micro_longterm` <- read.csv("../data/t2micro_longterm.csv")
`t1micro_longterm` <- read.csv("../data/t1micro_longterm.csv")
`m3medium_cpu` <- read.csv("../data/m3medium_cpu.csv")

t2micro_longterm <- cbind(Config = "t2.micro", t2micro_longterm)
i <- 0
for(t in sort(t2micro_longterm$Time)) {
  t2micro_longterm[t2micro_longterm$Time == t, ]$Time <- i
  i <- i + 1
}
t1micro_longterm <- cbind(Config = "t1.micro", t1micro_longterm)

longterm <- t2micro_longterm
longterm <- rbind(longterm, t1micro_longterm)
mie_basis <- mean(m3medium_cpu$Value)
longterm$TransformedValue <- mie_basis / longterm$Value

ggplot(longterm, aes(y = Value, group = Config, color = Config, shape = Config, x = Time)) + geom_point() + labs(x= "Experiment Duration", y="sysbench Benchmark Value [s]")
# EXPORT IN size 8x3 inches

##############################################################################################################################
##############################################################################################################################
##############################################################################################################################

# generate Costs of Performance plot

`t2micro_peak_cpu` <- read.csv("../data/t2micro_peak_cpu.csv")
`t2micro_base_cpu` <- read.csv("../data/t2micro_base_cpu.csv")
`t2small_peak_cpu` <- read.csv("../data/t2small_peak_cpu.csv")
`t2small_base_cpu` <- read.csv("../data/t2small_base_cpu.csv")
`t2medium_peak_cpu` <- read.csv("../data/t2medium_peak_cpu.csv")
`t2medium_base_cpu` <- read.csv("../data/t2medium_base_cpu.csv")
`m3medium_cpu` <- read.csv("../data/m3medium_cpu.csv")
`m3large_cpu` <- read.csv("../data/m3large_cpu.csv")
`c4large_cpu` <- read.csv("../data/c4large_cpu.csv")
# `t1micro_cpu` <- read.csv("../data/t1micro_cpu.csv")

t2micro_peak_cpu <- cbind(Config = "t2.micro - Peak", t2micro_peak_cpu)
t2micro_base_cpu <- cbind(Config = "t2.micro - Base", t2micro_base_cpu)
t2small_peak_cpu <- cbind(Config = "t2.small - Peak", t2small_peak_cpu)
t2small_base_cpu <- cbind(Config = "t2.small - Base", t2small_base_cpu)
t2medium_peak_cpu <- cbind(Config = "t2.medium - Peak", t2medium_peak_cpu)
t2medium_base_cpu <- cbind(Config = "t2.medium - Base", t2medium_base_cpu)
m3medium_cpu <- cbind(Config = "m3.medium", m3medium_cpu)
m3large_cpu <- cbind(Config = "m3.large", m3large_cpu)
c4large_cpu <- cbind(Config = "c4.large", c4large_cpu)
# t1micro_cpu <- cbind(Config = "t1.micro - Peak", t1micro_cpu)



cpu <- t2micro_peak_cpu
cpu <- rbind(cpu, t2micro_base_cpu, t2small_peak_cpu, t2small_base_cpu, t2medium_peak_cpu, t2medium_base_cpu,
             m3medium_cpu, m3large_cpu, c4large_cpu)

mie_basis <- mean(m3medium_cpu$Value)
cpu$TransformedValue <- mie_basis / cpu$Value

configs = unique(cpu$Config)
cs = c(0.014, 0.014, 0.028, 0.028, 0.056, 0.056, 0.077, 0.154, 0.132)
fuef = c(10,1,5,1,5,1,1,1,1)
costs <- data.frame(configs, cs, fuef)

cp <- data.frame(Config=character(), CP=numeric(), CPLAB=character(), FUE=numeric(), COSTLAB=character(), stringsAsFactors=FALSE)
for(c in unique(cpu$Config)) {
  mean <- mean(cpu[cpu$Config == c,]$TransformedValue)
  sd <- sd(cpu[cpu$Config == c,]$TransformedValue)
  cost <- costs[costs$configs == c,]$cs
  ratio <- mean / cost
  fue <- mean / (cost * costs[costs$configs == c,]$fuef)
  cp[nrow(cp) + 1,]$Config <- c
  cp[nrow(cp),]$CP <- round(ratio)
  cp[nrow(cp),]$FUE <- round(fue)
}

ggplot(cp, aes(x = reorder(Config,FUE), y = CP)) + geom_bar(stat="identity") + coord_flip() + labs(x= "Instance Types", y="Performance / Cost Ratio (pcr)") + geom_text(aes(label=CP), hjust=-1, vjust=-0.5, size=3.5)
ggplot(cp, aes(x = reorder(Config,FUE), y = FUE)) + geom_bar(stat="identity") + coord_flip() + labs(x= "Instance Types", y="Full-Utilization Equivalent pcr")
# EXPORT IN size 5x5 inches

##############################################################################################################################
##############################################################################################################################
##############################################################################################################################

  # generate Costs of Performance plot for different utilization levels
  
  `t2micro_peak_cpu` <- read.csv("../data/t2micro_peak_cpu.csv")
  `t2small_peak_cpu` <- read.csv("../data/t2small_peak_cpu.csv")
  `t2medium_peak_cpu` <- read.csv("../data/t2medium_peak_cpu.csv")
  `m3medium_cpu` <- read.csv("../data/m3medium_cpu.csv")
  `c4large_cpu` <- read.csv("../data/c4large_cpu.csv")
  `m3large_cpu` <- read.csv("../data/m3large_cpu.csv")  

  t2micro_peak_cpu <- cbind(Config = "t2.micro - Peak", t2micro_peak_cpu)
  t2small_peak_cpu <- cbind(Config = "t2.small - Peak", t2small_peak_cpu)
  t2medium_peak_cpu <- cbind(Config = "t2.medium - Peak", t2medium_peak_cpu)
  m3medium_cpu <- cbind(Config = "m3.medium", m3medium_cpu)
  c4large_cpu <- cbind(Config = "c4.large", c4large_cpu)
  m3large_cpu <- cbind(Config = "m3.large", m3large_cpu)
  
  cpu <- t2micro_peak_cpu
  cpu <- rbind(cpu, t2small_peak_cpu, t2medium_peak_cpu, m3medium_cpu, m3large_cpu, c4large_cpu)
  mie_basis <- mean(m3medium_cpu$Value)
  cpu$TransformedValue <- mie_basis / cpu$Value
  
  configs = unique(cpu$Config)
  cs = c(0.014, 0.028, 0.056, 0.077, 0.154, 0.132)
  capacity = c(10,20,20,100,100,100)
  costs <- data.frame(configs, cs, capacity)
  
  cpr <- data.frame(Config = character(), U = numeric(), UNPCR = numeric(), stringsAsFactors = FALSE)
  for(u in seq(25,100, 0.1)) {
    for(c in unique(cpu$Config)) {
      cpr[nrow(cpr) + 1,]$Config <- c
      cpr[nrow(cpr),]$U <- u
      cpr[nrow(cpr),]$UNPCR <- unpcr(c,u)
    }
  }
  
  ggplot(cpr, aes(group = Config, color = Config, shape = Config, x = U, y = UNPCR)) + geom_line() + labs(x= "Average Utilization (%)", y="Utilization-Normalised PCR") 
# EXPORT IN size 8x3 inches  

  unpcr <- function(c, u) {
    mean <- mean(cpu[cpu$Config == c,]$TransformedValue)
    cost <- costs[costs$configs == c,]$cs
    nr <- ceiling(u / costs[costs$configs == c,]$capacity)
    mean / (nr * cost)
  }