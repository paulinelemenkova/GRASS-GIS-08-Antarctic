#!/bin/sh

# Subset via GMT:
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R-180/180/-90/-60 -Ga_relief.nc
#
gdalinfo a_relief.nc

# gdalwarp code to convert GeoTIFF file from XY Cartesian to WGS84, from NetCDF to GeoTIFF
gdalwarp -t_srs EPSG:4326 a_relief.nc a_relief_wgs84.tif
#
gdalinfo a_relief_wgs84.tif

# re-projecting to UPS projection (Universal Polar Stereographic)
gdalwarp -t_srs '+proj=ups +south +datum=WGS84' a_relief_wgs84.tif a_relief_ups.tif -overwrite
# [-te xmin ymin xmax ymax]
#gdalwarp -t_srs '+proj=ups +south +datum=WGS84' -te -1800000 -900000 1800000 -600000 a_relief_wgs84.tif a_relief_ups.tif -overwrite

# import raster NetCDF file to GRASS via GDAL:
r.in.gdal a_relief_ups.tif out=a_relief_ups title="Antarctic ETOPO1" --overwrite

r.timestamp map=a_relief_wgs84 date='04 Dec 2020'
r.info a_relief_ups
# min = -7160  max = 4763

g.region raster=a_relief_ups -p

# r.region map=a_relief_ups n=-600000 s=-800000 w=-1800000 e=1800000

#g.proj -p
#g.proj -c epsg=4326 location=latlong
#g.mapset mapset=PERMANENT location=latlong
#r.in.gdal a_relief_ups.tif out=a_relief_ups title="Antarctic ETOPO1" -o --overwrite

# visualize raster
g.list rast
-
# min = 0  max = 14000
g.region raster=ant_sed_ups -p

d.erase
d.mon wx0
r.colors --help
r.colors a_relief_ups col=byr
d.rast a_relief_ups

d.redraw
# title
d.title map=a_relief_ups | d.text text="Antarctic" color="red" size=3

# isolines
r.contour a_relief_ups out=reliefAnt step=2000 --overwrite
d.vect reliefAnt color='100:93:134' width=0

# border box
v.in.region output=a_relief_ups_bbox
g.list vect
v.info map=a_relief_ups_bbox
d.vect a_relief_ups_bbox color=grey width=3 fill_color="none"

# grid
#d.grid size=90 border_color=grey width=0.1 fontsize=8 text_color=white

# legend min = -7054  max = 3972
d.legend raster=a_relief_ups range=-7160,4763 -d title=Topography,m title_fontsize=8 font=Arial fontsize=7 -t -b bgcolor=white label_step=1000 border_color=gray thin=8
# texts
d.text text="Antarctica" color='0:0:51' size=2.0 font=Arial
d.text text="ETOPO1" color='0:0:51' size=2.0 font=Arial
d.text text="1 arc minute grid" color='0:0:51' size=2.0 font=Arial
d.text text="Topography " color='0:0:51' size=2.0 font=Arial
d.text text="Scale: 1:10 000 000" color=blue size=2.0 font="Trebuchet MS"
d.text text="Atlantic Ocean" color=yellow size=2.5 font="Verdana" rotation=30
d.text text="Pacific Ocean" color=yellow size=2.5 font="Trebuchet MS" rotation=330
d.text text="Indian Ocean" color=yellow size=2.5 font="Trebuchet MS" rotation=55
d.text text="Scotia Sea" color=blue size=2.0 font="Trebuchet MS" rotation=45
d.text text="Weddell Sea" color=blue size=2.0 font="Trebuchet MS"
d.text text="Ross Sea" color=blue size=2.0 font="Trebuchet MS"
d.text text="Amundsen Sea" color=blue size=2.0 font="Trebuchet MS"
d.text text="Bellingshausen Sea" color=blue size=2.0 font="Trebuchet MS"
d.text text="Histogram" color=black size=2.0 font="Trebuchet MS" rotation=90

# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief
