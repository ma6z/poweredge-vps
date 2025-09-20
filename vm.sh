#!/bin/bash
# vm.sh - Make your VPS look and feel like a Dell PowerEdge 730

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "⚠️ Please run as root or with sudo"
  exit 1
fi

# Neofetch override
CONFIG="$HOME/.config/neofetch/config.conf"
[ -f "$CONFIG" ] && cp "$CONFIG" "$CONFIG.bak_$(date +%s)"
mkdir -p "$(dirname "$CONFIG")"
cat > "$CONFIG" << 'EOF'
info "Host" "PowerEdge 730"
EOF

# Hostname
hostnamectl set-hostname poweredge730

# MOTD
tee /etc/motd > /dev/null << 'EOF'
Welcome to PowerEdge 730
Kernel optimized for enterprise workloads
EOF

# Performance tweaks
apt update && apt install -y cpufrequtils
cpufreq-set -r -g performance
sysctl -w vm.swappiness=10
echo noop | tee /sys/block/sda/queue/scheduler

echo "✅ VPS optimized and Neofetch overridden!"
echo "Run 'neofetch' to verify."
