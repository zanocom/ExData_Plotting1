####################################################
# Code for PROJECT 1
# EXPLORATORY DATA ANALYSIS
# Part of the DATA SCIENCE SPECIALIZATION
####################################################

# The code downloads and unzip data from UC Irvine Machine Learning Repository
# and made available by Prof.Peng at
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

# Load required packages
    require ( "chron")
    library ( chron )
    require ("sqldf")
    library(sqldf)


# import data
# download and unzip
# Code adapted from Michael Koohafkan
# https://www.ocf.berkeley.edu/~mikeck/?p=688
    
    td <- tempdir()  # create a temporary directory
    tf <- tempfile(tmpdir=td, fileext=".zip")  # create the placeholder file
    
    download.file ("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                   destfile= tf )  # download into the placeholder file
    
    fname <- unzip(tf, list=TRUE)$Name[1]  # get the name of the first file in the zip archive
    unzip( tf, files=fname, exdir=td, overwrite=TRUE)  # unzip the file to the temporary directory
    fpath <- file.path(td, fname)  # fpath is the full path to the extracted file
    f <- file( fpath )    # open connection to fpath


# subset imported data
    data <- sqldf("select * 
                      from f
                      where Date in ('1/2/2007','2/2/2007')", 
                  dbname = tempfile() , 
                  file.format = list(header = T, row.names = F , sep=";" )  ) 
    
    close( f  ) # close connection


#summary ( data )
#head ( data , n= 100)
#tail ( data , n= 100)
#str ( data )

# compute tick position
#    tapply( data$Day ,  data$Day   , length )  # 1 1441 2881

# set locale 
    lct <- Sys.getlocale("LC_TIME")
    Sys.setlocale("LC_TIME", "C")

# date and time formatting
    data$Date <- as.Date( strptime ( data$Date , format="%d/%m/%Y"))
    data$Day <-  strftime ( data$Date , format="%a"  )
    data$Time <-  times( format( as.POSIXct(data$Time,format="%T") , "%T"  ) )
    
    Sys.setlocale("LC_TIME", lct)


# Export plot in png format 
    png(file = "plot3.png", bg = "white" , width = 480, height = 480)
    
    plot (  data$Sub_metering_1 , col="black" , 
            type="l" , ylab="Energy sub metering" , xlab=NA,
            xaxt='n'  )
    axis ( side= 1 ,  at=seq(1,2881,by=1440) , labels=c("Thu","Fri","Sat")   )
    lines ( data$Sub_metering_2 , col="red"  )    
    lines ( data$Sub_metering_3 , col="blue" )    
    legend ( "topright" , legend= paste("Sub_metering_",1:3,sep="") , 
             lty=1 ,  col=c("black","red","blue")  )

    dev.off()

# END