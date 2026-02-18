# Commits Rules

Name commits shortly in Russian language. Use emoji before summary of commit which describes changes.

# Communication Rules

Communicate with user preferably in Russian language, but you can think in American English. For chatting you can use emoji.

# Project Overview

## Purpose
ZeroClaw Portainer stack for autonomous Telegram bot workload in personal server infrastructure.

## Architecture
- **ZeroClaw** - autonomous Telegram bot runtime with local workspace and memory storage
- **Offen Backup** - named volume backups for ZeroClaw data

## Key Points
- All services connected to shared Docker network `infra`
- Main image is published to GHCR and versioned by `.version`
- Runtime configuration files are embedded from `configuration/` at image build time
- Backup container uploads scheduled snapshots of `zeroclaw_data` volume to S3-compatible storage

## File Structure
- `docker-compose.yaml` - stack definition (runtime + backups)
- `Dockerfile` - custom ZeroClaw image build
- `configuration/*` - embedded runtime identity/soul/config templates
- `.version` - image version pinning for CI/CD workflow
- `.github/workflows/build-zeroclaw-image.yml` - build/push automation to GHCR

## Important Notes
- Keep service port internal (`expose`) unless public publishing is explicitly required
- Keep CPU/memory limits and logging rotation configured for predictable runtime behavior
- Backup service is expected to be read-only against the main data volume
