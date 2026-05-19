using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using POS_Nova.Domain.Entities;
using POS_Nova.Infrastructure.DataPersistence;
using Microsoft.EntityFrameworkCore;
using POS_Nova.Application.Interfaces.Persistence;

namespace POS_Nova.Infrastructure.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly AppDbContext _context;

        public UserRepository(AppDbContext context)
        {
            _context = context;
        }

        // Login Methods
        public async Task<User?> GetByEmailOrUserNameAsync(string emailOrUserName)
        {

            return await _context.User
                .Include(u => u.UserRole)
                    .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u =>
                    u.Email == emailOrUserName
                    || u.UserName == emailOrUserName
                );
        }

        public async Task UpdateAsync(User user)
        {
            _context.User.Update(user);
            await _context.SaveChangesAsync();
        }

        // Registration methods
        public async Task<bool> ExistByEmail(string email)
        {
            return await _context.User.AnyAsync(u => u.Email == email);
        }

        public async Task<bool> ExistByUserName(string userName)
        {
            return await _context.User.AnyAsync(u => u.UserName == userName);
        }

        public async Task<User> CreateAsync(User user)
        {
            await _context.User.AddAsync(user);
            await _context.SaveChangesAsync();
            return user;
        }
    }
}
