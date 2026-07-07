# FiveM Graffiti Tags Resource

> **WORK IN PROGRESS | AI-Slop | KRGSH-Scripts**

Transparent PNG graffiti tags with range-based visibility in 3D world.

## Features
- ESP/ESX/QBCore/QBox compatible
- 3D DUI rendering with transparent PNG support
- Range-based visibility (15m-25m)
- Spray can animation with progress bar
- Configurable graffiti types and materials
- OX_TARGET/qb-target support for removal

## Installation
1. Place resource in `resources/[local]/graffiti_tags`
2. Add `ensure graffiti_tags` to server.cfg
3. Run SQL from `sql/graffiti_tags.sql`

## Commands
- `/graffiti [type]` - Place graffiti (e.g., `/graffiti tag2`)
- `/graffiti_remove` - Remove nearby graffiti

## Development
```bash
make install-deps  # Install luacheck, luaunit
make test          # Run syntax and compatibility checks
make ci            # Full CI pipeline
```

## License
AI-Slop / KRGSH-Scripts - Work in Progress