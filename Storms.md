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

The Event type code (EVTYPE) is important, as it will be used to categorise the data. Unfortunately, there are many errors and inconsistencies in the raw data. For example:

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

There are 87 event types that differ only in the case (upper or lower) of their lettering, 'avalanche' is missspelled at least once, and high winds may be categorised as something like 'tstm wind' or 'thunderstorm wind', with variations based on wind speeds/gust speeds. All of these variations make it difficult to compare weather events. According to the [instructions](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf) on storm data preparation, there are only 48 allowed event types, which are listed below: 

-Astronomical Low Tide 
-Avalanche 
-Blizzard 
-Coastal Flood 
-Cold/Wind Chill 
-Debris Flow 
-Dense Fog 
-Dense Smoke 
-Drought 
-Dust Devil 
-Dust Storm 
-Excessive Heat 
-Extreme Cold/Wind Chill 
-Flash Flood 
-Flood 
-Frost/Freeze 
-Funnel Cloud 
-Freezing Fog 
-Hail 
-Heat 
-Heavy Rain 
-Heavy Snow 
-High Surf 
-High Wind 
-Hurricane (Typhoon) 
-Ice Storm 
-Lake-Effect Snow 
-Lakeshore Flood 
-Lightning 
-Marine Hail 
-Marine High Wind 
-Marine Strong Wind 
-Marine Thunderstorm Wind 
-Rip Current 
-Seiche 
-Sleet 
-Storm Surge/Tide 
-Strong Wind 
-Thunderstorm Wind 
-Tornado 
-Tropical Depression 
-Tropical Storm 
-Tsunami 
-Volcanic Ash 
-Waterspout 
-Wildfire 
-Winter Storm 
-Winter Weather

The raw data will need to be tidied before it can be processed effectively. First the observations (rows) of interest will be selected (as this will limit the range of EVTYPE codes that need to be corrected), and then regular expressions will be used to correct the event type codes to one of the 48 options listed above.

based on [this post](https://www.coursera.org/learn/reproducible-research/discussions/weeks/4/threads/IdtP_JHzEeaePQ71AQUtYw) in the course discussion forums, it was only after January 1996 that NOAA started recording events of all types. Tornado data was present from the beginning (1950), but other types of weather events were reported and recorded later. Data prior to January 1996 will be omitted, as analysis of this data could introduce bias due to lack of records on certain weather types.


```r
library(dplyr)
stormData$BGN_DATE<-as.Date(stormData$BGN_DATE,format='%m/%d/%Y')
storm96<-stormData %>% filter(BGN_DATE >  '1996-01-01')
```
Crop and property damage are stored strangely, with the first few significant digits stored seperately from the dollar exponent.** blah blah **


```r
storm96$CropDamage<-storm96$CROPDMG
levels(storm96$CROPDMGEXP) 
```

```
## NULL
```

```r
sum(storm96$CROPDMGEXP == '2')
```

```
## [1] 0
```

```r
sum(storm96$CROPDMGEXP == '0')
```

```
## [1] 0
```

```r
sum(storm96$CROPDMGEXP == '')
```

```
## [1] 373047
```

```r
max(storm96$CROPDMG[storm96$CROPDMGEXP == ''])
```

```
## [1] 0
```

```r
# scale crop damage
thelist<-with(storm96, CROPDMGEXP=='B')
storm96$CropDamage[thelist]<-storm96$CropDamage[thelist]*1.0e9
thelist<-with(storm96, CROPDMGEXP=='K' | CROPDMGEXP=='k')
storm96$CropDamage[thelist]<-storm96$CropDamage[thelist]*1.0e3
thelist<-with(storm96, CROPDMGEXP=='M' | CROPDMGEXP=='m')
storm96$CropDamage[thelist]<-storm96$CropDamage[thelist]*1.0e6

# scale property damage
storm96$PropDamage<-storm96$PROPDMG
thelist<-grepl('[1-8]',storm96$PROPDMGEXP)
sum(thelist)
```

```
## [1] 0
```

```r
thelist<-grepl('[bB]',storm96$PROPDMGEXP)
storm96$PropDamage[thelist]<-storm96$PropDamage[thelist]*1.0e9
thelist<-grepl('[mM]',storm96$PROPDMGEXP)
storm96$PropDamage[thelist]<-storm96$PropDamage[thelist]*1.0e6
thelist<-grepl('[kK]',storm96$PROPDMGEXP)
storm96$PropDamage[thelist]<-storm96$PropDamage[thelist]*1.0e3

# slim data based on injuries, fatalities, and property/crop damage
storm96i<- storm96 %>% select(BGN_DATE,EVTYPE,PropDamage,CropDamage,INJURIES,FATALITIES) %>%
filter(PropDamage>0 | CropDamage >0 | INJURIES >0 | FATALITIES >0)
```


At this point, there are 186 unique EVTYPE codes, which should be much easier to deal with.





questions: what event types are worst for population health
panel plot fatalities vs magnitude, colour = evtype
injuries vs magnitude, colour = evetype

what storms do most damage/are most expensive
plot propdamageexp vs magnitude, colour = eventtype

where do these occur most
plot lat and long, colour = mag, on a map of US


