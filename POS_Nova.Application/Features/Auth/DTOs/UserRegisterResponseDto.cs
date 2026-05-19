using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Application.Features.Auth.DTOs
{
    public record UserRegisterResponseDto
    {
        public string UserName { get; set; }

        public string Email { get; set; }
    }
}
