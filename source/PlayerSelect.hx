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
		BG = new FlxSprite(0, 0).loadGraphic(Paths.getFilePath('images/playerSelect/unknown.png'));
		add(BG);

		characters = new FlxTypedSpriteGroup(-117, -247, characterList.length);
		characters.updateHitbox();
		add(characters);
		var offset = 0;
		for (name in characterList)
		{
			var tempSprite:FlxSprite = new FlxSprite(offset, 0).loadGraphic(Paths.getFilePath('images/playerSelect/' + name + '.png'));
			tempSprite.scale.set(0.4, 0.4);
			offset += 300;
			characters.add(tempSprite);
		}
		characters.members[0].loadGraphic(Paths.getFilePath('images/playerSelect/Catterry_Color.png'));

		characterText = new FlxSprite(0, 1000).loadGraphic(Paths.getFilePath('images/playerSelect/text/Catterry_text.png'));
		characterText.scale.set(0.7, 0.7);
		characterText.screenCenter(X);
		add(characterText);

		border = new FlxSprite(53, 43).loadGraphic(Paths.getFilePath('images/playerSelect/border.png'));
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
			characterText.loadGraphic(Paths.getFilePath('images/playerSelect/text/' + characterList[characterPointer] + '_text.png'));
			characters.members[0].loadGraphic(Paths.getFilePath('images/playerSelect/Catterry.png'));
			characters.members[1].loadGraphic(Paths.getFilePath('images/playerSelect/Wildcard.png'));
			characters.members[2].loadGraphic(Paths.getFilePath('images/playerSelect/Lolli.png'));
			if (characterPointer == 0)
			{
				characters.members[0].loadGraphic(Paths.getFilePath('images/playerSelect/Catterry_Color.png'));
			}
			else if (characterPointer == 1)
			{
				characters.members[1].loadGraphic(Paths.getFilePath('images/playerSelect/Wildcard_Color.png'));
			}
			else if (characterPointer == 2)
			{
				characters.members[2].loadGraphic(Paths.getFilePath('images/playerSelect/Lolli_Color.png'));
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
