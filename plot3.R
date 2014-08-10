
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
with(data, {
    plot(DateTime, Sub_metering_1, type="l", 
         ylab="Energy sub metering", xlab="")
    lines(DateTime, Sub_metering_2, col="red")
    lines(DateTime, Sub_metering_3, col="blue")
})
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


## save to file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
