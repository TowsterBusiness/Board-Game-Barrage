package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSubState;

class PauseSubState extends FlxSubState
{
	var resume:BruhButton;
	var mainMenu:BruhButton;

	override public function create():Void
	{
		super.create();
		FlxG.sound.playMusic('assets/music/BOARD_BLASTIN_-_PAUSE.ogg', 0, true);
		FlxTween.tween(FlxG.sound, {volume: 0.5}, 1);

		resume = new BruhButton(220, 0, 'resume', 0.4);
		mainMenu = new BruhButton(270, 0, 'mainMenu', 0.4);

		resume.screenCenter(XY);
		mainMenu.screenCenter(XY);
		resume.x += 270;
		mainMenu.x -= 270;
		add(resume);
		add(mainMenu);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (resume.updateButton())
		{
			FlxG.sound.playMusic('assets/music/BOARD_BLASTIN_-_BATTLE.ogg', 0.4, true);
			close();
		}
		if (mainMenu.updateButton())
		{
			FlxTween.tween(FlxG.camera, {alpha: 0}, 1.5, {
				ease: FlxEase.sineIn,
				onComplete: (x) ->
				{
					FlxG.switchState(new TitleState());
				}
			});
		}
	}
}
