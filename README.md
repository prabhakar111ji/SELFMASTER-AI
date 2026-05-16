# SELFMASTER AI

> **"Become the Master of Yourself."**

An AI-Powered Behavioral Intelligence Platform built with Java Spring Boot that helps humans gain self-control, defeat procrastination, build discipline, and become the best version of themselves.

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Backend** | Java 17, Spring Boot 3.2.5, Spring Security, JPA/Hibernate |
| **Authentication** | JWT (jjwt 0.12.5), BCrypt |
| **Frontend** | Thymeleaf, HTML5, CSS3, JavaScript |
| **Database** | PostgreSQL 15+ |
| **Charts** | ApexCharts |
| **AI** | OpenAI GPT-4o-mini API |
| **Exports** | iText PDF, Apache POI (Excel) |
| **Deployment** | Docker, Docker Compose |

## Modules

1. **Authentication System** - Register, Login, JWT, Password Reset
2. **Goal Management** - SMART Goals, Milestones, Progress Tracking
3. **Habit Intelligence** - Streaks, Scoring, Trigger Tracking
4. **Focus Timer** - Pomodoro, Deep Work, Flow, Dopamine Detox
5. **Daily Accountability** - Morning Planning, Night Review
6. **Emotional Intelligence** - Mood, Energy, Stress, Anxiety Tracking
7. **Journal** - Daily Reflections and Thoughts
8. **AI Life Coach** - OpenAI-powered behavioral coaching
9. **AI Decision Support** - 5-dimension decision analysis
10. **Discipline Engine** - 7 Mastery Scores computed daily
11. **Life Analytics** - Charts, Graphs, Behavioral Trends
12. **Challenges & Gamification** - XP, Levels, Badges, Streaks

## Setup

### Prerequisites
- Java 17+
- Maven 3.8+
- PostgreSQL 15+

### Quick Start

```bash
# 1. Clone the project
git clone <repo-url>
cd LifeAI

# 2. Create PostgreSQL database
psql -U postgres -c "CREATE DATABASE selfmaster_db;"

# 3. Configure database (edit src/main/resources/application.properties)
# Set your PostgreSQL username/password

# 4. (Optional) Set OpenAI API key
export OPENAI_API_KEY=your-key-here

# 5. Run the application
mvn spring-boot:run

# 6. Open browser
# http://localhost:8080
```

### Docker Deployment

```bash
# Set your OpenAI API key (optional)
export OPENAI_API_KEY=your-key-here

# Start with Docker Compose
docker-compose up -d

# Access at http://localhost:8080
```

## Project Structure

```
src/main/java/com/selfmaster/
├── SelfMasterApplication.java
├── config/          SecurityConfig
├── security/        JWT Filter, Provider, UserDetailsService
├── entity/          16 JPA Entities
├── repository/      14 Spring Data Repos
├── dto/             AuthDto, GoalDto, HabitDto, UserDto, ApiResponse
├── service/         Auth, Goal, Habit, Focus, Accountability,
│                    Emotional, Journal, AI Coach, Discipline Score
├── controller/      Auth, Home, Goal, Habit, Focus, Accountability,
│                    EmotionalLog, Journal, AiCoach, Dashboard
└── exception/       Global Handler + Custom Exceptions

src/main/resources/
├── application.properties
├── templates/       15 Thymeleaf pages
└── static/
    ├── css/         main.css, components.css
    └── js/          app.js
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register |
| POST | `/api/auth/login` | Login |
| GET/POST | `/api/goals` | Goals CRUD |
| GET/POST | `/api/habits` | Habits CRUD |
| POST | `/api/habits/log` | Log habit completion |
| POST | `/api/focus/start` | Start focus session |
| POST | `/api/focus/{id}/end` | End focus session |
| POST | `/api/ai/chat` | AI Coach chat |

## License

Open Source - MIT License
