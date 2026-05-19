using Microsoft.AspNetCore.Http;
using POS_Nova.Application.Interfaces.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;


namespace POS_Nova.Infrastructure.Services
{
    public class CurrentUserService : ICurrentUserService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public CurrentUserService(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public bool IsAuthenticated =>
            _httpContextAccessor
                .HttpContext?
                .User?
                .Identity?
                .IsAuthenticated ?? false;

        public int UserId =>
            int.Parse(
                _httpContextAccessor
                    .HttpContext!
                    .User
                    .FindFirst(ClaimTypes.NameIdentifier)!
                    .Value
            );

        public string? Email =>
            _httpContextAccessor
                .HttpContext?
                .User?
                .FindFirst(ClaimTypes.Email)?
                .Value;

        public IEnumerable<string> Roles =>
            _httpContextAccessor
                .HttpContext?
                .User?
                .Claims
                .Where(x => x.Type == ClaimTypes.Role)
                .Select(x => x.Value)
            ?? Enumerable.Empty<string>();

    }
}
