using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Application.Interfaces.Services
{
    public interface IPasswordHasher
    {
        bool verify(string password, string hash);
    }
}
