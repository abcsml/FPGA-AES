#TOP = aes_mix_columns

BUILD_DIR = $(abspath build)
OBJ_DIR = $(BUILD_DIR)/obj_dir

$(shell mkdir -p $(BUILD_DIR))
$(shell mkdir -p $(BUILD_DIR)/obj_dir)

CPP_PATH = $(abspath src/sim/csrc)
INC_PATH = $(abspath src/sim/csrc/include)

VSRCS 	 = $(shell find $(abspath src/rtl) -name "*.v")
TB_VSRCS = $(shell find $(abspath src/sim) -name "*.v" -or -name "*.txt")
CSRCS  	 = $(shell find $(CPP_PATH) -name "*.c" -or -name "*.cc" -or -name "*.cpp")

clean:
	-rm -rf $(BUILD_DIR)

clean-obj:
	-rm -rf $(OBJ_DIR)

.PHONY: build sim clean-obj

include scripts/vcs.mk
