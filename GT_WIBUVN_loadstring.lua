--[[
    GT_WIBUVN - Universal Player Menu
    Version: 1.0

    Features:
    Fix Lag
    Fly
    Infinite Jump
    Jump Boost
    Speed Boost
    FlyCam
    Fullbright
    Noclip
    FPS
    Ping
    Language
    Mobile Support
    Confirmation before GUI deletion
]]

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------

local GUI_NAME = "GT_WIBUVN_Menu"

local DEFAULT_WALK_SPEED = 16
local DEFAULT_JUMP_POWER = 50
local DEFAULT_FLY_SPEED = 60

local MIN_SPEED = 16
local MAX_SPEED = 150

local MIN_JUMP = 50
local MAX_JUMP = 150

local MIN_FLY = 20
local MAX_FLY = 200

----------------------------------------------------------------
-- REMOVE OLD GUI
----------------------------------------------------------------

local OldGui = PlayerGui:FindFirstChild(GUI_NAME)

if OldGui then
	pcall(function()
		OldGui:Destroy()
	end)
end

----------------------------------------------------------------
-- STATE
----------------------------------------------------------------

local State = {
	FixLag = false,
	Fly = false,
	InfiniteJump = false,
	JumpBoost = false,
	SpeedBoost = false,
	FlyCam = false,
	Fullbright = false,
	Noclip = false,
	FPS = false,
	Ping = false,

	Speed = 50,
	Jump = 75,
	FlySpeed = DEFAULT_FLY_SPEED,

	Language = "vi",

	MainOpen = true,
	Destroyed = false,
}

----------------------------------------------------------------
-- CONNECTIONS
----------------------------------------------------------------

local Connections = {}

local function Connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(Connections, connection)
	return connection
end

