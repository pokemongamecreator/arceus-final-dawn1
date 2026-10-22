#include <gba.h>
#include <stdio.h>

int main(void) {
    irqInit();
    irqEnable(IRQ_VBLANK);

    REG_DISPCNT = MODE_0 | BG0_ON;
    consoleInit(0, 0, 0, NULL, 0, 15);
    SetMode(MODE_0 | BG0_ON);

    iprintf("\x1b[2;2HARCEUS: THE FINAL DAWN");
    iprintf("\x1b[4;2HA world is dying.");
    iprintf("\x1b[5;2HOne chance remains.");
    iprintf("\x1b[8;2H--- Build works! ---");
    iprintf("\x1b[10;2HNext: cinematic, starters,");
    iprintf("\x1b[11;2Hbattles, music, Arceus.");

    while (1) {
        VBlankIntrWait();
    }
    return 0;
}
