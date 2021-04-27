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

touch ${outDir}/slacks.txt
for c in {10..30..5}
do
	echo
	echo Doing slack of $c%
	SLACK=$c
        export TMGN=$(awk "BEGIN {printf \"%.2f\n \", $CLK_PERIOD * $SLACK / 100}");
	
	rm SDD/*
	
	pt_shell -f ./tcl/PT_scriptsd.tcl > "${outDir}/pt_sl${SLACK}.txt"
	echo Finished PrimeTime
	tmax -shell ./tcl/sddatpg.tcl > "${outDir}/tmax_sl${SLACK}.txt"
	echo Finished TetraMax

	cat ${outDir}/tmax_sl${SLACK}.txt | grep SDQL | column | cut -d " " -f3 | xargs echo $c 
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
	echo
	echo Doing $patterns patterns

	tmax -shell ./tcl/sddatpg.tcl > "${outDir}/tmax_pat${patterns}.txt"
	echo Finished TetraMax

	cat ${outDir}/tmax_pat${patterns}.txt | grep SDQL | column | cut -d " " -f3 | xargs echo $patterns
done

echo
echo Starting Time
export patterns=200
for time in $(seq 0.01 0.01 0.5)
do
	echo
	echo Doing $time seconds

	tmax -shell ./tcl/sddatpg.tcl > "${outDir}/tmax_tm${time}.txt"
	echo Finished TetraMax

	cat ${outDir}/tmax_tm${time}.txt | grep SDQL | column | cut -d " " -f3 | xargs echo $time
done

echo Done
exit 0
