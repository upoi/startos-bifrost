# Family AI Gateway - StartOS Package

<p align="center">
  <img src="https://raw.githubusercontent.com/maximhq/bifrost/main/docs/bifrost.svg" width="200" alt="Bifrost Logo"/>
</p>

> **Bifrost AI Gateway** packaged for StartOS - The privacy-first Family Hub orchestration layer.

## Overview

This package deploys **Bifrost** (by [Maxim AI](https://getmaxim.ai/bifrost)) on StartOS, providing a unified AI gateway for your Family Hub architecture.

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Family Hub Network                          │
│                                                                 │
│  ┌──────────────┐    ┌──────────────────────────────────────┐  │
│  │   Devices    │    │         StartOS Server               │  │
│  │              │    │                                      │  │
│  │ • Phone      │───▶│  ┌─────────────────────────────┐    │  │
│  │ • Tablet     │    │  │  Family AI Gateway          │    │  │
│  │ • Laptop     │    │  │  (Bifrost on Port 8080)     │    │  │
│  │ • Desktop    │    │  │                             │    │  │
│  └──────────────┘    │  │  ┌─────────────────────┐   │    │  │
│                      │  │  │  Virtual Key Mgmt   │   │    │  │
│                      │  │  │  Usage Tracking     │   │    │  │
│                      │  │  │  Provider Routing   │   │    │  │
│                      │  │  └──────────┬──────────┘   │    │  │
│                      │  │             │              │    │  │
│                      │  │  ┌──────────▼──────────┐   │    │  │
│                      │  │  │  Request Router     │   │    │  │
│                      │  │  └──────────┬──────────┘   │    │  │
│                      │  └─────────────┼──────────────┘    │  │
│                      │               │                     │  │
│  ┌───────────────────▼────────────────▼────────────────────┐ │
│  │                    Routing Layer                           │ │
│  │                                                          │ │
│  │  ┌─────────────────┐    ┌─────────────────────────────┐ │ │
│  │  │ Local Inference │    │     Cloud Providers          │ │ │
│  │  │                 │    │                             │ │ │
│  │  │ SwapServeLLM   │    │ • OpenRouter                │ │ │
│  │  │ (192.168.x.x)  │    │ • Anthropic                │ │ │
│  │  │                 │    │ • OpenAI                   │ │ │
│  │  │ GPU Cluster    │    │ • Google Vertex            │ │ │
│  │  └─────────────────┘    └─────────────────────────────┘ │ │
│  └──────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Features

| Feature | Description |
|---------|-------------|
| **Unified API** | Single endpoint for local and cloud AI models |
| **Virtual Keys** | Unique API keys per family application |
| **Usage Tracking** | Monitor per-member AI usage and costs |
| **Auto Failover** | Seamless fallback from local to cloud |
| **Privacy First** | Local inference keeps data on your network |
| **Web UI** | Built-in dashboard for configuration |

## Quick Start

### 1. Install via StartOS Market

Search for "Family AI Gateway" in the StartOS Marketplace and install.

### 2. Configure SwapServeLLM

Edit the provider configuration to point to your local SwapServeLLM instance:

```bash
# Via Web UI
open http://<your-startos-ip>:8080

# Or via config file
vim /home/start/.startai/data/volumes/family-ai-gateway/app/data/config/providers.yaml
```

### 3. Add Cloud Providers (Optional)

Set environment variables or add API keys via the web UI:

```bash
# Via StartOS properties
OPENROUTER_API_KEY=sk-or-xxxxx
ANTHROPIC_API_KEY=sk-ant-xxxxx
OPENAI_API_KEY=sk-xxxxx
```

### 4. Create Family Virtual Keys

Access the Keys section in the web UI to generate unique keys for each family application:

- **Notes App**: `sk-fam-notes-xxxxx`
- **Family Chat**: `sk-fam-chat-xxxxx`
- **Homework Helper**: `sk-fam-homework-xxxxx`

## API Usage

### OpenAI-Compatible Endpoint

```bash
curl -X POST http://<startos-ip>:8080/openai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-fam-notes-xxxxx" \
  -H "X-Family-Member: dad" \
  -d '{
    "model": "swapserve/llama-3.1-8b",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Switch Between Local and Cloud

```bash
# Use local model (via SwapServeLLM)
"model": "swapserve/llama-3.1-8b"

# Use cloud model (via OpenRouter)
"model": "anthropic/claude-3.5-sonnet"

# Use any model - Bifrost handles routing automatically
"model": "claude-3-5-sonnet"  # Routes to available provider
```

## Performance

- **Bifrost Overhead**: ~11 µs per request
- **Local Inference**: 18x-31x faster cold starts via SwapServeLLM
- **Throughput**: Tested at 5,000+ RPS

## Troubleshooting

### Local inference not connecting

```bash
# Check SwapServeLLM is running
curl http://192.168.1.100:8000/health

# Verify network connectivity from container
docker exec -it family-ai-gateway curl http://192.168.1.100:8000/health
```

### Cloud providers not working

```bash
# Verify API keys are set
docker exec -it family-ai-gateway env | grep API_KEY

# Check logs
docker exec -it family-ai-gateway cat /app/data/logs/bifrost.log
```

## Development

```bash
# Build the package
make build

# Test locally
make test

# Package for distribution
make package
```

## License

- **Bifrost**: Apache 2.0 - [Maxim AI](https://getmaxim.ai)
- **Package**: MIT

---

<p align="center">
  Built with ❤️ for the Family Hub
</p>
