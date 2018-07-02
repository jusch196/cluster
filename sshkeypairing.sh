path="$PWD"

echo "Enter your accountname:";
read accname;

echo 'Host sollipulli
    HostName 134.99.112.82
    Port 55517
    IdentityFile ~/.ssh/'$accname'_cluster
    User '$accname'
Host node49
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.49 22
    User '$accname'
Host node50
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.50 22
    User '$accname'
Host node51
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.51 22
    User '$accname'
Host node52
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.52 22
    User '$accname'
Host node53
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.53 22
    User '$accname'
Host node54
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.54 22
    User '$accname'
Host node55
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.55 22
    User '$accname'
Host node56
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.56 22
    User '$accname'
Host node57
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.57 22
    User '$accname'
Host node58
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.58 22
    User '$accname'
Host node59
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.59 22
    User '$accname'
Host node60
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.60 22
    User '$accname'
Host node61
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.61 22
    User '$accname'
Host node62
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.62 22
    User '$accname'
Host node63
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.63 22
    User '$accname'
Host node64
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.64 22
    User '$accname'
Host node65
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.65 22
    User '$accname'
Host node66
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.66 22
    User '$accname'
Host node67
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.67 22
    User '$accname'
Host node68
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.68 22
    User '$accname'
Host node69
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.69 22
    User '$accname'
Host node70
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.70 22
    User '$accname'
Host node71
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.71 22
    User '$accname'
Host node72
    ProxyCommand ssh -q sollipulli nc -q0 10.0.0.72 22
    User '$accname'' >> ~/.ssh/config


cd ~/.ssh/
chmod 600 config
ssh-keygen -t rsa -b 4096 -N "" -f $accname"_cluster"

cat ~/.ssh/"$accname"_cluster.pub | ssh $accname@sollipulli "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys"

cd "$path"
