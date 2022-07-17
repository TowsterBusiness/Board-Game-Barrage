package;

import flixel.FlxSprite;
import flixel.FlxG;

class BruhButton extends FlxSprite
{ // run update functions
	var imagePath:String;
	var pressedImagePath:String;

	public function new(x:Float, y:Float, imagePath:String, pressedImagePath:String, ?scale1:Float)
	{
		super(x, y);
		this.imagePath = imagePath;
		this.pressedImagePath = pressedImagePath;
		loadGraphic(imagePath);
		scale.set(scale1, scale1);
		updateHitbox();
	}

	public function updateButton():Bool
	{
		if (FlxG.mouse.justMoved)
		{
			if (FlxG.mouse.overlaps(this))
			{
				loadGraphic(imagePath);
			}
			else
			{
				loadGraphic(pressedImagePath);
			}
		}

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this))
			return true;
		return false;
	}
}
