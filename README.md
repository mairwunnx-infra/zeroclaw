# ZeroClaw Portainer стек

[![AI Capable](https://img.shields.io/badge/AI-Capable-brightgreen?style=flat&logo=openai&logoColor=white)](https://github.com/mairwunnx-infra/zeroclaw)
[![Docker](https://img.shields.io/badge/Docker-Available-2496ED?style=flat&logo=docker&logoColor=white)](https://github.com/mairwunnx-infra/zeroclaw/pkgs/container/zeroclaw)

ZeroClaw стек для автономного Telegram-бота в инфраструктуре сервера.

В `docker-compose.yaml` описаны:
- основной сервис `zeroclaw` с лимитами ресурсов, healthcheck и ротацией логов;
- named volume `zeroclaw_data` для runtime данных;
- backup сервис `backup-zeroclaw` (offen/docker-volume-backup) для регулярных бэкапов в S3.

Кастомный образ собирается из исходников `zeroclaw/` и получает конфигурацию через встроенные файлы из `configuration/`:
- `configuration/config.toml`
- `configuration/IDENTITY.md`
- `configuration/SOUL.md`

Автосборка и публикация в GHCR настраивается workflow-файлом `.github/workflows/build-zeroclaw-image.yml`.

> Примечание: сервис работает внутри сети `infra` и не публикует порт наружу (используется `expose`).

### Связные ссылки:

- [Infra Zygote](https://github.com/mairwunnx-infra/zygote) - Зигота/основа инфраструктуры.
- [Infra Xi Manager](https://github.com/mairwunnx-infra/ximanager) - Portainer стек для проекта Xi Manager.
- [Infra Ingress](https://github.com/mairwunnx-infra/ingress) - Portainer стек для входящего трафика.
- [Infra VS Code](https://github.com/mairwunnx-infra/vscode) - Portainer стек для VS Code.
- [Infra GitLab](https://github.com/mairwunnx-infra/gitlab) - Portainer стек для GitLab.
- [Infra Jenkins](https://github.com/mairwunnx-infra/jenkins) - Portainer стек для Jenkins.
