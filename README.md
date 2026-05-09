# Nmap Reconnaissance Project

> **Disclaimer:** This project was performed on a deliberately vulnerable virtual machine (Metasploitable 2) in a **controlled, isolated lab environment**. No real-world systems were targeted. All content is for **educational purposes only**.

---

## Overview

A complete network reconnaissance exercise using **Nmap** against **Metasploitable 2**, covering TCP scanning, service enumeration, OS detection, NSE scripting, and vulnerability mapping. The project reflects a real-world penetration testing recon phase with confirmed CVEs and exploit evidence.

---

## Lab Environment

```
 ┌─────────────────────┐        Host-Only Network
 │   Kali Linux        │        192.168.56.0/24
 │   192.168.56.101    │◄──────────────────────►│ Metasploitable 2    │
 │   (Attacker)        │                         │ 192.168.56.102      │
 └─────────────────────┘                         └─────────────────────┘
```

| Component      | Details                        |
|----------------|-------------------------------|
| Attacker OS    | Kali Linux                    |
| Target         | Metasploitable 2              |
| Hypervisor     | Oracle VM VirtualBox          |
| Network Mode   | Host-Only Adapter             |
| Attacker IP    | 192.168.56.101                |
| Target IP      | 192.168.56.102                |

---

## Tools Used

- **Nmap 7.95** — Port scanning, service detection, OS fingerprinting, NSE scripts
- **Kali Linux** — Attacker machine
- **Metasploitable 2** — Intentionally vulnerable target VM
- **Oracle VirtualBox** — Hypervisor for isolated lab

---

## Project Structure

```
nmap-recon-project/
├── scans/
│   ├── basic_scan.txt          # TCP port discovery
│   ├── service_scan.txt        # Service and version detection
│   ├── aggressive_scan.txt     # OS + version + scripts + traceroute
│   ├── nse_scan.txt            # NSE default scripts
│   └── vuln_scan.txt           # Vulnerability script scan
├── report/
│   └── report.txt              # Full findings with confirmed CVEs
└── README.md
```

---

## Scans Performed

| # | Scan Type             | Command                                          | Duration |
|---|-----------------------|--------------------------------------------------|----------|
| 1 | Basic TCP Scan        | `nmap --privileged 192.168.56.102`               | 17s      |
| 2 | Service Version Scan  | `nmap --privileged -sV 192.168.56.102`           | 29s      |
| 3 | Aggressive Scan       | `nmap --privileged -A 192.168.56.102`            | 71s      |
| 4 | NSE Default Scripts   | `nmap --privileged -sC -sV 192.168.56.102`       | 69s      |
| 5 | Vulnerability Scripts | `nmap --privileged --script vuln 192.168.56.102` | 344s     |

---

## Key Findings

> Full CVE table, risk ratings, exploit evidence, and remediation steps are in `report/report.txt`.

| Port    | Service          | Risk       | Confirmed Evidence                          |
|---------|------------------|------------|---------------------------------------------|
| 21      | vsftpd 2.3.4     | 🔴 Critical | CVE-2011-2523 — root shell confirmed (`uid=0`) |
| 80      | Apache 2.2.8     | 🔴 Critical | SQL injection confirmed across 80+ endpoints |
| 80      | Apache 2.2.8     | 🟠 High    | CSRF confirmed in /dvwa and /twiki           |
| 139/445 | Samba 3.0.20     | 🔴 Critical | CVE-2007-2447 — SMB signing disabled, guest auth allowed |
| 1099    | Java RMI         | 🔴 Critical | RMI classloader RCE confirmed               |
| 1524    | Bindshell        | 🔴 Critical | Unauthenticated root shell on open port     |
| 3306    | MySQL 5.0.51a    | 🔴 Critical | Root login with no password                 |
| 5432    | PostgreSQL 8.3   | 🟠 High    | CVE-2014-0224 CCS Injection confirmed       |
| 6667    | UnrealIRCd       | 🔴 Critical | CVE-2010-2075 — backdoored binary           |
| 8009    | AJP / Ghostcat   | 🔴 Critical | CVE-2020-1938 — AJP connector exposed       |
| 25      | Postfix SMTP     | 🟡 Medium  | POODLE + Logjam + anon DH confirmed         |
| 23      | Telnet           | 🟠 High    | Plaintext credentials — no encryption       |

---

## Additional Findings from Scans

- Anonymous FTP login allowed on port 21
- SSLv2 enabled with weak ciphers on SMTP (port 25)
- SSL certificate expired since 2010-04-16 — still active on ports 25 and 5432
- SMB guest authentication allowed — no password required
- Sensitive web paths exposed: `/phpMyAdmin/`, `/phpinfo.php`, `/dvwa/`, `/tikiwiki/`
- Apache WebDAV enabled at `/dav/` — potential file upload vector
- JSESSIONID cookie missing `httponly` flag on Tomcat (port 8180)
- HTTP TRACE method enabled — Cross-Site Tracing (XST) possible

---

## Improvements Made

| Version | Change                                                                      |
|---------|-----------------------------------------------------------------------------|
| v2.0    | Added vulnerability script scan (`--script vuln`)                           |
| v2.0    | README updated with topology, structure, quick-start guide                  |
| v3.0    | Report updated with real confirmed CVEs from actual vuln scan output        |
| v3.0    | Added exploit evidence — vsftpd root shell, SQLi endpoints, CSRF paths      |
| v3.0    | Additional findings added from NSE and aggressive scan analysis             |

---

## Learning Outcomes

After completing this project, the following skills were practised:

- Running multiple types of Nmap scans and understanding their differences
- Reading and interpreting Nmap output including NSE script results
- Identifying outdated and vulnerable service versions
- Mapping discovered services to known CVEs with real scan evidence
- Documenting reconnaissance findings in a structured, professional format
- Understanding how backdoors, weak auth, and unencrypted protocols are detected

---

## References

- [Nmap Official Documentation](https://nmap.org/docs.html)
- [Metasploitable 2 Guide](https://docs.rapid7.com/metasploit/metasploitable-2/)
- [NIST NVD — CVE Database](https://nvd.nist.gov/)
- [Nmap NSE Script Reference](https://nmap.org/nsedoc/)

---

*Part of a cybersecurity learning lab. All scanning performed with permission on an isolated virtual environment.*
