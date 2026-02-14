# Deployment Guide - Port Configuration

## 🎯 Overview

**nerochat.co.in** now uses **enterprise-grade port configuration** by default:

- **External Access:** Port 80 (HTTP) and 443 (HTTPS) only
- **Internal Services:** All services run on port 8080 internally
- **Routing:** Nginx reverse proxy handles all traffic

---

## 📊 Port Configuration Summary

### Production (Default - `docker-compose.yml`)

```
External Access:
├── Port 80  (HTTP)  → Nginx
└── Port 443 (HTTPS) → Nginx

Nginx Routes:
├── /api/agent/   → agent_service:8080
├── /api/auth/    → auth_service:8080
└── /api/records/ → record_service:8080

Internal Services (not exposed):
├── agent_service:8080
├── auth_service:8080
├── record_service:8080
├── redis:6379
└── chroma:8000
```

### Development (`docker-compose.dev.yml`)

```
Direct Access:
├── localhost:8001 → agent_service
├── localhost:5004 → auth_service
├── localhost:7001 → record_service
├── localhost:6379 → redis
└── localhost:8000 → chroma
```

---

## 🚀 Deployment Options

### Option 1: Production (Recommended)

**Use Case:** Production deployment with SSL and security

```bash
# Start production environment
docker-compose up -d

# Access services
curl http://localhost/health
curl http://localhost/api/agent/health
curl http://localhost/api/auth/health
```

**Features:**
- ✅ Single entry point (port 80/443)
- ✅ SSL/TLS support
- ✅ Rate limiting
- ✅ Load balancing
- ✅ Security headers
- ✅ Service isolation

**URLs:**
```
http://localhost/api/agent/
http://localhost/api/auth/
http://localhost/api/records/

# With domain:
https://nerochat.co.in/api/agent/
https://nerochat.co.in/api/auth/
```

---

### Option 2: Development Mode

**Use Case:** Local development with direct service access

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up -d

# Access services directly
curl http://localhost:8001/health  # Agent
curl http://localhost:5004/health  # Auth
curl http://localhost:7001/health  # Records
```

**Features:**
- ✅ Direct service access
- ✅ Hot reload (volume mounts)
- ✅ Easy debugging
- ✅ Familiar ports

**URLs:**
```
http://localhost:8001  # Agent Service
http://localhost:5004  # Auth Service
http://localhost:7001  # Record Service
```

---

### Option 3: Enterprise (Alternative)

**Use Case:** Testing enterprise config without changing main file

```bash
# Use the enterprise-specific file
docker-compose -f docker-compose.enterprise.yml up -d
```

This is identical to the default `docker-compose.yml` but kept separate for reference.

---

## 🔄 Migration from Old Ports

### What Changed?

| Component | Old Port | New Port (Internal) | External Access |
|-----------|----------|---------------------|-----------------|
| Agent Service | 8001 | 8080 | /api/agent/ |
| Auth Service | 5004 | 8080 | /api/auth/ |
| Record Service | 7001 | 8080 | /api/records/ |
| Redis | 6379 | 6379 | Internal only |
| ChromaDB | 8000 | 8000 | Internal only |
| **Nginx** | - | - | **80, 443** |

### Update Your Code

#### Frontend API Calls

**Before:**
```javascript
const AGENT_API = 'http://localhost:8001';
const AUTH_API = 'http://localhost:5004';
```

**After (Production):**
```javascript
const API_BASE = process.env.REACT_APP_API_URL || 'http://localhost';
const AGENT_API = `${API_BASE}/api/agent`;
const AUTH_API = `${API_BASE}/api/auth`;
```

**After (Development):**
```javascript
// Use docker-compose.dev.yml and keep old URLs
const AGENT_API = 'http://localhost:8001';
const AUTH_API = 'http://localhost:5004';
```

---

## 🔧 Configuration

### Environment Variables

Both services now support the `PORT` environment variable:

**Production (docker-compose.yml):**
```yaml
environment:
  - PORT=8080  # All services use 8080
