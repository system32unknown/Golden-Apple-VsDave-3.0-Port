package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
#if desktop
import Discord.DiscordClient;
#end

import flixel.system.FlxSound;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = 
	[
		'story mode', 
		'freeplay', 
		'credits',
		'ost',
		'options',
		'discord'
	];

	var languagesOptions:Array<String> =
	[
		'main_story',
		'main_freeplay',
		'main_credits',
		'main_ost',
		'main_options',
		'main_discord'
	];

	var languagesDescriptions:Array<String> =
	[
		'desc_story',
		'desc_freeplay',
		'desc_credits',
		'desc_ost',
		'desc_options',
		'desc_discord'
	];

	public static var firstStart:Bool = true;
	public static var finishedFunnyMove:Bool = false;

	public static var daRealEngineVer:String = 'Golden Apple';
	public static var engineVer:String = '(Dave 3.0b)';
	public static var gameVer:String = "0.2.7.1";
	
	var bg:FlxSprite;
	var magenta:FlxSprite;
	var selectUi:FlxSprite;
	var bigIcons:FlxSprite;
	public static var bgPaths:Array<String> = [
		'Aadsta',
		'ArtiztGmer',
		'DeltaKastel',
		'DeltaKastel2',
		'DeltaKastel3',
		'DeltaKastel4',
		'DeltaKastel5',
		'diamond man',
		'Jukebox',
		'kiazu',
		'Lancey',
		'mamakotomi',
		'mantis',
		'mepperpint',
		'morie',
		'neon',
		'Onuko',
		'ps',
		'ricee_png',
		'sk0rbias',
		'SwagnotrllyTheMod',
		'zombought',
	];

	var curOptText:FlxText;
	var curOptDesc:FlxText;
	
	var prompt:Prompt;
	var canInteract:Bool = true;

	var black:FlxSprite;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		persistentUpdate = persistentDraw = true;

		#if desktop
		DiscordClient.changePresence("In the Menus", null);
		#end
		
		KeybindPrefs.loadControls();
		
		MathGameState.accessThroughTerminal = false;

		bg = new FlxSprite(-80).loadGraphic(randomizeBG());
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xFFFDE871;
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(bg.graphic);
		magenta.scrollFactor.set();
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		selectUi = new FlxSprite(0, 0).loadGraphic(Paths.image('mainMenu/Select_Thing', 'preload'));
		selectUi.scrollFactor.set(0, 0);
		selectUi.antialiasing = true;
		selectUi.updateHitbox();
		add(selectUi);

		bigIcons = new FlxSprite(0, 0);
		bigIcons.frames = Paths.getSparrowAtlas('ui/menu_big_icons');
		for (i in 0...optionShit.length)
		{
			bigIcons.animation.addByPrefix(optionShit[i], optionShit[i] == 'freeplay' ? 'freeplay0' : optionShit[i], 24);
		}
		bigIcons.scrollFactor.set(0, 0);
		bigIcons.antialiasing = true;
		bigIcons.updateHitbox();
		bigIcons.animation.play(optionShit[0]);
		bigIcons.screenCenter(X);
		add(bigIcons);

		curOptText = new FlxText(0, 0, FlxG.width, CoolUtil.formatString(LanguageManager.getTextString(languagesOptions[curSelected]), ' '));
		curOptText.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		curOptText.scrollFactor.set(0, 0);
		curOptText.borderSize = 2.5;
		curOptText.antialiasing = true;
		curOptText.screenCenter(X);
		curOptText.y = FlxG.height / 2 + 28;
		add(curOptText);

		curOptDesc = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString(languagesDescriptions[curSelected]));
		curOptDesc.setFormat("Comic Sans MS Bold", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		curOptDesc.scrollFactor.set(0, 0);
		curOptDesc.borderSize = 2;
		curOptDesc.antialiasing = true;
		curOptDesc.screenCenter(X);
		curOptDesc.y = FlxG.height - 58;
		add(curOptDesc);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('ui/main_menu_icons');

		for (i in 0...optionShit.length)
		{
			var currentOptionShit = optionShit[i];
			var menuItem:FlxSprite = new FlxSprite(FlxG.width * 1.6, 0);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', (currentOptionShit == 'freeplay glitch' ? 'freeplay' : currentOptionShit) + " basic", 24);
			menuItem.animation.addByPrefix('selected', (currentOptionShit == 'freeplay glitch' ? 'freeplay' : currentOptionShit) + " white", 24);
			menuItem.animation.play('idle');
			menuItem.antialiasing = false;
			menuItem.setGraphicSize(128, 128);
			menuItem.ID = i;
			menuItem.updateHitbox();
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 1);
			if (firstStart) {
				FlxTween.tween(menuItem, {x: FlxG.width / 2 - 450 + (i * 160)}, 1 + (i * 0.25), {
					ease: FlxEase.expoInOut,
					onComplete: function(flxTween:FlxTween) {
						finishedFunnyMove = true;
						changeItem();
					}
				});
			} else {
				menuItem.x = FlxG.width / 2 - 450 + (i * 160);
				changeItem();
			}
		}

		firstStart = false;

		var versionShit:FlxText = new FlxText(1, FlxG.height - 25, 0, '${daRealEngineVer} Engine v${engineVer}\nFNF v${gameVer}', 12);
		versionShit.antialiasing = true;
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var pressR:FlxText = new FlxText(150, 10, 0, LanguageManager.getTextString("main_resetdata"), 12);
		pressR.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		pressR.x -= versionShit.textField.textWidth;
		pressR.antialiasing = true;
		pressR.alpha = 0;
		pressR.scrollFactor.set();
		add(pressR);

		FlxTween.tween(pressR, {alpha: 1}, 1);

		menuItems.forEach(function(spr:FlxSprite) {
			spr.y = FlxG.height / 2 + 130;
		});

		super.create();
	}
	
	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		if (canInteract)
		{
			if (FlxG.keys.justPressed.SEVEN)
			{
				var deathSound:FlxSound = new FlxSound();
				deathSound.loadEmbedded(Paths.soundRandom('missnote', 1, 3));
				deathSound.volume = FlxG.random.float(0.6, 1);
				deathSound.play();
				
				FlxG.camera.shake(0.05, 0.1);
			}
			if (FlxG.keys.justPressed.R)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				
				prompt = new Prompt(LanguageManager.getTextString("main_warningdata"), controls);
				prompt.canInteract = true;
				prompt.alpha = 0;
				canInteract = false;
				
				
				black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.screenCenter();
				black.alpha = 0;
				add(black);

				FlxTween.tween(black, {alpha: 0.6}, 0.3);

				FlxTween.tween(prompt, {alpha: 1}, 0.5, {
					onComplete: function(tween:FlxTween) {
						prompt.canInteract = true;
					}
				});
				prompt.noFunc = function()
				{
					FlxTween.tween(black, {alpha: 0}, 0.3, {onComplete: function(tween:FlxTween)
					{
						remove(black);
					}});
					prompt.canInteract = false;
					FlxTween.tween(prompt, {alpha: 0}, 0.5, {
						onComplete: function(tween:FlxTween) {
							remove(prompt);
							FlxG.mouse.visible = false;
							canInteract = true;
						}
					});
				}
				prompt.yesFunc = function()
				{
					resetData();
				}
				add(prompt);
			}
		}
		
		if (!selectedSomethin && canInteract)
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'discord' || optionShit[curSelected] == 'merch')
				{
					switch (optionShit[curSelected])
					{
						case 'discord':
							fancyOpenURL("https://www.discord.gg/vsdave");
					}
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween) {
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];
								switch (daChoice)
								{
									case 'story mode': FlxG.switchState(new StoryMenuState());
									case 'freeplay' | 'freeplay glitch': FlxG.switchState(new FreeplayState());
									case 'options': FlxG.switchState(new OptionsMenu());
									case 'ost': FlxG.switchState(new MusicPlayerState());
									case 'credits': FlxG.switchState(new CreditsMenuState());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
			}
			//spr.screenCenter(Y);
			spr.updateHitbox();
		});

		bigIcons.animation.play(optionShit[curSelected]);
		curOptText.text = CoolUtil.formatString(LanguageManager.getTextString(languagesOptions[curSelected]), ' ');
		curOptDesc.text = LanguageManager.getTextString(languagesDescriptions[curSelected]);
	}

	public static function randomizeBG():flixel.system.FlxAssets.FlxGraphicAsset
	{
		var date = Date.now();
		var chance:Int = FlxG.random.int(0, bgPaths.length - 1);
		if(date.getMonth() == 3 && date.getDate() == 1) {
			return Paths.image('backgrounds/ramzgaming');
		} else {
			return Paths.image('backgrounds/${bgPaths[chance]}');
		}
	}
	function resetData()
	{
		for (save in ['funkin', 'controls', 'language'])
		{
			FlxG.save.bind(save, 'ninjamuffin99');
			FlxG.save.erase();
			FlxG.save.flush();
		}
		FlxG.save.bind('funkin', 'ninjamuffin99');

		Highscore.songScores = new Map();
		Highscore.songChars = new Map();

		SaveDataHandler.initSave();
		LanguageManager.init();

		Highscore.load();
		
		CoolUtil.init();

		CharacterSelectState.unlockCharacter('bf');
		CharacterSelectState.unlockCharacter('bf-pixel');

		FlxG.switchState(new StartStateSelector());
	}
}
class Prompt extends FlxSpriteGroup
{
	var promptText:FlxText;
	var yesText:FlxText;
	var noText:FlxText;
	var texts = new Array<FlxText>();

