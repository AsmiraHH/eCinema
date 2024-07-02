using eCinema.Core.Helpers;
using eCinema.Core.SearchObjects;
using eCinema.RabbitMQ;

namespace eCinema.Service.MailService
{
    public interface IMailService
    {
        void StartRabbitMQ(Email_TokenDTO obj);
    }
}
