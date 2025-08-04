namespace UserManagement.Api.Dtos;

public record User(int Id, string Name, string? Description, string? Email) : CreateUser(Name, Description, Email);