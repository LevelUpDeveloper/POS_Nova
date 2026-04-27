using POS_Nova.Application.Contracts;
using POS_Nova.Domain.Entities;
using POS_Nova.Infrastructure.DataPersistence;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Infrastructure.Repositories
{
    public class ProductRepository : IProductRepository
    {

        private readonly AppDbContext _context;

        public ProductRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task AddAsync(Product product)
        {
        await _context.Products.AddAsync(product);
        await _context.SaveChangesAsync();
        }
    }
}
