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
	if [ ! -d "${DOCDIR}" ]; then \
		${mkdir} ${DOCDIR}; \
	fi && \
	if [ ! -d "${DATADIR}" ]; then \
		${mkdir} ${DATADIR}; \
	fi && \
	if [ ! -d "${MANDIR}" ]; then \
		${mkdir} ${MANDIR}; \
	fi && \
	ruby -pe 'gsub(/^(.)DATADIR = ".*"/, "\\1DATADIR = \"${DATADIR}\"")' < ./raggle > ${BINDIR}/raggle && chmod 755 ${BINDIR}/raggle && \
	cp raggle.1 ${MANDIR} && \
	cp -r ${DOCS} ${DOCDIR} && \
	cp -r ${DATA} ${DATADIR}

defaultconfig:
	ruby -e 'puts((/^.config = \{/ .. /^\}/).join)' > doc/default_config.rb

apidoc:
	rdoc -o doc/api --title "Raggle API Documentation" --webcvs http://cvs.pablotron.org/cgi-bin/viewcvs.cgi/raggle/ raggle README COPYING AUTHORS ChangeLog

man :
	pod2man --release 0.2 --center "User Commands Manual" \
	    --official raggle.pod > raggle.1
