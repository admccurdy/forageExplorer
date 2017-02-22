x <- 6
dynamicInputs <- data.table("id" = paste0("year", 1:x),
                            "name" = paste("Year", 1:x),
                            "value" = 1)

getForage <- function(foragePotential, carryingCap){
  return(foragePotential / carryingCap)
}

getForageFrame <- function(input, dynamicInputs){
  names <- c("year", "rainIndex", "droughtForage", "forageCarry", "Gt", "actualForage", "finalForage")
  forageFrame <- data.table(matrix(0, ncol = length(names), nrow = nrow(dynamicInputs)))
  setnames(forageFrame, names)
}