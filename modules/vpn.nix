{ ... }:

{
  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.8.0.5/24" ];
    privateKeyFile = "/etc/wireguard/wg0.key";
    dns = [ "172.18.0.1" "8.8.8.8" ];

    peers = [
      {
        publicKey = "lM0mCXBpNgN9FUsO7fFsA7ji4gYj0QQIkoNEBsRZvFg=";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "212.227.202.41:51820";
        persistentKeepalive = 25;
        presharedKeyFile = "/etc/wireguard/wg0.psk";
      }
    ];
  };
}
