NO_PIE := $(shell echo "int main() { return 0; }" | gcc -no-pie -xc - -o /dev/null 2> /dev/null; echo $$?)

ifneq ($(NO_PIE), 0)
CFLAGS=
else
CFLAGS=-no-pie
endif
## SKIP UNTIL HERE ##

clean:
	rm -f calculator
	rm -f *.o


.PHONY: clean
