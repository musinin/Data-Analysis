from flask import Flask

app = Flask(__name__)       # web application 만들기

@app.route("/")              # / 요청에 대한 처리기 등록: index 함수
def index():
    return "This is home !!!"

@app.route("/hello-world")   # /hello-world 요청에 대한 처리기 등록: hello_world 함수
def hello_world():
    return "플라스크 프로그래밍 세계에 오신 것을 환영합니다 !!!"


if __name__ == "__main__":  #import hello_world에 대해서 실행 x, python hello_world.py에 대해서 실행
    # app.run()             # web application 실행(내장 웹 서버 같이 실행)
    # app.debug = True
    app.run(debug=True)     # debug 모드로 실행
