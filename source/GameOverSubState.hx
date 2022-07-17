package;

import towsterFlxUtil.Paths;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSubState;

class GameOverSubState extends FlxSubState
{
	var gameOverSprite:FlxSprite;
	var retryButton:FlxSprite;

	override public function create():Void
	{
		super.create();

		gameOverSprite = new FlxSprite(0, -50).loadGraphic(Paths.getFilePath('images/gameover.png'));
		gameOverSprite.screenCenter(X);
		gameOverSprite.scale.set(0.8, 0.8);
		gameOverSprite.alpha = 0;
		add(gameOverSprite);

		retryButton = new FlxSprite(550, 433).loadGraphic(Paths.getFilePath('images/retry.png'));

		retryButton.scale.set(0.4, 0.4);
		retryButton.updateHitbox();
		retryButton.alpha = 0;
		add(retryButton);

		FlxG.camera.alpha = 1;
		FlxTween.tween(retryButton, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		FlxTween.tween(gameOverSprite, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(retryButton) && retryButton.alpha != 0)
		{
			FlxTween.tween(FlxG.camera, {alpha: 0}, 1, {
				ease: FlxEase.quadIn,
				onComplete: (x) ->
				{
					FlxG.switchState(new PlayState());
				}
			});
		}
	}
}
