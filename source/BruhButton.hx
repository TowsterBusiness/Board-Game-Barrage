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
		switch (spriteId)
		{
			case 'play' | 'credits':
				loadGraphic(Paths.getFilePath('images/titleScreen/TitleScreenButtons.png'), true, 1000, 600);
				animation.add('credits-color', [0], 1, true);
				animation.add('play-color', [1], 1, true);
				animation.add('credits-gray', [2], 1, true);
				animation.add('play-gray', [3], 1, true);
			case 'resume' | 'mainMenu':
				loadGraphic(Paths.getFilePath('images/PauseMenu.png'), true, 1000, 600);
				animation.add('resume-gray', [0], 1, true);
				animation.add('resume-color', [1], 1, true);
				animation.add('mainMenu-color', [2], 1, true);
				animation.add('mainMenu-gray', [3], 1, true);
		}
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
