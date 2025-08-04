namespace UserManagement.Api.Dtos;

public record CreateUser(string Name, string? Description, string? Email);