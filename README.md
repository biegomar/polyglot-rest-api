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
