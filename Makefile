#-------------------------------------------------------------------------------
# Arceus: The Final Dawn - GBA Makefile (standalone, no gba_rules)
#-------------------------------------------------------------------------------
TARGET   := arceus-final-dawn
BUILD    := build
SOURCES  := source
INCLUDES := include

DEVKITARM ?= /opt/devkitpro/devkitARM
PREFIX    := $(DEVKITARM)/bin/arm-none-eabi-
CC        := $(PREFIX)gcc
OBJCOPY   := $(PREFIX)objcopy
LD        := $(PREFIX)ld

ARCH     := -mthumb-interwork -mthumb
CFLAGS   := -g -Wall -O2 -mthumb-interwork -mthumb -mcpu=arm7tdmi
CFLAGS   += -I$(CURDIR)/$(INCLUDES) -I$(DEVKITPRO)/libgba/include
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS  := -g -mthumb-interwork -mthumb -mcpu=arm7tdmi

ifneq ($(BUILD),$(notdir $(CURDIR)))
export OUTPUT   := $(CURDIR)/$(TARGET)
export VPATH    := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir))
export DEPSDIR  := $(CURDIR)/$(BUILD)
export CC
export OBJCOPY

CFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))

export OFILES  := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
export INCLUDE := -I$(CURDIR)/$(INCLUDES) -I$(DEVKITPRO)/libgba/include

.PHONY: all clean

all: $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).gba

else

$(OUTPUT).gba : $(OUTPUT).elf
	@$(OBJCOPY) -O binary $(OUTPUT).elf $(OUTPUT).gba

$(OUTPUT).elf : $(OFILES)
	@$(CC) $(ARCH) -T $(DEVKITARM)/lib/gba.ld $(OFILES) -o $(OUTPUT).elf -L$(DEVKITPRO)/libgba/lib -lgba

%.o : %.c
	@$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

%.o : %.cpp
	@$(CC) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

%.o : %.s
	@$(CC) $(ASFLAGS) -c $< -o $@

endif
