# J Skills

> Làm việc chăm chỉ hơn, rồi nghỉ ngơi một chút. 4 skill giúp bạn có nhịp code tốt hơn với Claude Code.

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)
[![Skills](https://img.shields.io/badge/skills-4-blue.svg)]()
[![Zero Dependencies](https://img.shields.io/badge/dependencies-0-brightgreen.svg)]()
[![Claude Code](https://img.shields.io/badge/platform-Claude%20Code-purple.svg)]()
[![OpenClaw](https://img.shields.io/badge/platform-OpenClaw-orange.svg)]()

[English](../../README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Español](README.es.md) | [Português](README.pt-BR.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Русский](README.ru.md) | [हिन्दी](README.hi.md) | [Türkçe](README.tr.md) | [Tiếng Việt](README.vi.md)

### Demo nhanh

```
$ /block-break fix the flaky test

Block Break 🔥 Activated
┌───────────────┬─────────────────────────────────────────┐
│ 3 Red Lines   │ Closed-loop · Fact-driven · Exhaust all │
├───────────────┼─────────────────────────────────────────┤
│ Escalation    │ L0 Trust → L4 Graduation                │
├───────────────┼─────────────────────────────────────────┤
│ Method        │ Smell→Pull hair→Mirror→New approach→Retro│
└───────────────┴─────────────────────────────────────────┘

> Trust is earned by results. Don't let down those who trust you.

[Block Break 🔥] Starting task: fix the flaky test
  L0 Trust — Normal execution. Investigating root cause...
```

## Cài đặt

```bash
# Claude Code (một lệnh duy nhất)
claude plugin add juserch/jskills

# OpenClaw
git clone https://github.com/juserch/jskills.git
cp -r jskills/platforms/openclaw/* ~/.openclaw/skills/
```

## Các Skill

### Làm việc chăm chỉ hơn

| Skill | Chức năng | Thử ngay |
|-------|-----------|----------|
| **block-break** | Buộc phải thử hết mọi cách trước khi bỏ cuộc | `/block-break` |
| **ralph-boost** | Vòng lặp phát triển tự động với đảm bảo hội tụ | `/ralph-boost setup` |
| **skill-lint** | Kiểm tra tính hợp lệ của bất kỳ Claude Code skill plugin nào | `/skill-lint .` |

### Nghỉ ngơi một chút

| Skill | Chức năng | Thử ngay |
|-------|-----------|----------|
| **news-fetch** | Đọc tin nhanh giữa các phiên code | `/news-fetch AI today` |

---

## Block Break — Công cụ Ràng buộc Hành vi

AI của bạn bỏ cuộc rồi à? `/block-break` buộc nó phải thử hết mọi cách trước đã.

Khi Claude bị kẹt, Block Break kích hoạt hệ thống leo thang áp lực ngăn chặn việc đầu hàng sớm. Nó buộc agent đi qua các giai đoạn giải quyết vấn đề ngày càng nghiêm ngặt trước khi cho phép bất kỳ phản hồi "tôi không làm được" nào.

| Cơ chế | Mô tả |
|--------|-------|
| **3 Lằn ranh Đỏ** | Xác minh vòng kín / Dựa trên dữ kiện / Thử hết mọi phương án |
| **Leo thang Áp lực** | L0 Tin tưởng → L1 Thất vọng → L2 Chất vấn → L3 Đánh giá Hiệu suất → L4 Tốt nghiệp |
| **Phương pháp 5 Bước** | Đánh hơi → Vò đầu bứt tai → Soi gương → Cách tiếp cận mới → Nhìn lại |
| **Checklist 7 Điểm** | Checklist chẩn đoán bắt buộc ở L3+ |
| **Chống Hợp lý hóa** | Nhận diện và chặn 14 kiểu bào chữa phổ biến |
| **Hook** | Tự động phát hiện bế tắc + đếm lỗi + lưu trạng thái |

```text
/block-break              # Kích hoạt chế độ Block Break
/block-break L2           # Bắt đầu ở mức áp lực cụ thể
/block-break fix the bug  # Kích hoạt và bắt đầu ngay một task
```

Cũng được kích hoạt qua ngôn ngữ tự nhiên: `try harder`, `stop spinning`, `figure it out`, `you keep failing`, v.v. (tự động phát hiện bởi hook).

> Lấy cảm hứng từ [PUA](https://github.com/tanweai/pua), tinh gọn thành một skill không phụ thuộc.

## Ralph Boost — Công cụ Vòng lặp Phát triển Tự động

Vòng lặp phát triển tự động thực sự hội tụ. Thiết lập trong 30 giây.

Tái tạo khả năng vòng lặp tự động của ralph-claude-code dưới dạng skill, tích hợp sẵn leo thang áp lực Block Break L0-L4 để đảm bảo hội tụ. Giải quyết vấn đề "quay vòng không tiến triển" trong các vòng lặp tự động.

| Tính năng | Mô tả |
|-----------|-------|
| **Vòng lặp Hai Đường** | Vòng lặp agent (chính, không phụ thuộc bên ngoài) + bash script dự phòng (jq/python engine) |
| **Circuit Breaker Nâng cao** | Tích hợp leo thang áp lực L0-L4: từ "bỏ cuộc sau 3 vòng" lên "6-7 vòng tự cứu lũy tiến" |
| **Theo dõi Trạng thái** | state.json hợp nhất cho circuit breaker + áp lực + chiến lược + phiên |
| **Bàn giao Mượt mà** | L4 tạo báo cáo bàn giao có cấu trúc thay vì crash thô |
| **Độc lập** | Sử dụng thư mục `.ralph-boost/`, không phụ thuộc ralph-claude-code |

```text
/ralph-boost setup        # Khởi tạo dự án
/ralph-boost run          # Bắt đầu vòng lặp tự động
/ralph-boost status       # Kiểm tra trạng thái hiện tại
/ralph-boost clean        # Dọn dẹp
```

> Lấy cảm hứng từ [ralph-claude-code](https://github.com/frankbria/ralph-claude-code), tái thiết kế thành skill không phụ thuộc với đảm bảo hội tụ.

## Skill Lint — Công cụ Kiểm tra Skill Plugin

Kiểm tra Claude Code plugin của bạn chỉ với một lệnh.

Kiểm tra tính toàn vẹn cấu trúc và chất lượng ngữ nghĩa của các file skill trong bất kỳ dự án Claude Code plugin nào. Bash script xử lý kiểm tra cấu trúc, AI xử lý kiểm tra ngữ nghĩa — bổ trợ lẫn nhau.

| Loại kiểm tra | Mô tả |
|---------------|-------|
| **Cấu trúc** | Các trường bắt buộc trong frontmatter / sự tồn tại file / liên kết tham chiếu / mục marketplace |
| **Ngữ nghĩa** | Chất lượng mô tả / tính nhất quán tên / định tuyến lệnh / phạm vi eval |

```text
/skill-lint              # Hiển thị hướng dẫn sử dụng
/skill-lint .            # Kiểm tra dự án hiện tại
/skill-lint /path/to/plugin  # Kiểm tra một đường dẫn cụ thể
```

## News Fetch — Giải lao Tinh thần Giữa các Sprint

Kiệt sức vì debug? `/news-fetch` — 2 phút giải lao tinh thần cho bạn.

Ba skill kia đẩy bạn làm việc chăm chỉ hơn. Skill này nhắc bạn hít thở. Lấy tin tức mới nhất về bất kỳ chủ đề nào, ngay từ terminal — không cần chuyển ngữ cảnh, không lạc vào hố thỏ trình duyệt. Lướt nhanh rồi quay lại công việc, tinh thần sảng khoái.

| Tính năng | Mô tả |
|-----------|-------|
| **Dự phòng 3 Tầng** | L1 WebSearch → L2 WebFetch (nguồn khu vực) → L3 curl |
| **Loại trùng & Gộp** | Cùng sự kiện từ nhiều nguồn tự động gộp, giữ bản điểm cao nhất |
| **Chấm điểm Liên quan** | AI chấm điểm và sắp xếp theo độ phù hợp chủ đề |
| **Tóm tắt Tự động** | Tóm tắt thiếu được tự động tạo từ nội dung bài viết |

```text
/news-fetch AI                    # Tin AI tuần này
/news-fetch AI today              # Tin AI hôm nay
/news-fetch robotics month        # Tin robotics tháng này
/news-fetch climate 2026-03-01~2026-03-31  # Khoảng thời gian tùy chọn
```

## Chất lượng

- 10+ kịch bản đánh giá mỗi skill với kiểm tra kích hoạt tự động
- Tự kiểm tra bằng chính skill-lint của mình
- Không phụ thuộc bên ngoài — không rủi ro
- Giấy phép MIT, mã nguồn mở hoàn toàn

## Cấu trúc Dự án

```text
jskills/
├── skills/                        # Nền tảng Claude Code
│   └── <skill>/
│       ├── SKILL.md               # Định nghĩa skill
│       ├── references/            # Nội dung chi tiết (tải khi cần)
│       ├── scripts/               # Script hỗ trợ
│       └── agents/                # Định nghĩa sub-agent
├── platforms/                     # Thích ứng nền tảng khác
│   └── openclaw/
│       └── <skill>/
│           ├── SKILL.md           # Phiên bản OpenClaw
│           ├── references/        # Nội dung riêng nền tảng
│           └── scripts/           # Script riêng nền tảng
├── .claude-plugin/                # Metadata marketplace Claude Code
├── hooks/                         # Hook nền tảng Claude Code
├── evals/                         # Kịch bản đánh giá đa nền tảng
├── docs/
│   ├── guide/                     # Hướng dẫn sử dụng (tiếng Anh)
│   ├── plans/                     # Tài liệu thiết kế
│   └── i18n/                      # Bản dịch (zh-CN, ja, ko)
│       ├── README.*.md            # README đã dịch
│       └── guide/{zh-CN,ja,ko}/   # Hướng dẫn đã dịch
└── plugin.json                    # Metadata bộ sưu tập
```

## Đóng góp

1. `skills/<name>/SKILL.md` — Claude Code skill + references/scripts
2. `platforms/openclaw/<name>/SKILL.md` — Phiên bản OpenClaw + references/scripts
3. `evals/<name>/scenarios.md` + `run-trigger-test.sh` — Kịch bản đánh giá
4. `.claude-plugin/marketplace.json` — Thêm mục vào mảng `plugins`
5. Hook nếu cần trong `hooks/hooks.json`

Xem [CLAUDE.md](../../CLAUDE.md) để biết đầy đủ hướng dẫn phát triển.

## Giấy phép

[MIT](../../LICENSE) - [juserch](https://github.com/juserch)
