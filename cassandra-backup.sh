#!/bin/sh

usage() { echo "Usage: $0 -u <cassandra username> -p <cassandra password> -h <cassandra host> -k <cassandra keyspace> -o <output dir>" 1>&2; exit 1; }

while getopts ":u:p:h:k:o:" a; do
    case "${a}" in
	u) USER=${OPTARG};;
	p) PASS=${OPTARG};;
	h) HOST=${OPTARG};;
	k) KEYSPACE=${OPTARG};;
	o) OUTDIR=${OPTARG};;
	*) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${USER}" ] || [ -z "${PASS}" ] || [ -z "${HOST}" ] || [ -z "${KEYSPACE}" ] || [ -z "${OUTDIR}" ]; then
    echo "USER=${USER} PASS=${PASS} HOST=${HOST} KEYSPACE=${KEYSPACE} OUTDIR=${OUTDIR}"
    usage
fi

CQLSHCMD="cqlsh -u ${USER} -p ${PASS} -k ${KEYSPACE} ${HOST}"
tables=`${CQLSHCMD} -e 'describe tables';`
for table in $tables; do
    ${CQLSHCMD} -e "COPY $table TO '${OUTDIR}/$table.bak'"
done
echo 'Done'
