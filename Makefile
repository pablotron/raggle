PREFIX=/usr/local
BINDIR=${PREFIX}/bin
MANDIR=${PREFIX}/share/man/man1
DOCDIR=${PREFIX}/share/doc/raggle
DATADIR=${PREFIX}/share/raggle
DATA=themes extras
DOCS=doc/* AUTHORS BUGS COPYING ChangeLog README
mkdir=/bin/mkdir -p

phony :
	@echo "Run make install"
install :
	if [ ! -d "${BINDIR}" ]; then \
		${mkdir} -p ${BINDIR}; \
	fi && \
	cp raggle ${BINDIR} && \
	if [ ! -d "${DOCDIR}" ]; then \
		${mkdir} ${DOCDIR}; \
	fi && \
	if [ ! -d "${DATADIR}" ]; then \
		${mkdir} ${DATADIR}; \
	fi && \
	if [ ! -d "${MANDIR}" ]; then \
		${mkdir} ${MANDIR}; \
	fi && \
	cp raggle.1 ${MANDIR} && \
	cp -r ${DOCS} ${DOCDIR} && \
	cp -r ${DATA} ${DATADIR}

apidoc:
	rdoc --op doc/api raggle

man :
	pod2man --release 0.2 --center "User Commands Manual" \
	    --official raggle.pod > raggle.1
