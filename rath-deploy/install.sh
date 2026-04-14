#!/bin/bash
#
# RATH Deploy Bootstrap Installer
# Public entry point for installing RATH Deploy on macOS
#
# Usage: curl -fsSL https://raw.githubusercontent.com/sidhen-ai/installers/main/rath-deploy/install.sh | bash
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/rath-deploy"
REPO_URL="https://github.com/sidhen-ai/rath-deploy.git"

# Print functions
print_header() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║     RATH Deploy - Installation Wizard      ║"
    echo "║           SIDHEN AI Avatar Stack           ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if already installed
check_existing_installation() {
    if [ -d "$INSTALL_DIR" ]; then
        print_warning "RATH Deploy is already installed at $INSTALL_DIR"
        echo ""
        read -p "Reinstall? This will remove the existing installation [y/N]: " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            exit 0
        fi
        print_info "Removing existing installation..."
        rm -rf "$INSTALL_DIR"
    fi
}

# Check macOS version
check_macos_version() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This installer only supports macOS"
        exit 1
    fi

    macos_version=$(sw_vers -productVersion | cut -d. -f1)
    if [ "$macos_version" -lt 13 ]; then
        print_error "macOS 13.0 (Ventura) or later is required"
        print_error "Current version: $(sw_vers -productVersion)"
        exit 1
    fi

    print_success "macOS $(sw_vers -productVersion) detected"
}

# Check for required tools
check_dependencies() {
    # Check for git
    if ! command -v git &> /dev/null; then
        print_error "git is not installed"
        print_info "Installing Xcode Command Line Tools..."
        xcode-select --install
        echo "Please run this installer again after Xcode Command Line Tools installation completes."
        exit 1
    fi
    print_success "git found"

    # Check for curl
    if ! command -v curl &> /dev/null; then
        print_error "curl is required but not found"
        exit 1
    fi
    print_success "curl found"
}

# Get GitHub token from user
get_github_token() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  GitHub Authentication Required"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "This installer requires a Fine-grained Personal Access Token."
    echo ""
    echo "📖 Create a token at:"
    echo "   https://github.com/settings/personal-access-tokens/new"
    echo ""
    echo "   Token name: RATH Deploy"
    echo "   Expiration: 90 days (recommended)"
    echo ""
    echo "   Repository access → Only select repositories:"
    echo "   ✓ sidhen-ai/rath-deploy"
    echo "   ✓ sidhen-ai/glinn-app"
    echo "   ✓ sidhen-ai/cairn-kiosk"
    echo ""
    echo "   Repository permissions:"
    echo "   ✓ Contents: Read"
    echo "   ✓ Metadata: Read"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    read -sp "Enter your GitHub token (github_pat_xxx): " GITHUB_TOKEN < /dev/tty
    echo ""
    echo ""

    if [ -z "$GITHUB_TOKEN" ]; then
        print_error "Token cannot be empty"
        exit 1
    fi

    # Validate token format
    if [[ ! $GITHUB_TOKEN =~ ^github_pat_[a-zA-Z0-9_]+ ]]; then
        print_error "Invalid token format"
        print_info "Fine-grained tokens start with: github_pat_"
        print_info "Make sure you created a Fine-grained token, not a Classic token"
        exit 1
    fi

    print_success "Token format valid"
}

# Verify token has access to required repositories
verify_token_access() {
    print_info "Verifying repository access..."

    repos=(
        "sidhen-ai/rath-deploy"
        "sidhen-ai/glinn-app"
        "sidhen-ai/cairn-kiosk"
    )

    for repo in "${repos[@]}"; do
        if ! curl -sf \
            -H "Authorization: Bearer $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github+json" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "https://api.github.com/repos/$repo" > /dev/null 2>&1; then
            print_error "Cannot access $repo"
            echo ""
            print_info "Please check:"
            echo "  1. Token is valid and not expired"
            echo "  2. You have access to the repository"
            echo "  3. Token has required permissions (Contents: Read, Metadata: Read)"
            echo "  4. Repository is selected in token's repository access list"
            exit 1
        fi
        print_success "Access verified: $repo"
    done
}

# Clone the main rath-deploy repository
clone_repository() {
    echo ""
    print_info "Cloning rath-deploy repository..."

    if ! git clone "https://oauth2:${GITHUB_TOKEN}@github.com/sidhen-ai/rath-deploy.git" "$INSTALL_DIR" 2>&1 | grep -v "Cloning into"; then
        print_error "Failed to clone repository"
        exit 1
    fi

    print_success "Repository cloned to $INSTALL_DIR"
}

# Run the main installer from the cloned repo
run_main_installer() {
    echo ""
    print_info "Running main installer..."
    echo ""

    cd "$INSTALL_DIR"

    # Make installer executable
    chmod +x src/install.sh

    # Run installer with token
    ./src/install.sh "$GITHUB_TOKEN"
}

# Main installation flow
main() {
    print_header

    print_info "Starting preflight checks..."
    echo ""

    check_existing_installation
    check_macos_version
    check_dependencies

    echo ""
    print_success "Preflight checks passed"

    get_github_token
    verify_token_access

    clone_repository
    run_main_installer
}

# Run main function
main
