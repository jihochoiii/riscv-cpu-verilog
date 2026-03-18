TOP_MODULE = SingleCycleCPU
VERILOG_SOURCES = $(TOP_MODULE).v
CPP_SOURCES = testbench.cpp
OBJ_DIR = obj_dir
VCD_FILE = waveform.vcd

all: run

build: $(VERILOG_SOURCES) $(CPP_SOURCES)
		verilator --cc --trace --exe --build -j $(VERILOG_SOURCES) $(CPP_SOURCES) --top-module $(TOP_MODULE)

run: build
		./$(OBJ_DIR)/V$(TOP_MODULE)

wave: run
		gtkwave $(VCD_FILE)

clean:
		rm -rf $(OBJ_DIR) $(VCD_FILE)

.PHONY: all build run wave clean
