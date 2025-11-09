# Use the official NGINX base image from Docker Hub
FROM nginx:alpine

# Copy the static website or application files to the default directory
# Replace 'your-app' with the directory where your website is located
COPY ./nginx /usr/share/nginx/html

# Expose the port that NGINX will use
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
