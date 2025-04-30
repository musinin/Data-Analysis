from flask import Blueprint
from flask import render_template, redirect, url_for, jsonify 
from flask import request

import os
import math
from pathlib import Path

import pandas as pd
import yfinance as yf

from ..db import data_util

data_bp = Blueprint("data", __name__, url_prefix="/data")

# 파일을 데이터베이스에 저장
@data_bp.route("/init-titanic/", methods=['GET'])
def init_titanic():
    # 파일에서 데이터 읽기
    bp_path = data_bp.root_path         # 현재 blueprint의 경로 ( 여기서는 views)
    root_path = Path(bp_path).parent    # 부모 경로 ( 여기서는 demoweb)
    file_path = os.path.join(root_path, 'data_files', 'titanic-train.csv')
    df_titanic = pd.read_csv(file_path)

    df_titanic['Age'] = df_titanic['Age'].fillna(df_titanic['Age'].mean())
    df_titanic['Cabin'] = df_titanic['Cabin'].fillna('')
    df_titanic['Embarked'] = df_titanic['Embarked'].fillna('')

    # 데이터베이스의 titanic 데이터 저장
    data_util.create_titanic_table()
    data = df_titanic.values.tolist()
    data_util.insert_titanic_data(data)

    # 응답 컨텐츠 생산 --> home으로 이동 
    return redirect(url_for('main.index'))

# 파일일때
# @data_bp.route("/titanic/", methods=['GET'])
# def titanic():
#     # 파일에서 데이터 읽기
#     bp_path = data_bp.root_path         # 현재 blueprint의 경로 ( 여기서는 views)
#     root_path = Path(bp_path).parent    # 부모 경로 ( 여기서는 demoweb)
#     file_path = os.path.join(root_path, 'data_files', 'titanic-train.csv')
#     df_titanic = pd.read_csv(file_path)

#     # 템플릿으로 이동 ( 위에서 읽은 데이터 전달 )
#     return render_template('data/titanic.html', df=df_titanic)   # (경로, 데이터)

# 데이터베이스일때
@data_bp.route("/titanic", methods=['GET'])
def titanic():
    rows = data_util.select_titanic()
    df_titanic = pd.DataFrame(rows, columns=['PassengerId','Survived','Pclass','Name','Sex','Age','SibSp','Parch','Ticket','Fare','Cabin','Embarked'])
    
    # 템플릿으로 이동 ( 위에서 읽은 데이터 전달 )
    return render_template('data/titanic.html', df=df_titanic) 

# 데이터베이스일때
@data_bp.route("/titanic_by_page", methods=['GET'])
def titanic_by_page():

    # 요청 데이터 읽기 (페이지 번호 읽기)
    page_no = request.args.get('page_no', '1')
    page_no = int(page_no)

    pager = {
        'page_no' : page_no,
        'page_size' : 10,       # 한 페이지에 표시할 행의 수
        'pager_size': 5          # 페이지 번호 표시 개수
    }

    data_cnt = data_util.select_titanic_count() # 전체 데이터 개수

    pager['page_cnt'] = math.ceil(data_cnt / pager['page_size'])        # 나눗셈 + 올림
    pager['page_start'] = ((pager['page_no'] - 1) // pager['pager_size'] ) * pager['pager_size'] + 1  # // :나눗셈 버림
    pager['page_stop'] = pager['page_start'] + pager['pager_size']

    page_start = (page_no -1) * pager['page_size'] # 현재 페이지에서 보여줄 데이터의 시작 번호

    # 데이터베이스에서 해당 페이지의 데이터 읽기
    rows = data_util.select_titanic_by_page(page_start, pager['page_size'])
    df_titanic = pd.DataFrame(rows, columns=['PassengerId','Survived','Pclass','Name','Sex','Age','SibSp','Parch','Ticket','Fare','Cabin','Embarked'])
    
    # 템플릿으로 이동 ( 위에서 읽은 데이터 전달 )
    return render_template('data/titanic_by_page.html', df=df_titanic, pager=pager) 


@data_bp.route("/stock_chart", methods=['GET', 'POST'])
def stock_chart():
    bp_path = data_bp.root_path         # 현재 blueprint의 경로 ( 여기서는 views)
    root_path = Path(bp_path).parent    # 부모 경로 ( 여기서는 demoweb)
    file_path = os.path.join(root_path, 'data_files', 'stock-code.csv')
    df_stock_code = pd.read_csv(file_path)

    quotes = []
    if request.method.lower() == 'post':
        stock1 = request.form.get('stock1')
        stock2 = request.form.get('stock2')
        stock3 = request.form.get('stock3')
        # for code in ['005930.KS', '000100.KS', '000660.KS', '005380.KS']:
        for code in [stock1, stock2, stock3]:
            if len(code) < 9:                       # 6자리 코드(000000.KS)로 만들기
                code = '0' * (9-len(code)) + code   # 총 9개 자리가 아니면 앞에 0 추가
            ticker = yf.Ticker(code)
            history = ticker.history(start='2021-01-01', interval='1d')
            history.reset_index(inplace=True)
            history['Date'] = history['Date'].map(lambda v: v.strftime('%Y-%m-%d')) # datetime -> '1234-12-12'
            # quotes.update({ code: history })
            quotes.append([code, history['Date'].to_list(), history['Close'].to_list()])

    return render_template('data/stock_chart.html', stock_code=df_stock_code, quotes=quotes)


@data_bp.route("/stock_chart_async", methods=['GET'])
def stock_chart_async():
    bp_path = data_bp.root_path         # 현재 blueprint의 경로 ( 여기서는 views)
    root_path = Path(bp_path).parent    # 부모 경로 ( 여기서는 demoweb)
    file_path = os.path.join(root_path, 'data_files', 'stock-code.csv')
    df_stock_code = pd.read_csv(file_path)

    return render_template('data/stock_chart_async.html', stock_code=df_stock_code)


@data_bp.route("/get_stock_quotes", methods=['GET', 'POST'])
def get_stock_quotes():

    quotes = []
    stock1 = request.args.get('stock1')
    stock2 = request.args.get('stock2')
    stock3 = request.args.get('stock3')
    # if request.method.lower() == 'post':
    for code in [stock1, stock2, stock3]:
        if len(code) < 9:                       # 6자리 코드(000000.KS)로 만들기
            code = '0' * (9-len(code)) + code   # 총 9개 자리가 아니면 앞에 0 추가
        ticker = yf.Ticker(code)
        history = ticker.history(start='2021-01-01', interval='1d')
        history.reset_index(inplace=True)
        history['Date'] = history['Date'].map(lambda v: v.strftime('%Y-%m-%d')) # datetime -> '1234-12-12'
        # quotes.update({ code: history })
        quotes.append([code, history['Date'].to_list(), history['Close'].to_list()])

    return jsonify(quotes)  # 객체를 json 형식으로 반환해서 응답

