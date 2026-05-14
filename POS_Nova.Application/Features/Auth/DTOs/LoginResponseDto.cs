using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Application.Features.Auth.DTOs
{
    public record LoginResponseDto
    {
        public string Token { get; set; }
        public string UserName { get; set; }
        public string? ImageUrl { get; set; } 

        public List<string> Role { get; set; }
    }
}
