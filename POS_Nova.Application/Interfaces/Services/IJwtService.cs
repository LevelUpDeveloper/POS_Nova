using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;
using POS_Nova.Domain.Entities;

namespace POS_Nova.Application.Interfaces.Services
{
    public interface IJwtService
    {
        public string GenerateToken(User user);

    }
}
