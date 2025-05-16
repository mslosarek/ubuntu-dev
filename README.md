# Ubuntu Dev Environment

A ready-to-use Ubuntu-based development environment in Docker, featuring SSH access, Oh My Zsh, GitHub CLI, passwordless sudo, and a persistent workspace. Ideal for local development, onboarding, or cloud-based dev containers.

## Features

- **Ubuntu Noble** base image
- **SSH server** for remote access
- **Oh My Zsh** shell for enhanced terminal experience
- **GitHub CLI (`gh`)** pre-installed
- **Passwordless sudo** for the `dev` user
- **Persistent workspace** via Docker volume
- **Automatic SSH key import** from GitHub or Launchpad
- **Customizable port mappings**

## Quick Start

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- [docker-compose](https://docs.docker.com/compose/)

### 1. Clone the repository
```sh
git clone <this-repo-url>
cd ubuntu-dev-environment
```

### 2. Configure Environment Variables (optional)
You can override these defaults by setting them in your shell or a `.env` file:
- `SSH_PORT` (default: `2222`): Host port mapped to container's SSH (22)
- `SSH_IMPORT_ID` (default: `yourusername`): Your GitHub or Launchpad username for SSH key import
- `SSH_IMPORT_FROM` (default: `gh`): `gh` for GitHub, `lp` for Launchpad
- `ADDITIONAL_PORTS` (default: unset): Comma-separated list of additional port mappings (e.g., `9000:9000,27017:27017`)

Example `.env`:
```
SSH_PORT=2222
SSH_IMPORT_ID=octocat
SSH_IMPORT_FROM=gh
ADDITIONAL_PORTS=9000:9000,27017:27017
```

### 3. Build and Start the Container
```sh
docker-compose up --build -d
```

### 4. Connect via SSH
```sh
ssh dev@localhost -p 2222
```
- Default username: `dev`
- Default password: `dev` (password login is disabled if SSH keys are imported)

## Workspace Persistence
Your code and files in `/home/dev/workspace` are stored in a Docker volume (`dev-workspace`) and persist across container restarts.

## Customization
- Add more packages to the `Dockerfile` as needed.
- Mount additional volumes by editing `docker-compose.yml`.

## Coding Style
This repo uses an `.editorconfig` to enforce consistent code style (2-space indent, LF line endings, UTF-8, etc.).

## Ignored Files
See `.gitignore` for a list of files and directories excluded from version control (OS files, IDE configs, Python caches, etc.).

## License
MIT or your preferred license.
