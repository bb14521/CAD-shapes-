#!/bin/bash\
#!/bin/bash

echo Content-type: text/html 
echo 
echo

# removing old files.
rm -f join.g
rm -f rt*

rt=rtFile

cat <<EOF | env /usr/brlcad/bin/mged -c join.g
in s1 rpp -150 150 0 100 0 30
in s2 rpp -60 60 0 100 30 80
in s3 rcc 0 0 80 0 100 0 60 
in s4 rcc 0 0 80 0 100 0 30 
in s5 rcc -100 50 0 0 0 30 20 
in s6 rcc 100 50 0 0 0 30 20
r region u s1 u s2 u s3 
r region1 u region - s4 - s5 - s6 
mater region1 plastic 165 0 0 0
B region1 
ae 243 35
saveview $rt
EOF

sed '2cenv /usr/brlcad/bin/rt -M \\' $rt > tempFile1

rm $rt

# changing name of temporary file to that of original file.
mv tempFile1 $rt

# give executable permissions to raytrace file.
chmod 777 $rt

# executing raytrace file. This will produce raw image in .pix format
# and a log
#file.
sh $rt

# converting .pix file to png image using BRLCAD commands.
env /usr/brlcad/bin/pix-png < $rt.pix > $rt.png

# open png image in a frame buffer. Currently not required.
#env /usr/brlcad/bin/png-fb $rt.png


# copying final image to public_html for displaying on browser.
cp $rt.png ../cgi-images/

# using html <img src tag, display image on browser.
echo "<img src = ../cgi-images/$rt.png"

echo "<h1>bbr</h1>"

