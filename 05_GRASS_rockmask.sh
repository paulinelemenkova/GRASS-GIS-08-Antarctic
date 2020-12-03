#!/bin/sh
# raster info:
gdalinfo bedmap2_rockmask.tif

# import raster NetCDF file to GRASS via GDAL:
r.in.gdal bedmap2_rockmask.tif out=bedmap2_rockmask title="Antarctic" --overwrite

r.timestamp map=bedmap2_icemask_grounded_and_shelves date='03 Dec 2020'
r.info bedmap2_rockmask
# min = 0  max = 0

# GRASS GIS
# visualize raster
g.list rast
g.region raster=bedmap2_rockmask -p

# d.erase
d.mon wx0
r.colors --help
r.colors bedmap2_rockmask col=random
# plasma terrain rainbow etopo2
d.rast bedmap2_rockmask

# title
d.title map=bedmap2_rockmask | d.text text="Antarctic" color="red" size=3

# border box
v.in.region output=bedmap2_bed_bbox
g.list vect
v.info map=bedmap2_bed_bbox
d.vect bedmap2_bed_bbox color=grey width=3 fill_color="none"

# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief
