#!/bin/sh
# raster NetCDF in WGS84 warped to UTM proj Zone 56 by GDAL:

gdalinfo bedmap2_thickness.tif
# WGS84 warped to a UTM projection, Zone 56:
#gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_relief.nc rt_relief_UTM52.nc

# import raster NetCDF file to GRASS via GDAL:
r.in.gdal bedmap2_thickness.tif out=bedmap2_thickness title="Antarctic Bedmap Thickness" --overwrite

r.timestamp map=bedmap2_thickness date='03 Dec 2020'
r.info bedmap2_thickness
#  min = 0  max = 4621

g.region raster=bedmap2_thickness -p

# GRASS GIS
# visualize raster
g.list rast

# d.erase
d.mon wx0
r.colors --help
r.colors bedmap2_thickness col=roygbiv
# plasma terrain rainbow etopo2
d.rast bedmap2_thickness
d.title map=bedmap2_thickness | d.text text="Antarctic" color="red" size=3

# border box
v.in.region output=bedmap2_thickness_bbox
g.list vect
v.info map=bedmap2_thickness_bbox
d.vect bedmap2_thickness_bbox color=grey width=3 fill_color="none"

# grid
#d.grid size=500000 border_color=grey width=0.1 fontsize=8 text_color=white

# legend min = -7054  max = 3972
d.legend raster=bedmap2_thickness range=1,4621 -d title=Thickness,m title_fontsize=8 font=Arial fontsize=7 -t -b -f bgcolor=white label_step=250 border_color=gray thin=8
# texts
d.text text="Antarctica" color='0:0:51' size=2.0 font=Arial
d.text text="Bedmap Thickness" color='0:0:51' size=2.0 font=Arial
d.text text="Bedmap2" color='0:0:51' size=2.0 font=Arial
d.text text="Scale: 1:10 000 000" color=blue size=2.0 font="Trebuchet MS"

# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief
