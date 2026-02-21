# =============================================================================
# Family AI Gateway - Bifrost Wrapper for StartOS
# =============================================================================
FROM maximhq/bifrost:latest

LABEL maintainer="Family Hub Team"
LABEL version="0.1.0.0"
LABEL description="Bifrost AI Gateway for StartOS"

ENV ENABLE_VISION=true
ENV BIFROST_LOG_LEVEL=info
ENV BIFROST_CONFIG_PATH=/app/data/config
ENV BIFROST_KEYS_PATH=/app/data/keys

COPY config/ /app/data/config/
COPY docker_entrypoint.sh /docker_entrypoint.sh

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["/docker_entrypoint.sh"]
