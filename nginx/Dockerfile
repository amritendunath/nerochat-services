FROM nginx:latest

# Copy your custom main configuration file (this now handles everything)
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]