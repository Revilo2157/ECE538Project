echo Got $# arguments


if [ $# -ne 1 ]; then
        echo Not enough arguments
        exit 1
fi

export outDir=outputs/pathdelay_${1}

export CLK_PERIOD=$(awk "BEGIN {printf \"%.2f\n \", $1 / 100}")
echo Clock Period of: $CLK_PERIOD

rm -r $outDir
mkdir $outDir

echo

for (( c=50; c<=300; c+=50 ))
do
	echo Doing $c
        export NUM_PATHS=$c

	rm pathdelay/*

	pt_shell -f ./scripts/PT_scriptpd.tcl > "${outDir}/pt_${NUM_PATHS}.txt"
	echo Finished PrimeTime
	tmax -shell ./scripts/path_delay_atpg.tcl > "${outDir}/tmax_${NUM_PATHS}.txt"
	echo Finished TetraMax
done

echo Done
exit 0

