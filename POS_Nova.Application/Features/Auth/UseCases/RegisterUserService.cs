using POS_Nova.Application.Features.Auth.DTOs;
using POS_Nova.Application.Interfaces.Persistence;
using POS_Nova.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Application.Features.Auth.UseCases
{
    public class RegisterUserService
    {
        private readonly IUserRepository _user;

        public RegisterUserService(IUserRepository userRepository)
        {
            _user = userRepository;
        }

        
        public async Task<UserRegisterResponseDto> Execute(UserRegisterRequestDto userRegisterRequest)
        {
            var registeredEmailExists = _user.ExistByEmail(userRegisterRequest.Email);

            if (registeredEmailExists.Result == true)
            {
                throw new Exception("Ya se encuentra registrado ese correo");
            }

            return new UserRegisterResponseDto
            {
                UserName = userRegisterRequest.UserName,
                Email = userRegisterRequest.Email
            };

        }
    }

}
