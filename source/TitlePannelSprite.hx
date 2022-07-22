package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import towsterFlxUtil.Paths;
import flixel.FlxSprite;

class TitlePannelSprite extends FlxSprite
{
	public function new(id:String)
	{
		super(0, -1000);
		switch (id)
		{
			case 'credits':
				loadGraphic(Paths.filePath('titleScreen/creditsPannel', PNG));
			case 'tutorial':
				loadGraphic(Paths.filePath('titleScreen/tutorialPannel', PNG));
		}

		scale.set(0.4, 0.4);
		updateHitbox();
		screenCenter(X);
	}

	public function bringDown()
	{
		FlxTween.tween(this, {y: 50}, 1, {ease: FlxEase.bounceOut});
	}

	public function putUp()
	{
		FlxTween.tween(this, {y: -1000}, 1, {ease: FlxEase.backIn});
	}
}
