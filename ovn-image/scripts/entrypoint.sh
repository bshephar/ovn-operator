#!/bin/bash
set -xe -o pipefail

# XXX: Add SSL. service-ca generated certs don't seem to work here.
#--ovn-nb-db-ssl-key=
#--ovn-nb-db-ssl-cert=
#--ovn-nb-db-ssl-ca-cert=
#--db-nb-cluster-local-proto=ssl

if [ "${DB_TYPE}" == "NB" ]; then
  exec /usr/share/openvswitch/scripts/ovn-ctl \
    --no-monitor \
    --db-nb-cluster-local-addr="${SVC_NAME}" \
    --db-nb-cluster-local-proto=tcp \
    --ovn-nb-log="-vconsole:${OVN_LOG_LEVEL} -vfile:off" \
    run_nb_ovsdb

elif [ "${DB_TYPE}" == "SB" ]; then
  exec /usr/share/openvswitch/scripts/ovn-ctl \
    --no-monitor \
    --db-sb-cluster-local-addr="${SVC_NAME}" \
    --db-sb-cluster-local-proto=tcp \
    --ovn-sb-log="-vconsole:${OVN_LOG_LEVEL} -vfile:off" \
    run_sb_ovsdb

else
    echo "Unknown DB_TYPE: ${DB_TYPE}" >&2
    exit 1
fi