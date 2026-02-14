# Contributing to nerochat.co.in

Thank you for your interest in contributing to nerochat.co.in! This document provides guidelines and instructions for contributing.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Our Standards

- ✅ Be respectful and inclusive
- ✅ Accept constructive criticism gracefully
- ✅ Focus on what's best for the community
- ✅ Show empathy towards others

## 🚀 Getting Started

### Prerequisites

- Git
- Docker & Docker Compose
- Python 3.9+
- Node.js 16+
- Basic understanding of FastAPI and React

### Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/nerochat.co.in.git
cd nerochat.co.in

# Add upstream remote
git remote add upstream https://github.com/amritendunath/nerochat.co.in.git
```

### Set Up Development Environment

```bash
# Navigate to services
cd services

# Copy environment files
cp agent/.env.example agent/.env
cp auth/.env.example auth/.env

# Start development environment
docker-compose up -d

# Verify services are running
docker-compose ps
```

## 🔄 Development Workflow

### 1. Create a Branch

```bash
# Update your main branch
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
# Or for bug fixes
git checkout -b fix/bug-description
```

### 2. Make Changes

- Write clean, readable code
- Follow our coding standards (see below)
- Add tests for new features
- Update documentation as needed

### 3. Test Your Changes

```bash
# Run unit tests
cd agent
pytest tests/ -v

cd ../auth
pytest tests/ -v

# Run integration tests
docker-compose -f docker-compose.test.yml up -d
pytest tests/integration/ -v
```

### 4. Commit Your Changes

We use [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Format: <type>(<scope>): <description>

git commit -m "feat(agent): add symptom checker functionality"
git commit -m "fix(auth): resolve OAuth callback issue"
git commit -m "docs(readme): update deployment instructions"
git commit -m "test(agent): add tests for appointment booking"
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### 5. Push and Create PR

```bash
# Push to your fork
git push origin feature/your-feature-name

# Create a Pull Request on GitHub
# Fill out the PR template completely
```

## 💻 Coding Standards

### Python (FastAPI Services)

#### Style Guide

- Follow [PEP 8](https://pep8.org/)
- Use [Black](https://black.readthedocs.io/) for formatting
- Use [isort](https://pycqa.github.io/isort/) for import sorting
- Use type hints

```python
# Good
def calculate_bmi(weight: float, height: float) -> float:
    """Calculate Body Mass Index.
    
    Args:
        weight: Weight in kilograms
        height: Height in meters
        
    Returns:
        BMI value
    """
    return weight / (height ** 2)

# Bad
def calc(w, h):
    return w/(h**2)
```

#### Code Formatting

```bash
# Format code with Black
black src/

# Sort imports
isort src/

# Check with flake8
flake8 src/
```

#### Docstrings

Use Google-style docstrings:

```python
def book_appointment(
    patient_id: str,
    doctor_id: str,
    datetime: str
) -> dict:
    """Book a medical appointment.
    
    Args:
        patient_id: Unique identifier for the patient
        doctor_id: Unique identifier for the doctor
        datetime: Appointment datetime in ISO format
        
    Returns:
        Dictionary containing appointment details
        
    Raises:
        ValueError: If datetime is in the past
        NotFoundError: If patient or doctor not found
    """
    pass
```

### JavaScript/React (Frontend)

#### Style Guide

- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use [Prettier](https://prettier.io/) for formatting
- Use ESLint for linting

```javascript
// Good
const ChatMessage = ({ message, sender, timestamp }) => {
  const formattedTime = formatTimestamp(timestamp);
  
  return (
    <div className="chat-message">
      <span className="sender">{sender}</span>
      <p className="content">{message}</p>
      <time className="timestamp">{formattedTime}</time>
    </div>
  );
};

// Bad
function msg(m,s,t) {
  return <div><span>{s}</span><p>{m}</p><time>{t}</time></div>
}
```

### Database

#### MongoDB

- Use descriptive collection names (plural)
- Create indexes for frequently queried fields
- Use schema validation

```python
# Good
users_collection = db["users"]
users_collection.create_index("email", unique=True)

# Bad
u = db["u"]
```

## 🧪 Testing Guidelines

### Test Coverage

- Maintain minimum 80% code coverage
- Write tests for all new features
- Update tests when modifying existing code

### Test Structure

```python
# tests/test_appointments.py
import pytest
from src.services.appointments import AppointmentService

class TestAppointmentService:
    """Test suite for appointment service."""
    
    @pytest.fixture
    def service(self):
        """Create appointment service instance."""
        return AppointmentService()
    
    def test_create_appointment_success(self, service):
        """Test successful appointment creation."""
        result = service.create_appointment(
            patient_id="P123",
            doctor_id="D456",
            datetime="2024-03-15T10:00:00"
        )
        assert result["status"] == "confirmed"
        assert result["patient_id"] == "P123"
    
    def test_create_appointment_past_date(self, service):
        """Test appointment creation fails for past dates."""
        with pytest.raises(ValueError):
            service.create_appointment(
                patient_id="P123",
                doctor_id="D456",
                datetime="2020-01-01T10:00:00"
            )
```

### Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src --cov-report=html

# Run specific test file
pytest tests/test_appointments.py

# Run specific test
pytest tests/test_appointments.py::TestAppointmentService::test_create_appointment_success
```

## 🔍 Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commit messages follow conventional commits
- [ ] No merge conflicts with main branch

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings generated
```

### Review Process

1. Automated checks run (tests, linting)
2. Code review by maintainers
3. Address feedback
4. Approval and merge

## 🐛 Issue Reporting

### Bug Reports

Use the bug report template:

```markdown
**Describe the bug**
A clear description of the bug

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What should happen

**Screenshots**
If applicable

**Environment**
- OS: [e.g., Ubuntu 22.04]
- Browser: [e.g., Chrome 120]
- Version: [e.g., 6.0.0]

**Additional context**
Any other relevant information
```

### Feature Requests

```markdown
**Is your feature request related to a problem?**
Description of the problem

**Describe the solution you'd like**
Clear description of desired functionality

**Describe alternatives you've considered**
Other solutions you've thought about

**Additional context**
Mockups, examples, etc.
```

## 🏆 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project website

## 📞 Getting Help

- **Discord:** Join our community server
- **GitHub Discussions:** Ask questions
- **Email:** dev@nerochat.co.in

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to nerochat.co.in! 🎉
