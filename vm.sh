#!/bin/bash
# vm.sh - Safe VPS PowerEdge 730 override

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "⚠️ Please run as root or with sudo"
  exit 1
fi

# 1️⃣ Neofetch override
CONFIG="$HOME/.config/neofetch/config.conf"
mkdir -p "$(dirname "$CONFIG")"
if [ -f "$CONFIG" ]; then
    cp "$CONFIG" "$CONFIG.bak_$(date +%s)"
fi

cat > "$CONFIG" << 'EOF'
info "Host" "PowerEdge 730"
EOF

# 2️⃣ Set hostname safely
if command -v hostnamectl &> /dev/null; then
    hostnamectl set-hostname poweredge730
else
    hostname poweredge730
    echo "poweredge730" > /etc/hostname
fi

# 3️⃣ Custom MOTD
tee /etc/motd > /dev/null << 'EOF'
Welcome to PowerEdge 730
Kernel optimized for enterprise workloads
EOF

# 4️⃣ Performance tweaks (safe)
if command -v cpufreq-set &> /dev/null; then
    cpufreq-set -r -g performance 2>/dev/null || echo "⚠️ Could not set CPU governor"
fi

sysctl -w vm.swappiness=10 2>/dev/null || echo "⚠️ Could not set swappiness"

if [ -e /sys/block/sda/queue/scheduler ]; then
    echo noop | tee /sys/block/sda/queue/scheduler
fi

echo "✅ VPS optimized and Neofetch overridden Made By ZenX!"
echo "Run 'neofetch' to verify."
