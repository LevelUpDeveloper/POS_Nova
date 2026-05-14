using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Domain.Entities
{
    [Table("Role", Schema = "Security")]
    public class Role
    {
        public int Id { get; private set; }
        public string Name { get; private set; }
    }
}
