#!/bin/sh
gdalinfo bedmap2_icemask_grounded_and_shelves.tif

# import raster NetCDF file to GRASS via GDAL:
r.in.gdal bedmap2_icemask_grounded_and_shelves.tif out=bedmap2_icemask_grounded_and_shelves title="Antarctic" --overwrite

r.timestamp map=bedmap2_icemask_grounded_and_shelves date='03 Dec 2020'
r.info bedmap2_icemask_grounded_and_shelves
# min = 0  max = 1

#gdalwarp -t_srs '+proj=ups +south +datum=WGS84' bedmap2_bed.tif bedmap2_bed_ups.tif
gdalinfo bedmap2_icemask_grounded_and_shelves.tif

# GRASS GIS
# visualize raster
g.list rast
g.region raster=bedmap2_icemask_grounded_and_shelves -p

# d.erase
d.mon wx0
r.colors --help
r.colors bedmap2_icemask_grounded_and_shelves col=blues
# plasma terrain rainbow etopo2
d.rast bedmap2_icemask_grounded_and_shelves

# title
d.title map=bedmap2_icemask_grounded_and_shelves | d.text text="Antarctic" color="red" size=3

# border box
v.in.region output=bedmap2_bed_bbox
g.list vect
v.info map=bedmap2_bed_bbox
d.vect bedmap2_bed_bbox color=grey width=3 fill_color="none"

# isolines
r.contour bedmap2_surface out=bedmap2_surface_cont step=100 --overwrite
d.vect bedmap2_surface_cont color='100:93:134' width=0

# legend min = -7054  max = 3972
d.legend raster=bedmap2_bed range=-7054,3972 -d title=Topography,m title_fontsize=8 font=Arial fontsize=7 -t -b -f bgcolor=white label_step=1000 border_color=gray thin=8
# texts
d.text text="Icemask grounded" color='0:0:51' size=2.0 font=Arial
d.text text="and shelves" color='0:0:51' size=2.0 font=Arial
d.text text="Bedmap2" color='0:0:51' size=2.0 font=Arial
d.text text="Scale: 1:10 000 000" color=blue size=2.0 font="Trebuchet MS"

# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief
