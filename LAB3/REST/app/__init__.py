from flask import Flask

def create_app():
    app = Flask(__name__)
    
    from app.views import init_views
    init_views(app)
    
    return app
