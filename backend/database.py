import boto3
from botocore.exceptions import ClientError

# 初始化 DynamoDB 資源
# 如果你在本地環境已經設定好 aws configure，它會自動抓取憑證
dynamodb = boto3.resource('dynamodb', region_name='ap-northeast-1')
table = dynamodb.Table('UserCards')

def get_user_from_db(user_id: str):
    try:
        response = table.get_item(Key={'id': user_id})
        return response.get('Item') # 如果找不到會回傳 None
    except ClientError as e:
        print(f"資料庫連線錯誤: {e.response['Error']['Message']}")
        return None
    
def update_user_photo(user_id: str, s3_url: str):
    try:
        table.update_item(
            Key={'id': user_id},
            UpdateExpression="set photoUrl = :url",
            ExpressionAttributeValues={':url': s3_url},
            ReturnValues="UPDATED_NEW"
        )
        return True
    except ClientError as e:
        print(f"更新失敗: {e}")
        return False