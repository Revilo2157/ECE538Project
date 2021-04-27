if [ $# -ne 2 ]; then
	echo "Need top level module name, and clock pin"
	exit 1
fi

export top=$1
export source=$(realpath "rtl/${top}")
export clk=$2

cd compilation 

# Compile the Verilog
echo Compiling $top
dc_shell -f ../tcl/DC_script.tcl > compile.txt
grep Error compile.txt

echo 

# Insert Scan
echo "Inserting Scan Cells"
dc_shell -f ../tcl/scan_insertion_DC.tcl > scan.txt
grep Error scan.txt

# Move Required Components for next step
rm -r ../gate/$top
mkdir ../gate/$top > /dev/null
cp ${top}_scan.v ../gate/$top/
cp ${top}.spf ../gate/$top/

cd ..

