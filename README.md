# Family AI Gateway - StartOS Package

<p align="center">
  <img src="https://raw.githubusercontent.com/maximhq/bifrost/main/docs/bifrost.svg" width="200" alt="Bifrost Logo"/>
</p>

> **Bifrost AI Gateway** packaged for StartOS — unified AI provider access with per-key usage tracking for the family.

## Architecture

```
Family Devices (phone, tablet, laptop)
        │
        │  Authorization: Bearer <virtual-key>
        ▼
┌─────────────────────────┐
│   Family AI Gateway     │  StartOS (port 8080, LAN/TOR)
│   (Bifrost)             │
│                         │
│  • Virtual key auth     │
│  • Usage tracking       │
│  • Provider routing     │
│  • Request logging      │
└──────────┬──────────────┘
           │  Uses stored provider API keys
           ▼
    ┌──────────────┐
    │  OpenRouter  │  (and/or Anthropic, OpenAI, local)
    └──────────────┘
```

## Setup

All configuration is done via the **Bifrost Web UI** — no environment variables or config files.

### 1. Install
Sideload `bifrost.s9pk` via StartOS: Settings → Sideload Service.

### 2. Add Provider Keys (Web UI)
Open the gateway UI and add your provider API keys:

| Provider | Base URL |
|----------|----------|
| OpenRouter | `https://openrouter.ai/api` ⚠️ no `/v1` suffix |
| Anthropic | `https://api.anthropic.com` |
| OpenAI | `https://api.openai.com/v1` |

> **Important**: OpenRouter's base URL in Bifrost must be `https://openrouter.ai/api` — Bifrost appends `/v1/chat/completions` itself. Using `https://openrouter.ai/api/v1` results in a double `/v1/v1/` path and a 404.

### 3. Create Virtual Keys (Web UI)
Go to Keys in the UI and create one per family app or member. These are what clients use to authenticate — Bifrost maps them to the real provider keys internally.

Examples:
- `sk-fam-dad-phone`
- `sk-fam-homework-helper`
- `sk-fam-notes-app`

## API Usage

### Chat Completions

```bash
curl -k https://<startos-address>/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-virtual-key>" \
  -d '{
    "model": "openrouter/arcee-ai/trinity-large-preview:free",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Model Format

Models are prefixed with the provider name:

```
openrouter/anthropic/claude-3.5-sonnet
openrouter/openai/gpt-4o-mini
openrouter/arcee-ai/trinity-large-preview:free
anthropic/claude-3-5-sonnet-20241022
openai/gpt-4o
```

### Virtual Keys & Usage Tracking

Sending `Authorization: Bearer <virtual-key>` is **required** for per-key tracking. Bifrost logs requests per virtual key, enabling you to see which app or family member is consuming what in the Logs UI.

`allow_direct_keys` is set to `false` — clients cannot bypass the gateway with real provider API keys.

## Persistence

All data lives in the StartOS data volume at `/app/data/`:

| File | Contents |
|------|----------|
| `bifrost.db` | Provider config, virtual keys (from UI) |
| `logs.db` | Request logs, usage tracking |

Both survive service restarts and upgrades. Uninstalling and reinstalling will wipe them.

## Development

```bash
# Rebuild Docker image and repackage (requires Docker Desktop with WSL2 integration)
make

# Force rebuild (when only config changed, not Dockerfile)
rm -f docker-images/x86_64.tar && make

# Clean build artifacts
make clean
```

## License

- **Bifrost**: Apache 2.0 — [Maxim AI](https://getmaxim.ai)
- **Package**: MIT
