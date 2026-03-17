extends Control


var sfx_volume = 0.8
var mus_volume = 0.8
var amb_volume = 0.8

var mus_playing = false
var amb_playing = false


func _ready() -> void:
	
	"""VCA -- это типа мастер-шины, их удобно для настроек громкости юзать"""
	"""в реальной жизни тут наверное надо подтянуть настройки громкости из сейва"""
	
	var sfx_vca = FmodServer.get_vca('vca:/SFX')  # не знаю, зачем я тут эти переменные создал, но оставлю :D
	sfx_vca.volume = mus_volume					 # я и так по итогу почти всё с нуля переделал!
	
	var music_vca = FmodServer.get_vca('vca:/Music')
	music_vca.volume = sfx_volume
	
	var amb_vca = FmodServer.get_vca('vca:/Ambience')
	amb_vca.volume = amb_volume


func _on_texture_rect_mouse_entered() -> void:
	
	$TextureRect.offset_top = randf_range(0., 50.)
	$TextureRect.offset_left = randf_range(0., 50.)
	
	_play_sfx('event:/SFX/snd_explosion')


func _play_sfx(sfx_name):
	
	"""каждый звук здесь -- это отдельная нода, в отличие от привычных"""
	"""годошных audiostreamplayer и шин"""
	
	var sfx = FmodEventEmitter3D.new()  # да, там ошибка, но оно работает, я щас точно с этим не буду разбираться(
	sfx.set_event_name(sfx_name)		   # не знаю, как по-умному добавлять новые ноды)
	sfx.play()


func _on_play_music_1_pressed() -> void:
	_play_music('event:/mus/mus_pieceofkinight')


func _on_play_music_2_pressed() -> void:
	_play_music('event:/mus/mus_puzzle')


func _play_music(music_name):
	
	"""для примера -- вообщееее так-то мооожно и менять само событие в EventEmitter,"""
	"""возможно, это пригодится в случае с музыкой, тут сходу хз"""
	
# короче мега-прикол, кабудто у эмиттера нет метода типа is_playing (зато есть is_paused...)
	if $MusicEmitter.event_name != music_name:
		$MusicEmitter.set_event_name(music_name)
		$MusicEmitter.play()
		mus_playing = true
	elif not mus_playing:
		$MusicEmitter.play()
		mus_playing = true
	else:
		$MusicEmitter.stop()
		mus_playing = false


func _on_play_ambience_pressed() -> void:
	"""кстати, 3д и 2д эмиттеры отличаются просто тем, будет ли звук уметь звучать типа над тобой"""
	"""вроде у 3д были какие-то преимущества и в 2д, лучше брать их"""
	
	if not amb_playing:
		$AmbienceEmitter.play()
		amb_playing = true
	else:
		$AmbienceEmitter.stop()
		amb_playing = false


func _on_noise_amount_slider_value_changed(value: float) -> void:
	"""Наверное, одна из ключевых фич фмода -- параметры"""
	$AmbienceEmitter.set_parameter('noise_amount', value)



# Ну и просто слайдеры

func _on_mus_vol_slider_value_changed(value: float) -> void:
	FmodServer.get_vca('vca:/Music').volume = value


func _on_amb_vol_slider_value_changed(value: float) -> void:
	FmodServer.get_vca('vca:/Ambience').volume = value


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	FmodServer.get_vca('vca:/SFX').volume = value
