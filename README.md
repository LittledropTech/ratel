# Ratel — The Fearless Bitcoin Wallet for Gen Z and Gen Alpha

Ratel is a Bitcoin-only, non-custodial mobile wallet inspired by the honey badger — also known as the ratel — a symbol of resilience and fearlessness.

This wallet is designed for the new wave of Bitcoiners: Gen Z and Gen Alpha. People who create, learn, game, and value privacy, expression, and usability over traditional finance.

## Why Ratel?

Bitcoin deserves better than boring wallets.

Ratel is built not just for storage, but for experience. It combines real utility with culture:

- Earn sats while learning or gaming  
- Share wallet addresses through expressive, encrypted emojis  
- Back up your wallet using a poem  
- Interact with Bitcoin in a way that feels intuitive and native to the next generation of digital users  

Ratel isn’t just a wallet — it’s a cultural bridge.

---
## 📱 Download the Ratel Wallet

Latest beta APKs available:
Ratel is still in Beta, do not use it for large amounts of Bitcoin

- [app-arm64-v8a-release.apk](https://github.com/LittledropTech/ratel/releases/download/v0.0.1-beta.1/app-arm64-v8a-release.apk)
- [app-armeabi-v7a-release.apk](https://github.com/LittledropTech/ratel/releases/download/v0.0.1-beta.1/app-armeabi-v7a-release.apk)
---


## Key Features

| Feature                         | Description |
|---------------------------------|-------------|
| **Non-Custodial Security** | Built on [Bitcoin Dev Kit (BDK)](https://bitcoindevkit.org/) using Flutter. Users retain full control over their keys. We never store or access private data. |
| **Privacy-Preserving Addresses** | Uses dynamic public keys to prevent address reuse and enhance user privacy. |
| **Backup Options** | 1. Manual seed phrase export<br>2. Encrypted Google Drive backup<br>3. **Poetic Backup** — encrypt your seed in a custom poem (with no seed words); restore with poem + passkey. |
| **(L)earn Bitcoin** | Discover platforms that reward learning about Bitcoin. In-app tutorials, quizzes, and challenges that pay in sats. |
| **Play to Earn** | Curated list of games where Bitcoin is the actual reward. No tokens or altcoins — just real sats. Constantly updated, accessible with one tap. |
| **Emoji Wallet Sharing** | Share your wallet address as any emoji. Each emoji is encrypted, self-contained, and uniquely decodable — secure, expressive, and private. Multiple people can use the same emoji safely. |
| **Built for the Culture** | Sleek, bold, and minimal UI — no jargon, no clutter. Just a fun, intuitive UX built for digital natives. |

---

## Built For

This project was built as a submission for the **[Skibidi.cash bounty](https://skibidi.cash)**.

Ratel brings memes, education, gaming, and Bitcoin together in one seamless experience designed for a younger, internet-native audience.

---

## Supported Stack and Bitcoin Tech

- **Flutter**: Cross-platform mobile development.
- **Bitcoin Dev Kit (BDK)**: Fully sovereign Bitcoin integration.
- **Flutter Secure Storage**: Protects mnemonics and keys (Keychain on iOS, Keystore on Android).
- **Provider**: Lightweight, flexible state management.

---

## Getting Started

```bash
git clone https://github.com/your-org/ratel-wallet.git
cd ratel-wallet
flutter pub get
flutter run