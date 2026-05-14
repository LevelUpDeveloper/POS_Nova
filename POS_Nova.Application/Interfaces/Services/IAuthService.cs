using POS_Nova.Application.Features.Auth.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Application.Interfaces.Services
{
    public interface IAuthService
    {
        Task<LoginResponseDto?> Login(LoginRequestDto dto);
    }
}
