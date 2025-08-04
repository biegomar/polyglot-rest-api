using UserManagement.Api.Dtos;

namespace UserManagement.Api.Repositories;

public interface IUserRepository
{
    Task<IEnumerable<User>> GetAllUsersAsync();
    Task<User?> GetUserByIdAsync(int id);
    Task<User> CreateUserAsync(CreateUser user);
    Task UpdateUserAsync(User user);
    Task DeleteUserAsync(int id);
}