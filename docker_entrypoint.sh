#!/bin/bash
set -e

echo "Starting Bifrost AI Gateway..."
echo "Web UI: http://localhost:8080"
echo "API: http://localhost:8080/openai"

exec bifrost "$@"
