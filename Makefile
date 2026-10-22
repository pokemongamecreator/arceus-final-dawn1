TARGET   := arceus-final-dawn
BUILD    := build
SOURCES  := source
INCLUDES := include

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment.")
endif

include $(DEVKITARM)/gba_rules

ARCH     := -mthumb-interwork -mthumb
CFLAGS   := -g -Wall -O2 -mthumb-interwork -mthumb -mcpu=arm7tdmi
CFLAGS   += $(INCLUDE) -D__GBA__
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS  := -g -mthumb-interwork -mthumb -mcpu=arm7tdmi

ifneq ($(BUILD),$(notdir $(CURDIR)))
export OUTPUT := $(CURDIR)/$(TARGET)
export VPATH  := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir))
export DEPSDIR := $(CURDIR)/$(BUILD)

CFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))

export OFILES := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
export INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                  -I$(CURDIR)/$(BUILD) \
                  -I$(DEVKITPRO)/libgba/include

.PHONY: $(BUILD) clean

all: $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).gba

else

$(OUTPUT).gba : $(OUTPUT).elf
$(OUTPUT).elf : $(OFILES)

-include $(DEPSDIR)/*.d

endif
