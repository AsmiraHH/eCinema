using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.CryptoService
{
    internal class CryptoService : ICryptoService
    {
        public string GenerateHash(string password, string salt)
        {
            var hash = KeyDerivation.Pbkdf2(
                       password: password!,
                       salt: Encoding.UTF8.GetBytes(salt),
                       prf: KeyDerivationPrf.HMACSHA512,
                       iterationCount: 10000,
                       numBytesRequested: 256 / 8);

            return Convert.ToBase64String(hash);
        }

        public string GenerateSalt()
        {
            byte[] salt = RandomNumberGenerator.GetBytes(128 / 8);

            return Convert.ToBase64String(salt);
        }

        public bool VerifyPassword(string hash, string password, string salt)
        {
            var hashToCompare = GenerateHash(password, salt);
            return hashToCompare == hash;
        }
    }
}
