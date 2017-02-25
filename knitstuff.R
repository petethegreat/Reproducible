#!/usr/bin/Rscript

library(knitr)
library(markdown)
knit('Storms.Rmd')
markdownToHTML('Storms.md','Storms.html')
# knit2html('PA1_template.Rmd','PA1_template.html')
file.copy(from='Storms.html',to='/home/pete/petes_stuff/Storms.html',overwrite=TRUE)
message('knittted to html, copied to /home/pete/petes_stuff/Storms.html')
