#!/bin/bash
#
# /home/john/Images/dessins_moi/last-20_pixx/11_Nature-Paysage/30_Ciel-Nuages/11/20181108_083001-4ss.jpg
# hm3.sh -s 1199 -b 8 -c5.6,16 -q2 -f1 -o2
#
# x eviter les coutures en dupliquant les bords, puis les rognant dans hm.py ..
#


help() {
	echo "# Usage: $0 -opt.. file.jpg
	-q 1,2,3 ... paint_daub parms set
	-d parms ... paint_daub parms: sigma, DI
	-D parms ... paint_daub all parms
	-r 1,2,3 ... resize: 1111,999 or 1555
	-s size  ... resize  (999x999, xx%)
	-c ampl,frq. crease fx parms: amplitude, freq
	-f 1,2,3 ... sharpen/deblur parms set [1:soft 2:dur 3:softer, 4:deblur]
	-o 1,2 ..... smooth parms set [1:small 2:heavy 3:more, 4:photocomix]
	-w parms ... water fx: amplitude,_smoothness>=0,_angle
	-Q qual .... jpeg qual (85)
	-b n ....... enlarge bordure
"
}

[ $# = 0 ] && help && exit 2


q1="1,3,200,0.32,0.90,2.5,1,0,8"
q2="1,3,200,0.32,1.5,3.5,1,0,8"
q3="1,4,200,0.32,1.65,4.5,1,0,8"

r1=" -resize x1111"
r2=" -resize x999"
r3=" -resize x1555"

flt1="-fx_deblur 2,20,20,4.3,1,0,0,0"
flt2="-fx_deblur 2,20,20,0.5,1,0,0,0"
flt3="-fx_deblur 4,20,20,5,1,0,0,0"
flt4="-gcd_sharpen_gradient 1.49,1.76,0"

smo1="-fx_smooth_anisotropic 195,0.4,0.9,1,1.1,0.8,30,2,0,1,0,0"
smo2="-fx_smooth_anisotropic 195,0.4,0.9,4,1.1,0.8,30,2,0,1,0,0"
smo3="-fx_smooth_anisotropic 413,0.84,0.80,3.3,5.1,0.8,30,2,0,1,0,0"
smo4="-fx_smooth_anisotropic 314,0.5,0.63,0.60,2.35,0.8,30,2,0,1,1,0,1"
smo5="-fx_smooth_anisotropic 314,0.5,0.63,0.60,2.35,0.8,30,2,0,1,3,0,1"
smo6="-fx_smooth_anisotropic 60,0.16,0.63,0.6,2.35,0.8,30,2,0,1,1,0,1"

qual=85

opt="$2$3$4$5"
r="" #" -resize x666"
c=""
q=$q1
flt=""
smo=""
opts=""
bord=""
v=v
w=""

#set -x

while getopts 'q:r:s:d:D:c:Q:f:o:b:w:hv' opt; do
	case $opt in
		q) eval q=\$q$OPTARG; opts="$opts-q$OPTARG";;
		r) eval r=\$r$OPTARG;;
		s) r=" -resize $OPTARG";;
		d) q="1,3,200,0.32,$OPTARG,1,0,8"; opts="$opts-d$OPTARG";;
		D) q="$OPTARG,1,0,8";;
		c) c=" -fx_crease $OPTARG,0";;
		Q) qual=$OPTARG;;
		f) eval flt=\$flt$OPTARG; opts="$opts-f$OPTARG";;
		o) eval smo=\$smo$OPTARG; opts="$opts-o$OPTARG";;
		b) bord="$OPTARG";;
		v) v=;;
		w) w=" -water $OPTARG";;
		h) help; exit 0;;
		*) echo ???; help; exit 1;;
	esac
done


shift $((OPTIND-1))
file="$1"
[ -f "$file" ] || exit 1

f() {
echo gmic  -.jpg $c -samj_Barbouillage_Paint_Daub_en $q $flt $smo -output /tmp/hm.jpg,$qual
read
}


#read;set -x
#echo 0.;read