	public var yesFunc:Void->Void;
	public var noFunc:Void->Void;
	public var canInteract:Bool = true;
	public var controls:Controls;
	var curSelected:Int = 0;
	
	public function new(question:String, controls:Controls)
	{
		super();

		this.controls = controls;

		FlxG.mouse.visible = true;
		
		promptText = new FlxText(0, FlxG.height / 2 - 200, FlxG.width, question, 16);
		promptText.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		promptText.screenCenter(X);
		promptText.scrollFactor.set(0, 0);
		promptText.borderSize = 2.5;
		promptText.antialiasing = true;
		add(promptText);

		noText = new FlxText(0, FlxG.height / 2 + 100, 0, "No", 16);
		noText.screenCenter(X);
		noText.x += 200;
		noText.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		noText.scrollFactor.set(0, 0);
		noText.borderSize = 1.5;
		noText.antialiasing = true;
		add(noText);

		yesText = new FlxText(0, FlxG.height / 2 + 100, 0, "Yes", 16);
		yesText.screenCenter(X);
		yesText.x -= 200;
		yesText.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		yesText.scrollFactor.set(0, 0);
		yesText.borderSize = 1.5;
		yesText.antialiasing = true;
		add(yesText);
		
		texts = [yesText, noText];

		updateText();
	}
	override function update(elapsed:Float)
	{
		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var enter = controls.ACCEPT;

		if (leftP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected--;
			if (curSelected < 0)
			{
				curSelected = 1;
			}
			updateText();
		}
		if (rightP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected++;
			if (curSelected > 1)
			{
				curSelected = 0;
			}
			updateText();
		}
		if (enter)
		{
			select(texts[curSelected]);
		}

		if (FlxG.mouse.justMoved)
		{
			for (i in 0...texts.length)
			{
				if (i != curSelected)
				{
					if (FlxG.mouse.overlaps(texts[i]) && !FlxG.mouse.overlaps(texts[curSelected]))
					{
						curSelected = i;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						updateText();
					}
				}
			}
		}

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(texts[curSelected]))
			{
				select(texts[curSelected]);
			}
		}
		super.update(elapsed);
	}
	function updateText()
	{
		switch (curSelected)
		{
			case 0:
				yesText.borderColor = FlxColor.YELLOW;
				noText.borderColor = FlxColor.BLACK;
			case 1:
				noText.borderColor = FlxColor.YELLOW;
				yesText.borderColor = FlxColor.BLACK;
		}
	}
	function select(text:FlxText)
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		var select = texts.indexOf(text);

		FlxFlicker.flicker(text, 1.1, 0.1, false, false, function(flicker:FlxFlicker) {
			switch (select) {
				case 0: yesFunc();
				case 1: noFunc();
			}
		});
	}
}