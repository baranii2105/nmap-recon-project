#!/bin/bash
TARGET=$1
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTDIR="scans_${TARGET}_${TIMESTAMP}"

mkdir -p "$OUTDIR"

echo "[*] Starting Nmap Recon on $TARGET"
echo "[*] Output saved to $OUTDIR"

echo "[*] Scan 1: Basic TCP Scan"
nmap --privileged $TARGET -oN $OUTDIR/basic_scan.txt

echo "[*] Scan 2: Service Version Scan"
nmap --privileged -sV $TARGET -oN $OUTDIR/service_scan.txt

echo "[*] Scan 3: Aggressive Scan"
nmap --privileged -A $TARGET -oN $OUTDIR/aggressive_scan.txt

echo "[*] Scan 4: NSE Default Scripts"
nmap --privileged -sC -sV $TARGET -oN $OUTDIR/nse_scan.txt

echo "[*] Scan 5: Vulnerability Scripts"
nmap --privileged --script vuln $TARGET -oN $OUTDIR/vuln_scan.txt

echo "[+] All scans complete! Results in $OUTDIR/"
