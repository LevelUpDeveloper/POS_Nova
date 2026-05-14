using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Domain.Entities
{
    [Table("UserRole", Schema = "Security")]
    public class UserRole
    {
        public int id { get; private set; }
        public int UserId { get; private set; }
        public User User { get; private set; }

        public int RoleId { get; private set; }
        public Role Role { get; private set; }
    }
}
