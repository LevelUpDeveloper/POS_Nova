using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Application.Features.Auth.DTOs
{
    public record LoginRequestDto
    {
        public string login { get; set; }
        public string Password { get; set; }
    }
}
