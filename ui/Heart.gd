extends TextureRect

export(Texture) var filledHeart
export(Texture) var emptyHeart


func fillHeart():
	texture = filledHeart
	
	
func emptyHeart():
	texture = emptyHeart
