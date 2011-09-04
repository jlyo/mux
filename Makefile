# ghdl Makefile
TB = $(wildcard *_tb.vhdl)
TARGET = $(TB:%.vhdl=%.vcd)
GHDL = ghdl
GHDLFLAGS = --ieee=synopsys --warn-no-vital-generic --warn-binding --warn-reserved --warn-library --warn-delayed-checks --warn-body --warn-specs --warn-unused --warn-error
SRC = $(wildcard *.vhdl)
GHDLRUNFLAGS = --vcd-nodate --assert-level=warning

# Derived variables
BIN = $(TARGET:%.vcd=%)
OBJ = $(SRC:%.vhdl=%.o)
EOBJ = $(TARGET:%.vcd=e~%.o)
MKFILE = $(TARGET:%.vcd=%.mk)

# Default target
all: $(TARGET)

%.vcd: %.mk
	$(MAKE) -f $^ run GHDLRUNFLAGS="--vcd=$@ $(GHDLRUNFLAGS)"

work-obj93.cf: $(SRC)
	$(GHDL) -i $(GHDLFLAGS) $^

%.mk: %.vhdl work-obj93.cf
	$(GHDL) --gen-makefile $(GHDLFLAGS) $(<:%.vhdl=%) | \
		sed -e 's/^GHDLFLAGS=.*$$/GHDLFLAGS= $(GHDLFLAGS)/;s/^GHDL=.*$$/GHDL=$(GHDL)/' > $@

%: %.mk
	$(MAKE) -f $^ $@

clean:
	-$(RM) $(OBJ) $(TARGET) $(EOBJ) $(MKFILE) $(BIN) work-obj93.cf

.PHONY: clean all
