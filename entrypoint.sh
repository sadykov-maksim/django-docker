python manage.py migrate
python manage.py collectstatic --no-input --clear
gunicorn backend.wsgi:application --bind 0.0.0.0:8000