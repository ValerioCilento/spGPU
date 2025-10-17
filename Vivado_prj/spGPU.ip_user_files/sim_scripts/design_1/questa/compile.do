vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_19
vlib questa_lib/msim/processing_system7_vip_v1_0_21
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/lib_pkg_v1_0_4
vlib questa_lib/msim/fifo_generator_v13_2_11
vlib questa_lib/msim/lib_fifo_v1_0_20
vlib questa_lib/msim/lib_srl_fifo_v1_0_4
vlib questa_lib/msim/lib_cdc_v1_0_3
vlib questa_lib/msim/axi_datamover_v5_1_35
vlib questa_lib/msim/axi_sg_v4_1_19
vlib questa_lib/msim/axi_dma_v7_1_34
vlib questa_lib/msim/xlconstant_v1_1_9
vlib questa_lib/msim/proc_sys_reset_v5_0_16
vlib questa_lib/msim/smartconnect_v1_0
vlib questa_lib/msim/axi_register_slice_v2_1_33
vlib questa_lib/msim/axi_lite_ipif_v3_0_4
vlib questa_lib/msim/interrupt_control_v3_1_5
vlib questa_lib/msim/axi_gpio_v2_0_35
vlib questa_lib/msim/generic_baseblocks_v2_1_2
vlib questa_lib/msim/axi_data_fifo_v2_1_32
vlib questa_lib/msim/axi_protocol_converter_v2_1_33

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_19 questa_lib/msim/axi_vip_v1_1_19
vmap processing_system7_vip_v1_0_21 questa_lib/msim/processing_system7_vip_v1_0_21
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap lib_pkg_v1_0_4 questa_lib/msim/lib_pkg_v1_0_4
vmap fifo_generator_v13_2_11 questa_lib/msim/fifo_generator_v13_2_11
vmap lib_fifo_v1_0_20 questa_lib/msim/lib_fifo_v1_0_20
vmap lib_srl_fifo_v1_0_4 questa_lib/msim/lib_srl_fifo_v1_0_4
vmap lib_cdc_v1_0_3 questa_lib/msim/lib_cdc_v1_0_3
vmap axi_datamover_v5_1_35 questa_lib/msim/axi_datamover_v5_1_35
vmap axi_sg_v4_1_19 questa_lib/msim/axi_sg_v4_1_19
vmap axi_dma_v7_1_34 questa_lib/msim/axi_dma_v7_1_34
vmap xlconstant_v1_1_9 questa_lib/msim/xlconstant_v1_1_9
vmap proc_sys_reset_v5_0_16 questa_lib/msim/proc_sys_reset_v5_0_16
vmap smartconnect_v1_0 questa_lib/msim/smartconnect_v1_0
vmap axi_register_slice_v2_1_33 questa_lib/msim/axi_register_slice_v2_1_33
vmap axi_lite_ipif_v3_0_4 questa_lib/msim/axi_lite_ipif_v3_0_4
vmap interrupt_control_v3_1_5 questa_lib/msim/interrupt_control_v3_1_5
vmap axi_gpio_v2_0_35 questa_lib/msim/axi_gpio_v2_0_35
vmap generic_baseblocks_v2_1_2 questa_lib/msim/generic_baseblocks_v2_1_2
vmap axi_data_fifo_v2_1_32 questa_lib/msim/axi_data_fifo_v2_1_32
vmap axi_protocol_converter_v2_1_33 questa_lib/msim/axi_protocol_converter_v2_1_33

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/Vivado/2024.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_19  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/8c45/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_21  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_processing_system7_0_0/sim/design_1_processing_system7_0_0.v" \

vcom -work lib_pkg_v1_0_4  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/8c68/hdl/lib_pkg_v1_0_rfs.vhd" \

vlog -work fifo_generator_v13_2_11  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/6080/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_11  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/6080/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_11  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/6080/hdl/fifo_generator_v13_2_rfs.v" \

vcom -work lib_fifo_v1_0_20  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/e160/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_4  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/1e5a/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_3  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/2a4f/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_35  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/4277/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_19  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/fc5d/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_34  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/70ff/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_dma_0_0/sim/design_1_axi_dma_0_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/sim/bd_afc3.v" \

vlog -work xlconstant_v1_1_9  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/e2d2/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_0/sim/bd_afc3_one_0.v" \

