using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using POS_Nova.Application.Features.Auth.DTOs;
using POS_Nova.Application.Interfaces.Persistence;
using POS_Nova.Application.Interfaces.Services;
using POS_Nova.Domain.Entities;


namespace POS_Nova.Application.Features.Auth.UseCases
{
    public class LoginService
    {
        private readonly IUserRepository _users;
        private readonly IPasswordHasher _hasher;
        private readonly IJwtService _jwt;

        public LoginService(IUserRepository users, IPasswordHasher hasher, IJwtService jwt)
        {
            this._users = users;
            this._hasher = hasher;
            this._jwt = jwt;
        }

        public async Task<LoginResponseDto> Execute(LoginRequestDto loginRequest)
        {

            // 1. Search User
            var user = await _users
                .GetByEmailOrUserNameAsync(loginRequest.login);

            if (user == null)
            {
                    throw new Exception("Invalid credentials");               
            }

            // 2. Check look
            if (!user.CanLogin())
            {
                throw new Exception("User locked");
            }

            // 3. Validate password
            //Console.WriteLine($"Password input: {loginRequest.Password}");
            //Console.WriteLine($"Hash DB: {user.PasswordHash}");
            var validPassword = _hasher.Verify(loginRequest.Password, user.PasswordHash);

            //if (!validPassword)
            //{
            //    user.RegisterFailedAttempt();

            //    await _users.UpdateAsync(user);

            //    throw new Exception("Invalid credentials");
            //}

            // 4. Reset attempts
            user.SuccessfulLogin();

            await _users.UpdateAsync(user);

            // 5. Generate JWT
            var token = _jwt.GenerateToken(user);

            // 6. Respuesta
            return new LoginResponseDto
            {
                Token = token,
                UserName = user.UserName,
                Role = user.UserRole
                    .Select(ur => ur.Role.Name)
                    .ToList()
            };
        }
    }
}
