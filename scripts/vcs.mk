#TOP = aes_mix_columns

VCS_CXXFLAGS += -std=c++11 -static -Wall -I$(INC_PATH)
VCS_LDFLAGS  += -lpthread -lSDL2 -ldl -lz -lsqlite3

VCS_FLAGS += -full64 -timescale=1ns/1ns -sverilog -debug_access+all +lint=TFIPC-L #-top ${TOP}
VCS_FLAGS += -Mdir=${OBJ_DIR} -o ${BUILD_DIR}/simv
VCS_FLAGS += -CFLAGS "$(VCS_CXXFLAGS)" -LDFLAGS "$(VCS_LDFLAGS)"

VCS = vcs 

build: ${VSRCS}
	${VCS} ${VCS_FLAGS} ${VSRCS} ${CSRCS}

${BUILD_DIR}/simv: ${VSRCS}
	make build

sim: ${BUILD_DIR}/simv
	${BUILD_DIR}/simv
	@echo "sim over"

.PHONY: build sim clean-obj
