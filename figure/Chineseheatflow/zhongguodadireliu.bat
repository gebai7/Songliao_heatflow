@echo off





gmt begin zhongguoreliu jpg,pdf,eps
gmt set FORMAT_GEO_MAP dddA
gmt gmtset MAP_GRID_PEN=0.05p,black,dashed

gmt coast  -R73/135/18/54 -JM12c -Bxa80f80g20 -Byafg -A2000 -W0.1p,black -G244/243/239 -S220/255/255 -C224/255/255 -I1/0.15p,130/255/255  -N1/0.1p -N2/0.1p -ECN+p0.3p,black+g255/250/220 -ETW+p0.3p,black+g255/250/220 -Lg85/11+c11+w900k+f+u  -Tdg131/52+w20p+f1
gmt plot CN-border-La.gmt -W0.1p,black

gmt makecpt -Cjet -T30/120/1
gmt plot zhongguodadireliu.dat -Baf -Sc0.1c  -C -W0.01p,black
gmt colorbar  -Bxaf  -DJMB+w5c 


gmt inset begin -DjRB+w1.8c/2.2c -F+p0.5p
    gmt coast -JM? -R105/123/3/24 -G244/243/239 -S220/255/255 -Df  -ECN+p0.3p,black+g255/250/220 -ETW+p0.3p,black+g255/250/220
    gmt plot CN-border-La.gmt -W0.1p
gmt inset end



gmt end show


