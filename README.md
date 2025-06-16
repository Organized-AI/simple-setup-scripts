# OrganizedAI Hackathon Setup 🚀

A complete environment setup tool for hackathon participants. This website provides one-click setup scripts for macOS, Windows, and Linux to get beginners coding quickly.

## What It Does

This tool automatically installs and configures:
- Git with user configuration
- Python 3 with essential packages (requests, numpy, pandas, openai, flask, fastapi)
- Node.js for web development
- Cursor IDE for coding
- GitHub CLI for easy authentication
- A starter project template

## Live Site

Visit **[organizedai.vip](https://organizedai.vip)** to get started!

## For Hackathon Organizers

### Quick Setup for Events

1. **During your presentation**: Tell participants to visit `organizedai.vip`
2. **Visual instructions**: The site auto-detects their OS and provides step-by-step guidance
3. **One-click downloads**: Participants download platform-specific setup scripts
4. **Automated installation**: Scripts handle everything while you continue your presentation
5. **Ready to code**: Participants end up with a working development environment and starter project

### Deployment

This site is deployed on DigitalOcean App Platform with:
- Automatic SSL/HTTPS
- Global CDN for fast downloads
- Zero-downtime deployments
- Automatic scaling for high-traffic events

## Files Structure

```
organizedai-setup/
├── index.html                    # Main website
├── scripts/
│   ├── hackathon-setup-mac.sh    # macOS setup script
│   ├── hackathon-setup-windows.ps1 # Windows PowerShell script  
│   └── hackathon-setup-linux.sh  # Linux setup script
└── README.md                     # This file
```

## Script Features

### What Gets Installed
- **Package Managers**: Homebrew (Mac), Chocolatey (Windows), native package managers (Linux)
- **Development Tools**: Git, Python 3, Node.js, Cursor IDE, GitHub CLI
- **Python Packages**: requests, numpy, pandas, openai, python-dotenv, flask, fastapi
- **Project Template**: Ready-to-use hackathon project with example code

### Safety Features
- Progress indicators with clear status messages
- Error handling with helpful error messages
- Backup existing projects before creating new ones
- Skip installation if tools already exist
- Safe defaults for all configurations

## Customization

To customize for your hackathon:

1. **Fork this repository**
2. **Update the scripts** to include additional tools or packages specific to your event
3. **Modify the website** to match your branding or add event-specific information
4. **Deploy to your domain** using DigitalOcean App Platform or similar service

### Adding Custom Packages

Edit the setup scripts to include additional tools:

```bash
# Add to Mac/Linux scripts
pip3 install your-custom-package

# Add to Windows script  
pip install your-custom-package
```

## Troubleshooting

### Common Issues

**Permission Errors (Windows)**
- Solution: Right-click PowerShell and "Run as Administrator"

**Homebrew Installation Fails (Mac)**
- Solution: Check internet connection and try again
- Fallback: Install tools manually using the backup instructions

**Package Installation Fails**
- Solution: Scripts will continue and show which packages failed
- Fallback: Manual installation instructions provided

### Support During Events

1. **Train volunteers** on common issues before the event
2. **Have backup laptops** with pre-installed environments
3. **Provide manual installation guides** for edge cases
4. **Use GitHub Codespaces** as a browser-based fallback

## Analytics

The DigitalOcean deployment includes basic analytics to track:
- Number of visitors to the site
- Download counts for each platform
- Geographic distribution of users

Check `/var/log/nginx/script_downloads.log` on the server for download statistics.

## Contributing

Found an issue or want to improve the setup process? 

1. Fork this repository
2. Make your changes
3. Test on a fresh machine
4. Submit a pull request

## License

MIT License - Feel free to use this for your hackathons and events!

## About

Created for smooth hackathon experiences. No more spending the first hour of your event on environment setup!

For questions or support, reach out to the organizing team.