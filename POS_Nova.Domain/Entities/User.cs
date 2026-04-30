using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_Nova.Domain.Entities
{
    public class User
    {
        public int Id { get; private set; }
        public string Email { get; private set; }
        public string PasswordHash { get; private set; }
        public string UserName { get; private set; }
        public int FailedLoginAttempts { get; private set; }
        public bool IsLocked { get; private set; }
        public DateTime? LockedUntil { get; private set; }
        public string Role { get; private set; }


        // Rules
        // 1. After 5 failed login attempts, the account is locked for 15 minutes.
        public void RegisterFailedAttempt()
        {
            FailedLoginAttempts++;

            if (FailedLoginAttempts >= 5)
                Lock();
        }

        // 2. Blocked accounts cannot attempt to log in until the lock period expires.
        private void Lock()
        {
            IsLocked = true;
            LockedUntil = DateTime.UtcNow.AddMinutes(15);
        }

        // 3. Successful login resets the failed attempt counter and unlocks the account if it was locked.
        public void ResetFailedAttempts()
        {
            FailedLoginAttempts = 0;
            IsLocked = false;
            LockedUntil = null;
        }

        // 4. The system should provide a method to check if a user can attempt to log in, considering the lock status and lock expiration.
        public bool CanLogin()
        {
            if (IsLocked && LockedUntil > DateTime.UtcNow)
            {
                return false;
            }

            return true;
        }
    }
}
