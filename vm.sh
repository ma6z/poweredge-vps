#!/bin/bash
# Safe PowerEdge 730 override for VPS

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "⚠️ Please run as root or with sudo"
  exit 1
fi

# 1️⃣ Install Neofetch if missing
if ! command -v neofetch &> /dev/null; then
    apt update && apt install -y neofetch
fi

# 2️⃣ Neofetch override (safe)
CONFIG="$HOME/.config/neofetch/config.conf"
mkdir -p "$(dirname "$CONFIG")"
if [ -f "$CONFIG" ]; then
    cp "$CONFIG" "$CONFIG.bak_$(date +%s)"
fi
cat > "$CONFIG" << 'EOF'
info "Host" "PowerEdge 730"
EOF

# 3️⃣ Set hostname safely
if command -v hostnamectl &> /dev/null; then
    hostnamectl set-hostname poweredge730
else
    hostname poweredge730
    echo "poweredge730" > /etc/hostname
fi

# 4️⃣ Custom MOTD
tee /etc/motd > /dev/null << 'EOF'
Welcome to PowerEdge 730
Kernel optimized for enterprise workloads
EOF

# 5️⃣ Skip CPU/I/O tweaks (not allowed in VPS)
echo "⚠️ Skipping CPU and I/O tweaks (VPS restrictions)"

echo "✅ VPS optimized and Neofetch overridden!"
echo "Run 'neofetch' to verify."
