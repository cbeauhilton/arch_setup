#!/bin/sh

# This part is probably not necessary - "SECONDS" automatically starts at zero.
# The command here is mostly to remind me that you can reset the timer to zero at any point in the script.
SECONDS=0

mkdir ~/Music/VGM/
cd ~/Music/VGM/

# Recursively search all the systems of interest on xyz.joshw.info (see joshw.txt for list)
# and download all .7z files to the VGM directory
wget -r -np -t1 -N -l3 -e robots=off -A.7z -i ~/Documents/GitHub/arch_setup/music/joshw.txt

# Delete any empty directories that were made
find . -type d -empty -delete

# The SPC files get crazy when unarchived if not put into their own directories first
# This makes new directories for all the .7z files and moves the files into them
# find spc.joshw.info/*/* -prune -type f -exec sh -c 'mkdir -p "${0%.*}" && mv "$0" "${0%.*}"' {} \;
find . -prune -type f -exec sh -c 'mkdir -p "${0%.*}" && mv "$0" "${0%.*}"' {} \;
#FYI: not all the joshw.info files are raw SPC/NSF/etc. - there are mp3s, "minisnsf" files, and a few others.

# This unarchives all the .7z into the directories they are found in
find . -name "*.7z" -type f -execdir 7z -y x {} \;

# Delete the now-unneeded archives
find . -name "*.7z" -type f -delete

# Useful when debugging
# find . -type f -not -name "*.7z" -delete

if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)" 
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
else
    echo "Completed in $SECONDS seconds"
fi