in=$file
if [ "$bord" ]; then
	hm.py - $bord < $file
	in=/tmp/hm-out.jpg
fi

#echo 1.;read
time convert $in $r  -quality $qual -.jpg |
gmic  -.jpg $c $w -samj_Barbouillage_Paint_Daub_en $q $flt $smo -output /tmp/hm.jpg,$qual #>/tmp/g 2>&1


#echo 2.;read

out=""

if [ "$bord" ]; then
	hm.py /tmp/hm.jpg -$bord
	cp /tmp/hm-new.jpg /tmp/hm.jpg
fi

#echo 3.;read
hm.py /tmp/hm.jpg



ps=""
f(){
echo -n "# view ? "
#read && {gmic /tmp/hm-new.jpg &}
if read icule; then
	gmic /tmp/hm-new.jpg &
	ps=$!
	sleep 5
fi
}

[ "$v" ] && {
echo "# view:"
gmic /tmp/hm-new.jpg &
ps=$!
sleep 5
}

echo "###"
[ "$opts" ] && opts=_$opts
f=$(basename $file | tr [A-Z] '[a-z]')
#echo "convert /tmp/hm-new.jpg -quality $qual /home/john/Images/dessins_moi/last-20_pixx/11_Nature-Paysage/30_Ciel-Nuages/11/${f/.jpg/-__.jpg}"

echo "# ~/john/Images/dessins_moi/last-20_pixx/11_Nature-Paysage/30_Ciel-Nuages/12_hm-test/${f/.jpg/-__.jpg}"
echo -n "# mv -> 20_pixx/11_Nature-Paysage/30_Ciel-Nuages/12_hm-test/ ? [entrer n.] "
[ "$v" ] && read n && [ "$n" ] && mv -vi /tmp/hm-new.jpg /home/john/Images/dessins_moi/last-20_pixx/11_Nature-Paysage/30_Ciel-Nuages/12_hm-test/${f/.jpg/-${n}_.jpg} &&

echo
echo mv /tmp/hm-new.jpg /home/john/Images/dessins_moi/last-20_pixx/11_Nature-Paysage/30_Ciel-Nuages/12_hm-test/${f/.jpg/-__.jpg}
echo "ls -l /tmp/hm-new.jpg /home/john/Images/dessins_moi/last-20_pixx/11_Nature-Paysage/30_Ciel-Nuages/12*/${f/.jpg/}*"

[ "$ps" ] && kill $ps
sleep 1




f(){


echo $opt | grep -q r1 && r=$r1
echo $opt | grep -q r2 && r=$r2
echo $opt | grep -q r3 && r=$r3

echo $opt | grep -q q1 && q=$q1
echo $opt | grep -q q2 && q=$q2
gmic -.jpg -samj_Barbouillage_Paint_Daub_en 1,3,200,0.32,1.5,3.5,1,0,8 /tmp/hm.jpg < /home/john/Images/dessins_moi/last-20_pixx/11_Nature-Paysage/30_Ciel-Nuages/11/20181108_083001-4ss.jpg


###

hm.sh -c 11.2,15 -s x888  -q2 '/home2/john/7777_apn/103___10/IMG_0234.JPG'  ++ brouillage, souplesse...

195,0.4,2,0.9,1,1.1,0.8,30,2,0,1,0
195,0.4,2,0.9,4,1.1,0.8,30,2,0,1,0

#set -x
# -resize x,y  x%,y%

[gmic]-1./fx_deblur/ac/ Apply command 'gui_parallel_overlap "deblur 2,20,20,0.5,1 c 0,255",0,0' on channel 'all' of image [0].
[gmic]-1./fx_smooth_anisotropic/*repeat/*local/ac/ Apply command 'repeat 0 smooth 195,0.4,0.9,1,1.1,0.8,30,2,0,1 done' on channel 'all' of image [0].
[gmic]-1./fx_smooth_anisotropic/*repeat/*local/ac/ Apply command 'repeat 0 smooth 195,0.4,0.9,4,1.1,0.8,30,2,0,1 done' on channel 'all' of image [0].


}
