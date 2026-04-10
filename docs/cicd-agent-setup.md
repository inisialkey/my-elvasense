# CI/CD Agent Setup (Self-Hosted macOS)

This document describes the one-time setup required to run the My Elvasense Azure Pipelines on a self-hosted macOS agent.

## System Tools

Install the following on the agent machine:

- **Xcode** (latest stable) + Command Line Tools: `xcode-select --install`
- **Android Studio** + Android SDK + build-tools matching `compileSdk = 35`
- **Java 17** (matches Gradle/AGP requirements):
  ```bash
  brew install openjdk@17
  ```
- **Ruby 3.x + Bundler:**
  ```bash
  brew install ruby
  gem install bundler
  ```
- **Node.js + Firebase CLI:**
  ```bash
  brew install node
  npm install -g firebase-tools
  ```
- **CocoaPods:**
  ```bash
  sudo gem install cocoapods
  ```
- **FVM:**
  ```bash
  brew tap leoafarias/fvm
  brew install fvm
  ```
- **Git** (usually preinstalled with Xcode CLT)

## Azure Pipelines Agent

1. In Azure DevOps: Project Settings → Agent pools → New pool, name it (e.g., `mobile-mac-pool`).
2. On the agent machine, follow Azure DevOps download instructions for the pool.
3. Run the agent as your user (NOT as a service) so it has keychain access:
   ```bash
   ./run.sh
   ```
4. The agent must run while you are logged in. To run on boot, configure as a launch agent (per Azure DevOps docs).

## Environment Expectations

- Agent runs as your user (so keychain, `~/Library/MobileDevice/Provisioning Profiles` are accessible).
- `FVM_HOME` environment variable set so `fvm flutter` resolves correctly. Example in `~/.zshrc`:
  ```bash
  export FVM_HOME="$HOME/fvm"
  export PATH="$FVM_HOME/default/bin:$PATH"
  ```

## Variable Groups Required

In Azure DevOps → Pipelines → Library, create three variable groups:

### `mobile-common`
- `FLUTTER_VERSION` = `3.32.8`
- `FIREBASE_TOKEN` (from `firebase login:ci`)
- `BUILD_AGENT_POOL` = name of your self-hosted agent pool

### `mobile-signing-android` (mark all as secret)
- `MYAPP_RELEASE_STORE_PASSWORD`
- `MYAPP_RELEASE_KEY_ALIAS`
- `MYAPP_RELEASE_KEY_PASSWORD`
- `FIREBASE_ANDROID_APP_ID_STG`

### `mobile-signing-ios` (mark all as secret)
- `MATCH_PASSWORD`
- `MATCH_GIT_URL`
- `MATCH_GIT_BASIC_AUTHORIZATION` (base64 of `username:PAT`)
- `APPLE_TEAM_ID` = `S7FN6K8996`
- `APP_STORE_CONNECT_API_KEY_ID`
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`
- `APP_STORE_CONNECT_API_KEY_CONTENT` (base64 `.p8`)
- `FIREBASE_IOS_APP_ID_STG`

## Secure Files Required

In Azure DevOps → Pipelines → Library → Secure Files, upload:

- `upload-keystore.jks` (Android signing keystore)
- `.env.stg.json` (staging dart-define environment file)

## One-Time Match Setup

Match certificates and provisioning profiles need to be generated and pushed to the certificates repo before the pipeline can run successfully:

```bash
cd ios
bundle install
bundle exec fastlane match init   # creates Matchfile, prompts for git URL
bundle exec fastlane match appstore --app_identifier com.kalbe.myelvasense.stg
```

After this, the pipeline only ever runs `match` in `readonly: true` mode.

## Verifying the Agent

To confirm the agent is ready, run locally:

```bash
fvm flutter --version
java -version
xcodebuild -version
gem list bundler
firebase --version
pod --version
```

All should output without errors.
