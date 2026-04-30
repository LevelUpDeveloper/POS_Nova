using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using POS_Nova.Domain.Entities;


namespace POS_Nova.Application.Interfaces.Persistence
{
    public interface IProductRepository
    {
        Task AddAsync(Product product);
    }
}
