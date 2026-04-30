using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using POS_Nova.Domain.Entities;
using POS_Nova.Infrastructure.DataPersistence;
using Microsoft.EntityFrameworkCore;

namespace POS_Nova.Infrastructure.Repositories
{
    internal class UserRepository
    {
        private readonly AppDbContext _context;

        public UserRepository(AppDbContext context)
        {
            _context = context;
        }


        public async Task<User?> GetByEmailAsync(string email)
        {
            return await _context.User
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Email == email);
        }
    }
}
