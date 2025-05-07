namespace ZkManagementApi.Models
{
    public class SendUserRequest
    {
        public int? ServerId { get; set; }
        public int? Pin { get; set; }
        public string? Name { get; set; }
        public int? Privilege { get; set; }
        public string? Password { get; set; }
        public int? Card { get; set; }
        public List<string>? DevicesSerialNumbers { get; set; }

        public SendUserRequest(int? serverId = null, int? pin = null, string? name = null, int? privilege = null, string? password = null, int? card = null, List<string>? serialNumbers = null)
        {
            ServerId = serverId;
            Pin = pin;
            Name = name;
            Privilege = privilege;
            Password = password;
            Card = card;
            DevicesSerialNumbers = serialNumbers;
        }

        public SendUserRequest() { }

        public override string ToString()
        {
            return $"ServerId: {(ServerId.HasValue ? ServerId.Value.ToString() : "null")}, " +
                   $"Pin: {(Pin.HasValue ? Pin.Value.ToString() : "null")}, " +
                   $"Name: {Name ?? "null"}, " +
                   $"Privilege: {(Privilege.HasValue ? Privilege.Value.ToString() : "null")}, " +
                   $"Password: {Password ?? "null"}, " +
                   $"Card: {(Card.HasValue ? Card.Value.ToString() : "null")}, " +
                   $"SerialNumbers: {(DevicesSerialNumbers != null && DevicesSerialNumbers.Count > 0 ? string.Join(", ", DevicesSerialNumbers) : "null")}";
        }

        public string SerialNumbersToString()
        {
            if (DevicesSerialNumbers is null || DevicesSerialNumbers.Count <= 0)
                return string.Empty;

            return string.Join(", ", DevicesSerialNumbers);
        }
    }
}