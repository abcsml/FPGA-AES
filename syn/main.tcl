# set syn_log_dir ./log
# set syn_net_dir ./netlist
# set syn_ddc_dir ./ddc
# set syn_svf_dir ./svf
# set syn_def_dir ./def
# set syn_rpt_dir ./rpt
set top aes

define_design_lib WORK -path work 

#========================================================
#   读入RTL文件
#========================================================
analyze -format sverilog -vcs "-f ../filelist.f"
elaborate $top
current_design ${top}
# link

#========================================================
#   设置链接库,目标库,算数运算库
#========================================================
set STD_LIB_PATH "/share/db"
set MEM_LIB_PATH "/share/mem/db"
set LIB(STD) "std.db"
set LIB(MEM) "
mem1.db
mem2.db
"

set search_path         [lsort -u [concat . $STD_LIB_PATH $MEM_LIB_PATH]]
set synthetic_library   "dw_foundation.sldb "
# set link_library        [concat * $LIB(STD) $LIB(MEM) $synthetic_library]
set link_library        [concat * $LIB(STD) $synthetic_library]
set target_library "target_library.db"

link

#========================================================
#   施加约束
#========================================================

### 面积约束 ###
# set_max_area 100
# 0代表在满足时序情况下,面积尽可能小
set_max_area 0

### 时序路径约束 ###
# 定义sclk周期10ns, 100MHz
create_clock -period 10 [get_ports sclk]
# dont_touch: 不综合
set_dont_touch_network [get_ports sclk]
# 设置时钟端口为无穷大
set_drive 0 [get_ports sclk]
# 设置时钟端口为理想网络
set_ideal_network [get_ports sclk]

# 设置复位信号
set srst_n [get_ports srst_n]
set_dont_touch_network $srst_n
set_drive 0 $srst_n
set_ideal_network $srst_n

# 定义输入延迟
# set_input_delay -max 4 -clock sclk [get_ports tdata]

# 定义输出延迟
# set_output_delay -max 5.4 -clock sclk [get_ports odata]

# 设计约束, 由工艺库商提供, 但可以约束的更紧一些
# set_max_transition
# set_max_fanout
# set_max_capacitance

### 环境约束 ###
# 设置负载(也可以用工艺库中的load代替)
# set_load 5 [get_ports odata]

# 工作条件约束

# 连线延迟约束

# 连线负载模型

#========================================================
#   生成报告
#========================================================
report_area > aes.area_rpt
# 约束违例报告
report_constraint -all_violators > aes.constraint_rpt
report_timing > aes.timing_rpt
