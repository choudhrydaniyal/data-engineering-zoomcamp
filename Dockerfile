# Start with slim Python 3.13 image
FROM python:3.13-slim

# Copy uv binary from official uv image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Add virtual environment to PATH so installed executables work directly
ENV PATH="/app/.venv/bin:$PATH"

# Copy dependency files first (for Docker layer caching)
COPY pyproject.toml uv.lock .python-version ./

# Install dependencies into virtual environment (frozen sync, no dev dependencies)
RUN uv sync --frozen --no-dev

# Copy application code
COPY ingest_data.py .

# Set entry point using python directly from PATH
ENTRYPOINT ["python", "ingest_data.py"]