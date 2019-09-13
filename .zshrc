if tty | grep tty1 > /dev/null 2>&1; then
    exec startx
    exit
fi
