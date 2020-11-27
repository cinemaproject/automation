#! /bin/bash

sudo -i
# echo 'gce-user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers; 
apt-get update
apt install -y nginx python3-pip libgl1-mesa-glx libpq-dev
# chmod -R 0777 /var/www/html
pip3 install --upgrade pip
pip3 install scikit-build
git clone https://github.com/cinemaproject/backend.git
cd backend
pip3 install -r requirements.txt
ln -s /opt/* /var/www/html
python3 app.py&
