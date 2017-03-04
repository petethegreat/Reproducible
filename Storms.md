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
slim96<- storm96 %>% select(BGN_DATE,EVTYPE,PropDamage,CropDamage,INJURIES,FATALITIES,LATITUDE,LONGITUDE) %>%
filter(PropDamage>0 | CropDamage >0 | INJURIES >0 | FATALITIES >0)
length(unique(slim96$EVTYPE))
```

```
## [1] 222
```


Right now there are 222 event types. Start by casting everything to lower case, and by removing any leading whitespace


```r
slim96$EventType<-tolower(slim96$EVTYPE)
# trimws is new? doesn't exist in older R versions
#slim96$EventType<-trimws(slim96$EventType)
slim96$EventType<-gsub('^\\s+|\\s+$','',slim96$EventType)
length(unique(slim96$EventType))
```

```
## [1] 183
```

Start Reclassifying things/filtering things

```r
# remove things that can't be reclassified easily
badcodes<-c("astronomical high tide","other","marine accident", "coastal storm","coastalstorm","beach erosion","glaze","mixed precip","freezing spray","dam break","coastal erosion" )
slim96<- slim96 %>% filter(! (EventType  %in% badcodes))

# change non thunderstorm winds to strong winds
slim96$EventType<-gsub('non[ -]tstm wind','strong wind',slim96$EventType)
length(unique(slim96$EventType))
```

```
## [1] 170
```

```r
#change tstm/thunderstorm wind to thunderstorm wind
change<-with(slim96, (grepl('tstm',EventType) | grepl('thunderstorm',EventType)) & grepl('wind',EventType))
slim96$EventType[change]<-'thunderstorm wind'
length(unique(slim96$EventType))
```

```
## [1] 156
```

```r
# change 'blowing dust' to dust devil
slim96['EventType'=='blowing dust','EventType']<-'dust devil'
length(unique(slim96$EventType))
```

```
## [1] 156
```

```r
#change mudslide or similar to debris flow
slim96$EventType<-gsub('mud[\\s|-]?slides?','debris flow',slim96$EventType)
length(unique(slim96$EventType))
```

```
## [1] 155
```

```r
# freezing rain -> "frost/freeze" 
# extreme cold -> "extreme cold/wind chill"
# rip currents -> "rip current"
# "wild/forest fire" -> "wildfire"
# "storm surge" -> "Storm Surge/Tide"
# "ice jam flood (minor" -> "flood"
# "urban/sml stream fld" -> "flood"
# "fog" -> "dense fog"
# "rough surf"-> "high surf"
# "heavy surf"->"high surf"
# "freze" -> "frost/freeze"
# "dry microburst"->"thunderstorm wind"
# "winds"->"high wind"
# "erosion/cstl flood"->"coastal flood"
# "river flooding" ->"flood"
# "damaging freeze"->"frost/freeze"
# "heavy rain/high surf"->"heavy rain"
# "unseasonable cold"->"cold/wind chill"
# "early frost"->"frost/freeze"
# "coastal flooding" ->"coastal flood"
# "torrential rainfall"->"heavy rain"
# "landslump"->"debris flow"
# "hurricane edouard"->"hurricane"
# "tidal flooding"->"coastal flood"
# "strong winds" -> "strong wind"
# "extreme windchill"->"extreme cold/wind chill"
# "extended cold" -> "cold/wind chill"
# "wintry mix" -> "winter weather"
# "whirlwind" -> "dust devil"
# "heavy snow shower" -> "heavy snow"
# "cold"->"cold/windchill"
# "downburst"->"thunderstorm wind"
# "microburst" -> "thunderstorm wind"
# "snow"->"heavy snow"
# "snow squalls"->"heavy snow"
# "wind damage"->"high wind"
# "freezing drizzle"->"sleet"
# "gusty wind/rain"->"strong wind"
# "gusty wind/hvy rain"->"heavy rain"
# "wind"->"strong wind"
# "cold temperature"->"cold/wind chill"
# "heat wave"->"heat"
# "cold and snow"->"cold/wind chill"
# "rain/snow"->"heavy rain"
# "gusty winds"->"strong wind"
# "gusty wind"->"strong wind"
# "hard freeze"->"frost/freeze"
# "river flood"->"flood"
# "snow and ice"->"heavy snow"
# "agricultural freeze"->"frost/freeze"
# "snow squall"->"heavy snow"
# "icy roads"->"frost/freeze"
# "thunderstorm"->"thunderstorm wind"
# "hypothermia/exposure"->"cold/wind chill"
# "lake effect snow"->"lake-effect snow"
# "mixed precipitation"->"winter weather"
# "black ice"->"frost/freeze"
# "light snowfall"->"winter weather"
# "light snow"->"winter weather"
# "blowing snow"->"winter weather"
# "frost"->"frost/freeze"
# "gradient wind"->"high wind"
# "unseasonably cold"->"cold/wind chill"
# "wet microburst"->"thunderstorm wind"
# "heavy surf and wind"->"high surf"
# "typhoon"->"hurricane (typhoon)"
# "landslides"->"debris flow"                
# "high swells"->"high surf"              
# "high winds"->"high wind"                
# "small hail"->"hail"               
# "unseasonal rain"->"heavy rain"                           
# "coastal flooding/erosion"->"coastal flood" 
# "high wind (g40)"->"high wind"                                   
# "unseasonably warm"->"heat"                         
# "coastal  flooding/erosion"->"coastal flood"                 
# "hyperthermia/exposure"->"cold/wind chill"    
# "rock slide"->"debris flow"                                
# "gusty wind/hail"->"hail"          
# "heavy seas"->"high surf"                                
# "landspout"->"funnel cloud"                
# "record heat"->"excessive heat"                               
# "excessive snow"->"heavy snow"           
# "flood/flash/flood"->"flash flood"                         
# "wind and wave"->"high surf"            
# "flash flood/flood"->"flash flood"                         
# "light freezing rain"->"frost/freeze"      
# "ice roads"->"frost/freeze"                                 
# "high seas"->"high surf"                
# "rain"->"heavy rain"                                      
# "rough seas"->"high surf"               
# "non-severe wind damage"->"strong wind"                    
# "warm weather"->"heat"             
# "landslide"->"debris flow"                                 
# "high water"->"flood"               
# "late season snow"->"heavy snow"                          
# "winter weather mix"->"winter weather"       
# "rogue wave"->"high surf"                                
# "falling snow/ice"->"winter weather"          
# "brush fire"->"wildfire"                                
# "blowing dust"->"dust devil"             
# "volcanic ash"                              
# "high surf advisory"->"high surf"       
# "hazardous surf"->"high surf"                            
# "cold weather"->"cold/wind chill"                              
# "ice on road"->"frost/freeze"              
# "drowning"->"rip current"                                  
# "hurricane/typhoon"->"hurricane (typhoon)"                         
# "winter weather/mix"->"winter weather"                        
# "heavy surf/high surf"->"high surf"                      

