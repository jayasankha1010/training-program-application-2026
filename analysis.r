# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
# You may use base R or tidyverse for this exercise
library(tidyverse)

# ex. library(tidyverse)

# Load data here ----------------------
# Load each file with a meaningful variable name.
metadata <- read.csv("./data/GSE60450_filtered_metadata.csv")
expression_data <- read.csv("./data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv")


# Inspect the data -------------------------

# What are the dimensions of each data set? (How many rows/columns in each?)
# Keep the code here for each file.

## Expression data
print(dim(expression_data))
print(head(expression_data))
## Metadata
print(dim(metadata))
print(head(metadata))

# Rename the first column with a meaningful name.
colnames(metadata)[1] <- "sample_id"
colnames(expression_data)[1] <- "ensembl_id"

# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame?

# convert expression data from wide to long
expression_long <- expression_data %>%
  pivot_longer(
    cols = starts_with("GSM"), 
    names_to = "sample_id", 
    values_to = "expression_level"
  )

# combine the two data frames using sample_id
combined_data <- inner_join(expression_long, metadata, by = "sample_id")

# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2

expression_plot <- ggplot(combined_data, aes(x = immunophenotype, y = expression_level)) +
  geom_boxplot(fill = "steelblue", alpha = 0.8) +
  theme_minimal() +
  labs(
    title = "Gene Expression Distribution by Cell Type",
    x = "Cell type",
    y = "Expression level (normalized)"
  )

print(expression_plot)


## Save the plot
### Show code for saving the plot with ggsave() or a similar function
ggsave("./results/expression_by_celltype.jpg",
         plot = expression_plot, width = 8, height = 6, dpi = 300)