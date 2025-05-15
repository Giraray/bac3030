{
  library(dplyr)
  library(jsonlite)
  library(stringr)
  library(ngram)
  
  # config
  sourceFileName <- "dataset500.csv"
  newFilename <- "dataset.json"
  
  
  data <- read.csv(sourceFileName) |>
    as.data.frame()
  
  # Remember to switch columns
  firstRow <- data[1]
  secondRow <- data[2]
  promptMessage <- "You are an AI that translates english sentences to ASL gloss. Always assume that the input is an english sentence that is to be translated to english. You will translate the inputted sentence into ASL gloss."
  
  # Create dataframe, make lowercase to prepare for processing
  data <- data.frame(secondRow, firstRow)
  data[1] <- apply(data[1], FUN = str_to_lower, MARGIN = 1)
  data[2] <- apply(data[2], FUN = str_to_lower, MARGIN = 1)
  
  # Convert back to appropriate case
  data[,1] <- sapply(data[,1], str_to_sentence)
  data[,2] <- sapply(data[,2], str_to_upper)

  # WITH instruction
  data <- data.frame(promptMessage, data[1], data[2])
  colnames(data) <- c("instruction","input", "output")
  
  # WITHOUT instruction
  # data <- data.frame(data[1], data[2])
  # colnames(data) <- c("input", "output")
  
  # Filter data of insignificant size (character count)
  # data <- data %>% filter(str_count(prompt) > 10)
  
  # Write as JSON
  jsonlite::toJSON(data, pretty = TRUE) |>
    write(newFileName)
}

