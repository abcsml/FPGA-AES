TOP = aes_mix_columns

BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)

$(shell mkdir -p $(BUILD_DIR))

CPP_PATH = $(abspath src/sim/csrc)
INC_PATH = $(abspath src/sim/csrc/include)

CONFIG_VCD_RECORD = y

CFLAGS = -I$(INC_PATH)
ifdef CONFIG_VCD_RECORD
	CFLAGS += -DCONFIG_VCD_RECORD
endif

#LDFLAGS = -lpthread -lSDL2 -fsanitize=address -ldl

VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build -cc \
				-O3 --x-assign fast --x-initial fast --noassert	\
				-CFLAGS "$(CFLAGS)" #-LDFLAGS "$(LDFLAGS)"


VSRCS = $(shell find $(abspath src/rtl) -name "*.v")
CSRCS = $(shell find $(CPP_PATH) -name "*.c" -or -name "*.cc" -or -name "*.cpp")


$(OBJ_DIR)/V$(TOP): $(VSRCS) $(CSRCS)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOP) \
		$(CSRCS) $(VSRCS) \
		--Mdir $(OBJ_DIR) --exe --trace

sim: $(OBJ_DIR)/V$(TOP)
	./build/obj_dir/V$(TOP) $(SIMFLAGS)
	@echo "sim over"

run: $(OBJ_DIR)/V$(TOP)
	./build/obj_dir/V$(TOP) $(SIMFLAGS) $(ARGS) $(IMG)

clean:
	-rm -rf $(BUILD_DIR)

clean-obj:
	-rm -rf $(OBJ_DIR)

.PHONY: dpi-c sim clean-obj