vcom -work proc_sys_reset_v5_0_16  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0831/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_1/sim/bd_afc3_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/3718/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_2/sim/bd_afc3_arinsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_3/sim/bd_afc3_rinsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_4/sim/bd_afc3_awinsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_5/sim/bd_afc3_winsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_6/sim/bd_afc3_binsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_7/sim/bd_afc3_aroutsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_8/sim/bd_afc3_routsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_9/sim/bd_afc3_awoutsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_10/sim/bd_afc3_woutsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_11/sim/bd_afc3_boutsw_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_12/sim/bd_afc3_arni_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_13/sim/bd_afc3_rni_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_14/sim/bd_afc3_awni_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_15/sim/bd_afc3_wni_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_16/sim/bd_afc3_bni_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f49a/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_17/sim/bd_afc3_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/2da8/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_18/sim/bd_afc3_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/63ed/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_19/sim/bd_afc3_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/cef3/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_20/sim/bd_afc3_s00a2s_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_21/sim/bd_afc3_sarn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_22/sim/bd_afc3_srn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_23/sim/bd_afc3_sawn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_24/sim/bd_afc3_swn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_25/sim/bd_afc3_sbn_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/7f4f/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_26/sim/bd_afc3_m00s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_27/sim/bd_afc3_m00arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_28/sim/bd_afc3_m00rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_29/sim/bd_afc3_m00awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_30/sim/bd_afc3_m00wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_31/sim/bd_afc3_m00bn_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/37bc/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_19 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_32/sim/bd_afc3_m00e_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_33/sim/bd_afc3_m01s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_34/sim/bd_afc3_m01arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_35/sim/bd_afc3_m01rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_36/sim/bd_afc3_m01awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_37/sim/bd_afc3_m01wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_38/sim/bd_afc3_m01bn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_39/sim/bd_afc3_m01e_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_40/sim/bd_afc3_m02s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_41/sim/bd_afc3_m02arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_42/sim/bd_afc3_m02rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_43/sim/bd_afc3_m02awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_44/sim/bd_afc3_m02wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_45/sim/bd_afc3_m02bn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_46/sim/bd_afc3_m02e_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_47/sim/bd_afc3_m03s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_48/sim/bd_afc3_m03arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_49/sim/bd_afc3_m03rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_50/sim/bd_afc3_m03awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_51/sim/bd_afc3_m03wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_52/sim/bd_afc3_m03bn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_53/sim/bd_afc3_m03e_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_54/sim/bd_afc3_m04s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_55/sim/bd_afc3_m04arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_56/sim/bd_afc3_m04rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_57/sim/bd_afc3_m04awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_58/sim/bd_afc3_m04wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_59/sim/bd_afc3_m04bn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_60/sim/bd_afc3_m04e_0.sv" \

vlog -work axi_register_slice_v2_1_33  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/3ee4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_0/sim/design_1_axi_smc_0.v" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_rst_ps7_0_100M_0/sim/design_1_rst_ps7_0_100M_0.vhd" \

vcom -work xil_defaultlib  -2008  \
"../../../bd/design_1/ipshared/e078/hdl/myaxistream_v1_0_S_AXIS.vhd" \
"../../../bd/design_1/ipshared/e078/hdl/myaxistream_v1_0.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_myaxistream_0_0/sim/design_1_myaxistream_0_0.vhd" \
"../../../bd/design_1/ip/design_1_spCORE_0_0/sim/design_1_spCORE_0_0.vhd" \
"../../../bd/design_1/ip/design_1_merge_0_0/sim/design_1_merge_0_0.vhd" \

vcom -work axi_lite_ipif_v3_0_4  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work interrupt_control_v3_1_5  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/d8cc/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_35  -93  \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/6718/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_gpio_0_0/sim/design_1_axi_gpio_0_0.vhd" \
"../../../bd/design_1/ip/design_1_axi_gpio_0_1/sim/design_1_axi_gpio_0_1.vhd" \
"../../../bd/design_1/ip/design_1_axi_gpio_0_2/sim/design_1_axi_gpio_0_2.vhd" \
"../../../bd/design_1/ip/design_1_axi_gpio_0_3/sim/design_1_axi_gpio_0_3.vhd" \
"../../../bd/design_1/ip/design_1_RegDebug_0_0/sim/design_1_RegDebug_0_0.vhd" \

vlog -work generic_baseblocks_v2_1_2  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0c28/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_data_fifo_v2_1_32  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/65ce/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_protocol_converter_v2_1_33  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../../spGPU.gen/sources_1/bd/design_1/ipshared/27ae/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/86fe/hdl" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../spGPU.gen/sources_1/bd/design_1/ipshared/0127/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2024.2/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_mem_intercon_imp_auto_pc_0/sim/design_1_axi_mem_intercon_imp_auto_pc_0.v" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/sim/design_1.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

