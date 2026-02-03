# tasi-zia

A simple utility to toggle Zscaler on/off on macOS.

## Why?

Sometimes Zscaler's SSL inspection or network filtering interferes with legitimate development work, VPNs, or other tools. This script provides a quick way to temporarily disable Zscaler without uninstalling it.

## Installation
```bash
# Download or copy the script
curl -o tasi-zia https://your-paste-url/raw

# Make it executable
chmod +x tasi-zia

# Optionally move to PATH
mv tasi-zia /usr/local/bin/
```

## Usage
```bash
# Disable Zscaler
./tasi-zia stop

# Enable Zscaler
./tasi-zia start

# Check current status
./tasi-zia
./tasi-zia check
```

## How it works

**Stop:**
1. Removes execute permissions from Zscaler binaries (`chmod -x`)
2. Kills all running Zscaler processes
3. Unloads Zscaler launch agents/daemons

**Start:**
1. Restores execute permissions (`chmod +x`)
2. Launches the Zscaler app
3. Recommends a reboot for full restart

## Requirements

- macOS
- Administrator privileges (sudo)
- Zscaler installed in `/Applications/Zscaler/`

## ⚠️ Disclaimer

Use at your own risk. Disabling corporate security tools may violate your company's IT policies. Remember to re-enable Zscaler when you're done.

## License

MIT
