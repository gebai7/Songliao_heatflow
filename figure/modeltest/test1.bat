@echo off

set GMT_SESSION_NAME=3696

gmt begin meiguo jpg
gmt gmtset MAP_FRAME_PEN 1p
gmt gmtset MAP_FRAME_TYPE plain
gmt set PS_CHAR_ENCODING Standard+
gmt set FONT_TITLE 24p,41,black FONT_LABEL 16p,39,black
gmt coast -JM8c -R-130/-90/27/55 -GWHITE -S224/255/255 -W1/0.1p,black -Bya -Bxa -BWSen+t"" 
	echo -118 35 -102  47 | gmt plot -Sr+s -W1p,black
gmt makecpt -Cjet -T40/110/1
gmt plot meiguodaquyu.dat -Baf -Sc0.1c  -C
gmt colorbar  -Bxaf+l" "  -DJMB+w5c


gmt end show



gmt begin meiguo1 jpg
gmt gmtset MAP_FRAME_PEN 1p
gmt gmtset MAP_FRAME_TYPE plain
gmt set PS_CHAR_ENCODING Standard+
gmt set FONT_TITLE 24p,41,black FONT_LABEL 16p,39,black
gmt coast -JM8c -R-130/-90/27/55 -GWHITE -S224/255/255 -W1/0.1p,black -Bya -Bxa -BWSen+t"" 
	echo -118 35 -102  47 | gmt plot -Sr+s -W1p,black
gmt makecpt -Cjet -T40/110/1
gmt plot meiguodaquyu.dat -Baf -Sc0.07c  -Ggray
gmt colorbar  -Bxaf+l" "  -DJMB+w5c
gmt makecpt -Cjet -T40/110/1
gmt plot meiguochazhi.dat -Baf -Sc0.1c  -C
gmt colorbar  -Bxaf+l" "  -DJMB+w5c

gmt end show


gmt begin meiguo2 jpg
gmt gmtset MAP_FRAME_PEN 1p
gmt gmtset MAP_FRAME_TYPE plain
gmt set PS_CHAR_ENCODING Standard+
gmt set FONT_TITLE 24p,41,black FONT_LABEL 16p,39,black
gmt coast -JM8c -R-130/-90/27/55 -GWHITE -S224/255/255 -W1/0.1p,black -Bya -Bxa -BWSen+t"" 
	echo -118 35 -102  47 | gmt plot -Sr+s -W1p,black
gmt makecpt -Cjet -T40/110/1
gmt plot meiguodaquyu.dat -Baf -Sc0.07c  -Ggray
gmt colorbar  -Bxaf+l" "  -DJMB+w5c
gmt makecpt -Cjet -T40/110/1
gmt plot meiguoDNN.dat -Baf -Sc0.1c  -C
gmt colorbar  -Bxaf+l" "  -DJMB+w5c

gmt end show

gmt begin meiguo3 jpg
gmt gmtset MAP_FRAME_PEN 1p
gmt gmtset MAP_FRAME_TYPE plain
gmt set PS_CHAR_ENCODING Standard+
gmt set FONT_TITLE 24p,41,black FONT_LABEL 16p,39,black
gmt coast -JM8c -R-130/-90/27/55 -GWHITE -S224/255/255 -W1/0.1p,black -Bya -Bxa -BWSen+t"" 
	echo -118 35 -102  47 | gmt plot -Sr+s -W1p,black
gmt makecpt -Cjet -T40/110/1
gmt plot meiguodaquyu.dat -Baf -Sc0.07c  -Ggray
gmt colorbar  -Bxaf+l" "  -DJMB+w5c
gmt makecpt -Cjet -T40/110/1
gmt plot meiguobp.dat -Baf -Sc0.1c  -C
gmt colorbar  -Bxaf+l" "  -DJMB+w5c

gmt end show