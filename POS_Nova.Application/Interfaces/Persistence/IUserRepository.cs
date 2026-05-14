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
        Task<User?> GetByEmailOrUserNameAsync(string value);

        Task UpdateAsync(User user);
    }
}
