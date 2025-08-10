# Polyglot REST-API
A simple REST API implemented across multiple technology stacks for comparison and learning.

## ASP.NET Core Minimal – UserManagement

The `aspnet-core-minimal/UserManagement` project is a minimalist REST API for user management, built with ASP.NET Core 9.0. It provides basic endpoints for creating, retrieving, updating, and deleting users (CRUD). The API uses an in-memory repository and serves as a quick-start template or reference implementation.

**Features:**
- Minimal API approach with modern .NET features
- OpenAPI/Swagger integration (development only)
- Example user endpoints:  
  - `GET /api/users` – Retrieve all users  
  - `POST /api/users` – Create a new user  
  - `PUT /api/users` – Update a user  
  - `DELETE /api/users/{userId}` – Delete a user
- Dockerfile included for containerized deployment

**How to run locally:**
```bash
cd aspnet-core-minimal/src/UserManagement.Api
dotnet run
```
The API will be available at [http://localhost:5100](http://localhost:5100) by default.

**Note:**  
User data is stored in memory and will be lost when the application restarts.

---
## Spring Boot – UserManagement

The `spring-boot` project provides a REST API for user management, implemented with Java and Spring Boot. It offers endpoints for creating, retrieving, updating, and deleting users (CRUD operations). The application uses a simple in-memory `HashMap` to store user data for demonstration and development purposes.

**Features:**
- RESTful API using Spring Boot
- In-memory storage with Java `HashMap` for easy setup
- Example user endpoints:  
  - `GET /api/users` – Retrieve all users  
  - `POST /api/users` – Create a new user  
  - `PUT /api/users/{id}` – Update a user  
  - `DELETE /api/users/{id}` – Delete a user
- Dockerfile included for containerized deployment

**How to run locally:**
```bash
cd spring-boot
./mvnw spring-boot:run
```
The API will be available at [http://localhost:8080](http://localhost:8080) by default.

**Note:**  
User data is stored in an in-memory `HashMap` and will be lost when the application restarts.

---
## Delphi (Horse) – UserManagement

The `delphi-horse` project implements a REST API for user management using Delphi and the [Horse](https://github.com/HashLoad/horse) web framework. Horse was installed via the [boss](https://github.com/HashLoad/boss) package manager for Delphi. The API provides endpoints for creating, retrieving, updating, and deleting users (CRUD), with user data stored in memory.

**Features:**
- RESTful API using Delphi and [Horse](https://github.com/HashLoad/horse)
- Horse framework installed via `boss install horse`
- In-memory storage for user data

**Available endpoints:**
- `GET    /api/users` – Retrieve all users
- `GET    /api/users/:id` – Retrieve a user by ID
- `POST   /api/users` – Create a new user
- `PUT    /api/users/:id` – Update a user
- `DELETE /api/users/:id` – Delete a user
- `GET    /api/info` – Get API info
- `GET    /api/health` – Health check endpoint

**How to run locally:**
1. Open the Delphi project in the `delphi-horse` folder.
2. Build and run the application.

The API will be available at [http://localhost:9000](http://localhost:9000) by default.

Example:
```bash
curl http://localhost:9000/api/users
```

**Note:**  
User data is stored in memory and will be lost when the application restarts.

---
*This README was generated with the help of AI based on the project's source code and structure.*