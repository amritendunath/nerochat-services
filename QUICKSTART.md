# Quick Start Guide - nerochat.co.in

Choose your deployment mode based on your needs:

## 🚀 Production Deployment (Recommended)

**Best for:** Live production environment with SSL and security

```bash
# 1. Clone repository
git clone https://github.com/amritendunath/nerochat.co.in.git
cd nerochat.co.in/services

# 2. Configure environment
cp agent/.env.example agent/.env
cp auth/.env.example auth/.env
# Edit .env files with your credentials

# 3. Set up SSL certificates
mkdir -p nginx/ssl
# Place cert.pem and key.pem in nginx/ssl/

# 4. Deploy
docker-compose -f docker-compose.enterprise.yml up -d

# 5. Verify
curl https://nerochat.co.in/health
```

**Access:**
- Main: `https://nerochat.co.in`
- Agent API: `https://nerochat.co.in/api/agent/`
- Auth API: `https://nerochat.co.in/api/auth/`

---

## 💻 Development Mode

**Best for:** Local development and testing

```bash
# 1. Clone repository
git clone https://github.com/amritendunath/nerochat.co.in.git
cd nerochat.co.in/services

# 2. Configure environment
cp agent/.env.example agent/.env
cp auth/.env.example auth/.env

# 3. Start services
docker-compose up -d

# 4. Verify
curl http://localhost:8001/health
```

**Access:**
- Agent Service: `http://localhost:8001`
- Auth Service: `http://localhost:5004`
- Record Service: `http://localhost:7001`

---

## 🛠️ Local Development (No Docker)

**Best for:** Active development with hot-reload

### Agent Service
```bash
cd agent
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python src/main.py
```

### Auth Service
```bash
cd auth
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python src/main.py
```

---

## 🔧 Common Commands

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f agent_service
```

### Restart Services
```bash
# All services
docker-compose restart

# Specific service
docker-compose restart agent_service
```

### Stop Services
```bash
docker-compose down
```

### Update Services
```bash
git pull
docker-compose pull
docker-compose up -d
```

---

## 📚 Next Steps

- Read the full [README.md](README.md)
- Check [API Documentation](https://nerochat.co.in/api/agent/docs)
- Review [Port Configuration Guide](PORT_COMPARISON.md)
- See [Contributing Guidelines](CONTRIBUTING.md)

---

## 🆘 Troubleshooting

### Services won't start
```bash
# Check logs
docker-compose logs

# Rebuild containers
docker-compose build --no-cache
docker-compose up -d
```

### Port already in use
```bash
# Find process using port
netstat -ano | findstr :8001  # Windows
lsof -i :8001                 # Linux/Mac

# Kill process or change port in docker-compose.yml
```

### Environment variables not loading
```bash
# Verify .env file exists
ls agent/.env auth/.env

# Check file format (no spaces around =)
# Correct: PORT=8080
# Wrong:   PORT = 8080
```

---

**Need help?** Open an issue on [GitHub](https://github.com/amritendunath/nerochat.co.in/issues)
