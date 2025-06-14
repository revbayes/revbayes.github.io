```
# References

Definitions for regions, times, and features come from these sources:
- CP02: Clague & Price 2002
- LM17: Lim & Marshall 2017
- C96: Clague 1996

Notes:
- C96 provides minimum island ages and maximum elevation values.
- LM17 provides actual island ages and maximum size values.
- CP02 provides actual elevations per island per 1Myr time bin.



# Corrections to CP02 Spreadsheet

The CP02 Spreadsheet contained several peculiar entries that we corrected.

Current island elevations:
- Ni’ihau: 381 on Wikipedia, 390 in the table. Looks good, use table
- Kaua’i: 1587 on Wikipedia, 1598 in the table. Looks good, use table
- Wai’anae: 1227 on Wikipedia, 1231 in the table. Looks good, use table
- Ko’olau: 960 on Wikipedia, 1598 in the table. Wrong, use Wikipedia
- W. Moloka’i: 421 on Wikipedia, 421 in the table. Looks good, use table

Corrected island elevations:

    Ni’ihau
    dh = 1190-390 
    step = dh/5
    new ages: Ni’ihau,1190,1030,870,710,550,390

    Kaua’i
    dh = 1898-1598
    step = dh/4
    new ages: Kaua’i,1039,1898,1823,1748,1673,1598

    Wai’anae
    dh = 2731-1231
    step = dh/3
    new ages: Wai’anae,,,2731,2231,1731,1231

    Ko’olau
    dh = 1480-960
    step = dh/2
    new ages: Ko’olau,,,452,1480,1220,960

    W. Moloka’i
    dh = 1921-421
    step = dh/2 
    new ages: W. Moloka’i,,,,1921,1171,421

Removed island entries:

    Mahukona is listed at 47m during 1-2 Ma
    Kohala is listed as 534m during 1-2 Ma

    However, C96 lists the ages for both islands as 0.6 Ma (see Volcanoes 123 and 124 in Table 1).

    See also:
    Garcia, M.O., Hanano, D., Flinders, A. et al. Age, geology, geophysics, and geochemistry of Mahukona Volcano, Hawai`i. Bull Volcanol 74, 1445–1463 (2012). https://doi.org/10.1007/s00445-012-0602-4

    We therefore removed the entries for Mahukona and Kohala for the 1-2 Ma time bin. Their entries for the 0-1 Ma time bin remain.



# Region definitions

Index   Letter  RegionName      FirstRow    LastRow     FirstIsland     LastIsland
-------------------------------------------------------------------------------------------
0       G       Gardner         24          35          Maro            LaPerouse 
1       N       Necker          36          44          Necker          Nihoa
2       K       Kaua'i          45          47          Kaula           Kaua'i
3       O       O'ahu           48          51          Ka'ena          Penguin Bank
4       M       Maui Nui        52          57          W. Moloka'i     Kaho'olawe
5       H       Hawai'i         58          63          Mahukona        Kilauea  
6       Z       Non-Hawaiian    NA          NA          NA              NA    

NOTES:
Row codes correspond to the spreadsheet for CP02.



# Island ages

Index   Regions     MeanAge MinAge  MaxAge  Reference
-----------------------------------------------------
1       GNKOMHZ     1.2     1.1     1.3     LM17
2       GNKOM-Z     2.55    2.10    3.00    LM17
3       GNKO--Z     4.135   3.93    4.34    LM17
4       GNK---Z     6.15    6.00    6.30    LM17
5       GN----Z     11.5    11.0    12.0    CP02 
6       G-----Z     20.5    20.0    21.0    CP02
7       ------Z     32.0    30.0    34.0    C96

NOTES:
We used mean ages from LM17 for K, O, M, H. We used the mean of the bin ages in the CP02 spreadsheet for G and N. For example, an island in bin 19 is assumed to be between 19 and 20 Ma, so we choose 19.5 Ma as the age. We assumed Z (non-Hawaiian regions) are infinitely old. All Hawaiian islands were submerged 32 (30, 34) Ma, based on C96.



# Island features

Type    Rel.    Index   Unit        Name
--------------------------------------------------------------
Quant.  Within  1       km              Log mean elevation
Quant.  Within  2       Myr             Log mean age
Cat.    Within  1       0=no, 1=yes     High island?
Cat.    Within  2       0=no, 1=yes     Uplift?
Quant.  Between 1       km              Log distance
Quant.  Between 2       Myr             Log diff. mean age
Cat.    Between 1       0=no, 1=yes     In/out of Hawaiian Arch.?
Cat.    Between 2       0=no, 1-yes     Old-to-young?

NOTE:
QW1 uses mean peak elevation among all islands in region for a given time interval
QW2 uses mean age of island for a given time interval (e.g. Hawaii has mean age of 0.6 during [0.0, 1.2])
CW1 uses elevation of >1000m (approx. elev. in Oahu) to define High Island status
CW2 is yes if any region is in uplift phase during interval
QB1 uses coast-to-coast distances (may change to center-center distances)
QB2 is based off QW2
CB1 is 1 if the region pair involves Z, and 0 otherwise
CB2 is 1 for region pair i -> j if i is older than j

For quantitative features, region Z is associated with the mean-value over all times. This means the feature for region Z has no effect o the rate.
For categorical features, region Z is treated as an old, low island, not undergoing uplift, and requires long distance dispersal.
```
