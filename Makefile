PREFIX=/usr/local
BINDIR=${PREFIX}/bin
MANDIR=${PREFIX}/man/man1
DOCDIR=${PREFIX}/share/doc/raggle
DATADIR=${PREFIX}/share/raggle
DATA=themes extras
DOCS=doc/* AUTHORS BUGS COPYING ChangeLog README
mkdir=/bin/mkdir -p

install :
	cp raggle ${BINDIR} && \
	if [ ! -d "${DOCDIR}" ]; then \
		${mkdir} ${DOCDIR}; \
	fi && \
	if [ ! -d "${DATADIR}" ]; then \
		${mkdir} ${DATADIR}; \
	fi && \
	cp raggle.1 ${MANDIR} && \
	cp -r ${DOCS} ${DOCDIR} && \
	cp -r ${DATA} ${DATADIR}

man :
	pod2man --release 0.2 --center "User Commands Manual" \
	    --official raggle.pod > raggle.1.new
