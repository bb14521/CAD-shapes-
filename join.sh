#!/bin/bash

# removing old files.
rm -f join.g
rm -f rt*

rt=rtFile

cat <<EOF | mged -c join.g
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
ae 25 35
saveview $rt
EOF

# give executable permissions to raytrace file.
chmod 755 $rt

# executing raytrace file. This will produce raw image in .pix format
# and a log
#file.
sh $rt

# converting .pix file to png image using BRLCAD commands.
pix-png < $rt.pix > $rt.png

# open png image in a frame buffer. Currently not required.
#env /usr/brlcad/bin/png-fb $rt.png

shotwell $rt.png
