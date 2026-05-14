using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Domain.Entities
{
    [Table("User", Schema = "Security")]
    public class User
    {
        public int Id { get; private set; }
        public string UserName { get; private set; }
        public string PasswordHash { get; private set; }
        public string Email { get; private set; }
        public string? ImageUrl { get; private set; }
        public bool IsActive { get; private set; }
        public int FailedLoginAttempts { get; private set; }
        public bool IsLocked { get; private set; }
        public DateTime? LockedUntil { get; private set; }
        public ICollection<UserRole> UserRole { get; private set; }


        // =========================================
        // RULES
        // =========================================

        public bool CanLogin()
        {
            if (!IsActive)
                return false;

            if (!IsLocked)
                return true;

            if (LockedUntil.HasValue &&
                LockedUntil.Value <= DateTime.UtcNow)
            {
                Unlock();
                return true;
            }

            return false;
        }

        public void RegisterFailedAttempt()
        {
            FailedLoginAttempts++;

            if (FailedLoginAttempts >= 5)
                Lock();
        }

        public void SuccessfulLogin()
        {
            FailedLoginAttempts = 0;

            Unlock();
        }

        private void Lock()
        {
            IsLocked = true;

            LockedUntil = DateTime.UtcNow.AddMinutes(15);
        }

        private void Unlock()
        {
            IsLocked = false;

            LockedUntil = null;
        }
    }
}
