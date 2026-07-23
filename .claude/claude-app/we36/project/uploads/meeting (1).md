# Meeting Notes — We36 (App Social Media kiểu Instagram)

> Tên app: **We36**
> Danh sách tính năng đã chốt sau buổi thảo luận.
> Phạm vi: bỏ phần kinh doanh/monetization, bỏ livestream.

---

## 1. Tính năng cốt lõi (MVP)

### Tài khoản & xác thực
- [ ] Đăng ký / đăng nhập (email, số điện thoại, hoặc OAuth Google/Apple)
- [ ] Quản lý hồ sơ: avatar, bio, username, link
- [ ] Đặt tài khoản công khai / riêng tư

### Nội dung (feed)
- [ ] Đăng ảnh/video (1 hoặc nhiều ảnh — carousel)
- [ ] Caption, hashtag, tag người khác
- [ ] Feed hiển thị bài đăng (theo thời gian hoặc thuật toán đơn giản)
- [ ] Like, comment, lưu (save) bài

### Tương tác xã hội
- [ ] Follow / unfollow
- [ ] Trang profile hiển thị grid bài đăng
- [ ] Thông báo (notification) khi có like/comment/follow

---

## 2. Tính năng tăng tính hấp dẫn

- [ ] **Stories**: ảnh/video biến mất sau 24h
- [ ] **Reels / video ngắn**: feed video dọc vuốt lên
- [ ] **Direct Message (DM)**: nhắn tin 1-1, gửi ảnh, chia sẻ bài
- [ ] **Explore / khám phá**: gợi ý nội dung theo sở thích
- [ ] **Tìm kiếm**: theo username, hashtag, địa điểm
- [ ] Bộ lọc & chỉnh sửa ảnh (crop, filter, độ sáng…)
- [ ] Lưu bài vào collection (bộ sưu tập)

---

## 3. Tính năng nâng cao

- [ ] Comment dạng reply lồng nhau, mention
- [ ] Reaction đa dạng cho story/DM
- [ ] Close friends (chia sẻ riêng nhóm bạn thân)
- [ ] Đánh dấu vị trí (location tag) + bản đồ
- [ ] Báo cáo / chặn người dùng, kiểm duyệt nội dung
- [ ] Thuật toán đề xuất nội dung (recommendation)

---

## Ghi chú kỹ thuật

- Phần khó & tốn tài nguyên nhất: **lưu trữ + xử lý ảnh/video** (CDN, nén, streaming) và **thuật toán feed**.
- MVP: chỉ cần feed theo thời gian là đủ.
- Cần tính sớm: kiểm duyệt nội dung, bảo mật dữ liệu, chống spam/bot.

---

## Design System (We36)

**Phong cách:** hiện đại, trẻ trung, màu mè nhưng sạch — chữ ký là gradient ấm rose → violet.
Màu rực rỡ chỉ dùng ở điểm nhấn (nút chính, story ring, icon active, badge); nền/feed giữ neutral sạch.

**Bảng màu**
- Primary (rose): `#FF4E64`
- Accent violet: `#8B5CF6`
- Accent amber: `#FFB627`
- Accent mint: `#2DD4BF`
- Signature gradient: `#FF4E64` → `#8B5CF6`
- Neutral: `#1A1A2E`, `#6B7280`, `#9CA3AF`, `#D1D5DB`, `#E5E7EB`, `#F3F4F6`, `#FFFFFF`
- Status: success `#22C55E`, warning `#F59E0B`, error `#EF4444`, info `#3B82F6`
- Hỗ trợ cả Light mode & Dark mode.

**Typography**
- Heading/logo: Plus Jakarta Sans hoặc Outfit.
- Body: Inter.
- Thang cỡ chữ: Display, H1, H2, H3, Body, Caption, Label.

**Nền tảng:** Spacing thang 4px (4, 8, 12, 16, 24, 32, 48) · Border radius (nhỏ/vừa/lớn/tròn) · Shadow/elevation nhiều mức.

---

## Danh sách màn (Screen Inventory)

### A. Onboarding & Auth
- [ ] Splash / màn khởi động (logo We36)
- [ ] Onboarding (vài slide giới thiệu)
- [ ] Đăng nhập
- [ ] Đăng ký
- [ ] Quên mật khẩu / khôi phục
- [ ] Thiết lập hồ sơ ban đầu (avatar, username, bio)

### B. Feed & Nội dung chính
- [ ] Home feed (kèm thanh story trên cùng)
- [ ] Xem story (story viewer)
- [ ] Tạo story
- [ ] Reels (feed video dọc)
- [ ] Tạo bài đăng: chọn ảnh/video → chỉnh sửa/filter → caption & tag → đăng
- [ ] Chi tiết bài đăng (post detail)
- [ ] Màn bình luận (comment + reply)

### C. Khám phá & Tìm kiếm
- [ ] Explore (lưới khám phá)
- [ ] Tìm kiếm (user / hashtag / địa điểm)
- [ ] Kết quả tìm kiếm
- [ ] Trang hashtag / địa điểm

### D. Hồ sơ
- [ ] Profile của mình (grid bài, saved, tabs)
- [ ] Profile người khác (nút follow)
- [ ] Danh sách follower / following
- [ ] Chỉnh sửa hồ sơ
- [ ] Bộ sưu tập đã lưu (collections)

### E. Nhắn tin (DM)
- [ ] Danh sách hội thoại
- [ ] Khung chat 1-1 (gửi ảnh, chia sẻ bài)

### F. Thông báo & Cài đặt
- [ ] Thông báo (like/comment/follow)
- [ ] Cài đặt tài khoản (công khai/riêng tư, close friends)
- [ ] Quyền riêng tư & bảo mật
- [ ] Báo cáo / chặn người dùng

---

## Việc cần làm tiếp (TODO)

- [ ] Ước lượng công sức từng phần
- [ ] Chọn tech stack
- [ ] Vẽ kiến trúc hệ thống
