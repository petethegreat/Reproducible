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
```

```
## Warning: package 'dplyr' was built under R version 3.1.3
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
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
slim96<- storm96 %>% select(BGN_DATE,EVTYPE,PropDamage,CropDamage,INJURIES,FATALITIES,LATITUDE,LONGITUDE) %>%
filter(PropDamage>0 | CropDamage >0 | INJURIES >0 | FATALITIES >0)
```


Right now there are 222 event types. Start by casting everything to lower case, and by removing any leading whitespace


```r
slim96$EventType<-tolower(slim96$EVTYPE)
# trimws is new? 
#slim96$EventType<-trimws(slim96$EventType)
slim96$EventType<-gsub('^\\s+|\\s+$','',slim96$EventType)
```

reclassify 'non tstm wind' or similar as 'strong wind'

```r
length(unique(slim96$EventType))
```

```
## [1] 183
```

```r
slim96$EventType<-gsub('non[ -]tstm wind','strong wind',slim96$EventType)
length(unique(slim96$EventType))
```

```
## [1] 181
```

change tstm/thunderstorm wind to thunderstorm wind

```r
change<-with(slim96, (grepl('tstm',EventType) | grepl('thunderstorm',EventType)) & grepl('wind',EventType))
slim96$EventType[change]<-'thunderstorm wind'
length(unique(slim96$EventType))
```

```
## [1] 167
```

```r
# change 'blowing dust' to dust devil
slim96['EventType'=='blowing dust','EventType']<-'dust devil'
length(unique(slim96$EventType))
```

```
## [1] 167
```

```r
#change mudslide or similar to debris flow
slim96$EventType<-gsub('mud\\s?slides?','debris flow',slim96$EventType)
length(unique(slim96$EventType))
```

```
## [1] 165
```

```r
unique(slim96$EventType)
```

```
##   [1] "winter storm"              "tornado"                  
##   [3] "thunderstorm wind"         "high wind"                
##   [5] "flash flood"               "freezing rain"            
##   [7] "extreme cold"              "lightning"                
##   [9] "hail"                      "flood"                    
##  [11] "excessive heat"            "rip currents"             
##  [13] "other"                     "heavy snow"               
##  [15] "wild/forest fire"          "ice storm"                
##  [17] "blizzard"                  "storm surge"              
##  [19] "ice jam flood (minor"      "dust storm"               
##  [21] "strong wind"               "dust devil"               
##  [23] "urban/sml stream fld"      "fog"                      
##  [25] "rough surf"                "heavy surf"               
##  [27] "heavy rain"                "marine accident"          
##  [29] "avalanche"                 "freeze"                   
##  [31] "dry microburst"            "winds"                    
##  [33] "coastal storm"             "erosion/cstl flood"       
##  [35] "river flooding"            "waterspout"               
##  [37] "damaging freeze"           "hurricane"                
##  [39] "tropical storm"            "beach erosion"            
##  [41] "high surf"                 "heavy rain/high surf"     
##  [43] "unseasonable cold"         "early frost"              
##  [45] "wintry mix"                "drought"                  
##  [47] "coastal flooding"          "torrential rainfall"      
##  [49] "landslump"                 "hurricane edouard"        
##  [51] "tidal flooding"            "strong winds"             
##  [53] "extreme windchill"         "glaze"                    
##  [55] "extended cold"             "whirlwind"                
##  [57] "heavy snow shower"         "light snow"               
##  [59] "coastal flood"             "mixed precip"             
##  [61] "cold"                      "freezing spray"           
##  [63] "downburst"                 "debris flow"              
##  [65] "microburst"                "snow"                     
##  [67] "snow squalls"              "wind damage"              
##  [69] "light snowfall"            "freezing drizzle"         
##  [71] "gusty wind/rain"           "gusty wind/hvy rain"      
##  [73] "wind"                      "cold temperature"         
##  [75] "heat wave"                 "cold and snow"            
##  [77] "rain/snow"                 "gusty winds"              
##  [79] "gusty wind"                "hard freeze"              
##  [81] "heat"                      "river flood"              
##  [83] "rip current"               "frost/freeze"             
##  [85] "snow and ice"              "agricultural freeze"      
##  [87] "winter weather"            "snow squall"              
##  [89] "icy roads"                 "thunderstorm"             
##  [91] "hypothermia/exposure"      "lake effect snow"         
##  [93] "mixed precipitation"       "black ice"                
##  [95] "coastalstorm"              "dam break"                
##  [97] "blowing snow"              "frost"                    
##  [99] "gradient wind"             "unseasonably cold"        
## [101] "wet microburst"            "heavy surf and wind"      
## [103] "funnel cloud"              "typhoon"                  
## [105] "landslides"                "high swells"              
## [107] "high winds"                "small hail"               
## [109] "unseasonal rain"           "coastal flooding/erosion" 
## [111] "high wind (g40)"           "coastal erosion"          
## [113] "unseasonably warm"         "seiche"                   
## [115] "coastal  flooding/erosion" "hyperthermia/exposure"    
## [117] "rock slide"                "gusty wind/hail"          
## [119] "heavy seas"                "landspout"                
## [121] "record heat"               "excessive snow"           
## [123] "flood/flash/flood"         "wind and wave"            
## [125] "flash flood/flood"         "light freezing rain"      
## [127] "ice roads"                 "high seas"                
## [129] "rain"                      "rough seas"               
## [131] "non-severe wind damage"    "warm weather"             
## [133] "landslide"                 "high water"               
## [135] "late season snow"          "winter weather mix"       
## [137] "rogue wave"                "falling snow/ice"         
## [139] "brush fire"                "blowing dust"             
## [141] "volcanic ash"              "high surf advisory"       
## [143] "hazardous surf"            "wildfire"                 
## [145] "cold weather"              "ice on road"              
## [147] "drowning"                  "extreme cold/wind chill"  
## [149] "hurricane/typhoon"         "dense fog"                
## [151] "winter weather/mix"        "astronomical high tide"   
## [153] "heavy surf/high surf"      "tropical depression"      
## [155] "lake-effect snow"          "marine high wind"         
## [157] "tsunami"                   "storm surge/tide"         
## [159] "cold/wind chill"           "lakeshore flood"          
## [161] "marine strong wind"        "astronomical low tide"    
## [163] "dense smoke"               "marine hail"              
## [165] "freezing fog"
```








questions: what event types are worst for population health
panel plot fatalities vs magnitude, colour = evtype
injuries vs magnitude, colour = evetype

what storms do most damage/are most expensive
plot propdamageexp vs magnitude, colour = eventtype

where do these occur most
plot lat and long, colour = mag, on a map of US


