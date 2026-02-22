FROM maximhq/bifrost:latest

# Ensure we are root for the whole process
USER root

# Set the database location via Environment Variables
ENV BIFROST_DATABASE_TYPE=sqlite
ENV BIFROST_DATABASE_CONFIG_PATH=/app/data/bifrost.db

COPY config/ /app/config/
COPY docker_entrypoint.sh /docker_entrypoint.sh
RUN chmod +x /docker_entrypoint.sh

# No USER appuser here—let it run as root inside the container
ENTRYPOINT ["/docker_entrypoint.sh"]