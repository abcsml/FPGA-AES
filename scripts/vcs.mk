TOP = tb_aes

VCS_CXXFLAGS += -std=c++11 -static -Wall -I$(INC_PATH)
VCS_LDFLAGS  += -lpthread -lSDL2 -ldl -lz -lsqlite3

VCS_FLAGS += -full64 -timescale=1ns/1ns -sverilog -debug_access+all +lint=TFIPC-L -top ${TOP}
VCS_FLAGS += -Mdir=${OBJ_DIR} -o ${BUILD_DIR}/simv
VCS_FLAGS += -CFLAGS "$(VCS_CXXFLAGS)" -LDFLAGS "$(VCS_LDFLAGS)"

VCS = vcs 

build: ${VSRCS} ${TB_VSRCS}
	${VCS} ${VCS_FLAGS} ${VSRCS} ${TB_VSRCS}

${BUILD_DIR}/simv: ${VSRCS} ${TB_VSRCS}
	make build

verdi: 
	verdi ${VSRCS} ${TB_VSRCS}  \
 	-sverilog              \
 	-ssf ./aes.fsdb        \
 	-nologo

sim: ${BUILD_DIR}/simv 
	${BUILD_DIR}/simv
	@echo "sim over"

.PHONY: build sim clean-obj
