################################### READING DATA ########################################

# 0. Either download file manually or uncomment the lines of section 0 to download and unzip
#    using R commands (method = "curl" is there because I use Mac). 
# 1. To escape reading a big file into the memory, I am reading only the rows needed.
#    For that I need to know two numbers: 1.1. number of rows to skip, 1.2. number of rows to read.
#    1.1. Using lubridate package find the number of rows that we are going to skip. 
#    1.2. We are going to read only rows for two days. Each row corresponds to 1 minute.
#         Let's skip fancy programming here and do simple arithmetic.
# 2. After finding number of rows to skip and number of rows to read, we can now read the 
#    data into a data frame very fast. 
# 3. Great, but we still don't have variable names. Two approaches are:
#    3.1. Read the first few lines from the file into a different data frame.
#         Take the names from this new data frame and assign it to the names of our data.
#    3.2. Second approach is done just for fun. To run code from this approach uncomment the lines
#         under the section 3.2 in the code.
# 4. Let's creat a new column for our data frame that will hold information 
#    about the date and time in corresponding format.
#    This column is used to construct second, third and forth plots.

library(lubridate)

# 0
# download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
#              destfile = "household_power_consumption.zip", method = "curl")
# unzip("household_power_consumption.zip")

# 1.1
rows_to_skip_start <- dmy_hms("16/12/2006;17:24:00")                      # POSIXct
rows_to_skip_end <- dmy_hms("1/2/2007;00:00:00")                          # POSIXct
rows_to_skip_interval <- interval(rows_to_skip_start, rows_to_skip_end)   # class is Interval
rows_to_skip_period <- as.period(rows_to_skip_interval, unit = "min")     # class is Period
rows_to_skip_row <- minute(rows_to_skip_period)                           # numeric
# 1.2        
rows_to_read <- 2*24*60                                                   # numeric

# 2
data <- read.table("household_power_consumption.txt", 
                   sep = ";",  header = TRUE, 
                   skip = rows_to_skip_row, nrows = rows_to_read, na.strings = "?")

# 3.1
data_names <-  read.table("household_power_consumption.txt", 
                          sep = ";",  header = TRUE, nrows = 1)
names(data) <- names(data_names)
# 3.2
# names_as_string <- readLines("household_power_consumption.txt", 1)
# names <- unlist(strsplit(names, split = ";"))
# names(data) <- names

# 4
datetime <- strptime(paste(data$Date, data$Time), "%e/%m/%Y %H:%M:%S")  # POSIXlt
data <- cbind(datetime, data)

##########################################################################################

# PLOT 1

# 1. Make the plot
# 2. Copy the plot to png and close graphics device
#    Defaults for width and height are 480 pixels, so I didn't change those (?png for more details)

# 1
par(mfrow = c(1, 1))
hist(data$Global_active_power, col = "red",
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power")
# 2
dev.copy(png,'plot1.png')
dev.off()
