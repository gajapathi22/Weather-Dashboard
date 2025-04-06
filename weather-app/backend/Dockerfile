FROM node:18-alpine

# Create and set working directory
WORKDIR /usr/src/app

# Copy package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all application files
COPY . .

# Explicitly set the command to run
CMD ["node", "index.js"]

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/health || exit 1

EXPOSE 5000