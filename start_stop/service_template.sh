#!/bin/bash
# description: Application Start Stop Restart
# processname: Mon_application
# chkconfig: 234 94 11
#-------------------------------------------------------------------#
# Explication pour la ligne ci-dessus :
#   234 : Indique les niveaux pour lesquels le service est demarre
#         Dans ce cas, les niveaux 2 3 et 4 (c.f. ci-dessous)
#   20  : Indique la priorite de demarrage du service
#         19 demarre avant, 21 demarre apres
#   80  : Indique la priorite d'arret du service
#         79 est arrete avant, 81 apres
# Default runlevel. The runlevels used by RHS are:
#   0 - halt (Do NOT set initdefault to this)
#   1 - Single user mode
#   2 - Multiuser, without NFS (The same as 3, if you do not have networking)
#   3 - Full multiuser mode (DEFAULT MODE)
#   4 - unused
#   5 - X11
#   6 - reboot (Do NOT set initdefault to this)
#-------------------------------------------------------------------#

IDRUN=`/bin/date '+%y%m%d%H%M%S'`

#-------------------------------------------------------------------#
# Liste des constantes a mettre a jour en fonction de l'application #
#-------------------------------------------------------------------#
USER="user"
APPNAME="Mon_application"
REPLOG="/custom/log"
FICLOG="${REPLOG}/Mon_application_start_stop.log"
TCRUNTIME="/app/mon_application/bin/tcruntime-ctl.sh"
CLE="file=/PROD/APP/mon_application/conf/logging.properties"
#-------------------------------------------------------------------#

touch ${FICLOG}
chown ${USER} ${FICLOG}

ecrisLog()
{
    echo "${IDRUN} - ${APPNAME} - $1" >> ${FICLOG}
    return 0
}

case $1 in
    start)
        ecrisLog "Demande START application : DEBUT"
        (su - ${USER} -c "source ~/.profile; ${TCRUNTIME} start >> ${FICLOG} 2>&1")
        ecrisLog "START application : EFFECTUEE"
        echo "Demarrage ${APPNAME} effectue"
    ;;

    status)
        ecrisLog "Demande ETAT application : DEBUT"
        RES=` ps -eaf | grep -e "${CLE}" | grep -v grep | tr -s " " ";" | cut -d';' -f 2`
        if [ ${RES:-0} -gt 0 ]
        then
            ecrisLog "Application en execution sous le pid : ${RES}"
            echo "${APPNAME} est en execution sous le pid : ${RES}"
        else
            ecrisLog "Application est arretee"
            echo "${APPNAME} est arretee"
        fi
    ;;
    stop)
        ecrisLog "Demande STOP application : DEBUT"
        (su - ${USER} -c "source ~/.profile; ${TCRUNTIME} stop >> ${FICLOG} 2>&1")
        echo "Arret  ${APPNAME} effectue"
        ecrisLog "Demande STOP application : EFFECTUEE"
    ;;
    restart)
        ecrisLog "Demande RESTART application : DEBUT"
        (su - ${USER} -c "source ~/.profile; ${TCRUNTIME} stop >> ${FICLOG} 2>&1")
        (su - ${USER} -c "source ~/.profile; ${TCRUNTIME} start >> ${FICLOG} 2>&1")
        echo "Redemarrage ${APPNAME} effectue"
        ecrisLog "Demande RESTART application : FIN"
    ;;
esac
exit 0
        