local function DisconnectAll()
	for _, connection in ipairs(Connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(Connections)
end

----------------------------------------------------------------
-- LANGUAGE
----------------------------------------------------------------

local Languages = {
	vi = {
		Name = "Tiếng Việt",

		Title = "GT_WIBUVN MENU",
		Subtitle = "Điều khiển trình phát đa năng",
		Features = "TÍNH NĂNG",
		Settings = "CÀI ĐẶT",
		Language = "Ngôn ngữ",
		Credit = "Tác Giả",
		Close = "Đóng",
		Open = "Mở GUI",
		Delete = "Xoá GUI",
		ConfirmTitle = "Xác nhận",
		ConfirmDelete = "Bạn có chắc chắn muốn xoá GUI không?",
		Yes = "Đúng",
		No = "Không",
		On = "BẬT",
		Off = "TẮT",
		Run = "CHẠY",

		FixLag = "Giảm Lag",
		FixLagDesc = "Giảm hiệu ứng và chi tiết không cần thiết phía client.",

		Fly = "Bay",
		FlyDesc = "Cho phép nhân vật bay tự do bằng bàn phím hoặc nút mobile.",

		InfiniteJump = "Nhảy Vô Hạn",
		InfiniteJumpDesc = "Cho phép nhảy liên tục trên không.",

		JumpBoost = "Tăng Nhảy",
		JumpBoostDesc = "Tăng lực nhảy của nhân vật.",

		SpeedBoost = "Tăng Tốc Độ",
		SpeedBoostDesc = "Tăng tốc độ di chuyển của nhân vật.",

		FlyCam = "FlyCam",
		FlyCamDesc = "Điều khiển camera tự do mà không di chuyển nhân vật.",

		Fullbright = "Thấp Sáng",
		FullbrightDesc = "Làm sáng môi trường để nhìn rõ hơn.",

		Noclip = "Đi Xuyên",
		NoclipDesc = "Cho phép đi xuyên qua vật thể.",

		FPS = "FPS",
		FPSDesc = "Hiển thị FPS hiện tại.",

		Ping = "Ping",
		PingDesc = "Hiển thị ping hiện tại.",

		SpeedValue = "Tốc độ",
		JumpValue = "Lực nhảy",
		FlyValue = "Tốc độ Fly",

		Monitor = "Hiệu Năng",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "Điều khiển Mobile",

		Saved = "Đã bật",
		Disabled = "Đã tắt",
	},

	en = {
		Name = "English",

		Title = "GT_WIBUVN MENU",
		Subtitle = "Universal Player Control",
		Features = "FEATURES",
		Settings = "SETTINGS",
		Language = "Language",
		Credit = "Credit",
		Close = "Close",
		Open = "Open GUI",
		Delete = "Delete GUI",
		ConfirmTitle = "Confirmation",
		ConfirmDelete = "Are you sure you want to delete the GUI?",
		Yes = "Yes",
		No = "No",
		On = "ON",
		Off = "OFF",
		Run = "RUN",

		FixLag = "Fix Lag",
		FixLagDesc = "Reduce unnecessary client-side effects and details.",

		Fly = "Fly",
		FlyDesc = "Fly freely using keyboard or mobile controls.",

		InfiniteJump = "Inf Jump",
		InfiniteJumpDesc = "Jump continuously while in the air.",

		JumpBoost = "Jump Boost",
		JumpBoostDesc = "Increase the character's jump power.",

		SpeedBoost = "Speed Boost",
		SpeedBoostDesc = "Increase the character's movement speed.",

		FlyCam = "FlyCam",
		FlyCamDesc = "Freely control the camera without moving the character.",

		Fullbright = "Fullbright",
		FullbrightDesc = "Brighten the environment for better visibility.",

		Noclip = "Noclip",
		NoclipDesc = "Walk through physical objects.",

		FPS = "FPS",
		FPSDesc = "Show current FPS.",

		Ping = "Ping",
		PingDesc = "Show current ping.",

		SpeedValue = "Speed",
		JumpValue = "Jump Power",
		FlyValue = "Fly Speed",

		Monitor = "MONITOR",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "Mobile Controls",

		Saved = "Enabled",
		Disabled = "Disabled",
	},

	zh = {
		Name = "简体中文",

		Title = "GT_WIBUVN MENU",
		Subtitle = "通用玩家控制",
		Features = "功能",
		Settings = "设置",
		Language = "语言",
		Credit = "作者",
		Close = "关闭",
		Open = "打开 GUI",
		Delete = "删除 GUI",
		ConfirmTitle = "确认",
		ConfirmDelete = "确定要删除 GUI 吗？",
		Yes = "确定",
		No = "取消",
		On = "开启",
		Off = "关闭",
		Run = "运行",

		FixLag = "优化延迟",
		FixLagDesc = "减少客户端不必要的效果和细节。",

		Fly = "飞行",
		FlyDesc = "使用键盘或手机控制飞行。",

		InfiniteJump = "无限跳",
		InfiniteJumpDesc = "可以在空中连续跳跃。",

		JumpBoost = "跳跃增强",
		JumpBoostDesc = "增加角色跳跃力度。",

		SpeedBoost = "速度增强",
		SpeedBoostDesc = "增加角色移动速度。",

		FlyCam = "自由镜头",
		FlyCamDesc = "自由控制摄像机，不移动角色。",

		Fullbright = "全亮",
		FullbrightDesc = "提高环境亮度。",

		Noclip = "穿墙",
		NoclipDesc = "可以穿过物体。",

		FPS = "FPS",
		FPSDesc = "显示当前 FPS。",

		Ping = "Ping",
		PingDesc = "显示当前 Ping。",

		SpeedValue = "速度",
		JumpValue = "跳跃力度",
		FlyValue = "飞行速度",

		Monitor = "监控",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "手机控制",

		Saved = "已开启",
		Disabled = "已关闭",
	},

	es = {
		Name = "Español",

		Title = "GT_WIBUVN MENU",
		Subtitle = "Control Universal",
		Features = "FUNCIONES",
		Settings = "AJUSTES",
		Language = "Idioma",
		Credit = "Créditos",
		Close = "Cerrar",
		Open = "Abrir GUI",
		Delete = "Eliminar GUI",
		ConfirmTitle = "Confirmación",
		ConfirmDelete = "¿Seguro que quieres eliminar la GUI?",
		Yes = "Sí",
		No = "No",
		On = "ACTIVADO",
		Off = "DESACTIVADO",
		Run = "EJECUTAR",

		FixLag = "Fix Lag",
		FixLagDesc = "Reduce efectos innecesarios del cliente.",

		Fly = "Volar",
		FlyDesc = "Vuela usando teclado o controles móviles.",

		InfiniteJump = "Salto Infinito",
		InfiniteJumpDesc = "Permite saltar continuamente en el aire.",

		JumpBoost = "Impulso de Salto",
		JumpBoostDesc = "Aumenta la potencia de salto.",

		SpeedBoost = "Impulso de Velocidad",
		SpeedBoostDesc = "Aumenta la velocidad del personaje.",

		FlyCam = "FlyCam",
		FlyCamDesc = "Controla libremente la cámara.",

		Fullbright = "Fullbright",
		FullbrightDesc = "Aumenta la iluminación.",

		Noclip = "Noclip",
		NoclipDesc = "Permite atravesar objetos.",

		FPS = "FPS",
		FPSDesc = "Muestra los FPS actuales.",

		Ping = "Ping",
		PingDesc = "Muestra el ping actual.",

		SpeedValue = "Velocidad",
		JumpValue = "Salto",
		FlyValue = "Velocidad Fly",

		Monitor = "MONITOR",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "Controles móviles",

		Saved = "Activado",
		Disabled = "Desactivado",
	},

	pt = {
		Name = "Português",

		Title = "GT_WIBUVN MENU",
		Subtitle = "Controle Universal",
		Features = "FUNÇÕES",
		Settings = "CONFIGURAÇÕES",
		Language = "Idioma",
		Credit = "Créditos",
		Close = "Fechar",
		Open = "Abrir GUI",
		Delete = "Excluir GUI",
		ConfirmTitle = "Confirmação",
		ConfirmDelete = "Tem certeza que deseja excluir a GUI?",
		Yes = "Sim",
		No = "Não",
		On = "ATIVADO",
		Off = "DESATIVADO",
		Run = "EXECUTAR",

		FixLag = "Fix Lag",
		FixLagDesc = "Reduz efeitos desnecessários no cliente.",

		Fly = "Voar",
		FlyDesc = "Voe usando teclado ou controles móveis.",

		InfiniteJump = "Pulo Infinito",
		InfiniteJumpDesc = "Permite pular continuamente no ar.",

		JumpBoost = "Impulso de Pulo",
		JumpBoostDesc = "Aumenta a força do pulo.",

		SpeedBoost = "Impulso de Velocidade",
		SpeedBoostDesc = "Aumenta a velocidade do personagem.",

		FlyCam = "FlyCam",
		FlyCamDesc = "Controle a câmera livremente.",

		Fullbright = "Fullbright",
		FullbrightDesc = "Aumenta a iluminação.",

		Noclip = "Noclip",
		NoclipDesc = "Permite atravessar objetos.",

		FPS = "FPS",
		FPSDesc = "Mostra o FPS atual.",

		Ping = "Ping",
		PingDesc = "Mostra o ping atual.",

		SpeedValue = "Velocidade",
		JumpValue = "Pulo",
		FlyValue = "Velocidade Fly",

		Monitor = "MONITOR",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "Controles Mobile",

		Saved = "Ativado",
		Disabled = "Desativado",
	},

	id = {
		Name = "Bahasa Indonesia",

		Title = "GT_WIBUVN MENU",
		Subtitle = "Kontrol Pemain Universal",
		Features = "FITUR",
		Settings = "PENGATURAN",
		Language = "Bahasa",
		Credit = "Kredit",
		Close = "Tutup",
		Open = "Buka GUI",
		Delete = "Hapus GUI",
		ConfirmTitle = "Konfirmasi",
		ConfirmDelete = "Yakin ingin menghapus GUI?",
		Yes = "Ya",
		No = "Tidak",
		On = "AKTIF",
		Off = "NONAKTIF",
		Run = "JALANKAN",
		
		FixLag = "Fix Lag",
		FixLagDesc = "Mengurangi efek client yang tidak diperlukan.",

		Fly = "Fly",
		FlyDesc = "Terbang menggunakan keyboard atau kontrol mobile.",

		InfiniteJump = "Inf Jump",
		InfiniteJumpDesc = "Melompat terus di udara.",

		JumpBoost = "Jump Boost",
		JumpBoostDesc = "Meningkatkan kekuatan lompatan.",

		SpeedBoost = "Speed Boost",
		SpeedBoostDesc = "Meningkatkan kecepatan karakter.",

		FlyCam = "FlyCam",
		FlyCamDesc = "Mengontrol kamera dengan bebas.",

		Fullbright = "Fullbright",
		FullbrightDesc = "Meningkatkan pencahayaan.",

		Noclip = "Noclip",
		NoclipDesc = "Berjalan menembus objek.",

		FPS = "FPS",
		FPSDesc = "Menampilkan FPS saat ini.",

		Ping = "Ping",
		PingDesc = "Menampilkan ping saat ini.",

		SpeedValue = "Kecepatan",
		JumpValue = "Lompatan",
		FlyValue = "Kecepatan Fly",

		Monitor = "MONITOR",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "Kontrol Mobile",

		Saved = "Aktif",
		Disabled = "Nonaktif",
	},

	ru = {
		Name = "Русский",

		Title = "GT_WIBUVN MENU",
		Subtitle = "Универсальное управление",
		Features = "ФУНКЦИИ",
		Settings = "НАСТРОЙКИ",
		Language = "Язык",
		Credit = "Автор",
		Close = "Закрыть",
		Open = "Открыть GUI",
		Delete = "Удалить GUI",
		ConfirmTitle = "Подтверждение",
		ConfirmDelete = "Вы уверены, что хотите удалить GUI?",
		Yes = "Да",
		No = "Нет",
		On = "ВКЛ",
		Off = "ВЫКЛ",
		Run = "ЗАПУСК",

		FixLag = "Fix Lag",
		FixLagDesc = "Уменьшает ненужные эффекты клиента.",

		Fly = "Полёт",
		FlyDesc = "Позволяет летать с клавиатуры или телефона.",

		InfiniteJump = "Бесконечный прыжок",
		InfiniteJumpDesc = "Позволяет постоянно прыгать в воздухе.",

		JumpBoost = "Усиление прыжка",
		JumpBoostDesc = "Увеличивает силу прыжка.",

		SpeedBoost = "Ускорение",
		SpeedBoostDesc = "Увеличивает скорость персонажа.",

		FlyCam = "FlyCam",
		FlyCamDesc = "Свободное управление камерой.",

		Fullbright = "Fullbright",
		FullbrightDesc = "Увеличивает яркость окружения.",

		Noclip = "Noclip",
		NoclipDesc = "Позволяет проходить сквозь объекты.",

		FPS = "FPS",
		FPSDesc = "Показывает текущий FPS.",

		Ping = "Ping",
		PingDesc = "Показывает текущий Ping.",

		SpeedValue = "Скорость",
		JumpValue = "Прыжок",
		FlyValue = "Скорость Fly",

		Monitor = "МОНИТОР",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "Мобильное управление",

		Saved = "Включено",
		Disabled = "Выключено",
	},

	ja = {
		Name = "日本語",

		Title = "GT_WIBUVN MENU",
		Subtitle = "ユニバーサルプレイヤーコントロール",
		Features = "機能",
		Settings = "設定",
		Language = "言語",
		Credit = "クレジット",
		Close = "閉じる",
		Open = "GUIを開く",
		Delete = "GUIを削除",
		ConfirmTitle = "確認",
		ConfirmDelete = "GUIを削除してもよろしいですか？",
		Yes = "はい",
		No = "いいえ",
		On = "ON",
		Off = "OFF",
		Run = "実行",

		FixLag = "Fix Lag",
		FixLagDesc = "不要なクライアントエフェクトを減らします。",

		Fly = "Fly",
		FlyDesc = "キーボードまたはモバイルで飛行します。",

		InfiniteJump = "無限ジャンプ",
		InfiniteJumpDesc = "空中で連続ジャンプできます。",

		JumpBoost = "ジャンプ強化",
		JumpBoostDesc = "ジャンプ力を上げます。",

		SpeedBoost = "スピード強化",
		SpeedBoostDesc = "移動速度を上げます。",

		FlyCam = "FlyCam",
		FlyCamDesc = "カメラを自由に操作します。",

		Fullbright = "Fullbright",
		FullbrightDesc = "環境を明るくします。",

		Noclip = "Noclip",
		NoclipDesc = "オブジェクトを通り抜けます。",

		FPS = "FPS",
		FPSDesc = "現在のFPSを表示します。",

		Ping = "Ping",
		PingDesc = "現在のPingを表示します。",

		SpeedValue = "速度",
		JumpValue = "ジャンプ力",
		FlyValue = "Fly速度",

		Monitor = "モニター",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "モバイル操作",

		Saved = "ON",
		Disabled = "OFF",
	},

	ko = {
		Name = "한국어",

		Title = "GT_WIBUVN MENU",
		Subtitle = "유니버설 플레이어 컨트롤",
		Features = "기능",
		Settings = "설정",
		Language = "언어",
		Credit = "크레딧",
		Close = "닫기",
		Open = "GUI 열기",
		Delete = "GUI 삭제",
		ConfirmTitle = "확인",
		ConfirmDelete = "GUI를 삭제하시겠습니까?",
		Yes = "예",
		No = "아니요",
		On = "켜짐",
		Off = "꺼짐",
		Run = "실행",

		FixLag = "Fix Lag",
		FixLagDesc = "불필요한 클라이언트 효과를 줄입니다.",

		Fly = "Fly",
		FlyDesc = "키보드 또는 모바일로 비행합니다.",

		InfiniteJump = "무한 점프",
		InfiniteJumpDesc = "공중에서 계속 점프할 수 있습니다.",

		JumpBoost = "점프 강화",
		JumpBoostDesc = "점프력을 증가시킵니다.",

		SpeedBoost = "속도 강화",
		SpeedBoostDesc = "이동 속도를 증가시킵니다.",

		FlyCam = "FlyCam",
		FlyCamDesc = "카메라를 자유롭게 조작합니다.",

		Fullbright = "Fullbright",
		FullbrightDesc = "환경을 밝게 합니다.",

		Noclip = "Noclip",
		NoclipDesc = "물체를 통과할 수 있습니다.",

		FPS = "FPS",
		FPSDesc = "현재 FPS를 표시합니다.",

		Ping = "Ping",
		PingDesc = "현재 Ping을 표시합니다.",

		SpeedValue = "속도",
		JumpValue = "점프",
		FlyValue = "Fly 속도",

		Monitor = "모니터",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "모바일 컨트롤",

		Saved = "켜짐",
		Disabled = "꺼짐",
	},

	fr = {
		Name = "Français",

		Title = "GT_WIBUVN MENU",
		Subtitle = "Contrôle Universel",
		Features = "FONCTIONS",
		Settings = "PARAMÈTRES",
		Language = "Langue",
		Credit = "Crédit",
		Close = "Fermer",
		Open = "Ouvrir GUI",
		Delete = "Supprimer GUI",
		ConfirmTitle = "Confirmation",
		ConfirmDelete = "Voulez-vous vraiment supprimer la GUI ?",
		Yes = "Oui",
		No = "Non",
		On = "ACTIVÉ",
		Off = "DÉSACTIVÉ",
		Run = "EXÉCUTER",

		FixLag = "Fix Lag",
		FixLagDesc = "Réduit les effets client inutiles.",

		Fly = "Vol",
		FlyDesc = "Permet de voler avec le clavier ou mobile.",

		InfiniteJump = "Saut Infini",
		InfiniteJumpDesc = "Permet de sauter continuellement dans les airs.",

		JumpBoost = "Boost Saut",
		JumpBoostDesc = "Augmente la puissance du saut.",

		SpeedBoost = "Boost Vitesse",
		SpeedBoostDesc = "Augmente la vitesse du personnage.",

		FlyCam = "FlyCam",
		FlyCamDesc = "Contrôle librement la caméra.",

		Fullbright = "Fullbright",
		FullbrightDesc = "Augmente la luminosité.",

		Noclip = "Noclip",
		NoclipDesc = "Permet de traverser les objets.",

		FPS = "FPS",
		FPSDesc = "Affiche les FPS actuels.",

		Ping = "Ping",
		PingDesc = "Affiche le ping actuel.",

		SpeedValue = "Vitesse",
		JumpValue = "Saut",
		FlyValue = "Vitesse Fly",

		Monitor = "MONITEUR",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "Contrôles Mobile",

		Saved = "Activé",
		Disabled = "Désactivé",
	},

	de = {
		Name = "Deutsch",

		Title = "GT_WIBUVN MENU",
		Subtitle = "Universelle Spielersteuerung",
		Features = "FUNKTIONEN",
		Settings = "EINSTELLUNGEN",
		Language = "Sprache",
		Credit = "Credits",
		Close = "Schließen",
		Open = "GUI öffnen",
		Delete = "GUI löschen",
		ConfirmTitle = "Bestätigung",
		ConfirmDelete = "Möchtest du die GUI wirklich löschen?",
		Yes = "Ja",
		No = "Nein",
		On = "AN",
		Off = "AUS",
		Run = "AUSFÜHREN",

		FixLag = "Fix Lag",
		FixLagDesc = "Reduziert unnötige Client-Effekte.",

		Fly = "Fliegen",
		FlyDesc = "Fliege mit Tastatur oder Mobilsteuerung.",

		InfiniteJump = "Unendlich Sprung",
		InfiniteJumpDesc = "Erlaubt kontinuierliches Springen in der Luft.",

		JumpBoost = "Sprung Boost",
		JumpBoostDesc = "Erhöht die Sprungkraft.",

		SpeedBoost = "Geschwindigkeits Boost",
		SpeedBoostDesc = "Erhöht die Bewegungsgeschwindigkeit.",

		FlyCam = "FlyCam",
		FlyCamDesc = "Steuert die Kamera frei.",

		Fullbright = "Fullbright",
		FullbrightDesc = "Erhöht die Umgebungshelligkeit.",

		Noclip = "Noclip",
		NoclipDesc = "Ermöglicht das Durchgehen von Objekten.",

		FPS = "FPS",
		FPSDesc = "Zeigt aktuelle FPS.",

		Ping = "Ping",
		PingDesc = "Zeigt aktuellen Ping.",

		SpeedValue = "Geschwindigkeit",
		JumpValue = "Sprungkraft",
		FlyValue = "Fly Geschwindigkeit",

		Monitor = "MONITOR",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "Mobile Steuerung",

		Saved = "Aktiv",
		Disabled = "Deaktiviert",
	},

	tr = {
		Name = "Türkçe",

		Title = "GT_WIBUVN MENU",
		Subtitle = "Evrensel Oyuncu Kontrolü",
		Features = "ÖZELLİKLER",
		Settings = "AYARLAR",
		Language = "Dil",
		Credit = "Kredi",
		Close = "Kapat",
		Open = "GUI Aç",
		Delete = "GUI Sil",
		ConfirmTitle = "Onay",
		ConfirmDelete = "GUI'yi silmek istediğinizden emin misiniz?",
		Yes = "Evet",
		No = "Hayır",
		On = "AÇIK",
		Off = "KAPALI",
		Run = "ÇALIŞTIR",

		FixLag = "Fix Lag",
		FixLagDesc = "Gereksiz istemci efektlerini azaltır.",

		Fly = "Uçuş",
		FlyDesc = "Klavye veya mobil kontrollerle uçun.",

		InfiniteJump = "Sonsuz Zıplama",
		InfiniteJumpDesc = "Havada sürekli zıplamanızı sağlar.",

		JumpBoost = "Zıplama Gücü",
		JumpBoostDesc = "Zıplama gücünü artırır.",

		SpeedBoost = "Hız Gücü",
		SpeedBoostDesc = "Karakter hareket hızını artırır.",

		FlyCam = "FlyCam",
		FlyCamDesc = "Kamerayı özgürce kontrol eder.",

		Fullbright = "Fullbright",
		FullbrightDesc = "Çevreyi aydınlatır.",

		Noclip = "Noclip",
		NoclipDesc = "Objelerin içinden geçmenizi sağlar.",

		FPS = "FPS",
		FPSDesc = "Mevcut FPS'i gösterir.",

		Ping = "Ping",
		PingDesc = "Mevcut Ping'i gösterir.",

		SpeedValue = "Hız",
		JumpValue = "Zıplama",
		FlyValue = "Fly Hızı",

		Monitor = "MONİTÖR",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "Mobil Kontroller",

		Saved = "Açık",
		Disabled = "Kapalı",
	},

	th = {
		Name = "ไทย",

		Title = "GT_WIBUVN MENU",
		Subtitle = "การควบคุมผู้เล่น",
		Features = "ฟังก์ชัน",
		Settings = "ตั้งค่า",
		Language = "ภาษา",
		Credit = "เครดิต",
		Close = "ปิด",
		Open = "เปิด GUI",
		Delete = "ลบ GUI",
		ConfirmTitle = "ยืนยัน",
		ConfirmDelete = "คุณแน่ใจหรือไม่ว่าต้องการลบ GUI?",
		Yes = "ใช่",
		No = "ไม่",
		On = "เปิด",
		Off = "ปิด",
		Run = "เรียกใช้",

		FixLag = "Fix Lag",
		FixLagDesc = "ลดเอฟเฟกต์ที่ไม่จำเป็นของไคลเอนต์",

		Fly = "บิน",
		FlyDesc = "บินด้วยคีย์บอร์ดหรือมือถือ",

		InfiniteJump = "กระโดดไม่จำกัด",
		InfiniteJumpDesc = "กระโดดกลางอากาศได้ต่อเนื่อง",

		JumpBoost = "เพิ่มพลังการกระโดด",
		JumpBoostDesc = "เพิ่มพลังการกระโดด",

		SpeedBoost = "เพิ่มความเร็ว",
		SpeedBoostDesc = "เพิ่มความเร็วการเคลื่อนที่",

		FlyCam = "FlyCam",
		FlyCamDesc = "ควบคุมกล้องได้อย่างอิสระ",

		Fullbright = "Fullbright",
		FullbrightDesc = "เพิ่มความสว่างของสภาพแวดล้อม",

		Noclip = "Noclip",
		NoclipDesc = "เดินทะลุวัตถุ",

		FPS = "FPS",
		FPSDesc = "แสดง FPS ปัจจุบัน",

		Ping = "Ping",
		PingDesc = "แสดง Ping ปัจจุบัน",

		SpeedValue = "ความเร็ว",
		JumpValue = "พลังการกระโดด",
		FlyValue = "ความเร็ว Fly",

		Monitor = "มอนิเตอร์",
		FPSLabel = "FPS",
		PingLabel = "Ping",

		Mobile = "ควบคุมมือถือ",

		Saved = "เปิด",
		Disabled = "ปิด",
	},
}

local function T(key)
	local lang = Languages[State.Language] or Languages.vi
	return lang[key] or Languages.vi[key] or key
end

----------------------------------------------------------------
-- UI HELPERS
----------------------------------------------------------------

local function Create(className, properties, parent)
	local obj = Instance.new(className)

	for property, value in pairs(properties or {}) do
		pcall(function()
			obj[property] = value
		end)
	end

	if parent then
		obj.Parent = parent
	end

	return obj
end

local function Corner(parent, radius)
	return Create("UICorner", {
		CornerRadius = UDim.new(0, radius or 10)
	}, parent)
end

local function Stroke(parent, transparency)
	return Create("UIStroke", {
		Color = Color3.fromRGB(70, 75, 90),
		Transparency = transparency or 0.35,
		Thickness = 1
	}, parent)
end

local function Tween(object, properties, duration)
	TweenService:Create(
		object,
		TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		properties
	):Play()
end

----------------------------------------------------------------
-- MAIN GUI
----------------------------------------------------------------

local ScreenGui = Create("ScreenGui", {
	Name = GUI_NAME,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
}, PlayerGui)

----------------------------------------------------------------
-- OPEN BUTTON
----------------------------------------------------------------

local OpenButton = Create("TextButton", {
	Name = "OpenButton",
	Size = UDim2.fromOffset(54, 54),
	Position = UDim2.new(0, 20, 0.5, -27),
	BackgroundColor3 = Color3.fromRGB(28, 31, 40),
	BorderSizePixel = 0,
	Text = "GT",
	TextColor3 = Color3.fromRGB(255,255,255),
	TextSize = 17,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	Visible = false,
	ZIndex = 100,
}, ScreenGui)

Corner(OpenButton, 16)
Stroke(OpenButton, 0.2)

----------------------------------------------------------------
-- MAIN FRAME
----------------------------------------------------------------

local Main = Create("Frame", {
	Name = "Main",
	Size = UDim2.new(0, 610, 0, 590),
	Position = UDim2.new(0.5, -305, 0.5, -295),
	BackgroundColor3 = Color3.fromRGB(18, 20, 27),
	BorderSizePixel = 0,
	ZIndex = 10,
}, ScreenGui)

Corner(Main, 16)
Stroke(Main, 0.15)

----------------------------------------------------------------
-- SCALE
----------------------------------------------------------------

local UIScale = Create("UIScale", {
	Scale = 1
}, Main)

local function UpdateScale()
	local viewport = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize

	if not viewport then
		return
	end

	if viewport.X < 650 then
		UIScale.Scale = math.clamp(viewport.X / 700, 0.72, 0.95)
	else
		UIScale.Scale = 1
	end
end

Connect(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), UpdateScale)

