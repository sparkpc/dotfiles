dwmblocks &
sh ~/.screenlayout/screen.sh & 
setxkbmap -option caps:swapescape & nitrogen --restore &
xrdb -merge ~/.Xresources &
picom --experimental-backends --transparent-clipping &
lxsession &
pasystray &
/usr/lib/libexec/polkit-kde-authentication-agent-1 &

