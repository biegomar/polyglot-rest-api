using System.Security.Claims;
using Microsoft.AspNetCore.Http.HttpResults;
using UserManagement.Api.Dtos;
using UserManagement.Api.Repositories;

namespace UserManagement.Api.Routes;

public static class UserRoutes
{
    public static void MapUserRoutes(this IEndpointRouteBuilder routes)
    {
        routes.MapGet("/api/users",
                async Task<Results<Ok<IEnumerable<User>>, NoContent, BadRequest<string>>> (IUserRepository userRepository) =>
                {
                    var users = await userRepository.GetAllUsersAsync().ConfigureAwait(false);

                    if (!users.Any())
                    {
                        return TypedResults.NoContent();
                    }

                    return TypedResults.Ok(users);
                })
            .Produces<IEnumerable<User>>(StatusCodes.Status200OK)
            .Produces(StatusCodes.Status204NoContent)
            .WithName("GetAllUsers")
            .WithSummary("All users")
            .WithDescription("Delivers a list of all users.")
            .WithTags("User");
        
        routes.MapPost("/api/users",
                async Task<Results<Created, InternalServerError<string>, BadRequest<string>, Conflict<string>>> (CreateUser dto, IUserRepository userRepository) =>
                {
                    if (string.IsNullOrEmpty(dto.Name))
                    {
                        return TypedResults.BadRequest("Name is required.");
                    }

                    try
                    {
                        var result = await userRepository.CreateUserAsync(dto).ConfigureAwait(false);
                        return TypedResults.Created($"/api/users/{result.Id}");
                    }
                    catch (Exception ex)
                    {
                        return TypedResults.InternalServerError(ex.Message);
                    }
                    
                })
            .Produces(StatusCodes.Status201Created)
            .Produces(StatusCodes.Status500InternalServerError)
            .Produces(StatusCodes.Status400BadRequest)
            .WithName("CreateUser")
            .WithSummary("Add new user.")
            .WithDescription("Add a new user to the system.")
            .WithTags("User");
        
        routes.MapDelete("/api/users/{userId}",
                async Task<Results<NoContent, InternalServerError<string>, BadRequest<string>>> (int userId, IUserRepository userRepository) =>
                {
                    if (userId <= 0)
                    {
                        return TypedResults.BadRequest("Invalid user ID.");   
                    }
                    
                    try
                    {
                        await userRepository.DeleteUserAsync(userId).ConfigureAwait(false);
                        return TypedResults.NoContent();
                    }
                    catch (Exception ex)
                    {
                        return TypedResults.InternalServerError(ex.Message);
                    }
                })
            .Produces(StatusCodes.Status204NoContent)
            .Produces(StatusCodes.Status500InternalServerError)
            .Produces(StatusCodes.Status400BadRequest)
            .WithName("DeleteUser")
            .WithSummary("Delete user.")
            .WithDescription("Delete a user from the system.")
            .WithTags("User");
        
        routes.MapPut("/api/users",
                async Task<Results<NoContent, InternalServerError<string>, BadRequest<string>>> (User dto, IUserRepository userRepository) =>
                {
                    if (dto.Id <= 0)
                    {
                        return TypedResults.BadRequest("Invalid user ID.");   
                    }
                    
                    try
                    {
                        await userRepository.UpdateUserAsync(dto);
                        return TypedResults.NoContent();
                    }
                    catch (Exception ex)
                    {
                        return TypedResults.InternalServerError(ex.Message);
                    }
                })
            .Produces(StatusCodes.Status204NoContent)
            .Produces(StatusCodes.Status500InternalServerError)
            .Produces(StatusCodes.Status400BadRequest)
            .WithName("UpdateUser")
            .WithSummary("Update user.")
            .WithDescription("Update a user in the system.")
            .WithTags("User");
    }
}