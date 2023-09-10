# WireGuard Multi-hop Service

A simple yet powerful tool to set up multi-hop configurations with WireGuard, ensuring your traffic is routed securely through multiple servers. Made easy and accessible through the assistance of ChatGPT by OpenAI.

![WireGuard Logo](https://your-url-to-wireguard-logo.com/logo.png)

## Features
- Set up chains of WireGuard servers for multi-hop routing.
- Uses TOML for simple and clear configuration.
- Built as a system service to ensure the configuration stays intact across reboots.
- Allows for quick and easy installation through a single `curl` command.

## Quick Installation

To quickly install the WireGuard Multi-hop Service, run the following command:

```bash
curl -sL https://raw.githubusercontent.com/sahelea1/wireguard-multihop-service/main/install.sh | bash
```

**Note**: Always inspect scripts downloaded from the internet before executing them for security reasons.

## Manual Setup

### 1. Clone the Repository
```bash
git clone https://github.com/sahelea1/wireguard-multihop-service.git
cd wireguard-multihop-service
```

### 2. Install

```bash
sudo bash install.sh
```

### 3. Configuration

After installation, you can modify the configuration file located at `/etc/wireguard-multihop-service/config.toml`. An example configuration (`config.toml.example`) is provided to help guide you.

## Contributions

Contributions are always welcome! Please create a new issue or open a pull request if you have suggestions, features, or fixes.

## Credits

This project was created with the assistance of [ChatGPT by OpenAI](https://openai.com/research/publications/chatgpt-chat-done-right/).
