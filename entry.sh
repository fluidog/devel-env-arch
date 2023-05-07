#! /bin/bash

# git config
git config --global user.name fluidog
git config --global user.email fluidog@163.com

# sshd config
sed -i -e 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
mkdir -p  /run/sshd

# ssh config
cat >~/.ssh/config  <<<"StrictHostKeyChecking no"

# Add some public key from the host which you want login from.
# Warn : Delet or change the keys below to yourself.

echo >>~/.ssh/authorized_keys \
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6aZYJtPRrWujbE9nrlcJrTuC/9CWL2N9rAAse546DIBL\
JCaD1OKZlFy8sPu/PaNjHF6L2RAKWguh2rZAc4WXgyjZH1Dc3Ue2wDJRghzmmO+BuqE6Qk27ICPCiMcAdyxm\
Tp2RDib/xNp+muQKuv+QONmeP06vkMJzTTgC+srLvO076mAXSv8fNtWQ6O2jApJ9EcuY0BnvJi216A6BjoMA\
uo2Ctg+cf5Uf9qvOi5ojWj8mFLfvEkzTaYOcUMqZ/rIGPu0vv58B2ZxfY+klP6hWmU8sDcbTWg0H6ZeHln0B\
N1kD2SKvLi6oZklzW8DmywnSRPlxCdakvDxV+KvRNpOfRW78K6I8wXRN1ps6Kksuz2oCrmYVYOfb5kMVi7U6\
8oBJYPDimm5/tliNeHIXfgopp+m2Q3F/U1/0GoOUjkI+7KdBDuL8HlaGy9YteYGJKCWWDTo+X2JEbUb8/GiO\
kzsYv6iXqWJR93LDpm6xQYfo7eU1myfvFiDfEIl2QGRN4KwU= root@fluidog-workspace"

ssh-keygen -A

exec /sbin/sshd -D -p 6723
