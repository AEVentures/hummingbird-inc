#!/usr/bin/env bash
# GB10 (vims-box) ownership migration script
# Run this ON THE GB10 ITSELF (physical keyboard/monitor, or SSH'd in as
# plasmaraygun with John present) at 106 tomorrow morning.
#
# This does NOT touch Tailscale identity (must be done interactively via
# browser login, see Step 3 notes below) but sets up the new AEVentures
# admin Linux account and prepares the box for the handoff.
#
# USAGE:
#   1. Log in as plasmaraygun (or have John log in) with sudo access.
#   2. Copy this script to the box (or paste it into a new file).
#   3. Run: chmod +x gb10-migration-script.sh && sudo ./gb10-migration-script.sh
#   4. Follow the printed instructions for the Tailscale re-auth step.

set -euo pipefail

NEW_USER="aeventures"
PUBKEY_FILE="/tmp/aeventures_id_ed25519_sparks.pub"

echo "=== Step 1: Create AEVentures admin user ==="
if id "$NEW_USER" &>/dev/null; then
  echo "User $NEW_USER already exists, skipping creation."
else
  adduser --disabled-password --gecos "" "$NEW_USER"
  usermod -aG sudo "$NEW_USER"
  echo "Created user $NEW_USER with sudo access."
fi

echo ""
echo "=== Step 2: Install SSH public key ==="
echo "Paste the contents of ~/.ssh/id_ed25519_sparks.pub from the Mac into:"
echo "  $PUBKEY_FILE"
echo "on this machine, then re-run this script, OR run manually:"
echo ""
cat <<'EOF'
  mkdir -p /home/aeventures/.ssh
  echo "PASTE_PUBLIC_KEY_HERE" >> /home/aeventures/.ssh/authorized_keys
  chown -R aeventures:aeventures /home/aeventures/.ssh
  chmod 700 /home/aeventures/.ssh
  chmod 600 /home/aeventures/.ssh/authorized_keys
EOF

if [ -f "$PUBKEY_FILE" ]; then
  mkdir -p /home/"$NEW_USER"/.ssh
  cat "$PUBKEY_FILE" >> /home/"$NEW_USER"/.ssh/authorized_keys
  chown -R "$NEW_USER":"$NEW_USER" /home/"$NEW_USER"/.ssh
  chmod 700 /home/"$NEW_USER"/.ssh
  chmod 600 /home/"$NEW_USER"/.ssh/authorized_keys
  echo "SSH key installed for $NEW_USER."
fi

echo ""
echo "=== Step 3: Tailscale re-auth (MANUAL — must be done interactively) ==="
echo "Run these two commands and open the printed URL in a browser."
echo "Log in with the AEVentures GitHub org account, NOT plasmaraygun."
echo ""
echo "  sudo tailscale logout"
echo "  sudo tailscale up"
echo ""
echo "After re-auth, the machine will appear under the AEVentures tailnet."
echo "Then go to https://login.tailscale.com/admin/acls/file (logged in as"
echo "AEVentures) and confirm/add an SSH access rule permitting Michael's"
echo "MacBook to SSH into this box."
echo ""

echo "=== Step 4: Verify GPU / hardware ==="
nvidia-smi -L 2>/dev/null || echo "nvidia-smi not found — check GPU drivers."
free -h
df -h /

echo ""
echo "=== Step 5 (optional): Decide plasmaraygun account fate ==="
echo "To remove sudo from plasmaraygun but keep the account for John:"
echo "  sudo deluser plasmaraygun sudo"
echo ""
echo "To remove the account entirely:"
echo "  sudo deluser --remove-home plasmaraygun"
echo ""
echo "=== Migration script complete. Follow Step 3 manually to finish. ==="