# copy paste the above into a text file, do some sed/awk to remove the leading #'s and the ->, then sort by destination code
# see if we can deal with an entire group at a time by regex

# maybe make a list of the allowed groups, and have R do a unique(filter by EventType not in allowed)




unique(slim96$EventType)
```

```
##   [1] "winter storm"              "tornado"                  
##   [3] "thunderstorm wind"         "high wind"                
##   [5] "flash flood"               "freezing rain"            
##   [7] "extreme cold"              "lightning"                
##   [9] "hail"                      "flood"                    
##  [11] "excessive heat"            "rip currents"             
##  [13] "heavy snow"                "wild/forest fire"         
##  [15] "ice storm"                 "blizzard"                 
##  [17] "storm surge"               "ice jam flood (minor"     
##  [19] "dust storm"                "strong wind"              
##  [21] "dust devil"                "urban/sml stream fld"     
##  [23] "fog"                       "rough surf"               
##  [25] "heavy surf"                "heavy rain"               
##  [27] "avalanche"                 "freeze"                   
##  [29] "dry microburst"            "winds"                    
##  [31] "erosion/cstl flood"        "river flooding"           
##  [33] "waterspout"                "damaging freeze"          
##  [35] "hurricane"                 "tropical storm"           
##  [37] "high surf"                 "heavy rain/high surf"     
##  [39] "unseasonable cold"         "early frost"              
##  [41] "wintry mix"                "drought"                  
##  [43] "coastal flooding"          "torrential rainfall"      
##  [45] "landslump"                 "hurricane edouard"        
##  [47] "tidal flooding"            "strong winds"             
##  [49] "extreme windchill"         "extended cold"            
##  [51] "whirlwind"                 "heavy snow shower"        
##  [53] "light snow"                "coastal flood"            
##  [55] "cold"                      "downburst"                
##  [57] "debris flow"               "microburst"               
##  [59] "snow"                      "snow squalls"             
##  [61] "wind damage"               "light snowfall"           
##  [63] "freezing drizzle"          "gusty wind/rain"          
##  [65] "gusty wind/hvy rain"       "wind"                     
##  [67] "cold temperature"          "heat wave"                
##  [69] "cold and snow"             "rain/snow"                
##  [71] "gusty winds"               "gusty wind"               
##  [73] "hard freeze"               "heat"                     
##  [75] "river flood"               "rip current"              
##  [77] "mud slide"                 "frost/freeze"             
##  [79] "snow and ice"              "agricultural freeze"      
##  [81] "winter weather"            "snow squall"              
##  [83] "icy roads"                 "thunderstorm"             
##  [85] "hypothermia/exposure"      "lake effect snow"         
##  [87] "mixed precipitation"       "black ice"                
##  [89] "blowing snow"              "frost"                    
##  [91] "gradient wind"             "unseasonably cold"        
##  [93] "wet microburst"            "heavy surf and wind"      
##  [95] "funnel cloud"              "typhoon"                  
##  [97] "landslides"                "high swells"              
##  [99] "high winds"                "small hail"               
## [101] "unseasonal rain"           "coastal flooding/erosion" 
## [103] "high wind (g40)"           "unseasonably warm"        
## [105] "seiche"                    "coastal  flooding/erosion"
## [107] "hyperthermia/exposure"     "rock slide"               
## [109] "gusty wind/hail"           "heavy seas"               
## [111] "landspout"                 "record heat"              
## [113] "excessive snow"            "flood/flash/flood"        
## [115] "wind and wave"             "flash flood/flood"        
## [117] "light freezing rain"       "ice roads"                
## [119] "high seas"                 "rain"                     
## [121] "rough seas"                "non-severe wind damage"   
## [123] "warm weather"              "landslide"                
## [125] "high water"                "late season snow"         
## [127] "winter weather mix"        "rogue wave"               
## [129] "falling snow/ice"          "brush fire"               
## [131] "blowing dust"              "volcanic ash"             
## [133] "high surf advisory"        "hazardous surf"           
## [135] "wildfire"                  "cold weather"             
## [137] "ice on road"               "drowning"                 
## [139] "extreme cold/wind chill"   "hurricane/typhoon"        
## [141] "dense fog"                 "winter weather/mix"       
## [143] "heavy surf/high surf"      "tropical depression"      
## [145] "lake-effect snow"          "marine high wind"         
## [147] "tsunami"                   "storm surge/tide"         
## [149] "cold/wind chill"           "lakeshore flood"          
## [151] "marine strong wind"        "astronomical low tide"    
## [153] "dense smoke"               "marine hail"              
## [155] "freezing fog"
```








questions: what event types are worst for population health
panel plot fatalities vs magnitude, colour = evtype
injuries vs magnitude, colour = evetype

what storms do most damage/are most expensive
plot propdamageexp vs magnitude, colour = eventtype

where do these occur most
plot lat and long, colour = mag, on a map of US


