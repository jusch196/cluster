path="$PWD"

cd ~/.ssh/
ssh-keygen -t rsa -b 4096 -N "" -f id_rsa;

cat ~/.ssh/id_rsa.pub | cat>> ~/.ssh/authorized_keys;

cd "$path"
