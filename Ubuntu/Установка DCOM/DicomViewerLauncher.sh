#!/bin/sh

path=$0
while [ -L $path ]
do
    path=`readlink $path`
done

viewer_bin=`dirname $path`

export LD_LIBRARY_PATH=$viewer_bin:$LD_LIBRARY_PATH
#export QT_PLUGIN_PATH=.
$viewer_bin/Viewer
