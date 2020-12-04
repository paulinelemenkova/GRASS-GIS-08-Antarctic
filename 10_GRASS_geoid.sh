#!/bin/sh
# import raster NetCDF file to GRASS via GDAL:
r.in.gdal gl04c_geiod_to_WGS84.tif out=gl04c_geiod_to_WGS84 title="Antarctic Geoid" -o --overwrite

r.timestamp map=gl04c_geiod_to_WGS84 date='04 Dec 2020'

r.info gl04c_geiod_to_WGS84
# min = -65.86805  max = 36.63612

g.region raster=gl04c_geiod_to_WGS84 -p

g.list rast

# display
d.erase
d.mon wx0
r.colors --help
r.colors gl04c_geiod_to_WGS84 col=bcyr
# celcius bcyr
d.rast gl04c_geiod_to_WGS84
d.redraw
d.title map=gl04c_geiod_to_WGS84 | d.text text="Antarctic" color="red" size=3

# isolines
r.contour gl04c_geiod_to_WGS84 out=reliefAnt step=2 --overwrite
d.vect reliefAnt color='100:93:134' width=0

# border box
v.in.region output=gl04c_geiod_to_WGS84_bbox --overwrite
#g.list vect
#v.info map=gl04c_geiod_to_WGS84_bbox
d.vect gl04c_geiod_to_WGS84_bbox color=grey width=3 fill_color="none" --overwrite

# grid
#d.grid size=90 border_color=grey width=0.1 fontsize=8 text_color=white

# legend
d.legend raster=gl04c_geiod_to_WGS84 range=-66,37 -d title=Geoid,m title_fontsize=8 font=Arial fontsize=7 -t -b bgcolor=white label_step=5 border_color=gray thin=8
# texts
d.text text="Antarctica" color='0:0:51' size=2.0 font=Arial
d.text text="Geoid" color='0:0:51' size=2.0 font=Arial
d.text text="Undulations" color='0:0:51' size=2.0 font=Arial
d.text text="gl04c_geiod_to_WGS84 " color='0:0:51' size=2.0 font=Arial
d.text text="Scale: 1:10 000 000" color=blue size=2.0 font="Trebuchet MS"
d.text text="Atlantic Ocean" color=blue size=2.5 font="Verdana" rotation=30
d.text text="Pacific Ocean" color=blue size=2.5 font="Trebuchet MS" rotation=330
d.text text="Indian Ocean" color=blue size=2.5 font="Trebuchet MS" rotation=55
d.text text="Scotia Sea" color=white size=2.0 font="Trebuchet MS" rotation=45
d.text text="Weddell Sea" color=blue size=2.0 font="Trebuchet MS"
d.text text="Ross Sea" color=white size=2.0 font="Trebuchet MS"
d.text text="Amundsen Sea" color=blue size=2.0 font="Trebuchet MS"
d.text text="Bellingshausen Sea" color=blue size=2.0 font="Trebuchet MS"
d.text text="Histogram" color=black size=2.0 font="Trebuchet MS" rotation=90
