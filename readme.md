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

