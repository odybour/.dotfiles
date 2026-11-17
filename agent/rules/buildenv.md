# Build environments (buildenv)

On this machine `mvn`, `npm`, `helm` and `gradle` are shims for `buildenv`. Each call runs in
the build environment (profile) of the current directory, picked from the nearest `.buildenv`
file above it: an Altiplano build container for Nokia work (via `docker exec`), or a personal
host Maven without the company Artifactory.

- Call `mvn`, `npm`, `helm`, `gradle` normally from the project directory. Don't hardcode Maven
  paths, call `devcon` directly, or pass `-s`/`-Dmaven.repo.local` yourself.
- For other tools (`./gradlew`, `./mvnw`, `java`) use `buildenv run <cmd> [args...]`.
- If a build behaves unexpectedly (wrong Maven, missing artifacts, container not running), run
  `buildenv which` and report its output before changing anything.
- Never create, edit or delete `.buildenv` files or `~/.config/buildenv/profiles/*` without
  asking the user first.
- When several agents work on the same repository in parallel, each uses its own git worktree:
  concurrent builds of one checkout overwrite each other's `target/`.
