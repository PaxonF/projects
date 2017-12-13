# Consider the data in the accompanying 'crime.csv' file.  We only desire the
# data in those rows that contain state names in capitals letters as the first
# elements on the lines.  Without editing the 'crime.csv' file and without
# creating any other files, get the desired data in a data frame called
# 'crime'.  Hint: you should have exactly 50 rows and 35 columns.
crime <- read.csv("crime.csv", header = FALSE)
crime<- crime[grepl("^[A-Z ]+$", crime$V1),, drop = TRUE]

# Compute the mean of the third column in the crime data frame.
mean.totalarrests <- mean(as.numeric(gsub(",", "", crime$V3)))
names(mean.totalarrests) <- "Mean of Total Arrests of Adolescents per State"
mean.totalarrests