task.defer(UpdateScale)

----------------------------------------------------------------
-- TOP BAR
----------------------------------------------------------------

local TopBar = Create("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, 70),
	BackgroundColor3 = Color3.fromRGB(24, 27, 36),
	BorderSizePixel = 0,
	ZIndex = 11,
}, Main)

Corner(TopBar, 16)

local Title = Create("TextLabel", {
	Name = "Title",
	Position = UDim2.fromOffset(20, 10),
	Size = UDim2.new(1, -150, 0, 28),
	BackgroundTransparency = 1,
	Text = T("Title"),
	TextColor3 = Color3.fromRGB(245,245,250),
	TextSize = 21,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 12,
}, TopBar)

local Subtitle = Create("TextLabel", {
	Name = "Subtitle",
	Position = UDim2.fromOffset(21, 39),
	Size = UDim2.new(1, -150, 0, 18),
	BackgroundTransparency = 1,
	Text = T("Subtitle") .. " • GT_WIBUVN",
	TextColor3 = Color3.fromRGB(145,150,165),
	TextSize = 11,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 12,
}, TopBar)

local CloseButton = Create("TextButton", {
	Size = UDim2.fromOffset(40, 40),
	Position = UDim2.new(1, -92, 0, 15),
	BackgroundColor3 = Color3.fromRGB(38, 41, 52),
	BorderSizePixel = 0,
	Text = "—",
	TextColor3 = Color3.fromRGB(220,220,225),
	TextSize = 22,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	ZIndex = 12,
}, TopBar)

