#!/bin/sh
# raster NetCDF in WGS84 warped to UTM proj Zone 56 by GDAL:

gdalinfo bedmap2_bed.tif
# WGS84 warped to a UTM projection, Zone 56:
#gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_relief.nc rt_relief_UTM52.nc

# import raster NetCDF file to GRASS via GDAL:
r.in.gdal bedmap2_bed.tif out=bedmap2_bed title="Antarctic Bedmap Topography" --overwrite
r.in.gdal bedmap2_bed_ups.tif out=bedmap2_bed_ups title="Antarctic Bedmap Topography" --overwrite

r.timestamp map=bedmap2_bed date='03 Dec 2020'
r.info bedmap2_bed
# min = -7054  max = 3972

gdalwarp -t_srs '+proj=ups +south +datum=WGS84' bedmap2_bed.tif bedmap2_bed_ups.tif
gdalinfo bedmap2_bed_ups.tif

# GRASS GIS
# visualize raster
g.list rast
g.region raster=bedmap2_bed -p

# d.erase
d.mon wx0
r.colors --help
r.colors bedmap2_bed_ups col=srtm_plus
# plasma terrain rainbow etopo2
d.rast bedmap2_bed_ups

# title
d.title map=bedmap2_bed | d.text text="Antarctic" color="red" size=3

# isolines
#r.contour bedmap2_bed out=reliefAnt step=2000 --overwrite
#d.vect reliefAnt color='100:93:134' width=0

# border box
v.in.region output=bedmap2_bed_bbox
g.list vect
v.info map=bedmap2_bed_bbox
d.vect bedmap2_bed_bbox color=grey width=3 fill_color="none"

# grid
# d.grid size=90 border_color=grey width=0.1 fontsize=8 text_color=white

# legend min = -7054  max = 3972
d.legend raster=bedmap2_bed range=-7054,3972 -d title=Topography,m title_fontsize=8 font=Arial fontsize=7 -t -b -f bgcolor=white label_step=1000 border_color=gray thin=8
# texts
d.text text="Antarctica" color='0:0:51' size=2.0 font=Arial
d.text text="Bed Topography" color='0:0:51' size=2.0 font=Arial
d.text text="Bedmap2" color='0:0:51' size=2.0 font=Arial
d.text text="Scale: 1:10 000 000" color=blue size=2.0 font="Trebuchet MS"
d.text text="Atlantic Ocean" color=yellow size=2.5 font="Verdana" rotation=30
d.text text="Pacific Ocean" color=yellow size=2.5 font="Trebuchet MS" rotation=330
d.text text="Indian Ocean" color=yellow size=2.5 font="Trebuchet MS" rotation=55
d.text text="Scotia Sea" color=white size=2.0 font="Trebuchet MS" rotation=45
d.text text="Weddell Sea" color=white size=2.0 font="Trebuchet MS"
d.text text="Ross Sea" color=white size=2.0 font="Trebuchet MS"
d.text text="Amundsen Sea" color=white size=2.0 font="Trebuchet MS"
d.text text="Bellingshausen Sea" color=white size=2.0 font="Trebuchet MS"

# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief
