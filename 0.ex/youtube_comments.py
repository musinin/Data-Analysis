from googleapiclient.discovery import build
import pandas as pd
from tqdm import tqdm

# 🔑 API 키
API_KEY = 'YOUR-API-KEY'  # 여기에 본인 API 키 붙여넣기
VIDEO_ID = 'nqye02H_H6I'       # 유튜브 동영상 ID (링크에서 v= 뒤에 있는 문자열)

# YouTube API 클라이언트 생성
youtube = build('youtube', 'v3', developerKey=API_KEY)

# 댓글 수집 함수
def get_comments(video_id):
    comments = []
    next_page_token = None

    print("📥 댓글 수집 중...")

    while True:
        response = youtube.commentThreads().list(
            part="snippet",
            videoId=video_id,
            maxResults=100,
            pageToken=next_page_token,
            textFormat="plainText"
        ).execute()

        for item in response['items']:
            comment = item['snippet']['topLevelComment']['snippet']
            comments.append({
                'author': comment['authorDisplayName'],
                'text': comment['textDisplay'],
                'likeCount': comment['likeCount'],
                'publishedAt': comment['publishedAt']
            })

        next_page_token = response.get('nextPageToken')

        if not next_page_token:
            break

    return comments

# ✅ 실행 및 저장
if __name__ == "__main__":
    comments = get_comments(VIDEO_ID)
    df = pd.DataFrame(comments)
    df.to_csv(f'youtube_comments_{VIDEO_ID}.csv', index=False, encoding='utf-8-sig')
    print(f"✅ 댓글 {len(df)}개 저장 완료! -> youtube_comments_{VIDEO_ID}.csv")

