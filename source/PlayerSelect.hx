package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import towsterFlxUtil.Paths;

class PlayerSelect extends FlxState
{
	var characterList = ['Catterry', 'Wildcard', 'Lolli', 'MonopolyBoy', 'Thimble', 'MrGreen', 'YahtZ'];
	var characters:FlxTypedSpriteGroup<FlxSprite>;
	var characterPointer = 0;

	var border:FlxSprite;
	var characterText:FlxSprite;

	var BG:FlxSprite;

	override public function create()
	{
		FlxG.sound.playMusic('assets/music/Board_Blastin_-_Menu_Selection.ogg', 0.5, true);

		BG = new FlxSprite(0, 0).loadGraphic(Paths.filePath('playerSelect/unknown', PNG));
		add(BG);

		characters = new FlxTypedSpriteGroup(-117, -247, characterList.length);
		characters.updateHitbox();
		add(characters);
		var offset = 0;
		for (name in characterList)
		{
			var tempSprite:FlxSprite = new FlxSprite(offset, 0).loadGraphic(Paths.filePath('playerSelect/' + name + '', PNG));
			tempSprite.scale.set(0.4, 0.4);
			offset += 300;
			characters.add(tempSprite);
		}
		characters.members[0].loadGraphic(Paths.filePath('playerSelect/Catterry_Color', PNG));

		characterText = new FlxSprite(0, 1000).loadGraphic(Paths.filePath('playerSelect/text/Catterry_text', PNG));
		characterText.scale.set(0.7, 0.7);
		characterText.screenCenter(X);
		add(characterText);

		border = new FlxSprite(53, 43).loadGraphic(Paths.filePath('playerSelect/border', PNG));
		border.scale.set(0.4, 0.4);
		border.updateHitbox();
		add(border);

		FlxTween.tween(characters, {y: -247}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(characterText, {y: 425}, 0.5, {ease: FlxEase.quadOut});

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if ((FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT) && characterPointer < characterList.length - 1)
		{
			characterPointer++;
			FlxTween.tween(characters, {x: (characterPointer * -300) - 117}, 0.5, {ease: FlxEase.quadOut});
		}
		else if ((FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT) && characterPointer > 0)
		{
			characterPointer--;
			FlxTween.tween(characters, {x: (characterPointer * -300) - 117}, 0.5, {ease: FlxEase.quadOut});
		}

		if (FlxG.keys.anyJustPressed([D, RIGHT, A, LEFT]))
		{
			FlxG.sound.load('assets/music/BOARD_BLASTIN_-_OPTION_SELECTED.ogg', 0.5, false).play();
			characterText.loadGraphic(Paths.filePath('playerSelect/text/' + characterList[characterPointer] + '_text', PNG));
			characters.members[0].loadGraphic(Paths.filePath('playerSelect/Catterry', PNG));
			characters.members[1].loadGraphic(Paths.filePath('playerSelect/Wildcard', PNG));
			characters.members[2].loadGraphic(Paths.filePath('playerSelect/Lolli', PNG));
			if (characterPointer == 0)
			{
				characters.members[0].loadGraphic(Paths.filePath('playerSelect/Catterry_Color', PNG));
			}
			else if (characterPointer == 1)
			{
				characters.members[1].loadGraphic(Paths.filePath('playerSelect/Wildcard_Color', PNG));
			}
			else if (characterPointer == 2)
			{
				characters.members[2].loadGraphic(Paths.filePath('playerSelect/Lolli_Color', PNG));
			}
		}

		if (FlxG.keys.anyJustPressed([ENTER]) && characterPointer <= 2)
		{
			FloatingVarables.characterType = characterPointer;
			FlxTween.tween(FlxG.camera, {zoom: 20, alpha: 0}, 1.5, {
				ease: FlxEase.sineIn,
				onComplete: (x) ->
				{
					FlxG.switchState(new PlayState());
				}
			});
		}

		super.update(elapsed);
	}
}
