# FiveM Graffiti Tags Resource

Transparent PNG graffiti tags with range-based visibility in 3D world.

## Features
- ESP/ESX/QBCore/QBox compatible
- 3D DUI rendering with transparent PNG support
- Range-based visibility (15m-25m)
- Spray can animation with progress bar
- Configurable graffiti types and materials

## Installation
1. Place resource in `resources/[local]/graffiti_tags`
2. Add `ensure graffiti_tags` to server.cfg
3. Run SQL from `sql/graffiti_tags.sql`

## Commands
- `/graffiti [type]` - Place graffiti (e.g., `/graffiti tag2`)

## Development
```bash
make install-deps  # Install luacheck, luaunit
make test          # Run syntax and compatibility checks
make format        # Check code formatting
make ci            # Full CI pipeline
```