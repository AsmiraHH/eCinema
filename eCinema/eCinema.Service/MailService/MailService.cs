using Newtonsoft.Json;
using RabbitMQ.Client;
using System.Text;
using eCinema.RabbitMQ;

namespace eCinema.Service.MailService
{
    public class MailService : IMailService
    {
        private readonly string serverAddress = Environment.GetEnvironmentVariable("SERVER_ADDRESS") ?? "smtp.gmail.com";
        private readonly string mailSender = Environment.GetEnvironmentVariable("MAIL_SENDER") ?? "ecinemav@gmail.com";
        private readonly string mailPass = Environment.GetEnvironmentVariable("MAIL_PASS") ?? "btzdmrofiiawlgrc";
        private readonly int port = int.Parse(Environment.GetEnvironmentVariable("MAIL_PORT") ?? "587");

        public void StartRabbitMQ(Email_TokenDTO obj)
        {
            var hostname = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
            var username = Environment.GetEnvironmentVariable("RABBITMQ_USER") ?? "guest";
            var password = Environment.GetEnvironmentVariable("RABBITMQ_PASS") ?? "guest";

            var factory = new ConnectionFactory { HostName = hostname };

            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "email_sending",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            var body = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(obj));

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "email_sending",
                                 basicProperties: null,
                                 body: body);
        }
    }
}
