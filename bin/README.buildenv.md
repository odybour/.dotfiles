# buildenv — per-directory build environments

`mvn`, `npm`, `helm`, and `gradle` in `~/.local/bin` are symlinks to **`buildenv`**
(source: `bin/.local/bin/buildenv` in this dotfiles repo). Each call picks an environment
from the nearest **`.buildenv`** file walking up from `$PWD`, or from **`$BUILDENV_PROFILE`**.

Profiles live in `~/.config/buildenv/profiles/*.env` (stowed from `buildenv/.config/buildenv/`).

## Layout

```
~/.local/bin/mvn   ──symlink──►  buildenv
~/.local/bin/npm   ──symlink──►  buildenv
(same for helm, gradle)

buildenv script:  dotfiles/bin/.local/bin/buildenv
profiles:         dotfiles/buildenv/.config/buildenv/profiles/
marker example:   ~/code/.buildenv   (one line = profile name)
```

## One invocation

```
you (or agent):  mvn clean install
       │
       ▼
  ~/.local/bin/mvn  →  buildenv (basename "mvn")
       │
       ▼
  walk up from $PWD → nearest .buildenv  (else $BUILDENV_PROFILE)
       │
       ├── no marker ──► exec real tool on host PATH (unchanged)
       │
       └── profile name ──► source ~/.config/buildenv/profiles/<name>.env
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
  BUILDENV_MODE=container   BUILDENV_MODE=host
        │                       │
        ▼                       ▼
  docker exec                 exec host mvn/npm/… with
  -w $PWD                     profile settings + local repo
  BUILDENV_CONTAINER          (e.g. personal)
  bash -l -c 'mvn ...'
```

## Typical tree (example)

```
~/programming/.buildenv     →  personal
~/code/.buildenv            →  altiplano-master-25
~/code/some-nokia-repo/     →  inherits ~/code → container mvn
```

Nokia work uses **container** profiles only (`altiplano-master`, `altiplano-master-25`, …).
Start the matching devcontainer first.

## Parallel agents / IDEs

```
Agent A  cwd=~/code/repo1      →  container profile for ~/code
Agent B  cwd=~/programming/x   →  personal host mvn
```

No shell hooks: each command uses **current directory + marker**, not a global toggle.

**IntelliJ on host** does not use the shim. Configure Maven per project:

```bash
cd <project> && buildenv ide
```

Refresh host copy of container Maven for IDE:

```bash
buildenv export altiplano-master-25   # → ~/env/profiles/<profile>/
```

**`devcon`**: explicit container when several run: `devcon -c altiplano-dev-master-25 -- mvn …`

## Commands

```bash
buildenv which          # profile for $PWD
buildenv list           # profile names
buildenv ide            # IntelliJ Maven hints for this project
buildenv export <name>  # sync Maven from container → ~/env/profiles/<name>/
buildenv run <cmd> …    # e.g. ./gradlew, java inside profile
buildenv help
```

## Altiplano example

```bash
cd ~/code/pm-ipfix-collector
buildenv which
mvn -DskipTests clean install -T4
```

## Related docs

- [`~/code/tools/devcontainer/readme.adoc`](~/code/tools/devcontainer/readme.adoc) — devcontainers, `devcon`, `buildenv export` / sync script
- Cursor / Claude rule: `dotfiles/agent/rules/buildenv.md`