Corner(CloseButton, 11)

local DeleteButton = Create("TextButton", {
	Size = UDim2.fromOffset(40, 40),
	Position = UDim2.new(1, -46, 0, 15),
	BackgroundColor3 = Color3.fromRGB(45, 30, 34),
	BorderSizePixel = 0,
	Text = "×",
	TextColor3 = Color3.fromRGB(255,120,125),
	TextSize = 24,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	ZIndex = 12,
}, TopBar)

Corner(DeleteButton, 11)

----------------------------------------------------------------
-- CONTENT
----------------------------------------------------------------

local Content = Create("ScrollingFrame", {
	Name = "Content",
	Position = UDim2.fromOffset(10, 80),
	Size = UDim2.new(1, -20, 1, -90),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollBarImageTransparency = 0.3,
	CanvasSize = UDim2.new(0,0,0,0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ZIndex = 11,
}, Main)

Create("UIPadding", {
	PaddingTop = UDim.new(0, 4),
	PaddingBottom = UDim.new(0, 12),
	PaddingLeft = UDim.new(0, 6),
	PaddingRight = UDim.new(0, 6),
}, Content)

Create("UIListLayout", {
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, Content)

----------------------------------------------------------------
-- SECTION TITLE
----------------------------------------------------------------

local function CreateSection(text, order)
	local section = Create("TextLabel", {
		Size = UDim2.new(1, -4, 0, 28),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Color3.fromRGB(125,135,155),
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = order,
		ZIndex = 12,
	}, Content)

	return section
end

----------------------------------------------------------------
-- FEATURE CARD
----------------------------------------------------------------

local FeatureCards = {}

local function CreateFeatureCard(key, order)
	local card = Create("Frame", {
		Name = key .. "Card",
		Size = UDim2.new(1, -4, 0, 72),
		BackgroundColor3 = Color3.fromRGB(25, 28, 37),
		BorderSizePixel = 0,
		LayoutOrder = order,
		ZIndex = 12,
	}, Content)

	Corner(card, 12)
	Stroke(card, 0.55)

	local icon = Create("TextLabel", {
		Size = UDim2.fromOffset(42,42),
		Position = UDim2.fromOffset(12,15),
		BackgroundColor3 = Color3.fromRGB(33,37,48),
		TextColor3 = Color3.fromRGB(220,225,235),
		Text = "●",
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		ZIndex = 13,
	}, card)

	Corner(icon, 12)

	local title = Create("TextLabel", {
		Position = UDim2.fromOffset(65, 10),
		Size = UDim2.new(1, -180, 0, 22),
		BackgroundTransparency = 1,
		Text = T(key),
		TextColor3 = Color3.fromRGB(245,245,248),
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 13,
	}, card)

	local desc = Create("TextLabel", {
		Position = UDim2.fromOffset(65, 33),
		Size = UDim2.new(1, -180, 0, 30),
		BackgroundTransparency = 1,
		Text = T(key .. "Desc"),
		TextColor3 = Color3.fromRGB(145,150,165),
		TextSize = 10,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 13,
	}, card)

	local toggle = Create("TextButton", {
		Size = UDim2.fromOffset(78, 34),
		Position = UDim2.new(1, -92, 0.5, -17),
		BackgroundColor3 = Color3.fromRGB(52, 55, 66),
		BorderSizePixel = 0,
		Text = T("Off"),
		TextColor3 = Color3.fromRGB(255,120,125),
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 13,
	}, card)

	Corner(toggle, 10)

	FeatureCards[key] = {
		Card = card,
		Icon = icon,
		Title = title,
		Desc = desc,
		Toggle = toggle,
	}

	return FeatureCards[key]
end

----------------------------------------------------------------
-- SETTINGS PANEL
----------------------------------------------------------------

local AdjustPanel = Create("Frame", {
	Name = "AdjustPanel",
	Size = UDim2.new(1, -4, 0, 96),
	BackgroundColor3 = Color3.fromRGB(21,24,32),
	BorderSizePixel = 0,
	Visible = false,
	LayoutOrder = 100,
	ZIndex = 13,
}, Content)

Corner(AdjustPanel, 12)
Stroke(AdjustPanel, 0.5)

local AdjustTitle = Create("TextLabel", {
	Position = UDim2.fromOffset(15, 8),
	Size = UDim2.new(1, -30, 0, 20),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = Color3.fromRGB(240,240,245),
	TextSize = 12,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 14,
}, AdjustPanel)

local SliderBack = Create("Frame", {
	Position = UDim2.fromOffset(15, 43),
	Size = UDim2.new(1, -30, 0, 8),
	BackgroundColor3 = Color3.fromRGB(45,49,60),
	BorderSizePixel = 0,
	ZIndex = 14,
}, AdjustPanel)

Corner(SliderBack, 8)

local SliderFill = Create("Frame", {
	Size = UDim2.new(0.3, 0, 1, 0),
	BackgroundColor3 = Color3.fromRGB(95,135,255),
	BorderSizePixel = 0,
	ZIndex = 15,
}, SliderBack)

Corner(SliderFill, 8)

local SliderButton = Create("TextButton", {
	Size = UDim2.fromOffset(22,22),
	Position = UDim2.new(0.3,-11,0.5,-11),
	BackgroundColor3 = Color3.fromRGB(240,242,248),
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
	ZIndex = 16,
}, SliderBack)

Corner(SliderButton, 50)

local SliderValue = Create("TextLabel", {
	Position = UDim2.new(1, -90, 0, 8),
	Size = UDim2.fromOffset(75,22),
	BackgroundTransparency = 1,
	Text = "50",
	TextColor3 = Color3.fromRGB(120,160,255),
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Right,
	ZIndex = 15,
}, AdjustPanel)

----------------------------------------------------------------
-- LANGUAGE PANEL
----------------------------------------------------------------

local LanguagePanel = Create("Frame", {
	Name = "LanguagePanel",
	Size = UDim2.new(1, -4, 0, 140),
	BackgroundColor3 = Color3.fromRGB(21,24,32),
	BorderSizePixel = 0,
	LayoutOrder = 102,
	ZIndex = 13,
}, Content)

Corner(LanguagePanel, 12)
Stroke(LanguagePanel, 0.5)

local LanguageTitle = Create("TextLabel", {
	Position = UDim2.fromOffset(15, 9),
	Size = UDim2.new(1, -30, 0, 20),
	BackgroundTransparency = 1,
	Text = T("Language"),
	TextColor3 = Color3.fromRGB(240,240,245),
	TextSize = 12,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 14,
}, LanguagePanel)

local LanguageGrid = Create("Frame", {
	Position = UDim2.fromOffset(12, 35),
	Size = UDim2.new(1, -24, 1, -45),
	BackgroundTransparency = 1,
	ZIndex = 14,
}, LanguagePanel)

Create("UIGridLayout", {
	CellSize = UDim2.new(0.25, -6, 0, 34),
	CellPadding = UDim2.fromOffset(7,7),
}, LanguageGrid)

local LanguageButtons = {}

for languageId, language in pairs(Languages) do
	local button = Create("TextButton", {
		Name = languageId,
		BackgroundColor3 = languageId == State.Language
			and Color3.fromRGB(55,70,110)
			or Color3.fromRGB(31,35,45),
		BorderSizePixel = 0,
		Text = language.Name,
		TextColor3 = Color3.fromRGB(225,228,235),
		TextSize = 10,
		Font = Enum.Font.GothamMedium,
		AutoButtonColor = false,
		ZIndex = 15,
	}, LanguageGrid)

	Corner(button, 8)

	LanguageButtons[languageId] = button
end

----------------------------------------------------------------
-- CREDIT
----------------------------------------------------------------

local CreditCard = Create("Frame", {
	Name = "Credit",
	Size = UDim2.new(1, -4, 0, 56),
	BackgroundColor3 = Color3.fromRGB(25,28,37),
	BorderSizePixel = 0,
	LayoutOrder = 103,
	ZIndex = 12,
}, Content)

Corner(CreditCard, 12)
Stroke(CreditCard, 0.55)

local CreditText = Create("TextLabel", {
	Position = UDim2.fromOffset(15,8),
	Size = UDim2.new(1,-30,0,20),
	BackgroundTransparency = 1,
	Text = T("Credit"),
	TextColor3 = Color3.fromRGB(140,148,165),
	TextSize = 10,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 13,
}, CreditCard)

local CreditName = Create("TextLabel", {
	Position = UDim2.fromOffset(15,25),
	Size = UDim2.new(1,-30,0,22),
	BackgroundTransparency = 1,
	Text = "GT_WIBUVN",
	TextColor3 = Color3.fromRGB(105,145,255),
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 13,
}, CreditCard)

----------------------------------------------------------------
-- DELETE CONFIRMATION
----------------------------------------------------------------

local ConfirmOverlay = Create("Frame", {
	Name = "ConfirmOverlay",
	Size = UDim2.fromScale(1,1),
	BackgroundColor3 = Color3.fromRGB(0,0,0),
	BackgroundTransparency = 0.4,
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 200,
}, ScreenGui)

local ConfirmBox = Create("Frame", {
	Size = UDim2.fromOffset(390,190),
	Position = UDim2.new(0.5,-195,0.5,-95),
	BackgroundColor3 = Color3.fromRGB(22,25,33),
	BorderSizePixel = 0,
	ZIndex = 201,
}, ConfirmOverlay)

Corner(ConfirmBox, 15)
Stroke(ConfirmBox, 0.2)

local ConfirmTitleLabel = Create("TextLabel", {
	Position = UDim2.fromOffset(20,18),
	Size = UDim2.new(1,-40,0,25),
	BackgroundTransparency = 1,
	Text = T("ConfirmTitle"),
	TextColor3 = Color3.fromRGB(245,245,250),
	TextSize = 17,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 202,
}, ConfirmBox)

local ConfirmDescription = Create("TextLabel", {
	Position = UDim2.fromOffset(20,52),
	Size = UDim2.new(1,-40,0,55),
	BackgroundTransparency = 1,
	Text = T("ConfirmDelete"),
	TextColor3 = Color3.fromRGB(165,170,185),
	TextSize = 12,
	Font = Enum.Font.Gotham,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	ZIndex = 202,
}, ConfirmBox)

local ConfirmYes = Create("TextButton", {
	Position = UDim2.new(1,-180,1,-58),
	Size = UDim2.fromOffset(75,38),
	BackgroundColor3 = Color3.fromRGB(50,120,75),
	BorderSizePixel = 0,
	Text = T("Yes"),
	TextColor3 = Color3.fromRGB(235,255,240),
	TextSize = 12,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	ZIndex = 202,
}, ConfirmBox)

Corner(ConfirmYes, 10)

local ConfirmNo = Create("TextButton", {
	Position = UDim2.new(1,-92,1,-58),
	Size = UDim2.fromOffset(75,38),
	BackgroundColor3 = Color3.fromRGB(45,48,58),
	BorderSizePixel = 0,
	Text = T("No"),
	TextColor3 = Color3.fromRGB(235,235,240),
	TextSize = 12,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	ZIndex = 202,
}, ConfirmBox)

Corner(ConfirmNo, 10)

----------------------------------------------------------------
-- MONITOR
----------------------------------------------------------------

local Monitor = Create("Frame", {
	Name = "PerformanceMonitor",
	Size = UDim2.fromOffset(190,105),
	Position = UDim2.new(1,-210,0,20),
	BackgroundColor3 = Color3.fromRGB(18,21,28),
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 80,
}, ScreenGui)

Corner(Monitor, 12)
Stroke(Monitor, 0.25)

local MonitorTitle = Create("TextLabel", {
	Position = UDim2.fromOffset(12,7),
	Size = UDim2.new(1,-24,0,18),
	BackgroundTransparency = 1,
	Text = T("Monitor"),
	TextColor3 = Color3.fromRGB(150,160,180),
	TextSize = 10,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 81,
}, Monitor)

local FPSText = Create("TextLabel", {
	Position = UDim2.fromOffset(12,31),
	Size = UDim2.new(1,-24,0,25),
	BackgroundTransparency = 1,
	Text = "FPS: --",
	TextColor3 = Color3.fromRGB(100,220,150),
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 81,
}, Monitor)

local PingText = Create("TextLabel", {
	Position = UDim2.fromOffset(12,62),
	Size = UDim2.new(1,-24,0,25),
	BackgroundTransparency = 1,
	Text = "Ping: --",
	TextColor3 = Color3.fromRGB(110,175,255),
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 81,
}, Monitor)

----------------------------------------------------------------
-- DRAG FUNCTION
----------------------------------------------------------------

local function MakeDraggable(object, handle)
	local dragging = false
	local dragStart
	local startPosition

	Connect(handle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPosition = object.Position

			local ended
			ended = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					ended:Disconnect()
				end
			end)
		end
	end)

	Connect(UserInputService.InputChanged, function(input)
		if not dragging then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart

		object.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)
end

MakeDraggable(Main, TopBar)
MakeDraggable(Monitor, Monitor)
MakeDraggable(OpenButton, OpenButton)

----------------------------------------------------------------
-- CHARACTER HELPERS
----------------------------------------------------------------

local Character
local Humanoid
local Root

local OriginalWalkSpeed = DEFAULT_WALK_SPEED
local OriginalJumpPower = DEFAULT_JUMP_POWER
local OriginalJumpHeight = 7.2

local function GetCharacter()
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

	Humanoid = Character:FindFirstChildOfClass("Humanoid")
	Root = Character:FindFirstChild("HumanoidRootPart")

	return Character, Humanoid, Root
end

GetCharacter()

----------------------------------------------------------------
-- RESET CHARACTER
----------------------------------------------------------------

local function RestoreMovement()
	GetCharacter()

	if Humanoid then
		Humanoid.WalkSpeed = OriginalWalkSpeed

		if Humanoid.UseJumpPower then
			Humanoid.JumpPower = OriginalJumpPower
		else
			Humanoid.JumpHeight = OriginalJumpHeight
		end
	end
end

Connect(LocalPlayer.CharacterAdded, function()
	task.wait(0.3)

	GetCharacter()

	if Humanoid then
		OriginalWalkSpeed = Humanoid.WalkSpeed
		OriginalJumpPower = Humanoid.JumpPower
		OriginalJumpHeight = Humanoid.JumpHeight
	end

	if State.SpeedBoost then
		Humanoid.WalkSpeed = State.Speed
	end

	if State.JumpBoost then
		if Humanoid.UseJumpPower then
			Humanoid.JumpPower = State.Jump
		else
			Humanoid.JumpHeight = math.clamp(State.Jump / 10, 5, 20)
		end
	end
end)

if Humanoid then
	OriginalWalkSpeed = Humanoid.WalkSpeed
	OriginalJumpPower = Humanoid.JumpPower
	OriginalJumpHeight = Humanoid.JumpHeight
end

----------------------------------------------------------------
-- FIX LAG
----------------------------------------------------------------

local OriginalEffects = {}

local function SetEffectsEnabled(enabled)
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter")
			or obj:IsA("Trail")
			or obj:IsA("Beam")
			or obj:IsA("Smoke")
			or obj:IsA("Fire")
			or obj:IsA("Sparkles") then

			if enabled then
				if OriginalEffects[obj] == nil then
					OriginalEffects[obj] = obj.Enabled
				end

				pcall(function()
					obj.Enabled = false
				end)
			else
				if OriginalEffects[obj] ~= nil then
					pcall(function()
						obj.Enabled = OriginalEffects[obj]
					end)
				end
			end
		end
	end

	if enabled then
		for _, obj in ipairs(Lighting:GetChildren()) do
			if obj:IsA("PostEffect") then
				if OriginalEffects[obj] == nil then
					OriginalEffects[obj] = obj.Enabled
				end

				pcall(function()
					obj.Enabled = false
				end)
			end
		end
	else
		for obj, value in pairs(OriginalEffects) do
			if obj and obj.Parent then
				pcall(function()
					obj.Enabled = value
				end)
			end
		end
	end
end

----------------------------------------------------------------
-- FULLBRIGHT
----------------------------------------------------------------

local OriginalLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
}

