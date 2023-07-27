@echo off

set GMT_SESSION_NAME=3696

gmt begin quanqiureliu jpg
gmt gmtset MAP_FRAME_PEN 1p
gmt gmtset MAP_FRAME_TYPE plain
gmt set PS_CHAR_ENCODING Standard+
gmt set FONT_TITLE 24p,41,black FONT_LABEL 16p,39,black
gmt coast -JN0/10c -Rg -G255/250/205 -S224/255/255 -W1/0.1p,black -Bya30g30 -Bxag -BWSen+t"" 
gmt makecpt -Cjet -T10/180/1
gmt plot globel.dat -Baf -Sc0.05c  -C 
gmt colorbar  -Bxaf+l" (m)"  -DJMB+w5c

gmt end 



gmt begin quanqiureliu2 pdf,eps
gmt set FORMAT_GEO_MAP dddA
gmt gmtset MAP_GRID_PEN=0.05p,black,dashed
gmt coast  -R-180/180/-55/80 -JCyl_stere/0/45/12c -Bxa60f30g60 -Byafg -A5000 -W0.1p,black -G255/250/220 -S220/255/255 -C224/255/255 -I1/0.15p,130/255/255 -N1/0.1p -Lg-140/-45+c11+w5000k+f+u  -Tdg165/75+w15p+f1
gmt makecpt -Cjet -T10/180/1
gmt plot globel.dat -Baf -Sc0.05c  -C 
gmt colorbar  -Bxaf  -DJMB+w5c 
gmt end show
