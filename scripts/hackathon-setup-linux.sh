#!/bin/bash

# Hackathon Environment Setup Script
# For complete beginners - Linux version

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}🚀 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        OS=Debian
        VER=$(cat /etc/debian_version)
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
}

# Install packages based on distribution
install_package() {
    local package=$1
    
    if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y $package
    elif command_exists yum; then
        sudo yum install -y $package
    elif command_exists dnf; then
        sudo dnf install -y $package
    elif command_exists pacman; then
        sudo pacman -S --noconfirm $package
    else
        print_error "Package manager not supported. Please install $package manually."
        return 1
    fi
}

# Main setup function
main() {
    clear
    echo "================================================="
    echo "🎯 HACKATHON ENVIRONMENT SETUP FOR LINUX"
    echo "This will install everything you need to code!"
    echo "Estimated time: 5-10 minutes"
    echo "================================================="
    echo ""
    
    # Detect distribution
    detect_distro
    print_status "Detected OS: $OS $VER"
    
    # Get user information upfront
    echo "First, let's get you set up with Git:"
    read -p "What's your full name? " user_name
    read -p "What's your email address? " user_email
    echo ""

    # Step 1: Update system
    print_status "Updating system packages..."
    if command_exists apt-get; then
        sudo apt-get update
    elif command_exists yum; then
        sudo yum update -y
    elif command_exists dnf; then
        sudo dnf update -y
    elif command_exists pacman; then
        sudo pacman -Syu --noconfirm
    fi
    print_success "System updated!"

    # Step 2: Install curl and wget if not present
    print_status "Installing basic tools..."
    if ! command_exists curl; then
        install_package curl
    fi
    if ! command_exists wget; then
        install_package wget
    fi
    print_success "Basic tools ready!"

    # Step 3: Install Git
    print_status "Installing Git..."
    if ! command_exists git; then
        install_package git
    fi
    print_success "Git ready!"

    # Step 4: Configure Git
    print_status "Configuring Git with your information..."
    git config --global user.name "$user_name"
    git config --global user.email "$user_email"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    print_success "Git configured!"

    # Step 5: Install Python
    print_status "Installing Python..."
    if ! command_exists python3; then
        if command_exists apt-get; then
            install_package python3 python3-pip python3-venv
        else
            install_package python3 python3-pip
        fi
    fi
    print_success "Python ready!"

    # Step 6: Install Node.js
    print_status "Installing Node.js..."
    if ! command_exists node; then
        if command_exists apt-get; then
            # Use NodeSource repository for latest version
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            install_package nodejs
        else
            install_package nodejs npm
        fi
    fi
    print_success "Node.js ready!"

    # Step 7: Install Cursor IDE
    print_status "Installing Cursor IDE..."
    if ! command_exists cursor; then
        # Download and install Cursor AppImage
        cursor_url="https://downloader.cursor.sh/linux/appImage/x64"
        cursor_file="$HOME/Applications/Cursor.AppImage"
        
        mkdir -p "$HOME/Applications"
        print_status "Downloading Cursor IDE..."
        wget -O "$cursor_file" "$cursor_url"
        chmod +x "$cursor_file"
        
        # Create desktop entry
        mkdir -p "$HOME/.local/share/applications"
        cat > "$HOME/.local/share/applications/cursor.desktop" << EOF
[Desktop Entry]
Name=Cursor
Exec=$cursor_file
Type=Application
Icon=cursor
Categories=Development;
EOF
        
        # Create symlink for command line
        mkdir -p "$HOME/.local/bin"
        ln -sf "$cursor_file" "$HOME/.local/bin/cursor"
        
        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            export PATH="$HOME/.local/bin:$PATH"
        fi
    fi
    print_success "Cursor IDE ready!"

    # Step 8: Install essential Python packages
    print_status "Installing essential Python packages..."
    python3 -m pip install --user requests numpy pandas openai python-dotenv flask fastapi
    print_success "Python packages ready!"

    # Step 9: Install GitHub CLI
    print_status "Installing GitHub CLI..."
    if ! command_exists gh; then
        if command_exists apt-get; then
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt-get update
            install_package gh
        else
            print_warning "GitHub CLI not installed automatically. Please install manually from https://cli.github.com"
        fi
    fi
    print_success "GitHub CLI ready!"

    # Step 10: Create starter project
    print_status "Creating your hackathon project..."
    
    # Create project directory
    project_dir="$HOME/hackathon-project"
    if [ -d "$project_dir" ]; then
        print_warning "Project directory already exists. Creating backup..."
        mv "$project_dir" "$project_dir-backup-$(date +%s)"
    fi
    
    mkdir -p "$project_dir"
    cd "$project_dir"

    # Initialize git repository
    git init
    
    # Create starter files
    cat > README.md << 'EOF'
# My Hackathon Project 🚀

Welcome to your hackathon project! This is where your amazing ideas come to life.

## Getting Started

1. Open this folder in Cursor
2. Start coding in `main.py` or `app.py`
3. Have fun and build something awesome!

## Useful Commands

- Run Python: `python3 main.py`
- Install packages: `pip3 install --user package-name`
- Git commands: `git add .` then `git commit -m "your message"`

Good luck! 🎯
EOF

    cat > main.py << 'EOF'
#!/usr/bin/env python3
"""
Your hackathon project starts here!
This is a simple starter template.
"""

def main():
    print("🎯 Welcome to your hackathon project!")
    print("🚀 Ready to build something amazing?")
    
    # Your code goes here
    name = input("What's your name? ")
    print(f"Hello {name}! Let's start coding! 💻")

if __name__ == "__main__":
    main()
EOF

    cat > requirements.txt << 'EOF'
requests>=2.28.0
numpy>=1.21.0
pandas>=1.5.0
openai>=1.0.0
python-dotenv>=0.19.0
flask>=2.0.0
fastapi>=0.68.0
EOF

    cat > .env.example << 'EOF'
# Copy this file to .env and add your API keys
OPENAI_API_KEY=your_openai_api_key_here
# Add other environment variables as needed
EOF

    # Create a simple run script
    cat > run.sh << 'EOF'
#!/bin/bash
echo "🚀 Running your hackathon project..."
python3 main.py
EOF
    chmod +x run.sh

    # Initial git commit
    git add .
    git commit -m "Initial hackathon project setup 🚀"
    
    print_success "Starter project created!"

    # Step 11: Final instructions
    echo ""
    echo "================================================="
    print_success "🎉 SETUP COMPLETE!"
    echo "================================================="
    echo ""
    echo "📍 Your project is located at: $project_dir"
    echo ""
    echo "🚀 Next steps:"
    echo "1. Authenticate with GitHub: 'gh auth login'"
    echo "2. Open Cursor: 'cursor $project_dir' or use the app menu"
    echo "3. Start coding in main.py"
    echo "4. Test your setup: './run.sh' or 'python3 main.py'"
    echo ""
    echo "💡 Need help? Ask a mentor or volunteer!"
    echo ""
    
    # Offer to open project in Cursor
    read -p "Would you like to open your project in Cursor now? (y/n): " open_cursor
    if [[ $open_cursor =~ ^[Yy]$ ]]; then
        print_status "Opening Cursor..."
        if command_exists cursor; then
            cursor "$project_dir" &
        elif [ -x "$HOME/Applications/Cursor.AppImage" ]; then
            "$HOME/Applications/Cursor.AppImage" "$project_dir" &
        else
            print_warning "Cursor not found. You can open it manually from your applications menu."
        fi
    fi
    
    print_success "You're all set! Happy hacking! 🎯"
}

# Error handling
trap 'print_error "Setup interrupted. You can run this script again to continue."' INT

# Run main function
main