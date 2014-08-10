
## download the data file if it doesn't exist
if (!file.exists("household_power_consumption.txt")) {
    if (!file.exists("household_power_consumption.zip")) {
        download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
        destfile="household_power_consumption.zip", method="curl")
    }
    unzip(zipfile="household_power_consumption.zip")
}


## read the data file
#  header (because we don't read the first line)
names <- c("Date", "Time", "Global_active_power", "Global_reactive_power", 
           "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", 
           "Sub_metering_3")

#  using data from the dates 2007-02-01 and 2007-02-02 : lines 66637 to 69516
data <- read.table("household_power_consumption.txt", header=FALSE, sep=';', 
                   na.strings="?", nrows=69516, check.names=FALSE, 
                   stringsAsFactors=FALSE, comment.char="", quote='\"', 
                   skip=66637, col.names=names)


## convert dates
data <- within(data, DateTime <- as.POSIXlt(paste(Date, Time), 
                                            format = "%d/%m/%Y %H:%M:%S"))


## subset the data
data <- subset(data, DateTime >= as.POSIXlt("2007-02-01") & 
                     DateTime < as.POSIXlt("2007-02-03"))


## plot
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(data, {
    plot(DateTime, Global_active_power, type="l", 
         ylab="Global Active Power", xlab="")
    plot(DateTime, Voltage, type="l", 
         ylab="Voltage", xlab="datetime")
    plot(DateTime, Sub_metering_1, type="l", 
         ylab="Energy sub metering", xlab="")
    lines(DateTime, Sub_metering_2, col='Red')
    lines(DateTime, Sub_metering_3, col='Blue')
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(DateTime, Global_reactive_power, type="l", 
         ylab="Global_rective_power",xlab="datetime")
})


## save to file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
