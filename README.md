# ❄️ Snow Crash

[![42 School](https://img.shields.io/badge/42-School-000000?style=flat&logo=42&logoColor=white)](https://42.fr/)
[![Security](https://img.shields.io/badge/Security-Ethical%20Hacking-red.svg)](https://en.wikipedia.org/wiki/Ethical_hacking)
[![CTF](https://img.shields.io/badge/CTF-Capture%20The%20Flag-green.svg)](https://en.wikipedia.org/wiki/Capture_the_flag_(cybersecurity))
[![Language](https://img.shields.io/badge/Language-Shell-blue.svg)](https://en.wikipedia.org/wiki/Unix_shell)

## 📋 Description

**Snow Crash** is a cybersecurity project from **42 School** focused on **ethical hacking** and **penetration testing**. This project consists of 15 progressive levels (Level00 to Level14) that teach fundamental concepts of information security, exploitation techniques, and defensive measures.

### Project Goals

This CTF-style project aims to develop skills in:
- **System Security Analysis**
- **Vulnerability Assessment**
- **Exploitation Techniques**
- **Reverse Engineering**
- **Cryptography**
- **Network Security**
- **Binary Analysis**

## 🎯 Learning Objectives

### Core Security Concepts
- **Authentication Bypass**
- **Privilege Escalation**
- **Buffer Overflow Exploitation**
- **SQL Injection**
- **Cross-Site Scripting (XSS)**
- **Command Injection**
- **File System Security**
- **Network Protocol Analysis**

### Technical Skills
- **Linux System Administration**
- **Shell Scripting and Command Line**
- **Binary Analysis with tools like GDB**
- **Network packet analysis**
- **Cryptographic algorithm breaking**
- **Social Engineering awareness**

## 🏗️ Project Structure

```
SnowCrash/
├── level00/                        # Entry level challenges
│   ├── flag                        # Target flag to capture
│   └── resources/                  # Challenge resources and hints
├── level01/                        # Password cracking
├── level02/                        # File system exploration
├── level03/                        # Binary analysis
├── level04/                        # Shell exploitation
├── level05/                        # Environment variable manipulation
├── level06/                        # Regular expressions and pattern matching
├── level07/                        # Network services
├── level08/                        # File permissions and SUID
├── level09/                        # Cryptography challenges
├── level10/                        # Race conditions
├── level11/                        # Advanced exploitation
├── level12/                        # Script analysis
├── level13/                        # Binary reverse engineering
├── level14/                        # Final challenge
└── hast.txt                        # Hash compilation file
```

## 🚀 Getting Started

### Prerequisites
```bash
# Virtual machine with Snow Crash ISO (provided by 42)
# OR Linux environment with similar tools
sudo apt-get update
sudo apt-get install gdb hexdump ltrace strace
```

### Level Progression
Each level follows this pattern:
1. **Reconnaissance**: Analyze the environment and available files
2. **Vulnerability Discovery**: Find security weaknesses
3. **Exploitation**: Craft and execute the attack
4. **Flag Capture**: Extract the flag and move to next level

### Basic Commands
```bash
# System exploration
ls -la
ps aux
netstat -tulpn
find / -user levelXX 2>/dev/null

# File analysis
file <filename>
strings <filename>
hexdump -C <filename>

# Binary analysis
gdb <binary>
ltrace <binary>
strace <binary>

# Network analysis
nmap localhost
nc -l -p <port>
```

## 🔍 Level Categories

### 🔐 **Authentication & Access Control**
- **Level00**: Basic system exploration
- **Level01**: Password hash cracking
- **Level08**: SUID binary exploitation

### 💻 **Binary Exploitation**
- **Level03**: Binary analysis and reverse engineering
- **Level13**: Advanced binary manipulation
- **Level14**: Complex exploitation chains

### 🌐 **Network Security**
- **Level07**: Network service analysis
- **Level10**: Network protocol exploitation

### 🔒 **Cryptography**
- **Level09**: Caesar cipher and encoding
- **Level12**: Hash analysis and collision

### ⚡ **System Exploitation**
- **Level04**: Shell command injection
- **Level05**: Environment variable exploitation
- **Level11**: Script-based vulnerabilities

## 🛠️ Tools Used

### Analysis Tools
- **GDB**: GNU Debugger for binary analysis
- **Ltrace**: Library call tracer
- **Strace**: System call tracer
- **Strings**: Extract printable strings from files
- **Hexdump**: Hexadecimal file viewer

### Network Tools
- **Nmap**: Network scanner
- **Netcat**: Network utility
- **Wireshark**: Packet analyzer
- **Tcpdump**: Packet capture

### Cryptographic Tools
- **John the Ripper**: Password cracker
- **Hashcat**: Advanced password recovery
- **OpenSSL**: Cryptographic toolkit

## 📊 Progress Tracking

| Level | Category | Difficulty | Status | Technique |
|-------|----------|------------|---------|-----------|
| 00 | Reconnaissance | ⭐ | ✅ | System exploration |
| 01 | Cryptography | ⭐ | ✅ | Hash cracking |
| 02 | File System | ⭐ | ✅ | File analysis |
| 03 | Binary | ⭐⭐ | ✅ | Reverse engineering |
| 04 | Injection | ⭐⭐ | ✅ | Command injection |
| 05 | Environment | ⭐⭐ | ✅ | Env manipulation |
| 06 | Regex | ⭐⭐ | ✅ | Pattern matching |
| 07 | Network | ⭐⭐⭐ | ✅ | Service analysis |
| 08 | Privileges | ⭐⭐⭐ | ✅ | SUID exploitation |
| 09 | Crypto | ⭐⭐⭐ | ✅ | Advanced cryptography |
| 10 | Race Condition | ⭐⭐⭐⭐ | ✅ | Timing attacks |
| 11 | Scripting | ⭐⭐⭐⭐ | ✅ | Script exploitation |
| 12 | Hashing | ⭐⭐⭐⭐ | ✅ | Hash manipulation |
| 13 | Binary Advanced | ⭐⭐⭐⭐⭐ | ✅ | Complex RE |
| 14 | Final Challenge | ⭐⭐⭐⭐⭐ | ✅ | Multi-stage exploit |

## 🔒 Security Best Practices

### Ethical Guidelines
- **Only use techniques in authorized environments**
- **Never exploit systems without permission**
- **Respect privacy and data protection laws**
- **Use knowledge for defensive purposes**

### Defensive Measures Learned
- **Input validation and sanitization**
- **Proper file permission management**
- **Secure coding practices**
- **Network security hardening**
- **Regular security auditing**

## 🎓 Skills Developed

### Technical Competencies
- **Vulnerability Assessment**
- **Penetration Testing Methodology**
- **Incident Response**
- **Security Architecture**
- **Risk Assessment**

### Soft Skills
- **Problem-solving under pressure**
- **Attention to detail**
- **Persistence and patience**
- **Documentation and reporting**
- **Ethical decision-making**

## 📖 Resources

### Learning Materials
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Penetration Testing Execution Standard](http://www.pentest-standard.org/)
- [Metasploit Unleashed](https://www.metasploit.com/unleashed)

### Practice Platforms
- [OverTheWire](https://overthewire.org/wargames/)
- [TryHackMe](https://tryhackme.com/)
- [Hack The Box](https://www.hackthebox.eu/)
- [VulnHub](https://www.vulnhub.com/)

### Certification Paths
- **CEH** - Certified Ethical Hacker
- **OSCP** - Offensive Security Certified Professional
- **CISSP** - Certified Information Systems Security Professional

## ⚠️ Disclaimer

This project is designed for **educational purposes only**. All techniques and methods demonstrated are intended to be used in:
- **Authorized penetration testing**
- **Personal learning environments**
- **Defensive security training**
- **Academic research**

**Unauthorized access to computer systems is illegal and unethical.**

## 👨‍💻 Author

**Rubén Delicado** - [@rdelicado](https://github.com/rdelicado)
- 📧 rdelicad@student.42.com
- 🏫 42 Málaga
- 📅 May 2025
- 🔐 Cybersecurity Student

## 📜 License

This project is part of the 42 School curriculum and is intended for educational purposes only. All content is subject to academic integrity policies.

## 🏆 Achievements

- ✅ **All 15 levels completed**
- 🎯 **100% project completion**
- 🔐 **Comprehensive security knowledge gained**
- 📚 **Foundation for advanced cybersecurity studies**

---

*"In cybersecurity, the only way to stay ahead is to think like an attacker while defending like a professional."* - Anonymous Security Expert

### 🌟 Final Note

Snow Crash represents a journey through the fundamentals of information security. Each level builds upon the previous, creating a comprehensive understanding of both offensive and defensive cybersecurity practices. This knowledge forms the foundation for responsible security professionals who protect digital assets and user privacy.
