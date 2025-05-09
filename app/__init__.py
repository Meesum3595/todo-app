from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os
from dotenv import load_dotenv

db = SQLAlchemy()

def create_app():
    load_dotenv()
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'sqlite:///todo.db')
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'devkey')
    
    db.init_app(app)
    
    with app.app_context():
        from . import routes
        db.create_all()
    
    return app
