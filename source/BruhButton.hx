package;

import towsterFlxUtil.Paths;
import flixel.FlxSprite;
import flixel.FlxG;

class BruhButton extends FlxSprite
{ // run update functions
	public var spriteId:String;

	public function new(x:Float, y:Float, spriteId:String, ?scale1:Float)
	{
		super(x, y);
		this.spriteId = spriteId;

		frames = Paths.getAnimation('buttons');

		animation.addByPrefix('credits-gray', 'credits 1', 1, true);
		animation.addByPrefix('credits-color', 'credits 2', 1, true);
		animation.addByPrefix('mainMenu-gray', 'main menu 1', 1, true);
		animation.addByPrefix('mainMenu-color', 'main menu 2', 1, true);
		animation.addByPrefix('resume-gray', 'resume 1', 1, true);
		animation.addByPrefix('resume-color', 'resume 2', 1, true);
		animation.addByPrefix('play-gray', 'play 1', 1, true);
		animation.addByPrefix('play-color', 'play 2', 1, true);

		animation.play(spriteId + '-gray');
		setGraphicSize(Math.floor(1000 * scale1), Math.floor(600 * scale1));
		updateHitbox();
	}

	public function updateButton():Bool
	{
		if (FlxG.mouse.justMoved)
		{
			if (FlxG.mouse.overlaps(this))
			{
				animation.play(spriteId + '-color');
			}
			else
			{
				animation.play(spriteId + '-gray');
			}
		}

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this))
			return true;
		return false;
	}
}
