---
title: "Reproducible Research: Storm Data Analysis"
output: 
  html_document:
    keep_md: true
---
Reproducible Research assignment 2: Storm Data
==============================================================


# Title

## Introduction
some notes

## obtaining data
data comes from blah

```r
destfile='StormData.csv.bz2'
if (! file.exists(destfile))
{
    download.file('https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2',dest=destfile,method='curl')
}
stormData<-read.csv('./StormData.csv.bz2',stringsAsFactors=FALSE)
head(stormData)
```

```
##   STATE__           BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE
## 1       1  4/18/1950 0:00:00     0130       CST     97     MOBILE    AL
## 2       1  4/18/1950 0:00:00     0145       CST      3    BALDWIN    AL
## 3       1  2/20/1951 0:00:00     1600       CST     57    FAYETTE    AL
## 4       1   6/8/1951 0:00:00     0900       CST     89    MADISON    AL
## 5       1 11/15/1951 0:00:00     1500       CST     43    CULLMAN    AL
## 6       1 11/15/1951 0:00:00     2000       CST     77 LAUDERDALE    AL
##    EVTYPE BGN_RANGE BGN_AZI BGN_LOCATI END_DATE END_TIME COUNTY_END
## 1 TORNADO         0                                               0
## 2 TORNADO         0                                               0
## 3 TORNADO         0                                               0
## 4 TORNADO         0                                               0
## 5 TORNADO         0                                               0
## 6 TORNADO         0                                               0
##   COUNTYENDN END_RANGE END_AZI END_LOCATI LENGTH WIDTH F MAG FATALITIES
## 1         NA         0                      14.0   100 3   0          0
## 2         NA         0                       2.0   150 2   0          0
## 3         NA         0                       0.1   123 2   0          0
## 4         NA         0                       0.0   100 2   0          0
## 5         NA         0                       0.0   150 2   0          0
## 6         NA         0                       1.5   177 2   0          0
##   INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO STATEOFFIC ZONENAMES
## 1       15    25.0          K       0                                    
## 2        0     2.5          K       0                                    
## 3        2    25.0          K       0                                    
## 4        2     2.5          K       0                                    
## 5        2     2.5          K       0                                    
## 6        6     2.5          K       0                                    
##   LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM
## 1     3040      8812       3051       8806              1
## 2     3042      8755          0          0              2
## 3     3340      8742          0          0              3
## 4     3458      8626          0          0              4
## 5     3412      8642          0          0              5
## 6     3450      8748          0          0              6
```

## Data Processing

There are some inconsitencies in the event type designations, for example:

```r
length(unique(stormData$EVTYPE))
```

```
## [1] 985
```

```r
moose<-unique(tolower(stormData$EVTYPE))
length(moose)
```

```
## [1] 898
```

```r
moose[grep('aval',moose)]
```

```
## [1] "avalanche"                     "avalance"                     
## [3] "heavy snow/blizzard/avalanche"
```

```r
sum(grepl('tstm',moose))
```

```
## [1] 29
```

```r
sum(grepl('thunderstorm',moose))
```

```
## [1] 81
```

There are 87 event types that differ only in the case (upper or lower) of their lettering, 'avalanche' is missspelled at least once, and high winds may be categorised as something like 'tstm wind' or 'thunderstorm wind', with variations based on wind speeds/gust speeds. All of these variations make it difficult to compare weather events. To make it easier, will first convert EVTYPE to lower case, and then create an additional classification column based on EVTYPE.

permitted event types:
Astronomical Low Tide Z
Avalanche Z
Blizzard Z
Coastal Flood Z
Cold/Wind Chill Z
Debris Flow C
Dense Fog Z
Dense Smoke Z
Drought Z
Dust Devil C
Dust Storm Z
Excessive Heat Z
Extreme Cold/Wind Chill Z
Flash Flood C
Flood C
Frost/Freeze Z
Funnel Cloud C
Freezing Fog Z
Hail C
Heat Z
Heavy Rain C
Heavy Snow Z
High Surf Z
High Wind Z
Hurricane (Typhoon) Z
Ice Storm Z
Lake-Effect Snow Z
Lakeshore Flood Z
Lightning C
Marine Hail M
Marine High Wind M
Marine Strong Wind M
Marine Thunderstorm Wind M
Rip Current Z
Seiche Z
Sleet Z
Storm Surge/Tide Z
Strong Wind Z
Thunderstorm Wind C
Tornado C
Tropical Depression Z
Tropical Storm Z
Tsunami Z
Volcanic Ash Z
Waterspout M
Wildfire Z
Winter Storm Z
Winter Weather Z 


Filter stuff. Only from January 96 were events

based on [this post](https://www.coursera.org/learn/reproducible-research/discussions/weeks/4/threads/IdtP_JHzEeaePQ71AQUtYw) in course discussion forums, it was only after January 1996 that they started recording events of all types. Tornado data was preset from the beginning (1950). Will omit data from before 1996, as this does not represent all event types fairly. Also, we are interested in health effects (i.e. injuries and fatalities) and economic effects (property and crop damage). Will omit observations that have no injuries or fatalities and do no damage

start by converting EVTYPE to lower case and BGN_DATE to date class

```r
library(dplyr)
stormData$EVTYPE<-tolower(stormData$EVTYPE)
stormData$BGN_DATE<-as.Date(stormData$BGN_DATE,format='%m/%d/%Y')

# should convert damge values to actual damage numbers, then do the filtering.

storm96ecoHealth<-stormData %>% filter(BGN_DATE > '1996-01-01') %>% filter(PROPDMG >0 | CROPDMG > 0| INJURIES >0 | FATALITIES >0)

# maybe put this in with the initial load, and only keep the slimmed things.
```



At this point, there are 186 unique EVTYPE codes, which should be much easier to deal with.





questions: what event types are worst for population health
panel plot fatalities vs magnitude, colour = evtype
injuries vs magnitude, colour = evetype

what storms do most damage/are most expensive
plot propdamageexp vs magnitude, colour = eventtype

where do these occur most
plot lat and long, colour = mag, on a map of US


