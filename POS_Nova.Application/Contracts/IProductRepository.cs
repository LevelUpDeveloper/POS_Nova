using POS_Nova.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace POS_Nova.Application.Contracts
{
    public interface IProductRepository
    {
        Task AddAsync(Product product);
    }
}
