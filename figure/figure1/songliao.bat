@echo off

gmt begin songliao eps
gmt gmtset MAP_GRID_PEN=0.05p,black,dashed

gmt makecpt -Cglobe -T-6000/6000
gmt grdimage @earth_relief_01m -JM15c -R115/135/41/51 -Bxafg -Byafg -I+d
gmt colorbar -Bxa2000

gmt coast -R115/135/41/51 -N1/1.5p,black,- 
gmt plot songliaobianjie.dat -W2p,black



gmt inset begin -DjTR+w5.1c/3.8c+o0.2p -F+gwhite+p3p
gmt grdimage @earth_relief_01m  -R73/135/18/54 -JM?
gmt coast -R73/135/18/54 -N1/1p,black 
echo 115 41 135 51 | gmt plot -Sr+s -W1p,blue
gmt inset end




gmt end show
