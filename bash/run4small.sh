if [ $# -ne 1 ]; then 
	echo Not enough arguments got $#
	exit 1
fi

[ $? == 1 ] && exit 1

export CLK_PERIOD=$1
echo Clock Period of: $CLK_PERIOD 

export outDir=outputs/${top}

rm -r $outDir > /dev/null
mkdir $outDir

echo Starting Slack
export patterns=200
export time=5
for c in {10..30..5}
do
	echo Doing slack of $c%
	SLACK=$c
        export TMGN=$(awk "BEGIN {printf \"%.2f\n \", $CLK_PERIOD * $SLACK / 100}");
	
	rm SDD/*
	
	pt_shell -f ./tcl/PT_scriptsd.tcl > "${outDir}/pt_sl${SLACK}.txt"
	echo Finished PrimeTime
	tmax -shell ./tcl/sddatpg.tcl > "${outDir}/tmax_sl${SLACK}.txt"
	echo Finished TetraMax
done

echo
echo Starting Patterns
rm SDD/*
export c=20
SLACK=$c
	export TMGN=$(awk "BEGIN {printf \"%.2f\n \", $CLK_PERIOD * $SLACK / 100}");
pt_shell -f ./tcl/PT_scriptsd.tcl > "${outDir}/pt_sl${SLACK}.txt"
	echo Finished PrimeTime

for patterns in {100..400..25}
do
	echo Doing $patterns patterns

	tmax -shell ./tcl/sddatpg.tcl > "${outDir}/tmax_pat${patterns}.txt"
	echo Finished TetraMax
done

echo
echo Starting Time
export patterns=200
for time in {1..10..1}
do
	echo Doing $time seconds

	tmax -shell ./tcl/sddatpg.tcl > "${outDir}/tmax_tm${time}.txt"
	echo Finished TetraMax
done

echo Done
exit 0
