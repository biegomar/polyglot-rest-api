package de.biegota.usermanagement.repository;

import de.biegota.usermanagement.model.dto.*;

public interface IUserRepository {
    Iterable<User> getAllUsers();
    User getUserById(int id);
    User createUser(CreateUser user);
    void updateUser(User user);
    void deleteUser(int id);
}
