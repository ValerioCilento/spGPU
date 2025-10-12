#!/bin/bash

echo "Running vsim.sh..."

LIB_NAME="work"
LIB_PATH=$(pwd)/$LIB_NAME


if [ -d $LIB_PATH ]
then 
	echo "$LIB_NAME already exists"
else 
	vlib $LIB_PATH
fi

vmap $LIB_NAME $LIB_PATH

vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/acc_RTL/circle_hw_accelerator/empty_circle/circle_acc.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/acc_RTL/circle_hw_accelerator/filled_circle/filled_circle_acc.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/acc_RTL/fill_hw_accelerator/edge_fill_v2.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/acc_RTL/fill_hw_accelerator/minmax.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/acc_RTL/fill_hw_accelerator/edge_fill_top_v2.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/acc_RTL/line_hw_accelerator/line_acc.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/sp-pkg.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/sp-pipe.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/sp-exec.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../RTL/sp-core.vhd || exit 1
vcom -2008 -quiet -suppress 2583 -work $LIB_NAME $LIB_PATH/../../tb/tb_spCORE.vhd || exit 1



vsim $LIB_NAME.tb_spCORE

echo "Exiting vsim.sh..."
