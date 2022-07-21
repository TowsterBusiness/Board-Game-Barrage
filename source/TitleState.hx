package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import towsterFlxUtil.Sprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import towsterFlxUtil.Paths;
import flixel.FlxState;
import flixel.FlxSprite;

class TitleState extends FlxState
{
	var BG:MtnBGManager;
	var transitionBox:FlxSprite;

	var playButton:BruhButton;
	var creditsButton:BruhButton;
	var titleText:FlxSprite;

	var bgChars:FlxTypedSpriteGroup<TitleCharacters>;

	public override function create()
	{
		super.create();

		BG = new MtnBGManager(20);
		add(BG);

		bgChars = new FlxTypedSpriteGroup(0, 0, 3);
		var bgCharNames = ['lolli', 'wilson', 'cat&terry'];
		for (charName in bgCharNames)
		{
			bgChars.add(new TitleCharacters(charName));
		}
		add(bgChars);

		FlxG.sound.playMusic('assets/music/BOARD_BLASTIN_-_TITLE.ogg', 0.5, true);

		FlxG.camera.alpha = 0;
		FlxTween.tween(FlxG.camera, {alpha: 1}, 1.5, {
			ease: FlxEase.sineIn,
			onComplete: (x) -> {
				//
			}
		});

		transitionBox = new FlxSprite(0, 950).loadGraphic(Paths.filePath('playerSelect/unknown', PNG));

		titleText = new FlxSprite(200, -60).loadGraphic(Paths.filePath('titleScreen/logo', PNG));
		titleText.setGraphicSize(666, 400);
		titleText.screenCenter(X);

		playButton = new BruhButton(760, 450, 'play', 0.4);
		creditsButton = new BruhButton(220, 450, 'credits', 0.4);

		playButton.screenCenter(X);

		add(playButton);
		add(titleText);
		add(transitionBox);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (playButton.updateButton())
		{
			FlxTween.tween(transitionBox, {y: -200}, 0.5, {
				ease: FlxEase.quadIn,
				onComplete: (x) ->
				{
					FlxG.switchState(new PlayerSelect());
				}
			});
		}
		if (creditsButton.updateButton())
		{
			// Doesn't work lmao
			// FlxG.switchState(new Credits());
		}
	}
}
