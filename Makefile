PREFIX ?= /usr/local

SHFILES = path_device rm_rotate rm_safe rmrm

install:
	for shfile in ${SHFILES}; do \
		cp -f bin/$${shfile} $(PREFIX)/bin/${shfile}; \
	done

uninstall:
	for shfile in ${SHFILES}; do \
		rm -f $(PREFIX)/bin/$${shfile}; \
	done

