# arrstack

Lightweight arr stack running on Colima (separate from Docker Desktop).

## Setup

```bash
# Install Colima
brew install colima

# Copy environment file
cp .env.example .env

# Create directories on SSD
mkdir -p "/Volumes/T7/arr"/{data,downloads,media}

# Start VM
./scripts/vm-start.sh

# Start containers
./scripts/up.sh download
```

## Environment Variables

### PUID / PGID

LinuxServer.io containers run processes as a specific user/group. This controls file ownership on mounted volumes.

Without setting these, files created by containers are owned by `root`, causing permission issues when accessing from macOS.

```bash
# Find your values:
id
# uid=501(alexluong) gid=20(staff) ...
#     ^^^PUID           ^^^PGID
```

Common macOS values:
- PUID=501 (first user)
- PGID=20 (staff group)

### TZ

Timezone for the containers. Affects scheduled tasks, log timestamps, etc.

Format: `Area/City` (e.g., `Asia/Ho_Chi_Minh`, `America/New_York`)

### VPN

Download traffic routes through [Gluetun](https://github.com/qdm12/gluetun-wiki/tree/main/setup/providers) VPN container.

1. Find your VPN provider in the [gluetun providers list](https://github.com/qdm12/gluetun-wiki/tree/main/setup/providers)
2. Optionally generate OpenVPN credentials from your provider's dashboard
3. Fill in `.env`:
   - `VPN_SERVICE_PROVIDER` - provider name (e.g., `private internet access`)
   - `OPENVPN_USER` - your VPN username
   - `OPENVPN_PASSWORD` - your VPN password
   - `SERVER_REGIONS` - optional, comma-separated regions

Test VPN is working:
```bash
docker --context colima-arr exec gluetun wget -qO- https://ipinfo.io
```

## Scripts

| Script | Description |
|--------|-------------|
| `./scripts/vm-start.sh` | Start Colima VM |
| `./scripts/vm-stop.sh` | Stop Colima VM (do before unplugging SSD) |
| `./scripts/up.sh [stack]` | Start containers (download, arr, all) |
| `./scripts/down.sh [stack]` | Stop containers |

## Architecture

```
Colima VM (2 CPU, 2GB RAM)
├── Gluetun (VPN)
│   └── qBittorrent (download client, routes through VPN)
├── Prowlarr (indexer manager)
├── Sonarr (TV)
└── Radarr (Movies)
        │
        ▼
/Volumes/T7/arr/
├── data/            # App databases, state, settings
├── downloads/       # Temporary download location
└── media/           # Organized library (TV, Movies)
```
