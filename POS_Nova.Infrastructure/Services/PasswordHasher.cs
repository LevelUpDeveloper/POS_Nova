using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using POS_Nova.Application.Interfaces.Services;

namespace POS_Nova.Infrastructure.Services
{
    public class PasswordHasher : IPasswordHasher
    {

        public string HashPassword(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password);
        }

        public bool Verify(string password, string hash)
        {
            //Console.WriteLine(BCrypt.Net.BCrypt.HashPassword("123456"));
            return BCrypt.Net.BCrypt.Verify(password, hash);
        }
    }
}
