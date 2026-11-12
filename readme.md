# Nerd-Font Installation

To use the Nerd Font "Hack," follow these steps:

## Download Nerd Font Hack

Get the Nerd Font Hack from [here](https://www.nerdfonts.com/font-downloads).

    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip -O ~/Downloads

    unzip ~/Downloads/Hack.zip -d ~/.local/share/fonts/hack/
    fc-cache -vf
    fc-match Hack -a | grep -i hack

 /home/bournas/programming/aux/ipfix-etl-pipelines/.venv/bin/activate


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

# Cursor + Stow Notes

`~/.cursor/cli-config.json` is intentionally not managed by GNU Stow.
Cursor may rewrite/replace this file during normal operation, which can
break symlink ownership and cause stow conflicts.

The install script excludes `cli-config.json` from stow. Skills, rules and agents are
tool neutral and live under `agent/`, not under `cursor/` (which only holds Cursor-specific
config). They are installed by `agent-install` (stowed from `bin/.local/bin/`) into both
Cursor and Claude Code. Honors `CURSOR_HOME` (default `~/.cursor`), `CLAUDE_HOME`
(default `~/.claude`) and `AGENT_HOME` (default `~/.agent`).

### Agent assets layout (this repo and others)

Any git repo can publish assets at:

```text
agent/skills/<skill-name>/SKILL.md
agent/skills/<skill-name>/scripts/   # optional; reference as ~/.agent/skills/<skill-name>/scripts/...
agent/rules/<rule>.md                # body only, no frontmatter (Claude Code reads it as is)
agent/rules/<rule>.cursor            # optional sidecar: Cursor frontmatter lines (description, alwaysApply, globs)
agent/agents/*.md                    # optional
agent/<package>/{skills,rules,agents}/...   # same, grouped per package
```

| Asset  | Cursor                                   | Claude Code                    |
|--------|------------------------------------------|--------------------------------|
| skill  | `~/.cursor/skills/<name>` (symlink)      | `~/.claude/skills/<name>` (symlink) |
| agent  | `~/.cursor/agents/<f>.md` (symlink)      | `~/.claude/agents/<f>.md` (symlink) |
| rule   | `~/.cursor/rules/<rule>.mdc` (generated: sidecar frontmatter + body; `alwaysApply: true` if no sidecar) | `~/.claude/rules/<rule>.md` (symlink) |

`~/.agent/skills/<name>` is a tool-neutral link to each skill so `SKILL.md` files can
reference their scripts without naming a tool. Do not hand-edit the generated `.mdc`
files; edit `agent/rules/<rule>.md` and re-run `agent-install`.

### Cursor Launchpad plugins in Claude Code

`launchpad-claude` (stowed from `bin/.local/bin/`) converts the Launchpad plugins that
Cursor caches in `~/.cursor/plugins/cache/kairosaica-launchpad/` into a local Claude
marketplace at `~/.claude/launchpad/` (copies, because Claude rejects symlinks that
leave the plugin directory) and writes the `.mdc` rules to `~/.claude/rules/launchpad-*.md`.
Skills and agents work; Cursor hooks (goal-lock gates, detect-secrets, `[cursor-assisted]`
commit marking) are not ported. One-time setup, then re-run `launchpad-claude` after
Cursor updates the plugins:

```bash
launchpad-claude
claude plugin marketplace add ~/.claude/launchpad
claude plugin install scaffold-core@launchpad   # likewise scaffold-dev/-product/-security/-qa
```

### New machine

1. Clone this repo and run `./install` from the dotfiles root.
2. Install finishes with `agent-install "$DOTFILES"` (dotfiles skills, rules, agents).

### Other repos (e.g. java-perf-toolkit)

After dotfiles install (so `agent-install` is on `PATH`):

```bash
cd /path/to/java-perf-toolkit
agent-install
```

(`cursor-skills-install` still works as a deprecated alias.)

Re-run after adding skills. If two repos define the same skill name, the last
install wins (`ln -sfn`).

