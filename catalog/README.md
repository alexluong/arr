# Media Catalog

Structured catalog for the arr media library.

## Files

| File | Purpose |
|------|---------|
| `media.json` | Library inventory (movies, TV shows) |
| `downloads.json` | Active downloads and seeding status |
| `torrents.json` | Torrent files and private tracker info |

## Storage Locations

- **Library**: `/Volumes/Blue4/arr/media/`
- **Downloads**: `/Volumes/Blue4/arr/downloads/`
- **Torrent Files**: `/Volumes/Blue4/pt/dc/`

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/scan-media.sh` | Scan library and output summary |
| `scripts/verify.sh` | Verify hardlinks, check for missing episodes |

## Naming Conventions

### Movies (Radarr default)
```
Folder: {Movie Title} ({Year})/
File:   {Movie Title} ({Year}) {Quality}.{ext}

Example: The Grey (2011)/The Grey (2011) Bluray-1080p.mkv
```

### TV Shows (Sonarr default)
```
Folder: {Series Title}/Season {X}/
File:   {Series Title} - S{00}E{00} - {Episode Title} {Quality}.{ext}

Example: Friends/Season 1/Friends - S01E01 - The Pilot HDTV-1080p.mkv
```

### Quality Tags
| Tag | Source |
|-----|--------|
| `Bluray-1080p` | 1080p BluRay |
| `Bluray-2160p` | 4K BluRay |
| `WEB-DL-1080p` | Streaming download |
| `WEBRip-1080p` | Web capture |
| `HDTV-1080p` | TV broadcast |

## Hardlinks

Hardlinks allow the same file to exist in two locations (downloads + library) using zero extra disk space.

### How It Works
```
downloads/movie.mkv  ──┐
                       ├──► [actual data on disk]
media/movie.mkv      ──┘
```

### Key Behavior
| Action | Result |
|--------|--------|
| Delete from `/downloads` | `/media` still works |
| Delete from `/media` | `/downloads` still works |
| Delete both | Data actually deleted |

### Benefits
- **No duplicate space**: Same data, two paths
- **Seed forever**: Keep `/downloads` for torrent client
- **Clean up anytime**: Done seeding? Delete from `/downloads`, library stays
- **Remove from library anytime**: Delete from `/media`, still seeding

### Limitation
Hardlinks only work on the same filesystem/volume. Cannot hardlink across different drives.
