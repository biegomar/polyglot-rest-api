using Scalar.AspNetCore;
using UserManagement.Api.Repositories;
using UserManagement.Api.Routes;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();

builder.Services.AddSingleton<IUserRepository, UserRepository>();
builder.Services.AddEndpointsApiExplorer();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference(options =>
    {
        options
            .WithTitle("UserManagement.Api v1")
            .WithTheme(ScalarTheme.Kepler)
            .WithDocumentDownloadType(DocumentDownloadType.Both)
            .WithDefaultHttpClient(ScalarTarget.CSharp, ScalarClient.HttpClient);
    });
}

app.UseHttpsRedirection();

app.MapUserRoutes();

app.Run();
