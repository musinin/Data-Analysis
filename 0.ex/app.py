import streamlit as st
import pandas as pd
import numpy as np
import torch
import torch.nn as nn
from konlpy.tag import Okt
import pickle

st.title('--Uber pickups in NYC')

DATE_COLUMN = 'date/time'
DATA_URL = ('https://s3-us-west-2.amazonaws.com/'
            'streamlit-demo-data/uber-raw-data-sep14.csv.gz')

@st.cache
def load_data(nrows):
    data = pd.read_csv(DATA_URL, nrows=nrows)
    lowercase = lambda x: str(x).lower()
    data.rename(lowercase, axis='columns', inplace=True)
    data[DATE_COLUMN] = pd.to_datetime(data[DATE_COLUMN])
    return data

data_load_state = st.text('Loading data...')
data = load_data(10000)
data_load_state.text("Done! (using st.cache)")

if st.button("버튼 클릭"):
    st.write("Data Loading..")
    # 데이터 로딩 함수는 여기에!

checkbox_btn1 = st.checkbox('옵션1')
checkbox_btn2 = st.checkbox('옵션2')

if checkbox_btn1:
    st.write('Great!')

option = st.selectbox('Please select in selectbox!',
                    ('kyle', 'seongyun', 'zzsza'))

st.write('You selected:', option)

if st.checkbox('Show raw data'):
    st.subheader('Raw data')
    st.write(data)

st.subheader('Number of pickups by hour')
hist_values = np.histogram(data[DATE_COLUMN].dt.hour, bins=24, range=(0,24))[0]
st.bar_chart(hist_values)

hour_to_filter = st.slider('hour', 0, 23, 17)
filtered_data = data[data[DATE_COLUMN].dt.hour == hour_to_filter]

st.subheader('Map of all pickups at %s:00' % hour_to_filter)
st.map(filtered_data)

values = st.text_input("대선 후보 입력")
st.write('input value:', values)



# 2. 집값 예측 모델

with open("xgboost_feature_full.pkl", "rb") as f:
    model = pickle.load(f)

st.title("XGBoost Prediction App")

# 입력 받기 예시
age = st.number_input("Enter Age")
income = st.number_input("Enter Income")

# 예측
if st.button("Predict"):
    input_df = pd.DataFrame([[age, income]], columns=["age", "income"])
    pred = model.predict(input_df)
    st.write("Prediction:", pred[0])

# 3. 감성로드
# 사전 정의
index_to_tag = {0: '부정', 1: '긍정'}
word_to_index = torch.load('word_to_index.pth')  # 예: {'좋다': 5, '싫다': 7, ...}
stopwords = ['도', '는', '다', '의', '가', '이', '은', '한', '에', '하', '고',
             '을', '를', '인', '듯', '과', '와', '네', '들', '듯', '지', '임', '게']
device = torch.device("cpu")
# device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
okt = Okt()


# 모델 클래스 정의 (LSTM 구조에 맞게 반드시 수정)
class SentimentLSTM(nn.Module):
    def __init__(self, vocab_size, embedding_dim, hidden_dim, output_dim):
        super(SentimentLSTM, self).__init__()
        self.embedding = nn.Embedding(vocab_size, embedding_dim, padding_idx=0)
        self.lstm = nn.LSTM(embedding_dim, hidden_dim, batch_first=True)
        self.fc = nn.Linear(hidden_dim, output_dim)

    def forward(self, x):
        x = self.embedding(x)
        _, (hidden, _) = self.lstm(x)
        output = self.fc(hidden[-1])
        return output

# 캐시된 모델 로드
@st.cache_resource
def load_model():
    vocab_size = 17403  # vocab_size 수정 (체크포인트와 일치하도록)
    embedding_dim = 100
    hidden_dim = 128
    output_dim = 2
    model = SentimentLSTM(vocab_size, embedding_dim, hidden_dim, output_dim).to(device)
    model.load_state_dict(torch.load('best_model_checkpoint.pth', map_location=device), strict=False)
    model.eval()
    return model

# 모델 로드
model = load_model()

# 체크포인트와 일치하는 vocab_size로 모델 로드
vocab_size = 17403  # 체크포인트와 일치하도록 수정
embedding_dim = 100
hidden_dim = 128
output_dim = 2

model = SentimentLSTM(vocab_size, embedding_dim, hidden_dim, output_dim).to(device)
model.load_state_dict(torch.load('best_model_checkpoint.pth', map_location=device), strict=False)
model.eval()

# 예측 함수
def predict(text):
    tokens = okt.morphs(text, stem=True)
    tokens = [word for word in tokens if word not in stopwords]
    token_indices = [word_to_index.get(word, 1) for word in tokens]
    input_tensor = torch.tensor([token_indices], dtype=torch.long).to(device)

    with torch.no_grad():
        logits = model(input_tensor)
        predicted_index = torch.argmax(logits, dim=1).item()
        return index_to_tag[predicted_index]

# Streamlit UI
st.title("감성 분석 (LSTM 기반)")

user_input = st.text_input("문장을 입력하세요:")

if st.button("예측"):
    if user_input:
        result = predict(user_input)
        st.write(f"👉 예측 결과: **{result}**")
    else:
        st.warning("문장을 입력해주세요.")