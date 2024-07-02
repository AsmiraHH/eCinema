using System.Net.Mail;
using System.Net;

namespace eCinema.RabbitMQ
{
    public class Email
    {
        public static void Send(Email_TokenDTO obj)
        {
            string serverAddress = Environment.GetEnvironmentVariable("SERVER_ADDRESS") ?? "smtp.gmail.com";
            string mailSender = Environment.GetEnvironmentVariable("MAIL_SENDER") ?? "ecinemav@gmail.com";
            string mailPass = Environment.GetEnvironmentVariable("MAIL_PASS") ?? "btzdmrofiiawlgrc";
            int port = int.Parse(Environment.GetEnvironmentVariable("MAIL_PORT") ?? "587");

            string to = obj.Mail;
            string subject = "Mail Verification";
            string content = $"<p>Dear User,</p> <br>In order to complete the registration you need to use the code below. <br>" +
                                    $"<p>Verification code: {obj.Token} </p> <br> <p> Best regards, eCinema </p>";

            SmtpClient client = new SmtpClient(serverAddress)
            {
                Port = port,
                Credentials = new NetworkCredential(mailSender, mailPass),
                EnableSsl = true,
            };

            MailMessage mail = new MailMessage(mailSender, to)
            {
                Subject = subject,
                Body = content,
                IsBodyHtml = true
            };

            try
            {
                Console.WriteLine("ADDRESS: " + serverAddress + "| SENDER: " + mailSender + "| PASS: " + mailPass + "| PORT: " + port.ToString());
                client.Send(mail);
                Console.WriteLine("Mail successfully sent to " + obj.Mail);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
                Console.WriteLine("StackTrace " + ex.StackTrace);
            }
        }
    }
}
