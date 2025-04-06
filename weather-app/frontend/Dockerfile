# Use Node.js Alpine as the base image
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json  ./
RUN npm install

# Copy the frontend code (Ensure it includes index.html)
COPY . . 

# Build the frontend
RUN npm run build

# Use a lightweight server to serve the frontend (like Nginx)
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
