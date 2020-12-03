#!/bin/sh
# raster NetCDF in WGS84 warped to UTM proj Zone 56 by GDAL:

gdalinfo bedmap2_grounded_bed_uncertainty.tif
# WGS84 warped to a UTM projection, Zone 56:
#gdalwarp -t_srs '+proj=utm +zone=52 +datum=WGS84' rt_relief.nc rt_relief_UTM52.nc

# import raster NetCDF file to GRASS via GDAL:
r.in.gdal bedmap2_grounded_bed_uncertainty.tif out=bedmap2_grounded_bed_uncertainty title="Antarctic Bedmap Coverage" --overwrite

r.timestamp map=bedmap2_coverage date='03 Dec 2020'
r.info bedmap2_grounded_bed_uncertainty
# min = 0  max = 65535

#gdalwarp -t_srs '+proj=ups +south +datum=WGS84' bedmap2_bed.tif bedmap2_bed_ups.tif
gdalinfo bedmap2_grounded_bed_uncertainty.tif

# GRASS GIS
# visualize raster
g.list rast
g.region raster=bedmap2_grounded_bed_uncertainty -p

# d.erase
d.mon wx0
r.colors --help
r.colors bedmap2_grounded_bed_uncertainty col=population
# ramp
# population
# population_dens
# plasma terrain rainbow etopo2
d.rast bedmap2_grounded_bed_uncertainty
d.redraw

# title
d.title map=bedmap2_bed | d.text text="Antarctic" color="red" size=3

# border box
v.in.region output=bedmap2_grounded_bed_uncertainty_bbox
#g.list vect
v.info map=bedmap2_grounded_bed_uncertainty_bbox
d.vect bedmap2_grounded_bed_uncertainty_bbox color=grey width=3 fill_color="none"

# grid
# d.grid size=90 border_color=grey width=0.1 fontsize=8 text_color=white

# legend min = -7054  max = 3972
d.legend raster=bedmap2_grounded_bed_uncertainty range=0,65535 -d title=Grounded_bed title_fontsize=8 font=Arial fontsize=7 -t -b -f bgcolor=white border_color=gray thin=8
# texts
d.text text="Grounded bed" color='0:0:51' size=2.0 font=Arial
d.text text="Uncertainty" color='0:0:51' size=2.0 font=Arial
d.text text="Bedmap2" color='0:0:51' size=2.0 font=Arial
d.text text="Scale: 1:10 000 000" color=blue size=2.0 font="Trebuchet MS"
# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief label_step=2500
