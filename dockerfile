# Build + run simple Node/Static app.
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget ca-certificates gnupg2 \
    libgtk-3-0 libnss3 libasound2 libx11-6 libx11-xcb1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# copy everything (source code + deb if you uploaded it)
COPY . /app
WORKDIR /app

# jeśli w repo jest .deb, install it:
RUN if [ -f "/app/Pinokio_3.9.0_amd64.deb" ]; then apt-get update && apt-get install -y /app/Pinokio_3.9.0_amd64.deb || true; fi

# expose typical port (zmień jeśli Pinokio raportuje inny)
EXPOSE 5173

# Command to run — spróbuj najpierw binarki pinokio, fallback do npm start
CMD ["sh", "-c", "if command -v pinokio >/dev/null 2>&1; then pinokio; elif [ -f package.json ]; then npm install && npm run start; else echo 'No start command found'; sleep 3600; fi"]
