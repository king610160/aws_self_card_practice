from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum # 1. 引入 Mangum
from database import get_user_from_db  # 引入剛寫好的函式

app = FastAPI()

# 設定 CORS：允許前端跨域請求
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 測試環境先開全開放，正式環境可設為 S3 或你的網域
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/user/{user_id}")
async def get_user(user_id: str):
    # 根據 user_id 找資料，找不到就回傳預設值
    user_data = get_user_from_db(user_id)

    if not user_data:
        # 這裡會讓前端的 response.ok 變成 false
        raise HTTPException(status_code=404, detail="User not found")
        
    return user_data

# 封裝成 handler，這是 Lambda 的入口點
handler = Mangum(app)