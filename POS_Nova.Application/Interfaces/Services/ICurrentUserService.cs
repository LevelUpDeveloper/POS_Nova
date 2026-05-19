using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Application.Interfaces.Services
{
    public interface ICurrentUserService
    {
        int UserId { get; }
        string? Email { get; }
        bool IsAuthenticated { get; }

        IEnumerable<string> Roles { get; }
    }
}
