from flask import Flask, render_template, request, redirect, url_for

from.views import example_view

def create_app():   # Flask framework와 약속된 이름의 함수(역할: application 생성)
    
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'humanda5-secret-key'
    @app.route("/")
    def index():
        # return "hello flask"
        return render_template("index.html")        # templates/index.html을 찾아서 처리 후 응답
    
    app.register_blueprint(example_view.example_blue_print)

    return app