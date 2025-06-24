# STAGE 1: Build the app
FROM node:18-alpine as build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the source
COPY . ./
RUN npm run build

# Check the contents of /app/dist
RUN ls -la /app/dist

# STAGE 2: Run the app with Nginx
FROM nginx:1.25.5-alpine

# Replace default Nginx config with your custom one
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the build output into Nginx's web root
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: expose port 80
EXPOSE 80

# Default Nginx command
CMD ["nginx", "-g", "daemon off;"]

