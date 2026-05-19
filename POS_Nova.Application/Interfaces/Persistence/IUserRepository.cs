using POS_Nova.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Application.Interfaces.Persistence
{
    public interface IUserRepository
    {
        // Login
        Task<User?> GetByEmailOrUserNameAsync(string emailOrUserName);

        Task UpdateAsync(User user);


        // Registration
        Task<bool> ExistByEmail(string email);
        Task<bool> ExistByUserName(string userName);
        Task<User> CreateAsync(User user);
    }
}
