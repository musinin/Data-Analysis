import pymysql

def create_titanic_table():
    try:
        conn = pymysql.connect(host="localhost", 
                               database='demoweb', 
                               user='humanda5', 
                               password='humanda5')
        cursor = conn.cursor()

        sql = "drop table if exists titanic"
        cursor.execute(sql)
        sql = """create table  if not exists titanic
                (
                    PassengerId int not null primary key
                    ,Survived boolean not null
                    ,Pclass int null
                    ,Name varchar(100) null
                    ,Sex varchar(10) null
                    ,Age float null
                    ,SibSp int null
                    ,Parch int null
                    ,Ticket varchar(50) null
                    ,Fare float null
                    ,Cabin varchar(100) null
                    ,Embarked char(1) null
                );"""
        cursor.execute(sql)

    except Exception as e:
        print("테이블 생성 실패 : ", e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

def insert_titanic_data(data):
    try:
        conn = pymysql.connect(host="localhost", 
                               database='demoweb', 
                               user='humanda5', 
                               password='humanda5')
        cursor = conn.cursor()

        sql = "insert into titanic values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        cursor.executemany(sql, data)
        conn.commit()

    except Exception as e:
        print("데이터 저장 실패 : ", e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


def select_titanic():
    rows = None
    try:
        conn = pymysql.connect(host="localhost", 
                               database='demoweb', 
                               user='humanda5', 
                               password='humanda5')
        cursor = conn.cursor()

        sql = "select * from titanic"
        cursor.execute(sql)
        rows = cursor.fetchall()

    except Exception as e:
        print("데이터 불러오기 실패 : ", e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

    return rows

def select_titanic_by_page(page_start, page_size):
    rows = None
    try:
        conn = pymysql.connect(host="localhost", 
                               database='demoweb', 
                               user='humanda5', 
                               password='humanda5')
        cursor = conn.cursor()

        sql = "select * from titanic limit %s, %s"
        cursor.execute(sql, (page_start, page_size))
        rows = cursor.fetchall()

    except Exception as e:
        print("데이터 불러오기 실패 : ", e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

    return rows


def select_titanic_count():
    cnt = None
    try:
        conn = pymysql.connect(host="localhost", 
                               database='demoweb', 
                               user='humanda5', 
                               password='humanda5')
        cursor = conn.cursor()

        sql = "select count(*) from titanic"
        cursor.execute(sql)
        cnt = cursor.fetchone()

    except Exception as e:
        print("데이터 조회 실패 : ", e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

    return cnt[0]
