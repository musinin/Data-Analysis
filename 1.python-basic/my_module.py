import random

description = "이 모듈은 테스트를 위해 만든 것입니다."

def greetings(name):
    return f'{name}님 반갑습니다.'

def select_rand_number(cnt=1):
    return [random.random() for _ in range(cnt)]

# print(__name__)     
# __name__ : import 로 실행하면 모듈의 이름 출력, 
#            python 명령으로 실행하면 "__main__" 으로 출력

if __name__ == "__main__":      # 직접 실행할 때 테스트 코드
    r = greetings("Jhon Doe")   # 모듈마다 필수 작용
    print(r)
    r = select_rand_number(5)
    print(r)