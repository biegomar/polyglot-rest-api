package de.biegota.usermanagement.repository;

import de.biegota.usermanagement.model.dto.CreateUser;
import de.biegota.usermanagement.model.dto.User;
import org.springframework.stereotype.Repository;

import java.util.concurrent.ConcurrentHashMap;

@Repository
public class UserRepository implements IUserRepository {

    private final ConcurrentHashMap<Integer, User> userDatabase = new ConcurrentHashMap<>() {{
        put(1, new User(1, "Jane", "First user",  "jane@test.org"));
        put(2, new User(2, "John", "Second user",  "john@test.org"));
    }};

    private int actualId = 2;

    @Override
    public Iterable<User> getAllUsers() {
        return userDatabase.values();
    }

    @Override
    public User getUserById(int id) {
        var user = userDatabase.get(id);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        return userDatabase.get(id);
    }

    @Override
    public User createUser(CreateUser user) {
        var nextId = actualId++;

        var newUser = new User(nextId, user.Name(), user.Description(), user.Email());

        if (userDatabase.putIfAbsent(nextId, newUser) == null)
        {
            throw new RuntimeException("Failed to add a new user. The ID might already exist.");
        }

        return newUser;
    }

    @Override
    public void updateUser(User user) {
        if (!userDatabase.containsKey(user.Id())){
            throw new RuntimeException("User not found");
        }

        userDatabase.replace(user.Id(), user);
    }

    @Override
    public void deleteUser(int id) {
        if (!userDatabase.containsKey(id)){
            throw new RuntimeException("User not found");
        }

        userDatabase.remove(id);
    }
}
