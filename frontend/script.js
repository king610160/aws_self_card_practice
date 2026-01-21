// 模擬 API 網址 (未來換成你的 API Gateway 網址)
const API_URL = 'https://u23zgsvkpe.execute-api.ap-northeast-1.amazonaws.com';
const CDN_BASE_URL = "https://djns63luwoway.cloudfront.net/"

async function fetchUserProfile() {
    try {
        const response = await fetch(`${API_URL}/user/1`);
        
        // 如果後端拋出 404，這裡 response.ok 就會是 false
        if (!response.ok) {
            throw new Error(`伺服器回傳錯誤: ${response.status}`);
        }

        const data = await response.json();
        renderCard(data);
    } catch (error) {
        console.error('發生錯誤:', error);
        document.getElementById('card-container').innerHTML = `
            <div class="alert alert-danger">載入失敗，請稍後再試。</div>
        `;
    }
}

function renderCard(user) {
    const container = document.getElementById('card-container');
    
    // 使用樣板字串 (Template Literals) 動態產生 HTML
    container.innerHTML = `
        <div class="card shadow-sm border-0 text-center p-4">
            <div class="d-flex justify-content-center">
                <img src="${CDN_BASE_URL+user.photoUrl || 'https://via.placeholder.com/150'}" class="profile-img mb-3" alt="Avatar">
            </div>
            <h2 class="fw-bold">${user.name}</h2>
            <p class="text-muted">${user.title}</p>
            <hr>
            <div class="text-start">
                <p><strong>關於我：</strong>${user.bio}</p>
                <p><strong>Email：</strong>${user.email}</p>
            </div>
            <div class="mt-3">
                <a href="${user.website}" class="btn btn-primary w-100" target="_blank">造訪我的個人網站</a>
            </div>
        </div>
    `;
}

// 頁面載入後立即執行
document.addEventListener('DOMContentLoaded', fetchUserProfile);