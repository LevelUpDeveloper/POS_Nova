using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Domain.Entities
{
    public class Product
    {
        public Guid id { get; private set; }
        public string Name { get; private set; }
        public decimal Price { get; private set; }
        public Product(string name, decimal price)
        {
            id = Guid.NewGuid();
            Name = name;
            Price = price;
        }

    }
}
