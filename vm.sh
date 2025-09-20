#!/bin/bash
# universal_vm.sh - PowerEdge 730 look for containers & cloud dev environments

echo "⚡ Starting PowerEdge 730 setup..."

# 1️⃣ Detect environment
ENV="unknown"
if [ -n "$CODESPACE_NAME" ]; then
    ENV="GitHub Codespace"
elif [ -n "$GITPOD_WORKSPACE_ID" ]; then
    ENV="Gitpod"
elif [ -n "$COLAB_GPU" ] || [[ "$(hostname)" == *"colab"* ]]; then
    ENV="Google Colab"
elif [ -n "$CODESANDBOX_PROJECT" ]; then
    ENV="Codesandbox"
fi
echo "Detected environment: $ENV"

# 2️⃣ Install Neofetch if missing
if ! command -v neofetch &> /dev/null; then
    echo "Installing Neofetch..."
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y neofetch
    elif command -v yum &> /dev/null; then
        sudo yum install -y neofetch
    else
        echo "⚠️ Package manager not found. Skipping neofetch install."
    fi
fi

# 3️⃣ Neofetch override
CONFIG="$HOME/.config/neofetch/config.conf"
mkdir -p "$(dirname "$CONFIG")"
if [ -f "$CONFIG" ]; then
    cp "$CONFIG" "$CONFIG.bak_$(date +%s)"
fi
cat > "$CONFIG" << 'EOF'
info "Host" "PowerEdge 730"
EOF

# 4️⃣ Custom welcome message in home directory
WELCOME_FILE="$HOME/.poweredge_welcome"
cat > "$WELCOME_FILE" << 'EOF'
Welcome to PowerEdge 730
Optimized for cloud dev & container environments
EOF
echo "Custom welcome message saved to $WELCOME_FILE"

# 5️⃣ Skip CPU/I/O tweaks
echo "⚠️ Skipping CPU and I/O tweaks (not supported in containers)"

echo "✅ Setup complete! Run 'neofetch' to see your PowerEdge 730."
