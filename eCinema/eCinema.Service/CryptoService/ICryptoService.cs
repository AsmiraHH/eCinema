using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinema.Service.CryptoService
{
    public interface ICryptoService
    {
        string GenerateSalt();
        string GenerateHash(string password, string salt);
        bool VerifyPassword(string hash, string password, string salt);
    }
}
