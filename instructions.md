# Family AI Gateway - Installation Instructions

## Overview

Family AI Gateway provides a unified API for accessing multiple AI providers through Bifrost. This service runs on StartOS and provides a web interface for configuration.

## Getting Started

### 1. Install the Service

Install "Family AI Gateway" from the StartOS marketplace.

### 2. Access the Web Interface

After installation, access the web UI at:
- **LAN**: http://<your-server-ip>:8080
- **Tor**: Check the service details in StartOS for your Tor address

### 3. Configure API Providers

Add your API keys through the web interface or environment variables:

- `OPENROUTER_API_KEY` - Get from https://openrouter.ai
- `ANTHROPIC_API_KEY` - Get from https://anthropic.com
- `OPENAI_API_KEY` - Get from https://platform.openai.com

### 4. Using the API

The service provides an OpenAI-compatible API at:
```
http://<your-server-ip>:8080/openai/v1/chat/completions
```

Example request:
```bash
curl -X POST http://<your-server-ip>:8080/openai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "model": "anthropic/claude-3-5-sonnet",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## Features

- **Unified API**: Access multiple AI providers through a single endpoint
- **Web UI**: Configure providers and manage settings
- **Usage Tracking**: Monitor API usage
- **2500+ Models**: Access models from 80+ providers via OpenRouter

## Troubleshooting

### Service not starting
Check logs in StartOS dashboard or via:
```bash
docker logs family-ai-gateway
```

### Can't connect to API
Ensure the service is running and check your firewall settings.

### API keys not working
Verify API keys are set correctly in the service configuration.
