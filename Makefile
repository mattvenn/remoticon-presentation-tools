OPEN_LANE=/home/matt/work/asic-workshop/openlane_v09
# name of top module
DESIGN=top
# directory inside openlane
DESIGN_DIR=led_flasher
RUN_DATE=15-04_09-29
RUN_DIR=$(OPEN_LANE)/designs/$(DESIGN_DIR)/runs/$(RUN_DATE)
# gds=$(\ls ../${OPEN_LANE}/${DESIGN}/${macro}/runs/*/results/*/*gds --sort=time | head -1;)

LEF=$(RUN_DIR)/tmp/merged.lef

show-synth:
	xdot $(RUN_DIR)/tmp/synthesis/post_techmap.dot

show-yosys-report:
	cat $(RUN_DIR)/reports/synthesis/1-yosys_4.stat.rpt
# 1
# spacers only?
magic-floorplan:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./results/floorplan/$(DESIGN).floorplan.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl

klayout-floorplan:
	klayout -l klayout_def.xml $(RUN_DIR)/results/floorplan/$(DESIGN).floorplan.def

klayout-pdn:
	klayout -l klayout_def.xml $(RUN_DIR)/tmp/floorplan/7-pdn.def

# 2
# cells scattered about, no outline
magic-replace:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./tmp/placement/8-replace.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl

klayout-replace:
	klayout -l klayout_def.xml $(RUN_DIR)/tmp/placement/8-replace.def

# 3
# cells aligned to grid, no routing
magic-placement:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./results/placement/$(DESIGN).placement.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl

klayout-placement:
	klayout -l klayout_def.xml $(RUN_DIR)/results/placement/$(DESIGN).placement.def

klayout-cts:
	klayout -l klayout_def.xml $(RUN_DIR)/results/cts/$(DESIGN).cts.def

# 4
magic-final:
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc results/magic/$(DESIGN).gds

klayout-final:
	klayout -l klayout_gds.xml $(RUN_DIR)/results/magic/$(DESIGN).gds

# good
# shows pdn with cells scattered about
magic-pdn:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./tmp/floorplan/pdn.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl

# all cells in the corner and pins and outline
magic-io:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./tmp/floorplan/ioPlacer.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl

# cells scattered about, no outline, pins
magic-openphysyn:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./tmp/placement/openphysyn.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl

# cells all overlaid in the corner
magic-verilog2def:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./tmp/floorplan/verilog2def_openroad.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl

# looks fairly complete
magic-powered:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./tmp/routing/$(DESIGN).powered.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl

# looks fairly complete
magic-triton:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./tmp/routing/tritonRoute_TA.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl

# cells scattered, outline
magic-cts:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./results/cts/$(DESIGN).cts.def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl


# looks fairly complete
magic-routing-def:
	cp load_head.tcl load.tcl
	sed -e 's|FILE|./results/routing/$(DESIGN).def|' load_head.tcl > load.tcl
	cd $(RUN_DIR) && magic -rcfile $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc $(PWD)/load.tcl


#####################################


final_gds:
	klayout -l $(PDK_ROOT)/open_pdks/sky130/klayout/sky130.lyp $(RUN_DIR)/results/magic/$(DESIGN).gds

show_sky_inverter: # broken lyp for some reason
	klayout -l $(PDK_ROOT)/sky130A/libs.tech/klayout/sky130A.lyp $(PDK_ROOT)/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells/inv/sky130_fd_sc_hd__inv_1.gds

show_3d_inverter:
	cd ~/work/asic-workshop/GDS3D; linux/GDS3D -p techfiles/sky130.txt  -i ~/work/asic-workshop/pdks_v09/skywater-pdk/libraries/sky130_fd_sc_hd/latest/cells/inv/sky130_fd_sc_hd__inv_1.gds

show_sky_all:
	klayout -l $(PDK_ROOT)/sky130A/libs.tech/klayout/sky130A.lyp $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds

logo:
	klayout -l $(PDK_ROOT)/sky130A/libs.tech/klayout/sky130A.lyp ../logo-to-gds2/logo.gds

#in magic:

#to view the intermediary def files:
#start magic with rcfile: 
#magic -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc
#then in tcl window:
#lef read $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
#def read  ./results/routing/inverter.def
#cellname delete <name>
