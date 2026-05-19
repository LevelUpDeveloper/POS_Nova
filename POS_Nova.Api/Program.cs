using Microsoft.EntityFrameworkCore;
using POS_Nova.Application.Features.Auth.UseCases;
using POS_Nova.Application.Interfaces.Persistence;
using POS_Nova.Application.Interfaces.Services;
using POS_Nova.Infrastructure.DependencyInjection;
using POS_Nova.Infrastructure.Repositories;
using POS_Nova.Infrastructure.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;


namespace POS_Nova.Api
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();

            // Swagger configuration for JWT Authentication
            builder.Services.AddSwaggerGen(c =>
            {
                c.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
                {
                    Name = "Authorization",
                    Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
                    Scheme = "bearer",
                    BearerFormat = "JWT",
                    In = Microsoft.OpenApi.Models.ParameterLocation.Header,
                    Description = "Escribe: Bearer {tu token}"
                });

                c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
            {
            {
            new Microsoft.OpenApi.Models.OpenApiSecurityScheme
            {
                Reference = new Microsoft.OpenApi.Models.OpenApiReference
                {
                    Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] {}
            }
            });
            });


            // Use Cases
            builder.Services.AddScoped<LoginService>();
            builder.Services.AddScoped<RegisterUserService>();

            // Repositories
            builder.Services.AddScoped<IUserRepository, UserRepository>();

            // Services
            builder.Services.AddScoped<IPasswordHasher, PasswordHasher>();
            builder.Services.AddScoped<IJwtService, JwtService>();


            builder.Services.AddHttpContextAccessor();
            builder.Services.AddScoped<ICurrentUserService,
                CurrentUserService>();

            // AUTHENTICATION 
            builder.Services
                .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,

                        ValidIssuer = builder.Configuration["JwtSettings:Issuer"],
                        ValidAudience = builder.Configuration["JwtSettings:Audience"],

                        IssuerSigningKey = new SymmetricSecurityKey(
                            Encoding.UTF8.GetBytes(
                                builder.Configuration["JwtSettings:Key"]!
                            )
                        ),

                        ClockSkew = TimeSpan.Zero
                    };
                });


            // Authorization policies
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("RequireAdmin",
                    policy => policy.RequireRole("Admin"));

                options.AddPolicy("RequireManager",
                    policy => policy.RequireRole("Manager"));

                options.AddPolicy("CanManageProducts",
                    policy => policy.RequireRole("Admin", "Manager"));

                options.AddPolicy("CanManageUser",
                    policy => policy.RequireRole("Admin", "Manager"));
            });


            // Database Conection Infraestructura
            builder.Services.AddInfrastructure(builder.Configuration);


            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }


            app.UseHttpsRedirection();

            // Polity Authorization
            app.UseAuthentication();
            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
