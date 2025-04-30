from flask import Blueprint
from flask import render_template, redirect, url_for 
from flask import request, session

from werkzeug.security import generate_password_hash, check_password_hash

from ..db import member_util

auth_bp = Blueprint("auth", __name__, url_prefix="/auth")

@auth_bp.route("/login/", methods=['GET','POST'])
def login():
    if request.method.lower() == 'get':
        return render_template("auth/login.html")
    else:
        # 1. 요청 데이터 읽기
        email = request.form.get('email','')
        passwd = request.form.get('passwd','')
        remember = request.form.get('remember','')
        # return f'{email}, {passwd}, {remember}'

        # 2. 요청 처리
        row = member_util.select_member_by_email(email)
        print(row)
        if not row: # 조회된 row가 없다면
            return render_template("auth/login.html", 
                                   message="존재하지 않는 이메일입니다.")    # 템플릿(.html)에 전달되는 데이터

        #if email == 'iamuser@example.com' and passwd == '12345': # 예시 계정
        if check_password_hash(row[1], passwd):
            session['loginuser'] = email                # 로그인 처리 : 세션에 로그인 관련 데이터 저장 
            return redirect(url_for('main.index'))      # main blueprint의 index 함수에 연결된 경로로 이동
        else:   # 로그인 실패

            # 3. 응답 컨텐츠 만들기
            return render_template("auth/login.html", 
                                   message="비밀번호가 잘못 되었습니다.")
            # return redirect(url_for('auth.login'))    # 새로고침할때 오류가 발생하기에 이 사용이 좋음

@auth_bp.route("/logout/", methods=['GET'])
def logout():
    #del session['loginuser']           # session의 개별 데이터 제거
    # session.pop('loginuser', None)    # session의 개별 데이터 제거
    #session['loginuser'] == None       # session의 개별 데이터 제거
    session.clear()                     # session의 모든 데이터 제거
    
    return redirect(url_for('main.index'))


@auth_bp.route("/register/", methods=['GET','POST'])
def register():
    if request.method.lower() == 'get':
        return render_template('auth/register.html')
    else:
        username = request.form.get('username')
        email = request.form.get('email')
        passwd = request.form.get('passwd')
        passwd_hash = generate_password_hash(passwd)
        #return f'{user_name}, {email},{passwd}'
        member_util.insert_member(email, passwd_hash, username)

        #return render_template('auth/login.html') 레지스터와 로그인과는 관련 없기에 리다이렉터로
        return redirect(url_for('auth.login'))
