import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from sqlalchemy_utils import database_exists, create_database
from local_settings import postgresql as settings
import psycopg2
from flask_migrate import Migrate

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    DB_URL = get_engine_from_settings()
    app.config['SECRET_KEY'] = 'hjshjhdjah kjshkjdhjs'
    app.config['SQLALCHEMY_DATABASE_URI'] = DB_URL
    db.init_app(app)
    migrate = Migrate(app, db)

    path = os.getcwd()
    # file Upload
    UPLOAD_FOLDER = os.path.join(path, 'doc_uploads')
    if not os.path.isdir(UPLOAD_FOLDER):
        os.mkdir(UPLOAD_FOLDER)
    app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

    from .views import views
    from .auth import auth

    app.register_blueprint(views, url_prefix='/')
    app.register_blueprint(auth, url_prefix='/')

    from .models import User
    
    with app.app_context():
        db.create_all()

    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(id):
        return User.query.get(int(id))

    return app

'''
def create_database(app):
    if not path.exists('website/' + DB_NAME):
        db.create_all(app=app)
        print('Created Database!')
'''
        
def get_url(user,passwd,db_url,db):
    url = 'postgresql+psycopg2://{user}:{pw}@{url}/{db}'.format(user=user,pw=passwd,url=db_url,db=db)
    if not database_exists(url):
        create_database(url)
    return url

def get_engine_from_settings():
    keys = ['pguser','pgpasswd','pgurl','pgdb']
    if not all(key in keys for key in settings.keys()):
        raise Exception('Bad config file')
    return get_url(settings['pguser'],
                    settings['pgpasswd'],
                    settings['pgurl'],
                    settings['pgdb'])