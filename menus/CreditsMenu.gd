extends Control

signal main_menu_pressed

const GAME_MUSIC_LINK = "https://www.soundclick.com/music/songInfo.cfm?songID=14197788"
const MENU_MUSIC_LINK = "https://www.soundclick.com/music/songInfo.cfm?songID=14275897"
const MUSIC_AUTHOR_LINK = "https://www.soundclick.com/artist/default.cfm?bandID=1277008"
const CC_BY_30_LINK = "https://creativecommons.org/licenses/by/3.0/"

const FONT_LINK = "https://www.dafont.com/dogica.font"
const FONT_AUTHOR_LINK = "https://www.dafont.com/roberto-mocci.d8882"
const OFL_11_LINK = "https://opensource.org/licenses/OFL-1.1"

onready var gameMusicSongLink = $MarginContainer/VBoxContainer/CreditsWrap/MusicCreditWrap/SongWrap/GameMusicWrap/MusicLinkWrap/MusicLink
onready var gameMusicAuthorLink = $MarginContainer/VBoxContainer/CreditsWrap/MusicCreditWrap/SongWrap/MenuMusicWrap/AuthorWrap/AuthorLink
onready var gameMusicLicenseLink = $MarginContainer/VBoxContainer/CreditsWrap/MusicCreditWrap/SongWrap/GameMusicWrap/LicenseWrap/LicenseLink

onready var menuMusicSongLink = $MarginContainer/VBoxContainer/CreditsWrap/MusicCreditWrap/SongWrap/MenuMusicWrap/MusicLinkWrap/MusicLink
onready var menuMusicAuthorLink = $MarginContainer/VBoxContainer/CreditsWrap/MusicCreditWrap/SongWrap/MenuMusicWrap/AuthorWrap/AuthorLink



func _on_MainMenuButton_pressed():
	emit_signal("main_menu_pressed")


func _on_GameMusicLink_pressed():
	OS.shell_open(GAME_MUSIC_LINK)


func _on_GameMusicAuthorLink_pressed():
	OS.shell_open(MUSIC_AUTHOR_LINK)


func _on_GameMusicLicenseLink_pressed():
	OS.shell_open(CC_BY_30_LINK)


func _on_MenuMusicLink_pressed():
	OS.shell_open(MENU_MUSIC_LINK)


func _on_MenuMusicAuthorLink_pressed():
	OS.shell_open(MUSIC_AUTHOR_LINK)


func _on_MenuMusicLicenseLink_pressed():
	OS.shell_open(CC_BY_30_LINK)


func _on_FontLink_pressed():
	OS.shell_open(FONT_LINK)


func _on_FontAuthorLink_pressed():
	OS.shell_open(FONT_AUTHOR_LINK)


func _on_FontLicenseLink_pressed():
	OS.shell_open(OFL_11_LINK)