```

**Development (docker-compose.dev.yml):**
```yaml
environment:
  - PORT=8001  # Agent
  - PORT=5004  # Auth
  - PORT=7001  # Records
```

### .env Files

Update your `.env` files:

**agent/.env:**
```env
PORT=8080  # For production
# PORT=8001  # For development
```

**auth/.env:**
```env
PORT=8080  # For production
# PORT=5004  # For development
```

---

## 🛠️ Common Commands

### Production Deployment

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Check status
docker-compose ps

# Stop services
docker-compose down
```

### Development Mode

```bash
# Start services
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Restart a service
docker-compose -f docker-compose.dev.yml restart agent_service

# Stop services
docker-compose -f docker-compose.dev.yml down
```

### Switch Between Modes

```bash
# Stop current mode
docker-compose down

# Start production mode
docker-compose up -d

# OR start development mode
docker-compose -f docker-compose.dev.yml up -d
```

---

## 🔒 SSL/HTTPS Setup

### Generate Self-Signed Certificate (Development)

```bash
mkdir -p nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/key.pem \
  -out nginx/ssl/cert.pem \
  -subj "/CN=localhost"
```

### Use Let's Encrypt (Production)

```bash
# Install certbot
sudo apt-get install certbot

# Generate certificate
sudo certbot certonly --standalone -d nerochat.co.in -d www.nerochat.co.in

# Copy certificates
sudo cp /etc/letsencrypt/live/nerochat.co.in/fullchain.pem nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/nerochat.co.in/privkey.pem nginx/ssl/key.pem

# Set permissions
sudo chmod 644 nginx/ssl/cert.pem
sudo chmod 600 nginx/ssl/key.pem
```

### Enable HTTPS in Nginx

Edit `nginx/nginx.conf` and uncomment the HTTPS server block (lines ~120-150).

---

## 📊 Health Checks

### Production

```bash
# Overall health
curl http://localhost/health

# Service health
curl http://localhost/api/agent/health
curl http://localhost/api/auth/health
```

### Development

```bash
# Service health
curl http://localhost:8001/health
curl http://localhost:5004/health
curl http://localhost:7001/health
```

---

## 🐛 Troubleshooting

### Port 80 already in use

```bash
# Find what's using port 80
sudo netstat -tulpn | grep :80

# Stop the service or use different port
# Edit docker-compose.yml:
ports:
  - "8080:80"  # Use port 8080 instead
```

### Services can't connect to each other

Make sure all services are on the same network:
```bash
docker network ls
docker network inspect nerochat-network
```

### Nginx shows 502 Bad Gateway

```bash
# Check if backend services are running
docker-compose ps

# Check backend logs
docker-compose logs agent_service
docker-compose logs auth_service

# Verify PORT environment variable
docker-compose exec agent_service env | grep PORT
```

### Can't access services externally

```bash
# Check firewall
sudo ufw status
sudo ufw allow 80
sudo ufw allow 443

# Check nginx is running
docker-compose ps nginx
docker-compose logs nginx
```

---

## 📈 Performance Tips

### Production Optimizations

1. **Enable Gzip Compression** (already configured in nginx.conf)
2. **Use Redis for Caching** (already configured)
3. **Enable HTTP/2** (requires HTTPS)
4. **Use CDN** for static assets
5. **Enable Connection Pooling** in services

### Scaling

```bash
# Scale agent service to 3 instances
docker-compose up -d --scale agent_service=3

# Nginx will automatically load balance
```

---

## 🎓 Best Practices

1. **Use Production Mode** for staging and production
2. **Use Development Mode** for local development only
3. **Always use HTTPS** in production
4. **Keep .env files** out of version control
5. **Use managed services** (Redis, MongoDB) in production
6. **Monitor logs** regularly
7. **Set up automated backups**
8. **Use health checks** for auto-recovery

---

## 📚 Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Configuration Guide](https://nginx.org/en/docs/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
- [FastAPI Deployment](https://fastapi.tiangolo.com/deployment/)

---

**Questions?** Open an issue on [GitHub](https://github.com/amritendunath/nerochat.co.in/issues)