local function SetFullbright(enabled)
	if enabled then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.fromRGB(255,255,255)
		Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
	else
		Lighting.Brightness = OriginalLighting.Brightness
		Lighting.ClockTime = OriginalLighting.ClockTime
		Lighting.FogEnd = OriginalLighting.FogEnd
		Lighting.GlobalShadows = OriginalLighting.GlobalShadows
		Lighting.Ambient = OriginalLighting.Ambient
		Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
	end
end

----------------------------------------------------------------
-- NOCLIP
----------------------------------------------------------------

local function SetNoclip(enabled)
	if not Character then
		return
	end

	for _, obj in ipairs(Character:GetDescendants()) do
		if obj:IsA("BasePart") then
			pcall(function()
				obj.CanCollide = not enabled
			end)
		end
	end
end

----------------------------------------------------------------
-- SPEED BOOST
----------------------------------------------------------------

local function ApplySpeed()
	GetCharacter()

	if not Humanoid then
		return
	end

	if State.SpeedBoost then
		Humanoid.WalkSpeed = State.Speed
	else
		Humanoid.WalkSpeed = OriginalWalkSpeed
	end
end

----------------------------------------------------------------
-- JUMP BOOST
----------------------------------------------------------------

local function ApplyJump()
	GetCharacter()

	if not Humanoid then
		return
	end

	if State.JumpBoost then
		if Humanoid.UseJumpPower then
			Humanoid.JumpPower = State.Jump
		else
			Humanoid.JumpHeight = math.clamp(State.Jump / 10, 5, 20)
		end
	else
		if Humanoid.UseJumpPower then
			Humanoid.JumpPower = OriginalJumpPower
		else
			Humanoid.JumpHeight = OriginalJumpHeight
		end
	end
