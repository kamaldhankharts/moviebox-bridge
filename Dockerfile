FROM python:3.12-slim

WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# DIAGNOSTIC: print what the installed moviebox-api package contains (temporary)
RUN pip list 2>/dev/null | grep -i -E "moviebox|throttle" ; \
    pip show -f moviebox-api | grep -E "^(Name|Version|Requires)|\.py$" | head -200 ; \
    python -c "import moviebox_api.v3.http_client as m; print('V3 IMPORT OK')" ; \
    true

# Copy application code
COPY main.py .

# Expose port (Railway will override this)
EXPOSE 8000

# Run the application
# Railway sets the PORT environment variable dynamically
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
