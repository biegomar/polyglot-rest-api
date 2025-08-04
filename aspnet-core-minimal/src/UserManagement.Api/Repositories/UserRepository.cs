using System.Collections.Concurrent;
using UserManagement.Api.Dtos;

namespace UserManagement.Api.Repositories;

public class UserRepository : IUserRepository
{
    private readonly ConcurrentDictionary<int, User> userDatabase = new (new Dictionary<int, User>
        {
            { 1, new User(1, "Jane", "First user", "jane@test.org") },
            { 2, new User(2, "John", "Second user", "john@test.org") }
        });
    
    private int actualId = 2;
    
    public async Task<IEnumerable<User>> GetAllUsersAsync()
    {
        return await Task.FromResult(userDatabase.Values.ToList()).ConfigureAwait(false);
    }

    public async Task<User?> GetUserByIdAsync(int id)
    {
        if (!userDatabase.TryGetValue(id, out var user))
        {
            return null;
        }
        
        return await Task.FromResult(user).ConfigureAwait(false);
    }

    public async Task<User> CreateUserAsync(CreateUser user)
    {
        var nextId = Interlocked.Increment(ref actualId);
        
        var newUser = new User(nextId, user.Name, user.Description, user.Email);
        
        if (!userDatabase.TryAdd(nextId, newUser))
        {
            throw new InvalidOperationException("Failed to add a new user. The ID might already exist.");
        }

        return await Task.FromResult(newUser).ConfigureAwait(false);
    }

    public Task UpdateUserAsync(User user)
    {
        if (!userDatabase.TryUpdate(user.Id, user, userDatabase[user.Id]))
        {
            throw new InvalidOperationException("Failed to update the user.");
        }
        
        return Task.CompletedTask;
    }

    public Task DeleteUserAsync(int id)
    {
        if (!userDatabase.TryRemove(id, out var user))
        {
            if (user == null)
            {
                throw new InvalidOperationException("User not found.");    
            }
            
            throw new InvalidOperationException("Failed to delete the user.");
        }
        
        return Task.CompletedTask;
    }
}