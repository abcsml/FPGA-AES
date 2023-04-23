#include "sim.h"
#include "aes.h"

VerilatedContext* contextp = NULL;
static VerilatedVcdC* tfp = NULL;

Vaes_mix_columns* top;

void init_sim() {
  contextp = new VerilatedContext;
  top = new Vaes_mix_columns;
#ifdef CONFIG_VCD_RECORD
  tfp = new VerilatedVcdC;
  contextp->traceEverOn(true);
  top->trace(tfp, 0);
  tfp->open("out/cpu.vcd");
#endif
  srand(time(0));
}

void step_and_dump_wave() {
  //top->clock = top->clock == 1?0:1;
  top->eval();
#ifdef CONFIG_VCD_RECORD
  contextp->timeInc(1);
  tfp->dump(contextp->time());
#endif
}

void sim_exit(int ret) {
  step_and_dump_wave();
#ifdef CONFIG_VCD_RECORD
  tfp->close();
#endif
  exit(ret);
}

void mixCol(uint8_t* state) {
  for (int i = 0; i < 16; i++) {
    ((uint8_t *)top->state)[i] = state[i];
  }
  step_and_dump_wave();
  for (int i = 0; i < 16; i++) {
    state[i] = top->val[i];
  }
}

bool sim() {
  uint8_t state[16];
  uint8_t sa[16];
  uint8_t sb[16];

  printf("begin sim\n");
  for (int n = 0; n < 2000; n++) {
    for (int i = 0; i < 16; i++) {
      state[i] = rand() % 256;
      sa[i] = state[i];
      sb[i] = state[i];
    }
    mixCol(sa);
    MixColumns((state_t *)sb);
    for (int i = 0; i < 16; i++) {
      if (sa[i] != sb[i]) {
        printf("diff\n");
        break;
      }
    }
  }
  for (int i = 0; i < 16; i++) {
    printf("%d->",state[i]);
    printf("%d,",sa[i]);
  }
  printf("over\n");
  return 0;
}

int main(int argc, char *argv[]) {
  printf("------ hello ----------\n");
  init_sim();
  sim_exit(sim());
}
