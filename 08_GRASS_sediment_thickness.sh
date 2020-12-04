#!/bin/sh

# Subset via GMT:
gmt grdcut GlobSed-v2.nc -R-180/180/-80/-60 -Gant_sed.nc

# gdalwarp code to convert GeoTIFF file from XY Cartesian to WGS84, from NetCDF to GeoTIFF
gdalwarp -t_srs EPSG:4326 ant_sed.nc ant_sed_wgs84.tif

# check up the projection
gdalinfo ant_sed_wgs84.tif

# re-projecting to UPS projection (Universal Polar Stereographic)
gdalwarp -t_srs '+proj=ups +south +datum=WGS84' ant_sed_wgs84.tif ant_sed_ups.tif -overwrite

# check up the projection
gdalinfo ant_sed_ups.tif

# import raster NetCDF file to GRASS via GDAL:
r.in.gdal ant_sed_ups.tif out=ant_sed_ups title="Antarctic Sdiment Thickness" --overwrite

r.timestamp map=ant_sed_ups date='04 Dec 2020'
r.info ant_sed_ups
# min = 0  max = 14000

# visualize raster
g.list rast
r.info ant_sed_ups
# min = 0  max = 14000
g.region raster=ant_sed_ups -p

d.erase
d.mon wx0
r.colors --help
r.colors ant_sed_ups col=viridis
# plasma terrain rainbow etopo2
d.rast ant_sed_ups
# title
d.title map=ant_sed_ups | d.text text="Antarctic" color="red" size=3

# isolines
r.contour ant_sed_ups out=reliefAnt step=1500 --overwrite
d.vect reliefAnt color='100:93:134' width=0

# border box
v.in.region output=ant_sed_ups_bbox
g.list vect
v.info map=ant_sed_ups_bbox
d.vect ant_sed_ups_bbox color=grey width=3 fill_color="none"

# grid
# d.grid size=500000 border_color=grey width=0.1 fontsize=8 text_color=white

# legend min = -7054  max = 3972
d.legend raster=ant_sed_ups range=0,14000 -d title=Sediments,m title_fontsize=8 font=Arial fontsize=7 -t -b -f bgcolor=white label_step=1000 border_color=gray thin=8
# texts
d.text text="Antarctica" color='0:0:51' size=2.0 font=Arial
d.text text="Sediment Thickness" color='0:0:51' size=2.0 font=Arial
d.text text="5 arc minute grid" color='0:0:51' size=2.0 font=Arial
d.text text="GlobSed " color='0:0:51' size=2.0 font=Arial
d.text text="Scale: 1:10 000 000" color=blue size=2.0 font="Trebuchet MS"
d.text text="Atlantic Ocean" color=yellow size=2.5 font="Verdana" rotation=30
d.text text="Pacific Ocean" color=yellow size=2.5 font="Trebuchet MS" rotation=330
d.text text="Indian Ocean" color=yellow size=2.5 font="Trebuchet MS" rotation=55
d.text text="Scotia Sea" color=white size=2.0 font="Trebuchet MS" rotation=45
d.text text="Weddell Sea" color=white size=2.0 font="Trebuchet MS"
d.text text="Ross Sea" color=white size=2.0 font="Trebuchet MS"
d.text text="Amundsen Sea" color=white size=2.0 font="Trebuchet MS"
d.text text="Bellingshausen Sea" color=white size=2.0 font="Trebuchet MS"
d.text text="Histogram" color=black size=2.0 font="Trebuchet MS" rotation=90

# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief
