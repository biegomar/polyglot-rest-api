package de.biegota.usermanagement.controller;

import de.biegota.usermanagement.model.dto.*;
import de.biegota.usermanagement.repository.IUserRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@Tag(name = "Users", description = "Operations for managing users")
public class UserController {

    @Autowired
    private IUserRepository repository;

    @GetMapping("/api/users")
    @Operation(summary = "List all users", description = "Returns all users available in the system.")
    @ApiResponse(responseCode = "200", description = "Successful operation",
            content = @Content(mediaType = "application/json",
                    schema = @Schema(implementation = User.class)))
    public Iterable<User> getAllUsers() {
        return repository.getAllUsers();
    }

    @GetMapping("/api/users/{userId}")
    @Operation(summary = "Get user by ID", description = "Returns a single user by its unique identifier.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "User found",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))),
            @ApiResponse(responseCode = "404", description = "User not found", content = @Content)
    })
    public User getUserById(@Parameter(description = "Unique ID of the user", example = "1")
                            @PathVariable int userId) {
        return repository.getUserById(userId);
    }

    @PostMapping("/api/users")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Create a new user", description = "Creates a new user and returns its generated ID.")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "User created",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Integer.class))),
            @ApiResponse(responseCode = "400", description = "Invalid input", content = @Content)
    })
    public int insertUser(@RequestBody(description = "User details for creation", required = true,
            content = @Content(mediaType = "application/json",
                    schema = @Schema(implementation = CreateUser.class)))
                          @org.springframework.web.bind.annotation.RequestBody CreateUser dto) {
        return repository.createUser(dto).Id();
    }

    @DeleteMapping("/api/users/{userId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Operation(summary = "Delete a user", description = "Deletes the user with the specified ID.")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "User deleted", content = @Content),
            @ApiResponse(responseCode = "404", description = "User not found", content = @Content)
    })
    public void deleteUser(@Parameter(description = "Unique ID of the user", example = "1")
                           @PathVariable int userId) {
        repository.deleteUser(userId);
    }

    @PutMapping("/api/users")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Operation(summary = "Update an existing user", description = "Updates the user with the provided details.")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "User updated", content = @Content),
            @ApiResponse(responseCode = "400", description = "Invalid input", content = @Content),
            @ApiResponse(responseCode = "404", description = "User not found", content = @Content)
    })
    public void updateUser(@RequestBody(description = "User details for update", required = true,
            content = @Content(mediaType = "application/json",
                    schema = @Schema(implementation = User.class)))
                           @org.springframework.web.bind.annotation.RequestBody User dto) {
        repository.updateUser(dto);
    }
}
