# Local Development Stack Installer

One-command installation for the complete SIDHEN Avatar Intelligence local development stack on macOS.

## What Gets Installed

- **LiveKit Server**: WebRTC infrastructure (port 7880)
- **Web application**: Next.js web UI (port 3000)
- **Kiosk application**: Native macOS kiosk app

All services are installed to `~/rath-deploy` and will NOT affect your existing projects in `~/Code`.

## Prerequisites

- **macOS**: 13.0 or later (Ventura, Sonoma, Sequoia)
- **GitHub Token**: Fine-grained Personal Access Token with access to the repositories listed in Step 1 below.

## Installation

### Step 1: Create GitHub Token

1. Visit: https://github.com/settings/personal-access-tokens/new
2. Configure:
   - **Token name**: Any name you prefer (e.g. `SIDHEN Local Stack`)
   - **Expiration**: 90 days
   - **Repository access**: Only select repositories — pick the ones the installer needs (the engineering team will provide the list)
   - **Repository permissions**:
     - Contents: **Read**
     - Metadata: **Read**
3. Click **Generate token**
4. **Copy the token** (starts with `github_pat_`)

### Step 2: Run Installer

```bash
curl -fsSL https://raw.githubusercontent.com/sidhen-ai/installers/main/rath-deploy/install.sh | bash
```

You'll be prompted to paste your GitHub token.

### Step 3: Start Using

After installation completes, run:

```bash
rath
```

This opens the interactive menu to start/stop services, check status, etc.

## Usage

### Interactive Menu

```bash
rath
```

Opens the main menu with options to:
- Start/Stop all services
- Check service status
- View logs
- Configure services
- Uninstall

### Direct Commands

```bash
rath start      # Start all services
rath stop       # Stop all services
rath status     # Show service status
rath logs       # View logs
rath uninstall  # Completely remove the local stack
```

## What Happens During Installation

1. **Preflight checks**: Verifies macOS version, checks for Xcode CLI tools
2. **Dependencies**: Installs Homebrew (if needed), Node.js, LiveKit
3. **Repository cloning**: Clones private repositories to `~/rath-deploy/services/`
4. **Service setup**: Configures each service and generates local credentials
5. **Path setup**: Creates the `rath` command in `~/.local/bin/`

## Installation Directory

Everything lives under `~/rath-deploy/`:
- Service repositories, logs, and configuration
- Your GitHub token (chmod 600, gitignored)
- An installation manifest with metadata
- A symlink that exposes the `rath` command

## Uninstalling

### Interactive Uninstall

```bash
rath uninstall
```

You'll be prompted to:
- Confirm deletion
- Choose whether to backup logs
- Choose whether to remove Homebrew packages

### Complete Removal

The uninstaller removes:
- `~/rath-deploy/` directory (all cloned repositories, configs, logs)
- `~/.local/bin/rath` symlink

The uninstaller preserves:
- Your original projects in `~/Code/`
- Homebrew packages (optional removal with confirmation)
- System-wide tools (Node.js, Xcode CLI tools)

## Troubleshooting

### Port Conflicts

If port 7880 or 3000 is already in use:

```bash
# Check what's using the port
lsof -i :7880
lsof -i :3000

# Kill the process or configure the stack to use different ports
rath configure
```

### Token Issues

If you get authentication errors:

1. Verify the token has access to all required repositories
2. Check the token hasn't expired
3. Ensure the token has `Contents: Read` permission
4. Regenerate the token if needed

### Logs

View installation and service logs:

```bash
rath logs

# Or directly:
tail -f ~/rath-deploy/logs/install.log
```

## Support

For issues, contact the SIDHEN engineering team.

## License

Internal use only — SIDHEN Avatar Intelligence.
