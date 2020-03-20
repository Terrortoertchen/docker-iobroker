#!/bin/sh

# Einfaches Script zum Stoppen von ioBroker.
# Kann zum Beispiel aus ioBroker heraus aufgerufen werden um ioBroker zu stoppen.

cd /opt/iobroker
pkill io
sleep 5
pkill io
sleep 10

exit 0
