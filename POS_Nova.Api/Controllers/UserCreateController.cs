using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using POS_Nova.Application.Interfaces.Persistence;
using POS_Nova.Application.Features.Auth.DTOs;
using POS_Nova.Application.Features.Auth.UseCases;
using Microsoft.EntityFrameworkCore.Internal;

namespace POS_Nova.Api.Controllers
{
    
    [ApiController]
    [Route("api/users")]
    public class UserCreateController : ControllerBase
    {
        private readonly RegisterUserService _RegisterUserService;

        public UserCreateController(RegisterUserService userRepository)
        {
            _RegisterUserService = userRepository;
        }

        [Authorize(Policy = "CanManageUser")]
        [HttpPost]
        public async Task<IActionResult> CreateUser(UserRegisterRequestDto userRegisterRequest)
        {
            var result = await _RegisterUserService.Execute(userRegisterRequest);
            return Ok(result);
        }
        
    }
}
