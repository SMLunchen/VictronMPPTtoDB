#!/usr/bin/bash

#define Datasources
DS_VBAT="sql//mysql/host=127.0.0.1/dbname=solarstats/username=root/password=pass//stats/Timestamp/VBat/1"
DS_IBAT="sql//mysql/host=127.0.0.1/dbname=solarstats/username=root/password=pass//stats/Timestamp/IBat/1"
DS_VPho="sql//mysql/host=127.0.0.1/dbname=solarstats/username=root/password=pass//stats/Timestamp/VPho/1"
DS_IPho="sql//mysql/host=127.0.0.1/dbname=solarstats/username=root/password=pass//stats/Timestamp/IPho/1"
DS_WPho="sql//mysql/host=127.0.0.1/dbname=solarstats/username=root/password=pass//stats/Timestamp/WPho/1"
DS_WBat="sql//mysql/host=127.0.0.1/dbname=solarstats/username=root/password=pass//stats/Timestamp/WBat/1"
DS_WL="sql//mysql/host=127.0.0.1/dbname=solarstats/username=root/password=pass//stats/Timestamp/WL/1"
DS_IL="sql//mysql/host=127.0.0.1/dbname=solarstats/username=root/password=pass//stats/Timestamp/IL/1"

#plot combined
rrdtool graph chargercomb1m.png --imgformat=PNG --start=-30day --end=+1hours --width=1000 --height=600 \
--right-axis 1:-24 --right-axis-label "Ampere" \
--vertical-label "Volt" \
--alt-autoscale-max \
--slope-mode \
--font TITLE:12: \
--font AXIS:8: \
--font LEGEND:10: \
--font UNIT:8: \
--y-grid 0.1:10 \
           "DEF:vavg=$DS_VBAT:avg:AVERAGE" \
           "VDEF:min=vavg,MINIMUM" \
           "VDEF:max=vavg,MAXIMUM" \
		   "CDEF:vpredict=86400,-7,1800,vavg,PREDICT" \
		   "LINE1:min#00EE00:VBat Minimum" \
           "LINE1:max#EE0000:VBat Maximum" \
		   "LINE1:vpredict#0000FF:VBat Prediction" \
		   "LINE1:vavg#FF0000:VBat\n" \
		   "GPRINT:vavg:LAST: Current\: %2.2lf V %s"  \
		   "GPRINT:vavg:AVERAGE: Average\: %2.2lf V %s"  \
		   "GPRINT:vavg:MIN: Minumum\: %2.2lf V %s" \
		   "GPRINT:vavg:MAX: Maximum\: %2.2lf V %s\n"  \
		   "LINE1:24#C0C0C0" \
		   "DEF:iavg=$DS_IBAT:avg:AVERAGE" \
		   "CDEF:iavgoffset=iavg,24,+" \
		   "LINE1:iavgoffset#E411E4:IBat" \

#plot voltages
rrdtool graph chargervolt1m.png --imgformat=PNG --start=-30day --end=+1hours --width=1000 --height=600 \
--vertical-label "Volt" \
--alt-autoscale-max \
--slope-mode \
--font TITLE:12: \
--font AXIS:8: \
--font LEGEND:10: \
--font UNIT:8: \
--y-grid 0.1:10 \
           "DEF:vavg=$DS_VBAT:avg:AVERAGE" \
		   "DEF:vavgpho=$DS_VPho:avg:AVERAGE" \
           "VDEF:min=vavg,MINIMUM" \
           "VDEF:max=vavg,MAXIMUM" \
		   "CDEF:vpredict=86400,-7,1800,vavg,PREDICT" \
		   "LINE1:min#00EE00:VBat Minimum" \
           "LINE1:max#EE0000:VBat Maximum" \
		   "LINE1:vpredict#0000FF:VBat Prediction" \
		   "LINE1:vavg#FF0000:VBat\n" \
		   "GPRINT:vavg:LAST: Current\: %2.2lf V %s"  \
		   "GPRINT:vavg:AVERAGE: Average\: %2.2lf V %s"  \
		   "GPRINT:vavg:MIN: Minumum\: %2.2lf V %s" \
		   "GPRINT:vavg:MAX: Maximum\: %2.2lf V %s\n"  \
		   "LINE1:24#C0C0C0" \
   
		   
#Plot currents
rrdtool graph chargercurrent1m.png --imgformat=PNG --start=-30day --end=+1hours --width=1000 --height=600 \
--vertical-label "Ampere" \
--alt-autoscale-max \
--slope-mode \
--font TITLE:12: \
--font AXIS:8: \
--font LEGEND:10: \
--font UNIT:8: \
           "DEF:iavgbat=$DS_IBAT:avg:AVERAGE" \
           "DEF:iavgl=$DS_IL:avg:AVERAGE" \
           "DEF:iavgpho=$DS_IPho:avg:AVERAGE" \
		   "CDEF:iavglinvert=iavgl,-1,*" \
		   "AREA:iavgbat#FFA0A0" \
		   "LINE1:iavgbat#FF0000:Battery Current" \
		   "LINE1:iavgpho#00AA00:Solar Current" \
		   "LINE1:iavglinvert#0000AA:Load Current" \
		   "LINE1:0#000000" \

#Plot solarstats
rrdtool graph chargersolar1m.png --imgformat=PNG --start=-30day --end=+1hours --width=1000 --height=600 \
--vertical-label "Volt" \
--right-axis 1:20 \
--right-axis-label "Ampere" \
--alt-autoscale-max \
--slope-mode \
--font TITLE:12: \
--font AXIS:8: \
--font LEGEND:10: \
--font UNIT:8: \
--y-grid 0.1:10 \
           "DEF:vavgpho=$DS_VPho:avg:AVERAGE" \
           "DEF:iavgpho=$DS_IPho:avg:AVERAGE" \
		   "LINE1:vavgpho#AA0000:VPho" \
		   "LINE1:iavgpho#0000AA:IPho" \
		   
#plot Wattages		   
rrdtool graph chargerwatts1m.png --imgformat=PNG --start=-30day --end=+1hours --width=1000 --height=600 \
--vertical-label "Watts" \
--alt-autoscale-max \
--slope-mode \
--font TITLE:12: \
--font AXIS:8: \
--font LEGEND:10: \
--font UNIT:8: \
           "DEF:wavgbat=$DS_WBat:avg:AVERAGE" \
		   "DEF:wavgpho=$DS_WPho:avg:AVERAGE" \
		   "DEF:wavgl=$DS_WL:avg:AVERAGE" \
		   "CDEF:wavglinvert=wavgl,-1,*" \
		   "AREA:wavgbat#FFA0A0" \
		   "LINE1:wavgbat#FF0000:P Battery" \
		   "LINE1:wavgpho#00AA00:P Solar" \
		   "LINE1:wavglinvert#0000AA:P Load" \
		   "LINE1:0#000000" \
