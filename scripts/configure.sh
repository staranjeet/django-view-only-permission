#!/bin/bash

# cd ..

echo "Creating virtual env"
virtualenv --no-site-packages pyenv

echo "Activating virtual env"
source pyenv/bin/activate

echo "Installing requirements"
pip install -r requriements/dev.txt

# before running bower install,
# make sure django_view_perm/static/bower_components exists

if [ ! -d "django_view_perm/static/bower_components" ]; then
    mkdir -p "django_view_perm/static/bower_components"
fi

# create `.bowerrc` dynamically, so that template variable
# project_name is substituted properly

cat <<'EOF' > ".bowerrc"
{
    "directory": "django_view_perm/static/bower_components"
}
EOF

if [ -f "bower.json" ]; then
    echo "Running bower install"
    bower install
fi

# before running collectstatic, make sure that
# `root_dir/static` exists

if [ ! -d "static" ]; then
    mkdir "static"
fi

echo "Collecting static files"
python manage.py collectstatic --noinput

echo "Running migrations"
python manage.py migrate --noinput
