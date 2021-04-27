cd outputs
for dir in path*; do
    cd $dir; echo "\n\n$dir"
    for file in tmax* ; do 
        echo $file 
        cat $file | grep "total faults\|Detected\|delay effectiveness\|SDQL\|internal patterns"
        echo
    done
    cd ..
done
cd .. 