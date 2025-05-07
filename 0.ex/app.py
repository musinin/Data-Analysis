import streamlit as st
import pandas as pd
import numpy as np

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