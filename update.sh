set -ex
GXIP=192.168.69.8
UPDATE="Battery.qml OverviewPage.qml HubData.qml OverviewHub.qml"
scp $UPDATE root@$GXIP:/opt/victronenergy/gui/qml
#ssh root@$GXIP "svc -t /service/gui"
ssh root@$GXIP "killall gui"
