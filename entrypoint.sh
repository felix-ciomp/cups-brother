#!/bin/bash -ex

if [ $(grep -ci $CUPSADMIN /etc/shadow) -eq 0 ]; then
    useradd -r -G lpadmin -M $CUPSADMIN

    # add password
    echo $CUPSADMIN:$CUPSPASSWORD | chpasswd

    # add tzdata
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
    dpkg-reconfigure --frontend noninteractive tzdata
fi

# restore default cups config in case user does not have any
if [ ! -f /etc/cups/cupsd.conf ]; then
    cp -rpn /etc/cups-bak/* /etc/cups/
fi

if [ $CUPSBRPRINTER !="" ]; then
    printf 'y\ny\ny\ny\nn\nn\nn\n' | bash /root/linux-brprinter-installer-2.2.4-1 $CUPSBRPRINTER
fi

exec /usr/sbin/cupsd -f
