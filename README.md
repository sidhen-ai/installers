# SIDHEN Installers

Public installation scripts for SIDHEN internal tools.

## Available Installers

### RATH Deploy

Local development stack for SIDHEN AI Avatar system (macOS only).

**What it includes:**
- LiveKit Server (WebRTC infrastructure)
- glinn-app (Web UI)
- cairn-kiosk (Native macOS app)

**Installation:**

```bash
curl -fsSL https://raw.githubusercontent.com/sidhen-ai/installers/main/rath-deploy/install.sh | bash
```

**Requirements:**
- macOS 13.0+
- GitHub Fine-grained Personal Access Token
- Xcode Command Line Tools

**Documentation:** [rath-deploy/README.md](./rath-deploy/README.md)

---

## Creating a GitHub Token

All installers require a GitHub Fine-grained Personal Access Token with access to SIDHEN private repositories.

**Steps:**
1. Go to: https://github.com/settings/personal-access-tokens/new
2. Token name: `SIDHEN Installers`
3. Expiration: 90 days (recommended)
4. Repository access: **Only select repositories**
   - Select the repositories needed for your installer
5. Repository permissions:
   - **Contents**: Read-only
   - **Metadata**: Read-only
6. Generate token and save it securely

---

## Support

For issues or questions, contact the SIDHEN engineering team.

**Repository:** https://github.com/sidhen-ai/installers

---

**Note:** SIDHEN is always written in all caps.