end

----------------------------------------------------------------
-- FLY
----------------------------------------------------------------

local FlyVelocity
local FlyGyro

local FlyKeys = {
	W = false,
	A = false,
	S = false,
	D = false,
	Up = false,
	Down = false,
}

local function StopFly()
	if FlyVelocity then
		FlyVelocity:Destroy()
		FlyVelocity = nil
	end

	if FlyGyro then
		FlyGyro:Destroy()
		FlyGyro = nil
	end

	GetCharacter()

	if Humanoid then
		Humanoid.AutoRotate = true
	end

	for key in pairs(FlyKeys) do
		FlyKeys[key] = false
	end
end

local function StartFly()
	GetCharacter()

	if not Root or not Humanoid then
		return
	end

	FlyVelocity = Instance.new("BodyVelocity")
	FlyVelocity.Name = "GT_WIBUVN_FlyVelocity"
	FlyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	FlyVelocity.P = 10000
	FlyVelocity.Velocity = Vector3.zero
	FlyVelocity.Parent = Root

	FlyGyro = Instance.new("BodyGyro")
	FlyGyro.Name = "GT_WIBUVN_FlyGyro"
	FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	FlyGyro.P = 10000
	FlyGyro.CFrame = Root.CFrame
	FlyGyro.Parent = Root

	Humanoid.AutoRotate = false
end

----------------------------------------------------------------
-- MOBILE FLY CONTROL
----------------------------------------------------------------

local MobileFly = Create("Frame", {
	Name = "MobileFly",
	Size = UDim2.fromOffset(210,155),
	Position = UDim2.new(0,18,1,-175),
	BackgroundTransparency = 1,
	Visible = false,
	ZIndex = 90,
}, ScreenGui)

local function MobileButton(name, text, pos, size)
	local b = Create("TextButton", {
		Name = name,
		Size = size or UDim2.fromOffset(52,52),
		Position = pos,
		BackgroundColor3 = Color3.fromRGB(25,29,38),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = Color3.fromRGB(235,238,245),
		TextSize = 17,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 91,
	}, MobileFly)

	Corner(b, 14)
	Stroke(b, 0.3)

	return b
end

local BtnUp = MobileButton(
	"Up",
	"↑",
	UDim2.fromOffset(79,0)
)

local BtnLeft = MobileButton(
	"Left",
	"←",
	UDim2.fromOffset(22,55)
)

local BtnDown = MobileButton(
	"Down",
	"↓",
	UDim2.fromOffset(79,55)
)

local BtnRight = MobileButton(
	"Right",
	"→",
	UDim2.fromOffset(136,55)
)

local BtnVerticalDown = MobileButton(
	"VerticalDown",
	"▼",
	UDim2.fromOffset(79,110)
)

local function BindMobileButton(button, key)
	Connect(button.MouseButton1Down, function()
		FlyKeys[key] = true
	end)

	Connect(button.MouseButton1Up, function()
		FlyKeys[key] = false
	end)

	Connect(button.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			FlyKeys[key] = true
		end
	end)

	Connect(button.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			FlyKeys[key] = false
		end
	end)
end

BindMobileButton(BtnUp, "W")
BindMobileButton(BtnLeft, "A")
BindMobileButton(BtnDown, "S")
BindMobileButton(BtnRight, "D")
BindMobileButton(BtnVerticalDown, "Down")

----------------------------------------------------------------
-- FLY UPDATE
----------------------------------------------------------------

Connect(RunService.Heartbeat, function()
	if State.Fly and FlyVelocity and Root then

		local camera = Workspace.CurrentCamera

		if not camera then
			return
		end

		local direction = Vector3.zero

		if FlyKeys.W then
			direction += camera.CFrame.LookVector
		end

		if FlyKeys.S then
			direction -= camera.CFrame.LookVector
		end

		if FlyKeys.A then
			direction -= camera.CFrame.RightVector
		end

		if FlyKeys.D then
			direction += camera.CFrame.RightVector
		end

		if FlyKeys.Up then
			direction += Vector3.new(0,1,0)
		end

		if FlyKeys.Down then
			direction -= Vector3.new(0,1,0)
		end

		if direction.Magnitude > 0 then
			direction = direction.Unit * State.FlySpeed
		end

		FlyVelocity.Velocity = direction

		if FlyGyro then
			FlyGyro.CFrame = CFrame.lookAt(
				Root.Position,
				Root.Position + camera.CFrame.LookVector
			)
		end
	end
end)

----------------------------------------------------------------
-- KEYBOARD FLY
----------------------------------------------------------------

local KeyMap = {
	[Enum.KeyCode.W] = "W",
	[Enum.KeyCode.A] = "A",
	[Enum.KeyCode.S] = "S",
	[Enum.KeyCode.D] = "D",
	[Enum.KeyCode.Space] = "Up",
	[Enum.KeyCode.LeftControl] = "Down",
}

Connect(UserInputService.InputBegan, function(input, processed)
	if processed then
		return
	end

	local key = KeyMap[input.KeyCode]

	if key then
		FlyKeys[key] = true
	end
end)

Connect(UserInputService.InputEnded, function(input)
	local key = KeyMap[input.KeyCode]

	if key then
		FlyKeys[key] = false
	end
end)

----------------------------------------------------------------
-- INFINITE JUMP
----------------------------------------------------------------

