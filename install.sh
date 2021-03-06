project_domain=""
project_path=`pwd`

read -p "Your domain: " project_domain
python -m venv env
source env/bin/activate
pip install -U pip
pip install -r requirements.txt

sed -i "s~fastapi_project_path~$project_path~g" nginx/site.conf systemd/gunicorn.service
sed -i "s~fastapi_project_domain~$project_domain~g" nginx/site.conf

sudo ln -s $project_path/nginx/site.conf /etc/nginx/sites-enabled/
sudo ln -s $project_path/systemd/gunicorn.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl start gunicorn
sudo systemctl enable gunicorn
sudo service nginx restart
