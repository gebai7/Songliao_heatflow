@echo off

gmt begin xianguanxing1 eps
gmt set FORMAT_GEO_MAP dddA
gmt gmtset MAP_GRID_PEN=0.05p,black,dashed
gmt coast  -R-180/180/-55/80 -JCyl_stere/0/45/12c -Bxa60f30g60 -Byafg -A5000 -W0.1p,black -G255/250/220 -S220/255/255 -C224/255/255 -N1/0.1p -I1/0.15p,130/255/255 -N1/0.1p -Lg-140/-45+c11+w5000k+f+u  -Tdg165/75+w15p+f1
gmt makecpt -Cjet -T0/1/0.1
gmt plot corr.dat -Baf -Sc0.05c  -C 
gmt colorbar  -Bxaf+l"(Heat flow (mW/m^2))"  -DJMB+w5c -S
gmt end show
