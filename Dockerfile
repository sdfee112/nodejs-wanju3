FROM node:current-slim

WORKDIR /dashboard

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application files
COPY index.js ./
COPY init.sh ./

# Install other required packages
RUN apt-get update && \
    apt-get -y install openssh-server wget iproute2 vim git cron unzip supervisor nginx sqlite3 && \
    # Configure Git settings
    git config --global core.bigFileThreshold 1k && \
    git config --global core.compression 0 && \
    git config --global advice.detachedHead false && \
    git config --global pack.threads 1 && \
    git config --global pack.windowMemory 50m && \
    # Clean up
    apt-get clean && \
    chmod 777 ./init.sh && \
    rm -rf /var/lib/apt/lists/*

# Expose the necessary port (if needed)
EXPOSE 3000

# Set the entrypoint to start the index.js file
CMD ["node", "index.js"]
