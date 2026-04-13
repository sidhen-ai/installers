# RATH Deploy Installer

One-command installation for the complete SIDHEN AI Avatar development stack on macOS.

## What Gets Installed

- **LiveKit Server**: WebRTC infrastructure (port 7880)
- **glinn-app**: Next.js web application (port 3000)
- **cairn-kiosk**: Native macOS kiosk application

All services are installed to `~/rath-deploy` and will NOT affect your existing projects in `~/Code`.

## Prerequisites

- **macOS**: 13.0 or later (Ventura, Sonoma, Sequoia)
- **GitHub Token**: Fine-grained Personal Access Token with access to:
  - `sidhen-ai/rath-deploy`
  - `sidhen-ai/glinn-app`
  - `sidhen-ai/cairn-kiosk`

## Installation

### Step 1: Create GitHub Token

1. Visit: https://github.com/settings/personal-access-tokens/new
2. Configure:
   - **Token name**: `RATH Deploy`
   - **Expiration**: 90 days
   - **Repository access**: Only select repositories
     - ✓ `sidhen-ai/rath-deploy`
     - ✓ `sidhen-ai/glinn-app`
     - ✓ `sidhen-ai/cairn-kiosk`
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
rath uninstall  # Completely remove RATH Deploy
```

## What Happens During Installation

1. **Preflight checks**: Verifies macOS version, checks for Xcode CLI tools
2. **Dependencies**: Installs Homebrew (if needed), Node.js, LiveKit
3. **Repository cloning**: Clones private repos to `~/rath-deploy/services/`
4. **Service setup**:
   - LiveKit: Creates config, generates API keys
   - glinn-app: Installs npm dependencies, creates `.env.local`
   - cairn-kiosk: Builds Xcode project
5. **Path setup**: Creates `rath` command in `~/.local/bin/`

## Installation Directory Structure

```
~/rath-deploy/
├── .github-token          # Your token (gitignored, chmod 600)
├── .install-manifest.json # Installation metadata
├── rath -> src/rath.sh   # Symlink for 'rath' command
├── services/
│   ├── livekit/
│   │   ├── config.yaml
│   │   └── livekit.pid
│   ├── glinn-app/
│   │   ├── repo/         # Cloned from GitHub
│   │   ├── .env.local
│   │   └── node_modules/
│   └── cairn-kiosk/
│       ├── repo/         # Cloned from GitHub
│       └── build/
└── logs/
    ├── livekit.log
    ├── glinn-app.log
    └── install.log
```

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
- `~/rath-deploy/` directory (all cloned repos, configs, logs)
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

# Kill the process or configure RATH to use different ports
rath configure
```

### Token Issues

If you get authentication errors:

1. Verify token has access to all three repositories
2. Check token hasn't expired
3. Ensure token has `Contents: Read` permission
4. Regenerate token if needed

### Logs

View installation and service logs:

```bash
rath logs

# Or directly:
tail -f ~/rath-deploy/logs/install.log
tail -f ~/rath-deploy/logs/livekit.log
tail -f ~/rath-deploy/logs/glinn-app.log
```

## Support

For issues, contact the SIDHEN engineering team or file an issue at:
https://github.com/sidhen-ai/rath-deploy/issues

## License

Internal use only - SIDHEN AI
