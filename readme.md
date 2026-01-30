# Nerd-Font Installation

To use the Nerd Font "Hack," follow these steps:

## Download Nerd Font Hack

Get the Nerd Font Hack from [here](https://www.nerdfonts.com/font-downloads).

    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip -O ~/Downloads

    unzip ~/Downloads/Hack.zip -d ~/.local/share/fonts/hack/
    fc-cache -vf
    fc-match Hack -a | grep -i hack

> Logout

Edit Konsole profile settings and select "hack nomo NF font" (κάτι τέτοιο) - not the common Hack font.

# More fonts

Chatgpt tells me to prefer OTF from TTF. better when scaling monitor too.

    yay -S otf-monaspace
    yay -S otf-monaspace-nerdfonts

Update font cache: ( you also see directories where the fonts are placed )

    fc-cache -f -v

Show font families

    fc-list : family | grep Mona

Open vscode, user settings (JSON), then 

    "editor.fontFamily": "'Monaspace Neon MF', monospace",
    "editor.inlineSuggest.fontFamily": "'Monaspace Krypton', monospace"

You can change fontFamily, and see the updated font immediately.

* Colors

Colors are different than fonts. use ctrl-shift-p in vscode to open color themes, find and install.
I selected this in vscode:

    Correia GruvBox Theme

# Bluetooth Headset Issues

Telika ebala to pipewire kai ola ta sxetika packeta. pipewire-pulse, alsa etc de thumamai. des wiki.

Mikrofwno de douleyeo apo to Bluetooth. tha prepei na allaksei to profile apo a2dp se hfp de thymamai. genika den to epsaksa kai para poly, alla thewrhtika ginetai me to pipewire kai ena allo tool , to wireplumber.

exei poly pragma. gia thn wra akouw apo ta Bluetooth kai mikrowno aytomata pairnei mia allh phgh apo kalwdio. opote ok. 

* Wayland - Settings

Intellij:
Add in Help-> edit custom VM options
-Dawt.toolkit.name=WLToolkit

VScode:
create ~/.config/code-flags.conf
add 
--ozone-platform=wayland
--enable-features=UseOzonePlatform

Teams:
teams-for-linux %U --proxy-server=http://10.158.100.2:8080 --ozone-platform=wayland --enable-features=UseOzonePlatform


* Tree-sitter

yay -S tree-sitter-cli

