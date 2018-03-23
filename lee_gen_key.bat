@echo off
ssh-keygen -t rsa -b 4096 -C "ligxer@gmail.com"



ssh-agent -s
ssh-add ~/.ssh/id_rsa
echo "copy begin"
cat ~/.ssh/id_rsa.pub
echo "copy end."
echo "keygen successed. use: 'ssh -T git@github.com' for test"