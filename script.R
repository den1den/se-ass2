#Import data from LibreOffice
d1 <- read.csv(file="change_with_files.csv", header=TRUE)
d2 <- read.csv(file="change_with_last_revision.csv", header=TRUE)
d3 <- read.csv(file="change_without_files.csv", header=TRUE)
d4 <- read.csv(file="people_with_changes.csv", header=TRUE)
d5 <- read.csv(file="people_with_history_review.csv", header=TRUE)
d6 <- read.csv(file="people_with_history_review+-2.csv", header=TRUE)
d7 <- read.csv(file="revision_created_dates.csv", header=TRUE, colClasses=c("myDate"))
d8 <- read.csv(file="revision_created_heatmap.csv", header=TRUE)
d9 <- read.csv(file="revision_created_per_weekday.csv", header=TRUE)

#Join tables
m1 <- merge(d2, d5, by.x = "ch_authorAccountId", by.y = "p_accountId")
m2 <- merge(m1, d4, by.x = "ch_authorAccountId", by.y = "p_accountId")
m3 <- merge(m2, d6, by.x = "ch_authorAccountId", by.y = "p_accountId")
m4 <- merge(m3, d1, by.x = "change_id", by.y = "change_id")

#Multiple linear regression
mlr <- lm(m4$ch_review_period ~ m4$p_ecosystem_tenure + m4$p_review_tenure + m4$ch_revision_count + m4$p_review_tenure_2 + m4$p_review_activity_2 + m4$ch_total_lines_inserted + m4$ch_total_lines_deleted + m4$ch_files_changed + m4$ch_contains_source)
# removed: m4$p_change_activity

#Import data from OpenStack
e1 <- read.csv(file="change_with_files.csv", header=TRUE)
e2 <- read.csv(file="change_with_last_revision.csv", header=TRUE)
e3 <- read.csv(file="change_without_files.csv", header=TRUE)
e4 <- read.csv(file="people_with_changes.csv", header=TRUE)

#Join tables
l <- merge(e2, e4, by.x = "ch_authorAccountId", by.y = "p_accountId")

#Multiple linear regression
mlr2 <- lm(l$ch_review_period ~ l$p_ecosystem_tenure + l$ch_revision_count)