using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Domain.Entities
{
    public class Product
    {
        public Guid id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int CategoryId { get; set; }
        public int ProviderId { get; set; }
        public int Stock { get; set; }
        public decimal SellPrice { get; set; }
        public string ImageUrl { get; set; }
    }
}