Connect(UserInputService.JumpRequest, function()
	if not State.InfiniteJump then
		return
	end

	GetCharacter()

	if Humanoid then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

----------------------------------------------------------------
-- FLYCAM
----------------------------------------------------------------

local Camera = Workspace.CurrentCamera

local FreecamPosition
local FreecamRotation = Vector2.zero

local FreecamKeys = {
	W = false,
	A = false,
	S = false,
	D = false,
	Q = false,
	E = false,
}

local FreecamConnection

local function StopFlyCam()
	State.FlyCam = false

	if FreecamConnection then
		FreecamConnection:Disconnect()
		FreecamConnection = nil
	end

	Camera = Workspace.CurrentCamera

	if Camera then
		Camera.CameraType = Enum.CameraType.Custom

		GetCharacter()

		if Humanoid then
			Camera.CameraSubject = Humanoid
		end
	end

	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	UserInputService.MouseIconEnabled = true
end

local function StartFlyCam()
	if State.Fly then
		State.Fly = false
		StopFly()
	end

	Camera = Workspace.CurrentCamera

	if not Camera then
		return
	end

	FreecamPosition = Camera.CFrame.Position

	local x, y, z = Camera.CFrame:ToOrientation()
	FreecamRotation = Vector2.new(x, y)

	Camera.CameraType = Enum.CameraType.Scriptable

	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	UserInputService.MouseIconEnabled = true

	FreecamConnection = RunService.RenderStepped:Connect(function(dt)
		if not State.FlyCam then
			return
		end

		Camera = Workspace.CurrentCamera

		if not Camera then
			return
		end

		local rotation = CFrame.fromOrientation(
			FreecamRotation.X,
			FreecamRotation.Y,
			0
		)

		local movement = Vector3.zero

		if FreecamKeys.W then
			movement += rotation.LookVector
		end

		if FreecamKeys.S then
			movement -= rotation.LookVector
		end

		if FreecamKeys.A then
			movement -= rotation.RightVector
		end

		if FreecamKeys.D then
			movement += rotation.RightVector
		end

		if FreecamKeys.E then
			movement += Vector3.new(0,1,0)
		end

		if FreecamKeys.Q then
			movement -= Vector3.new(0,1,0)
		end

		if movement.Magnitude > 0 then
			movement = movement.Unit * State.FlySpeed * dt
			FreecamPosition += movement
		end

		Camera.CFrame =
			CFrame.new(FreecamPosition)
			* CFrame.fromOrientation(
				FreecamRotation.X,
				FreecamRotation.Y,
				0
			)
	end)
end

Connect(UserInputService.InputChanged, function(input)
	if not State.FlyCam then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Delta

		FreecamRotation += Vector2.new(
			-delta.Y * 0.0025,
			-delta.X * 0.0025
		)

		FreecamRotation = Vector2.new(
			math.clamp(FreecamRotation.X, -1.45, 1.45),
			FreecamRotation.Y
		)
	end
end)

Connect(UserInputService.InputBegan, function(input, processed)
	if processed then
		return
	end

	if not State.FlyCam then
		return
	end

	local map = {
		[Enum.KeyCode.W] = "W",
		[Enum.KeyCode.A] = "A",
		[Enum.KeyCode.S] = "S",
		[Enum.KeyCode.D] = "D",
		[Enum.KeyCode.Q] = "Q",
		[Enum.KeyCode.E] = "E",
	}

	local key = map[input.KeyCode]

	if key then
		FreecamKeys[key] = true
	end
end)

Connect(UserInputService.InputEnded, function(input)
	local map = {
		[Enum.KeyCode.W] = "W",
		[Enum.KeyCode.A] = "A",
		[Enum.KeyCode.S] = "S",
		[Enum.KeyCode.D] = "D",
		[Enum.KeyCode.Q] = "Q",
		[Enum.KeyCode.E] = "E",
	}

	local key = map[input.KeyCode]

	if key then
		FreecamKeys[key] = false
	end
end)

----------------------------------------------------------------
-- FPS
----------------------------------------------------------------

local FPS = 60
local FrameCount = 0
local LastFPSUpdate = os.clock()

Connect(RunService.RenderStepped, function()
	FrameCount += 1

	local now = os.clock()

	if now - LastFPSUpdate >= 0.5 then
		FPS = math.floor(FrameCount / (now - LastFPSUpdate) + 0.5)

		FrameCount = 0
		LastFPSUpdate = now
	end
end)

----------------------------------------------------------------
-- PING
----------------------------------------------------------------

local function GetPing()
	local ping = nil

	pcall(function()
		local network = Stats:FindFirstChild("Network")

		if network then
			local serverStats = network:FindFirstChild("ServerStatsItem")

			if serverStats then
				local dataPing = serverStats:FindFirstChild("Data Ping")

				if dataPing then
					ping = dataPing:GetValue()
				end
			end
		end
	end)

	return ping
end

----------------------------------------------------------------
-- MONITOR UPDATE
----------------------------------------------------------------

Connect(RunService.RenderStepped, function()
	if not State.FPS and not State.Ping then
		Monitor.Visible = false
		return
	end

	Monitor.Visible = true

	FPSText.Visible = State.FPS
	PingText.Visible = State.Ping

	if State.FPS then
		FPSText.Text = T("FPSLabel") .. ": " .. tostring(FPS)
	end

	if State.Ping then
		local ping = GetPing()

		if ping then
			PingText.Text = T("PingLabel") .. ": " .. math.floor(ping) .. " ms"
		else
			PingText.Text = T("PingLabel") .. ": --"
		end
	end

	if State.FPS and State.Ping then
		FPSText.Position = UDim2.fromOffset(12,31)
		PingText.Position = UDim2.fromOffset(12,62)
	elseif State.FPS then
		FPSText.Position = UDim2.fromOffset(12,42)
	elseif State.Ping then
		PingText.Position = UDim2.fromOffset(12,42)
	end
end)

----------------------------------------------------------------
-- MOBILE FLYCAM BUTTONS
----------------------------------------------------------------

local MobileCam = Create("Frame", {
	Name = "MobileCam",
	Size = UDim2.fromOffset(185,125),
	Position = UDim2.new(1,-205,1,-145),
	BackgroundTransparency = 1,
	Visible = false,
	ZIndex = 90,
}, ScreenGui)

local CamForward = MobileButton(
	"CamForward",
	"▲",
	UDim2.fromOffset(66,0)
)

CamForward.Parent = MobileCam

local CamLeft = MobileButton(
	"CamLeft",
	"◀",
	UDim2.fromOffset(10,50)
)

CamLeft.Parent = MobileCam

local CamBackward = MobileButton(
	"CamBackward",
	"▼",
	UDim2.fromOffset(66,50)
)

CamBackward.Parent = MobileCam

local CamRight = MobileButton(
	"CamRight",
	"▶",
	UDim2.fromOffset(122,50)
)

CamRight.Parent = MobileCam

local CamUp = MobileButton(
	"CamUp",
	"+",
	UDim2.fromOffset(10,0)
)

CamUp.Parent = MobileCam

local CamDown = MobileButton(
	"CamDown",
	"−",
	UDim2.fromOffset(122,0)
)

CamDown.Parent = MobileCam

local function BindCamButton(button, key)
	Connect(button.MouseButton1Down, function()
		FreecamKeys[key] = true
	end)

	Connect(button.MouseButton1Up, function()
		FreecamKeys[key] = false
	end)

	Connect(button.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			FreecamKeys[key] = true
		end
	end)

	Connect(button.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			FreecamKeys[key] = false
		end
	end)
end

BindCamButton(CamForward, "W")
BindCamButton(CamLeft, "A")
BindCamButton(CamBackward, "S")
BindCamButton(CamRight, "D")
BindCamButton(CamUp, "E")
BindCamButton(CamDown, "Q")

----------------------------------------------------------------
-- ADJUST SLIDER
----------------------------------------------------------------

local AdjustMode = nil
local SliderDragging = false

local function UpdateSlider(value)
	if AdjustMode == "Speed" then
		State.Speed = math.floor(value)
		SliderValue.Text = tostring(State.Speed)
		AdjustTitle.Text = T("SpeedValue") .. ": " .. State.Speed

		SliderFill.Size = UDim2.new(
			(State.Speed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED),
			0,
			1,
			0
		)

		SliderButton.Position = UDim2.new(
			(State.Speed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED),
			-11,
			0.5,
			-11
		)

		ApplySpeed()

	elseif AdjustMode == "Jump" then
		State.Jump = math.floor(value)
		SliderValue.Text = tostring(State.Jump)
		AdjustTitle.Text = T("JumpValue") .. ": " .. State.Jump

		SliderFill.Size = UDim2.new(
			(State.Jump - MIN_JUMP) / (MAX_JUMP - MIN_JUMP),
			0,
			1,
			0
		)

		SliderButton.Position = UDim2.new(
			(State.Jump - MIN_JUMP) / (MAX_JUMP - MIN_JUMP),
			-11,
			0.5,
			-11
		)

		ApplyJump()

	elseif AdjustMode == "Fly" then
		State.FlySpeed = math.floor(value)
		SliderValue.Text = tostring(State.FlySpeed)
		AdjustTitle.Text = T("FlyValue") .. ": " .. State.FlySpeed

		SliderFill.Size = UDim2.new(
			(State.FlySpeed - MIN_FLY) / (MAX_FLY - MIN_FLY),
			0,
			1,
			0
		)

		SliderButton.Position = UDim2.new(
			(State.FlySpeed - MIN_FLY) / (MAX_FLY - MIN_FLY),
			-11,
			0.5,
			-11
		)
	end
end

local function SetAdjustMode(mode)
	AdjustMode = mode

	if mode == "Speed" then
		AdjustPanel.Visible = State.SpeedBoost
		AdjustTitle.Text = T("SpeedValue") .. ": " .. State.Speed
		UpdateSlider(State.Speed)

	elseif mode == "Jump" then
		AdjustPanel.Visible = State.JumpBoost
		AdjustTitle.Text = T("JumpValue") .. ": " .. State.Jump
		UpdateSlider(State.Jump)

	elseif mode == "Fly" then
		AdjustPanel.Visible = State.Fly
		AdjustTitle.Text = T("FlyValue") .. ": " .. State.FlySpeed
		UpdateSlider(State.FlySpeed)

	else
		AdjustPanel.Visible = false
	end
end

local function GetSliderValue(x)
	local percent = math.clamp(
		(x - SliderBack.AbsolutePosition.X) /
			SliderBack.AbsoluteSize.X,
		0,
		1
	)

	if AdjustMode == "Speed" then
		return MIN_SPEED + (MAX_SPEED - MIN_SPEED) * percent

	elseif AdjustMode == "Jump" then
		return MIN_JUMP + (MAX_JUMP - MIN_JUMP) * percent

	elseif AdjustMode == "Fly" then
		return MIN_FLY + (MAX_FLY - MIN_FLY) * percent
	end

	return 0
end

Connect(SliderButton.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		SliderDragging = true
	end
end)

Connect(UserInputService.InputEnded, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		SliderDragging = false
	end
end)

Connect(UserInputService.InputChanged, function(input)
	if not SliderDragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local value = GetSliderValue(input.Position.X)

		UpdateSlider(value)
	end
end)

Connect(SliderBack.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		UpdateSlider(GetSliderValue(input.Position.X))
	end
end)

----------------------------------------------------------------
-- UPDATE FEATURE CARD
----------------------------------------------------------------

local function UpdateFeatureCard(key)
	local info = FeatureCards[key]

	if not info then
		return
	end

	info.Title.Text = T(key)
	info.Desc.Text = T(key .. "Desc")

	-- FIX LAG là nút RUN, không phải ON/OFF
	if key == "FixLag" then
		info.Toggle.Text = T("Run")
		info.Toggle.TextColor3 = Color3.fromRGB(225, 240, 255)
		info.Toggle.BackgroundColor3 = Color3.fromRGB(45, 125, 210)
		return
	end

	-- Các tính năng khác vẫn dùng ON/OFF
	if State[key] then
		info.Toggle.Text = T("On")
		info.Toggle.TextColor3 = Color3.fromRGB(110,235,150)
		info.Toggle.BackgroundColor3 = Color3.fromRGB(33,65,47)
	else
		info.Toggle.Text = T("Off")
		info.Toggle.TextColor3 = Color3.fromRGB(255,120,125)
		info.Toggle.BackgroundColor3 = Color3.fromRGB(52,55,66)
	end
end

----------------------------------------------------------------
-- FEATURE TOGGLE
----------------------------------------------------------------

local function ToggleFeature(key, value)
	State[key] = value

	if key == "FixLag" then
		 SetEffectsEnabled(true)
   		 State.FixLag = false

	elseif key == "Fly" then
		if value then
			if State.FlyCam then
				StopFlyCam()
			end

			StartFly()
			MobileFly.Visible = UserInputService.TouchEnabled
			SetAdjustMode("Fly")
		else
			StopFly()
			MobileFly.Visible = false

			if AdjustMode == "Fly" then
				SetAdjustMode(nil)
			end
		end

	elseif key == "InfiniteJump" then
		-- JumpRequest handles this.

	elseif key == "JumpBoost" then
		ApplyJump()

		if value then
			SetAdjustMode("Jump")
		elseif AdjustMode == "Jump" then
			SetAdjustMode(nil)
		end

	elseif key == "SpeedBoost" then
		ApplySpeed()

		if value then
			SetAdjustMode("Speed")
		elseif AdjustMode == "Speed" then
			SetAdjustMode(nil)
		end

	elseif key == "FlyCam" then
		if value then
			if State.Fly then
				State.Fly = false
				StopFly()
				MobileFly.Visible = false
				UpdateFeatureCard("Fly")
			end

			StartFlyCam()
			MobileCam.Visible = UserInputService.TouchEnabled
		else
			StopFlyCam()
			MobileCam.Visible = false
		end

	elseif key == "Fullbright" then
		SetFullbright(value)

	elseif key == "Noclip" then
		SetNoclip(value)

	elseif key == "FPS" then
		-- Monitor automatically updates.

	elseif key == "Ping" then
		-- Monitor automatically updates.
	end

	UpdateFeatureCard(key)
end

----------------------------------------------------------------
-- CREATE FEATURE CARDS
----------------------------------------------------------------

CreateSection(T("Features"), 1)

local FeatureOrder = {
	"FixLag",
	"Fly",
	"InfiniteJump",
	"JumpBoost",
	"SpeedBoost",
	"FlyCam",
	"Fullbright",
	"Noclip",
	"FPS",
	"Ping",
}

local FeatureIcons = {
	FixLag = "⚡",
	Fly = "✦",
	InfiniteJump = "↑",
	JumpBoost = "⇧",
	SpeedBoost = "»",
	FlyCam = "◎",
	Fullbright = "☀",
	Noclip = "◈",
	FPS = "▣",
	Ping = "◉",
}

for index, key in ipairs(FeatureOrder) do
	local info = CreateFeatureCard(key, index + 1)

	info.Icon.Text = FeatureIcons[key] or "●"

	Connect(info.Toggle.MouseButton1Click, function()
		if key == "FixLag" then
			-- RUN Fix Lag
			SetEffectsEnabled(true)

			-- Sau khi chạy xong không giữ trạng thái ON
			State.FixLag = false

			-- Giữ nút ở dạng RUN
			UpdateFeatureCard("FixLag")
		else
			ToggleFeature(key, not State[key])
		end
	end)
end

----------------------------------------------------------------
-- LANGUAGE SECTION
----------------------------------------------------------------

CreateSection(T("Settings"), 101)

----------------------------------------------------------------
-- LANGUAGE BUTTONS
----------------------------------------------------------------

for languageId, button in pairs(LanguageButtons) do
	Connect(button.MouseButton1Click, function()
		State.Language = languageId

		for id, otherButton in pairs(LanguageButtons) do
			if id == languageId then
				otherButton.BackgroundColor3 = Color3.fromRGB(55,70,110)
			else
				otherButton.BackgroundColor3 = Color3.fromRGB(31,35,45)
			end
		end

		Title.Text = T("Title")
		Subtitle.Text = T("Subtitle") .. " • GT_WIBUVN"

		LanguageTitle.Text = T("Language")
		CreditText.Text = T("Credit")

		CloseButton.Text = "—"
		DeleteButton.Text = "×"

		ConfirmTitleLabel.Text = T("ConfirmTitle")
		ConfirmDescription.Text = T("ConfirmDelete")
		ConfirmYes.Text = T("Yes")
		ConfirmNo.Text = T("No")

		MonitorTitle.Text = T("Monitor")

		for _, key in ipairs(FeatureOrder) do
			UpdateFeatureCard(key)
		end

		if AdjustMode then
			SetAdjustMode(AdjustMode)
		end

		if State.FPS then
			FPSText.Text = T("FPSLabel") .. ": " .. tostring(FPS)
		end

		if State.Ping then
			local ping = GetPing()

			if ping then
				PingText.Text = T("PingLabel") .. ": " .. math.floor(ping) .. " ms"
			else
				PingText.Text = T("PingLabel") .. ": --"
			end
		end
	end)
end

----------------------------------------------------------------
-- CLOSE / OPEN GUI
----------------------------------------------------------------

local function OpenMain()
	State.MainOpen = true
	Main.Visible = true
	OpenButton.Visible = false

	Main.Size = UDim2.new(0,610,0,590)

	Tween(Main, {
		Position = UDim2.new(0.5,-305,0.5,-295)
	}, 0.2)
end

local function CloseMain()
	State.MainOpen = false
	Main.Visible = false
	OpenButton.Visible = true
end

Connect(CloseButton.MouseButton1Click, function()
	CloseMain()
end)

Connect(OpenButton.MouseButton1Click, function()
	OpenMain()
end)

----------------------------------------------------------------
-- DELETE GUI
----------------------------------------------------------------

local function ResetAllFeatures()
	State.FixLag = false
	State.Fly = false
	State.InfiniteJump = false
	State.JumpBoost = false
	State.SpeedBoost = false
	State.FlyCam = false
	State.Fullbright = false
	State.Noclip = false
	State.FPS = false
	State.Ping = false

	SetEffectsEnabled(false)
	StopFly()
	StopFlyCam()
	SetFullbright(false)
	SetNoclip(false)
	RestoreMovement()

	MobileFly.Visible = false
	MobileCam.Visible = false
	Monitor.Visible = false
end

local function DestroyEverything()
	if State.Destroyed then
		return
	end

	State.Destroyed = true

	ResetAllFeatures()

	DisconnectAll()

	task.defer(function()
		if ScreenGui and ScreenGui.Parent then
			ScreenGui:Destroy()
		end
	end)
end

Connect(DeleteButton.MouseButton1Click, function()
	ConfirmOverlay.Visible = true
end)

Connect(ConfirmNo.MouseButton1Click, function()
	ConfirmOverlay.Visible = false
end)

Connect(ConfirmYes.MouseButton1Click, function()
	ConfirmOverlay.Visible = false
	DestroyEverything()
end)

----------------------------------------------------------------
-- CHARACTER NOCLIP LOOP
----------------------------------------------------------------

Connect(RunService.Stepped, function()
	if State.Noclip then
		SetNoclip(true)
	end
end)

----------------------------------------------------------------
-- SPAWN SAFETY
----------------------------------------------------------------

Connect(LocalPlayer.CharacterAdded, function()
	task.wait(0.5)

	if State.Noclip then
		SetNoclip(true)
	end

	if State.SpeedBoost then
		ApplySpeed()
	end

	if State.JumpBoost then
		ApplyJump()
	end

	if State.Fly then
		StopFly()
		StartFly()
	end
end)

----------------------------------------------------------------
-- BUTTON HOVER EFFECTS
----------------------------------------------------------------

local function AddHover(button, normal, hover)
	Connect(button.MouseEnter, function()
		Tween(button, {
			BackgroundColor3 = hover
		}, 0.12)
	end)

	Connect(button.MouseLeave, function()
		Tween(button, {
			BackgroundColor3 = normal
		}, 0.12)
	end)
end

AddHover(
	CloseButton,
	Color3.fromRGB(38,41,52),
	Color3.fromRGB(50,53,65)
)

AddHover(
	DeleteButton,
	Color3.fromRGB(45,30,34),
	Color3.fromRGB(75,35,40)
)

AddHover(
	OpenButton,
	Color3.fromRGB(28,31,40),
	Color3.fromRGB(45,50,65)
)

----------------------------------------------------------------
-- ROBLOX ESC MENU SAFETY
----------------------------------------------------------------

Connect(GuiService.MenuOpened, function()
	if State.Destroyed then
		return
	end

	-- Không tắt GUI khi nhấn ESC
	if ScreenGui and ScreenGui.Parent then
		ScreenGui.Enabled = true
	end
end)

Connect(GuiService.MenuClosed, function()
	if State.Destroyed then
		return
	end

	-- Hiện lại GUI sau khi đóng ESC
	if ScreenGui and ScreenGui.Parent then
		ScreenGui.Enabled = true
	end
end)

----------------------------------------------------------------
-- INITIAL UI
----------------------------------------------------------------

for _, key in ipairs(FeatureOrder) do
	UpdateFeatureCard(key)
end

UpdateSlider(State.Speed)

----------------------------------------------------------------
-- MOBILE MAIN MENU POSITION
----------------------------------------------------------------

if UserInputService.TouchEnabled then
	Main.Position = UDim2.new(0.5,-305,0.5,-295)
end

----------------------------------------------------------------
-- INITIAL MONITOR
----------------------------------------------------------------

Monitor.Visible = false
MobileFly.Visible = false
MobileCam.Visible = false

----------------------------------------------------------------
-- CLEANUP IF GUI IS EXTERNALLY DESTROYED
----------------------------------------------------------------

ScreenGui.Destroying:Connect(function()
	if State.Destroyed then
		return
	end

	State.Destroyed = true

	pcall(ResetAllFeatures)
	pcall(DisconnectAll)
end)

----------------------------------------------------------------
-- DONE
----------------------------------------------------------------

print("[GT_WIBUVN] Menu loaded successfully.")
