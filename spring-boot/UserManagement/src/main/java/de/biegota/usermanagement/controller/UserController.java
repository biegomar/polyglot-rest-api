package de.biegota.usermanagement.controller;

import de.biegota.usermanagement.model.dto.*;
import de.biegota.usermanagement.repository.IUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class UserController {

    @Autowired
    private IUserRepository repository;
    @GetMapping("/api/users")
    public Iterable<User> getAllUsers() {
        return repository.getAllUsers();
    }

    @GetMapping("/api/users/{userId}")
    public User getUserById(@PathVariable int userId) {
        return repository.getUserById(userId);
    }

    @PostMapping("/api/users")
    public int insertUser(CreateUser dto){
        return repository.createUser(dto).Id();
    }

    @DeleteMapping("/api/users/{userId}")
    public void deleteUser(@PathVariable int userId){
        repository.deleteUser(userId);
    }

    @PutMapping("/api/users")
    public void updateUser(User dto){
        repository.updateUser(dto);
    }
}
