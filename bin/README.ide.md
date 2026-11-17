# Host IntelliJ (and Android Studio) — Maven setup

CLI/agents use `mvn` → **buildenv** → container. **Host IDEs** cannot; they need real paths on disk.

| Command | Purpose |
|---------|---------|
| **`buildenv export <profile>`** | Copy container Maven + `settings.xml` + `toolchains.xml` → `~/env/profiles/<profile>/` (run when missing or after container rebuild). |
| **`buildenv ide`** | Print paths to paste into IntelliJ for **$PWD** (does not change anything). |

You need **`export` once** (then occasionally refresh). Use **`ide`** when configuring a project.

## Example: `pm-ipfix-collector`

Profile: `altiplano-dev-master-25` (from `~/code/.buildenv`).

```bash
buildenv export altiplano-dev-master-25   # container running
cd ~/code/pm-ipfix-collector
buildenv ide
```

**Settings → Build Tools → Maven** (per project)

| Field | Value |
|-------|--------|
| Maven home | `~/env/profiles/altiplano-dev-master-25/maven` |
| User settings file | Override → `…/settings.xml` |
| Local repository | Override → `~/devcontainer-data/altiplano-dev-master/.m2/repository` |

**Maven → Importing** and **Maven → Runner → VM options** (same on both):

```
-Daether.syncContext.named.factory=file-lock -Daether.syncContext.named.nameMapper=file-gav
```

Locks the shared local repo when IDE + container/agents build in parallel. Optional if only one Maven at a time.

**Runner:** optionally `-t ~/env/profiles/altiplano-dev-master-25/toolchains.xml` if JDK toolchain resolution fails.

**File → Project Structure**

- Project SDK: `/java/jdk-17` (profile default)
- Add SDKs once if needed: `/java/jdk-21`, `/java/graalVM-jdk-25` (native)

Reload Maven. Paths must use `~/env/profiles/altiplano-dev-master-25/` (not legacy `~/env/maven`).

## Android Studio / Gradle

Per-project **Gradle JDK** in Android Studio. Agents: `buildenv run ./gradlew …` or `gradle` shim (personal profile sets `GRADLE_USER_HOME` if configured in profile).

## Dev container backend instead

Open project via **Dev Containers** → use container Maven/JDK from `devcontainer.json`; skip export/ide host paths.

See also: [`README.buildenv.md`](README.buildenv.md).