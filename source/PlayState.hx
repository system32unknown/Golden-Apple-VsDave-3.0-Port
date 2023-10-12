package; // "Most hard-coded FNF mod ever!!!!!!!!!!" - p0kk0 on GameBanana(https://gamebanana.com/mods/43201?post=10328553)

import CreditsMenuState.CreditsText;
import sys.FileSystem;
import Alphabet;
import Shaders.PulseEffect;
import Shaders.BlockedGlitchEffect;
import Section.SwagSection;
import Song.SwagSong;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.Transition;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.filters.ShaderFilter;
#if desktop
import Discord.DiscordClient;
#end

#if windows
import sys.io.File;
import lime.app.Application;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState;

	public static var curStage:String = '';
	public static var characteroverride:String = "none";
	public static var formoverride:String = "none";
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var globalFunny:CharacterFunnyEffect = CharacterFunnyEffect.None;

	public var localFunny:CharacterFunnyEffect = CharacterFunnyEffect.None;

	public var dadGroup:FlxGroup;
	public var bfGroup:FlxGroup;
	public var gfGroup:FlxGroup;

	public static var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness', 'bedroomNight', 'backyard'];
	public var sunsetLevels:Array<String> = ['bambiFarmSunset', 'daveHouse_Sunset'];

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; // stupid velocities for cutscene
	public var updatevels:Bool = false;

	public var hasTriggeredDumbshit:Bool = false;
	var AUGHHHH:String;
	var AHHHHH:String;

	public static var curmult:Array<Float> = [1, 1, 1, 1];

	public var curbg:BGSprite;
	public var pre3dSkin:String;
	#if SHADERS_ENABLED
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public static var lazychartshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
	public static var blockedShader:BlockedGlitchEffect;
	#end

	public var UsingNewCam:Bool = false;
	public var elapsedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;
	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'expunged', 'bambi-unfair', 'exbungo', 'dave-festival-3d', 'dave-3d-recursed', 'bf-3d'];

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	public var vocals:FlxSound;
	public var exbungo_funny:FlxSound;

	private var dad:Character;
	private var dadmirror:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var splitathonCharacterExpression:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var camFollow:FlxObject;

	var nightColor:FlxColor = 0xFF878787;
	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private static var prevCamFollow:FlxObject;
	public static var recursedStaticWeek:Bool;

	private var strumLine:FlxSprite;
	private var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var dadStrums:FlxTypedGroup<StrumNote>;

	private var noteLimbo:Note;
	private var noteLimboFrames:Int;

	public var camZooming:Bool = false;
	public var crazyZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1;
	private var combo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	public static var eyesoreson = true;

	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	public var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;

	private var camDialogue:FlxCamera;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camTransition:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	public var hasDialogue:Bool = false;
	
	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	var notestuffsGuitar:Array<String> = ['LEFT', 'DOWN', 'MIDDLE', 'UP', 'RIGHT'];

	var songScore:Int = 0;

	var scoreTxt:FlxText;
	var kadeEngineWatermark:FlxText;
	var creditsWatermark:FlxText;
	var songName:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
	var lockCam:Bool;
	
	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var activateSunTweens:Bool;

	var inFiveNights:Bool = false;

	var inCutscene:Bool = false;

	public var backgroundSprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var revertedBG:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var canFloat:Bool = true;

	var possibleNotes:Array<Note> = [];

	var tweenList:Array<FlxTween> = new Array<FlxTween>();
	var pauseTweens:Array<FlxTween> = new Array<FlxTween>();

	var bfTween:ColorTween;

	var tweenTime:Float;

	var songPosBar:FlxBar;
	var songPosBG:FlxSprite;

	var bfNoteCamOffset:Array<Float> = new Array<Float>();
	var dadNoteCamOffset:Array<Float> = new Array<Float>();

	var mcStarted:Bool = false; 
	public var noMiss:Bool = false;
	public var creditsPopup:CreditsPopUp;
	public var blackScreen:FlxSprite;

	//bg stuff
	var baldi:BGSprite;
	var spotLight:FlxSprite;
	var spotLightPart:Bool;
	var spotLightScaler:Float = 1.3;
	var lastSinger:Character;

	var crowdPeople:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	
	var interdimensionBG:BGSprite;
	var nimbiLand:BGSprite;
	var nimbiSign:BGSprite;
	var flyingBgChars:FlxTypedGroup<FlyingBGChar> = new FlxTypedGroup<FlyingBGChar>();
	public static var isGreetingsCutscene:Bool;
	var originalPosition:FlxPoint = new FlxPoint();
	var daveFlying:Bool;
	var pressingKey5Global:Bool = false;

	var highway:FlxSprite;
	var bambiSpot:FlxSprite;
	var bfSpot:FlxSprite;
	var originalBFScale:FlxPoint;
	var originBambiPos:FlxPoint;
	var originBFPos:FlxPoint;

	var desertBG:BGSprite;
	var desertBG2:BGSprite;
	var sign:BGSprite;
    var georgia:BGSprite;
	var train:BGSprite;
	var trainSpeed:Float;

	var place:BGSprite;
	var stageCheck:String = 'stage';

	//recursed
	var darkSky:BGSprite;
	var darkSky2:BGSprite;
	var darkSkyStartPos:Float = 1280;
	var resetPos:Float = -2560;
	var freeplayBG:BGSprite;
	var daveBG:String;
	var bambiBG:String;
	var tristanBG:String;
	var alphaCharacters:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
	var daveSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Bonus Song'];
	var bambiSongs:Array<String> = ['Blocked', 'Corn-Theft', 'Maze', 'Mealie'];
	var tristanSongs:Array<String> = ['Adventure', 'Vs-Tristan'];
	var tristanInBotTrot:BGSprite; 

	var missedRecursedLetterCount:Int = 0;
	var recursedCovers:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var isRecursed:Bool = false;
	var recursedUI:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

	var timeLeft:Float;
	var timeGiven:Float;
	var timeLeftText:FlxText;

	var noteCount:Int;
	var notesLeft:Int;
	var notesLeftText:FlxText;

	var preRecursedHealth:Float;
	var preRecursedSkin:String;
	var rotateCamToRight:Bool;
	var camRotateAngle:Float = 0;

	var rotatingCamTween:FlxTween;

	static var DOWNSCROLL_Y:Float;
	static var UPSCROLL_Y:Float;

	var switchSide:Bool;

	public var subtitleManager:SubtitleManager;
	
	public var guitarSection:Bool;
	public var dadStrumAmount = 4;
	public var playerStrumAmount = 4;
	
	//explpit
	var expungedBG:BGSprite;
	public static var scrollType:String;

	//indignancy
	var vignette:FlxSprite;
	
	//five night
	var time:FlxText;
	var times:Array<Int> = [12, 1, 2, 3, 4, 5];
	var night:FlxText;
	var powerLeft:Float = 100;
	var powerRanOut:Bool;
	var powerDrainer:Float = 1;
	var powerMeter:FlxSprite;
	var powerLeftText:FlxText;
	var powerDown:FlxSound;
	var usage:FlxText;

	var door:BGSprite;
	var doorButton:BGSprite;
	var doorClosed:Bool;
	var doorChanging:Bool;

	var banbiWindowNames:Array<String> = ['when you realize you have school this monday', 'industrial society and its future', 'my ears burn', 'i got that weed card', 'my ass itch', 'bruh', 'alright instagram its shoutout time'];

	var barType:String;
	override public function create()
	{
		instance = this;

		paused = false;

		barType = FlxG.save.data.songBarOption;

		resetShader();

		scrollType = FlxG.save.data.downscroll ? 'downscroll' : 'upscroll';

		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;

		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyString();

		// To avoid having duplicate images in Discord assets
		switch (SONG.player2)
		{
			case 'dave' | 'dave-angey' | 'dave-3d-recursed':
				iconRPC = 'dave';
			case 'bambi-new' | 'bambi-angey' | 'bambi' | 'bambi-joke' | 'bambi-3d' | 'bambi-unfair' | 'expunged':
				iconRPC = 'bambi';
			default:
				iconRPC = 'none';
		}
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				iconRPC = 'both';
		}

		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay Mode: ";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;


		curStage = "";

		localFunny = globalFunny;
		globalFunny = CharacterFunnyEffect.None;

		if (localFunny == CharacterFunnyEffect.Tristan)
		{
			SONG.player2 = "tristan-opponent";
		}

		// Updating Discord Rich Presence.
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camDialogue = new FlxCamera();
		camDialogue.bgColor.alpha = 0;
		camTransition = new FlxCamera();
		camTransition.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camDialogue, false);
		FlxG.cameras.add(camTransition, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		Transition.nextCamera = camTransition;

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('warmup');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		theFunne = theFunne && SONG.song.toLowerCase() != 'unfairness' && SONG.song.toLowerCase() != 'exploitation';

		// DIALOGUE STUFF
		// Hi guys i know yall are gonna try to add more dialogue here, but with this new system, all you have to do is add a dialogue file with the name of the song in the assets/data/dialogue folder,
		// and it will automatically get the dialogue in this function
		if (FileSystem.exists(Paths.txt('dialogue/${SONG.song.toLowerCase()}')))
		{
			var postfix:String = "";
			if (PlayState.instance.localFunny == PlayState.CharacterFunnyEffect.Recurser)
			{
				postfix = "-recurser";
			}
			dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/${SONG.song.toLowerCase() + postfix}'));
			hasDialogue = true;
		}
		else
		{
			hasDialogue = false;
		}

		if(SONG.stage == null)
		{
			switch(SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'supernovae' | 'warmup':
					stageCheck = 'house';
				case 'polygonized':
					stageCheck = 'red-void';
				case 'bonus-song':
					stageCheck = 'inside-house';
				case 'blocked' | 'corn-theft' | 'maze':
					stageCheck = 'farm';
				case 'indignancy':
					stageCheck = 'farm-night';
				case 'splitathon' | 'mealie':
					stageCheck = 'farm-night';
				case 'shredder' | 'greetings':
					stageCheck = 'festival';
				case 'interdimensional':
					stageCheck = 'interdimension-void';
				case 'rano':
					stageCheck = 'backyard';
				case 'cheating':
					stageCheck = 'green-void';
				case 'unfairness':
					stageCheck = 'glitchy-void';
				case 'exploitation':
					stageCheck = 'desktop';
				case 'kabunga':
					stageCheck = 'exbungo-land';
				case 'glitch' | 'memory':
					stageCheck = 'house-night';
				case 'secret':
					stageCheck = 'house-sunset';
				case 'vs-dave-rap' | 'vs-dave-rap-two':
					stageCheck = 'rapBattle';
				case 'recursed':
					stageCheck = 'freeplay';
				case 'roofs':
					stageCheck = 'roof';
				case 'bot-trot':
					stageCheck = 'bedroom';
				case 'escape-from-california':
					stageCheck = 'desert';
				case 'master':
					stageCheck = 'master';
				case 'overdrive':
					stageCheck = 'overdrive';
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}
		backgroundSprites = createBackgroundSprites(stageCheck, false);
		switch (SONG.song.toLowerCase())
		{
			case 'secret':
				UsingNewCam = true;
		}
		switch (SONG.song.toLowerCase())
		{
			case 'polygonized' | 'interdimensional':
				var stage = SONG.song.toLowerCase() != 'interdimensional' ? 'house-night' : 'festival';
				revertedBG = createBackgroundSprites(stage, true);
				for (bgSprite in revertedBG)
				{
					bgSprite.color = getBackgroundColor(SONG.song.toLowerCase() != 'interdimensional' ? 'daveHouse_night' : 'festival');
					bgSprite.alpha = 0;
				}
		}
		var gfVersion:String = 'gf';
		
		var noGFSongs = ['memory', 'five-nights', 'bot-trot', 'escape-from-california', 'overdrive'];
		
		if(SONG.gf != null)
		{
			gfVersion = SONG.gf;
		}
		if (formoverride == "bf-pixel")
		{
			gfVersion = 'gf-pixel';
		}
		if (SONG.player1 == 'bf-cool')
		{
			gfVersion = 'gf-cool';
		}
		if (SONG.player1 == 'tb-funny-man')
		{
			gfVersion = 'stereo';
		}
		
		if (noGFSongs.contains(SONG.song.toLowerCase()) || !['none', 'bf', 'bf-pixel'].contains(formoverride))
		{
			gfVersion = 'gf-none';
		}

		#if SHADERS_ENABLED
		screenshader.waveAmplitude = 0.5;
		screenshader.waveFrequency = 1;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);
		#end

		gfGroup = new FlxGroup();
		dadGroup = new FlxGroup();
		bfGroup = new FlxGroup();

		switch (stageCheck)
		{
			case 'office':
				add(gfGroup);
				add(bfGroup);

				var floor:BGSprite = new BGSprite('frontFloor', -689, 525, Paths.image('backgrounds/office/floor'), null, 1, 1);
				backgroundSprites.add(floor);
				add(floor);

				door = new BGSprite('door', 68, -152, 'backgrounds/office/door', [
					new Animation('idle', 'doorLOL instance 1', 0, false, [false, false], [11]),
					new Animation('doorShut', 'doorLOL instance 1', 24, false, [false, false], CoolUtil.numberArray(22, 11)),
					new Animation('doorOpen', 'doorLOL instance 1', 24, false, [false, false], CoolUtil.numberArray(11, 0))
				], 1, 1, true, true);
				door.animation.play('idle');
				backgroundSprites.add(door);
				add(door);

				var frontWall:BGSprite = new BGSprite('frontWall', -716, -381, Paths.image('backgrounds/office/frontWall'), null, 1, 1);
				backgroundSprites.add(frontWall);
				add(frontWall);

				doorButton = new BGSprite('doorButton', 521, 61, Paths.image('fiveNights/btn_doorOpen'), null, 1, 1);
				backgroundSprites.add(doorButton);
				add(doorButton);

				add(dadGroup);
			default:
				add(gfGroup);
				add(dadGroup);
				add(bfGroup);
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (gfVersion == 'gf-none')
		{
			gf.visible = false;
		}

		dad = new Character(100, 450, SONG.player2);
		switch (SONG.song.toLowerCase())
		{
			case 'insanity':
				dadmirror = new Character(100, 200, "dave-angey");
				dadmirror.visible = false;
		}
		switch (SONG.song.toLowerCase())
		{
			case 'maze':
				tweenTime = sectionStartTime(25);
				for (i in 0...backgroundSprites.members.length)
				{
					var bgSprite = backgroundSprites.members[i];
					var tween:FlxTween = null;
					switch (i)
					{
						case 0:
							tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000);
						case 1:
							tween = FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000));
						case 2:
							tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000));
						default:
							tween = FlxTween.color(bgSprite, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(
								FlxTween.color(bgSprite, tweenTime / 1000, sunsetColor, nightColor)
								);
					}
					tweenList.push(tween);
				}
				var gfTween = FlxTween.color(gf, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(FlxTween.color(gf, tweenTime / 1000, sunsetColor, nightColor));
				var bambiTween = FlxTween.color(dad, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(FlxTween.color(dad, tweenTime / 1000, sunsetColor, nightColor));
				bfTween = FlxTween.color(boyfriend, tweenTime / 1000, FlxColor.WHITE, sunsetColor, {
					onComplete: function(tween:FlxTween)
					{
						bfTween = FlxTween.color(boyfriend, tweenTime / 1000, sunsetColor, nightColor);
					}
				});
	
				tweenList.push(gfTween);
				tweenList.push(bambiTween);
				tweenList.push(bfTween);
			case 'rano':
				tweenTime = sectionStartTime(56);
				for (i in 0...backgroundSprites.members.length)
				{
					var bgSprite = backgroundSprites.members[i];
					var tween:FlxTween = null;
					switch (i)
					{
						case 0:
							tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000);
						case 1:
							tween = FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000));
						case 2:
							tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000));
						default:
							tween = FlxTween.color(bgSprite, tweenTime / 1000, nightColor, sunsetColor).then(
								FlxTween.color(bgSprite, tweenTime / 1000, sunsetColor, FlxColor.WHITE));
					}
					tweenList.push(tween);
				}
				var gfTween = FlxTween.color(gf, tweenTime / 1000, nightColor, sunsetColor).then(FlxTween.color(gf, tweenTime / 1000, sunsetColor, FlxColor.WHITE));
				var bambiTween = FlxTween.color(dad, tweenTime / 1000, nightColor, sunsetColor).then(FlxTween.color(dad, tweenTime / 1000, sunsetColor, FlxColor.WHITE));
				bfTween = FlxTween.color(boyfriend, tweenTime / 1000, nightColor, sunsetColor, {
					onComplete: function(tween:FlxTween)
					{
						bfTween = FlxTween.color(boyfriend, tweenTime / 1000, sunsetColor, FlxColor.WHITE);
					}
				});
				tweenList.push(gfTween);
				tweenList.push(bambiTween);
				tweenList.push(bfTween);
			case 'escape-from-california':
				tweenTime = sectionStartTime(52);
				for (i in 0...backgroundSprites.members.length)
				{
					var bgSprite = backgroundSprites.members[i];
					var tween:FlxTween = null;
					switch (i)
					{
						case 0:
							tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000);
						case 1:
							tween = FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000));
						case 2:
							tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000));
						default:
							tween = FlxTween.color(bgSprite, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(
								FlxTween.color(bgSprite, tweenTime / 1000, sunsetColor, nightColor)
								);
					}
					tweenList.push(tween);
				}
				var gfTween = FlxTween.color(gf, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(FlxTween.color(gf, tweenTime / 1000, sunsetColor, nightColor));
				var bambiTween = FlxTween.color(dad, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(FlxTween.color(dad, tweenTime / 1000, sunsetColor, nightColor));
				bfTween = FlxTween.color(boyfriend, tweenTime / 1000, FlxColor.WHITE, sunsetColor, {
					onComplete: function(tween:FlxTween)
					{
						bfTween = FlxTween.color(boyfriend, tweenTime / 1000, sunsetColor, nightColor);
					}
				});
	
				tweenList.push(gfTween);
				tweenList.push(bambiTween);
				tweenList.push(bfTween);
			
		}
		activateSunTweens = false;
		for (tween in tweenList)
		{
			tween.active = false;
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
		}

		if (formoverride == "none" || formoverride == "bf" || formoverride == SONG.player1)
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		else
		{
			if (darkLevels.contains(curStage) && formoverride == 'tristan-golden')
			{
				formoverride = 'tristan-golden-glowing';
			}
			boyfriend = new Boyfriend(770, 450, formoverride);
		}
		if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" || SONG.song.toLowerCase() == 'rano')
		{
			dad.color = nightColor;
			gf.color = nightColor;
			if (!formoverride.startsWith('tristan-golden')) {
			    boyfriend.color = nightColor;
			}
		}

		if (sunsetLevels.contains(curStage))
		{
			dad.color = sunsetColor;
			gf.color = sunsetColor;
			boyfriend.color = sunsetColor;
		}

		gfGroup.add(gf);
		dadGroup.add(dad);
		if (dadmirror != null)
		{
			dadGroup.add(dadmirror);
		}
		bfGroup.add(boyfriend);

		switch (stageCheck)
		{
			case 'desktop':
				dad.x -= 500;
				dad.y -= 100;
			case 'roof':
				dad.setPosition(-3, 467);
				boyfriend.setPosition(859, 343);
				gf.setPosition(232, -1);
			case 'rapBattle':
				dad.setPosition(430, 240);
				boyfriend.setPosition(1039, 263);
				gf.setPosition(756, 194);
			case 'farm' | 'farm-night'| 'farm-sunset':
				dad.x += 200;
			case 'house' | 'house-night' | 'house-sunset':
				dad.setPosition(50, 270);
				if (dadmirror != null)
				{
					dadmirror.setPosition(dad.x - 50, dad.y);
				}
				boyfriend.setPosition(843, 270);
				gf.setPosition(300, -60);
			case 'backyard':
				dad.setPosition(50, 300);
				boyfriend.setPosition(790, 300);
				gf.setPosition(500, -100);
			case 'festival':
				gf.x -= 200;
				boyfriend.x -= 200;
			case 'bedroom':
				dad.setPosition(-254, 577);
				boyfriend.setPosition(607, 786);
			case 'master':
				dad.setPosition(52, -166);
				boyfriend.setPosition(1152, 311);
				gf.setPosition(807, -22);
			case 'desert':
				dad.y -= 160;
				dad.x -= 350;
				boyfriend.x -= 275;
				boyfriend.y -= 160;
			case 'office':
				dad.flipX = !dad.flipX;
				boyfriend.flipX = !boyfriend.flipX;

				dad.setPosition(306, 50);
				boyfriend.setPosition(86, 100);
			case 'overdrive':
				dad.setPosition(244.15, 437);
				boyfriend.setPosition(837, 363);
			case 'exbungo-land':
				dad.setPosition(298, 131);
				boyfriend.setPosition(1332, 513);
				gf.setPosition(756, 206);
			case 'red-void':
				if (funnyFloatyBoys.contains(dad.curCharacter))
				{
					dad.y -= 70;
				}
		}

		switch (stageCheck)
		{
			case 'bedroom':
				if (FlxG.random.int(0, 99) == 0)
				{
					var ruby:BGSprite = new BGSprite('ruby', -697, 0, Paths.image('backgrounds/bedroom/ruby', 'shared'), null, 1, 1, true);
					backgroundSprites.add(ruby);
					add(ruby);	
				}
				var tv:BGSprite = new BGSprite('tv', -697, 955, Paths.image('backgrounds/bedroom/tv', 'shared'), null, 1.2, 1.2, true);
				backgroundSprites.add(tv);
				add(tv);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue, isStoryMode || localFunny == CharacterFunnyEffect.Recurser);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		UPSCROLL_Y = 50;
		DOWNSCROLL_Y = FlxG.height - 165;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (scrollType == 'downscroll')
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<StrumNote>();

		dadStrums = new FlxTypedGroup<StrumNote>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		//char repositioning
		repositionChar(dad);
		if (dadmirror != null)
		{
			repositionChar(dadmirror);
		}
		repositionChar(boyfriend);
		repositionChar(gf);

		var font:String = Paths.font("comic.ttf");
		var fontScaler:Int = 1;
	
		switch (SONG.song.toLowerCase())
		{
			case 'five-nights':
				font = Paths.font('fnaf.ttf');
				fontScaler = 2;
		}

		if (FlxG.save.data.songPosition && !isGreetingsCutscene && !['five-nights', 'overdrive'].contains(SONG.song.toLowerCase()))
		{
			var yPos = scrollType == 'downscroll' ? FlxG.height * 0.9 + 20 : strumLine.y - 20;

			songPosBG = new FlxSprite(0, yPos).loadGraphic(Paths.image('ui/timerBar'));
			songPosBG.antialiasing = true;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);
			
			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), Conductor, 
			'songPosition', 0, FlxG.sound.music.length);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.fromRGB(57, 255, 20));
			insert(members.indexOf(songPosBG), songPosBar);
			
			songName = new FlxText(songPosBG.x, songPosBG.y, 0, "", 32);
			songName.text = (barType == 'ShowTime' ? '0:00' : barType == 'SongName' ? SONG.song : '');
			songName.setFormat(font, 32 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			songName.scrollFactor.set();
			songName.borderSize = 2.5 * fontScaler;
			songName.antialiasing = true;
			if (barType == 'ShowTime')
			{
				songName.alpha = 0;
			}

			var xValues = CoolUtil.getMinAndMax(songName.width, songPosBG.width);
			var yValues = CoolUtil.getMinAndMax(songName.height, songPosBG.height);
			
			songName.x = songPosBG.x - ((xValues[0] - xValues[1]) / 2);
			songName.y = songPosBG.y + ((yValues[0] - yValues[1]) / 2);

			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		if (inFiveNights)
		{
			time = new FlxText(1175, 24, 0, '12 AM', 60);
			time.setFormat(Paths.font('fnaf.ttf'), 60, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			time.scrollFactor.set();
			time.antialiasing = false;
			time.borderSize = 2.5;
			time.cameras = [camHUD];
			add(time);

			night = new FlxText(1175, 70, 0, 'Night 7', 34);
			night.setFormat(Paths.font('fnaf.ttf'), 34, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			night.scrollFactor.set();
			night.antialiasing = false;
			night.borderSize = 2.5;
			night.cameras = [camHUD];
			add(night);

			powerLeftText = new FlxText(1100, 650, 0, 'Power Left: 100%', 34);
			powerLeftText.setFormat(Paths.font('fnaf.ttf'), 34, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			powerLeftText.scrollFactor.set();
			powerLeftText.antialiasing = false;
			powerLeftText.borderSize = 2;
			powerLeftText.cameras = [camHUD];
			add(powerLeftText);

			usage = new FlxText(1100, 685, 0, 'Usage: ', 34);
			usage.setFormat(Paths.font('fnaf.ttf'), 34, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			usage.scrollFactor.set();
			usage.antialiasing = false;
			usage.borderSize = 2;
			usage.cameras = [camHUD];
			add(usage);
			
			powerMeter = new FlxSprite(1170, 683).loadGraphic(Paths.image('fiveNights/powerMeter'));
			powerMeter.scrollFactor.set();
			powerMeter.cameras = [camHUD];
			add(powerMeter);
		}
		
		var healthBarPath = '';
		switch (SONG.song.toLowerCase())
		{
			case 'exploitation':
				healthBarPath = Paths.image('ui/HELLthBar');
			case 'overdrive':
				healthBarPath = Paths.image('ui/fnfengine');
			case 'five-nights':
				healthBarPath = Paths.image('ui/fnafengine');
			default:
				healthBarPath = Paths.image('ui/healthBar');
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(healthBarPath);
		if (scrollType == 'downscroll')
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.antialiasing = true;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, inFiveNights ? LEFT_TO_RIGHT : RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
		insert(members.indexOf(healthBarBG), healthBar);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae':
				credits = LanguageManager.getTextString('supernovae_credit');
			case 'glitch':
				credits = LanguageManager.getTextString('glitch_credit');
			case 'unfairness':
				credits = LanguageManager.getTextString('unfairness_credit');
			case 'cheating':
				credits = LanguageManager.getTextString('cheating_credit');
			case 'exploitation':
				credits = LanguageManager.getTextString('exploitation_credit') + " " + (FlxG.save.data.selfAwareness ? CoolSystemStuff.getUsername() : 'Boyfriend') + "!";
			case 'kabunga':
				credits = LanguageManager.getTextString('kabunga_credit');
			default:
				credits = '';
		}
		var creditsText:Bool = credits != '';
		var textYPos:Float = healthBarBG.y + 50;
		if (creditsText)
		{
			textYPos = healthBarBG.y + 30;
		}
		
		var funkyText:String;

		switch(SONG.song.toLowerCase())
		{
			case "exploitation":
				funkyText = SONG.song;
			case 'overdrive':
				funkyText = '';
			default:
				funkyText = SONG.song;
		}

		if (!isGreetingsCutscene)
		{
			kadeEngineWatermark = new FlxText(4, textYPos, 0, funkyText, 16);

			kadeEngineWatermark.setFormat(font, 16 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			kadeEngineWatermark.scrollFactor.set();
			kadeEngineWatermark.borderSize = 1.25 * fontScaler;
			kadeEngineWatermark.antialiasing = true;
			add(kadeEngineWatermark);
		}
		if (creditsText)
		{
			creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
			creditsWatermark.setFormat(font, 16 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsWatermark.scrollFactor.set();
			creditsWatermark.borderSize = 1.25 * fontScaler;
			creditsWatermark.antialiasing = true;
			add(creditsWatermark);
			creditsWatermark.cameras = [camHUD];
		}
		switch (curSong.toLowerCase())
		{
			case 'insanity':
				preload('backgrounds/void/redsky');
				preload('backgrounds/void/redsky_insanity');
			case 'polygonized':
				preload('characters/3d_bf');
				preload('characters/3d_gf');
			case 'maze':
				preload('spotLight');
			case 'shredder':
				preload('festival/bambi_shredder');
				for (asset in ['bambi_spot', 'boyfriend_spot', 'ch_highway'])
				{
					preload('festival/shredder/${asset}');
				}
			case 'interdimensional':
				preload('backgrounds/void/interdimensions/interdimensionVoid');
				preload('backgrounds/void/interdimensions/spike');
				preload('backgrounds/void/interdimensions/darkSpace');
				preload('backgrounds/void/interdimensions/hexagon');
				preload('backgrounds/void/interdimensions/nimbi/nimbiVoid');
				preload('backgrounds/void/interdimensions/nimbi/nimbi_land');
				preload('backgrounds/void/interdimensions/nimbi/nimbi');
			case 'mealie':
				preload('bambi/im_gonna_break_me_phone');
			case 'recursed':
				switch (boyfriend.curCharacter)
				{
					case 'dave':
						preload('recursed/characters/Dave_Recursed');
					case 'bambi-new':
						preload('recursed/characters/Bambi_Recursed');
					case 'tb-funny-man':
						preload('recursed/characters/STOP_LOOKING_AT_THE_FILES');
					case 'tristan' | 'tristan-golden':
						preload('recursed/characters/TristanRecursed');
					case 'dave-angey':
						preload('recursed/characters/Dave_3D_Recursed');
					default:
						preload('recursed/Recursed_BF');
				}
			case 'exploitation':
				preload('ui/glitch/glitchSwitch');
				preload('backgrounds/void/exploit/cheater GLITCH');
				preload('backgrounds/void/exploit/glitchyUnfairBG');
				preload('backgrounds/void/exploit/expunged_chains');
				preload('backgrounds/void/exploit/broken_expunged_chain');
				preload('backgrounds/void/exploit/glitchy_cheating_2');
			case 'bot-trot':
				preload('backgrounds/bedroom/night/bed');
				preload('backgrounds/bedroom/night/bg');
				preload('playrobot/playrobot_shadow');
			case 'escape-from-california':
				for (spr in ['1500miles', '1000miles', '500miles', 'welcomeToGeorgia', 'georgia'])
				{
					preload('california/$spr');
				}
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, FlxG.width, "", 20);
		scoreTxt.setFormat((SONG.song.toLowerCase() == "overdrive") ? Paths.font("ariblk.ttf") : font, 20 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5 * fontScaler;
		scoreTxt.antialiasing = true;
		scoreTxt.screenCenter(X);
		add(scoreTxt);

		if (inFiveNights)
		{
			iconP2 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, false);
			iconP2.y = healthBar.y - (iconP2.height / 2);
			add(iconP2);

			iconP1 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, true);
			iconP1.y = healthBar.y - (iconP1.height / 2);
			add(iconP1);
		}
		else
		{
			iconP1 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, true);
			iconP1.y = healthBar.y - (iconP1.height / 2);
			add(iconP1);

			iconP2 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, false);
			iconP2.y = healthBar.y - (iconP2.height / 2);
			add(iconP2);
		}
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		if (kadeEngineWatermark != null)
		{
			kadeEngineWatermark.cameras = [camHUD];
		}
		doof.cameras = [camDialogue];
		
		#if SHADERS_ENABLED
		if (SONG.song.toLowerCase() == 'kabunga' || localFunny == CharacterFunnyEffect.Exbungo) //i desperately wanted it so if you use downscroll it switches it to upscroll and flips the entire hud upside down but i never got to it
		{
			lazychartshader.waveAmplitude = 0.03;
			lazychartshader.waveFrequency = 5;
			lazychartshader.waveSpeed = 1;

			camHUD.filters = [new ShaderFilter(lazychartshader.shader)];
		}
		#end
		startingSong = true;
		if (startTimer != null && !startTimer.active)
		{
			startTimer.active = true;
		}
		if (isStoryMode || localFunny == CharacterFunnyEffect.Recurser)
		{
			if (hasDialogue)
			{
				schoolIntro(doof);
			}
			else
			{
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}
		
		subtitleManager = new SubtitleManager();
		subtitleManager.cameras = [camHUD];
		add(subtitleManager);

		exbungo_funny = FlxG.sound.load(Paths.sound('amen_' + FlxG.random.int(1, 6)));
		exbungo_funny.volume = 0.91;

		super.create();

		Transition.nextCamera = camTransition;
	}
	
	public function createBackgroundSprites(bgName:String, revertedBG:Bool):FlxTypedGroup<BGSprite>
	{
		var sprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
		var bgZoom:Float = 0.7;
		var stageName:String = '';
		switch (bgName)
		{
			case 'house' | 'house-night' | 'house-sunset':
				bgZoom = 0.8;
				
				var skyType:String = '';
				var assetType:String = '';
				switch (bgName)
				{
					case 'house':
						stageName = 'daveHouse';
						skyType = 'sky';
					case 'house-night':
						stageName = 'daveHouse_night';
						skyType = 'sky_night';
						assetType = 'night/';
					case 'house-sunset':
						stageName = 'daveHouse_sunset';
						skyType = 'sky_sunset';
				}
				var bg:BGSprite = new BGSprite('bg', -600, -300, Paths.image('backgrounds/shared/${skyType}'), null, 0.6, 0.6);
				sprites.add(bg);
				add(bg);
				
				var stageHills:BGSprite = new BGSprite('stageHills', -834, -159, Paths.image('backgrounds/dave-house/${assetType}hills'), null, 0.7, 0.7);
				sprites.add(stageHills);
				add(stageHills);

				var grassbg:BGSprite = new BGSprite('grassbg', -1205, 580, Paths.image('backgrounds/dave-house/${assetType}grass bg'), null);
				sprites.add(grassbg);
				add(grassbg);
	
				var gate:BGSprite = new BGSprite('gate', -755, 250, Paths.image('backgrounds/dave-house/${assetType}gate'), null);
				sprites.add(gate);
				add(gate);
	
				var stageFront:BGSprite = new BGSprite('stageFront', -832, 505, Paths.image('backgrounds/dave-house/${assetType}grass'), null);
				sprites.add(stageFront);
				add(stageFront);

				if (SONG.song.toLowerCase() == 'insanity' || localFunny == CharacterFunnyEffect.Recurser)
				{
					var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/void/redsky_insanity'), null, 1, 1, true, true);
					bg.alpha = 0.75;
					bg.visible = false;
					add(bg);
					// below code assumes shaders are always enabled which is bad
					voidShader(bg);
				}

				var variantColor = getBackgroundColor(stageName);
				if (stageName != 'daveHouse_night')
				{
					stageHills.color = variantColor;
					grassbg.color = variantColor;
					gate.color = variantColor;
					stageFront.color = variantColor;
				}
			case 'inside-house':
				bgZoom = 0.6;
				stageName = 'insideHouse';

				var bg:BGSprite = new BGSprite('bg', -1000, -350, Paths.image('backgrounds/inside_house'), null);
				sprites.add(bg);
				add(bg);

			case 'farm' | 'farm-night' | 'farm-sunset':
				bgZoom = 0.8;

				switch (bgName.toLowerCase())
				{
					case 'farm-night':
						stageName = 'bambiFarmNight';
					case 'farm-sunset':
						stageName = 'bambiFarmSunset';
					default:
						stageName = 'bambiFarm';
				}
	
				var skyType:String = stageName == 'bambiFarmNight' ? 'sky_night' : stageName == 'bambiFarmSunset' ? 'sky_sunset' : 'sky';
				
				var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/shared/' + skyType), null, 0.6, 0.6);
				sprites.add(bg);
				add(bg);

				if (SONG.song.toLowerCase() == 'maze')
				{
					var sunsetBG:BGSprite = new BGSprite('sunsetBG', -600, -200, Paths.image('backgrounds/shared/sky_sunset'), null, 0.6, 0.6);
					sunsetBG.alpha = 0;
					sprites.add(sunsetBG);
					add(sunsetBG);

					var nightBG:BGSprite = new BGSprite('nightBG', -600, -200, Paths.image('backgrounds/shared/sky_night'), null, 0.6, 0.6);
					nightBG.alpha = 0;
					sprites.add(nightBG);
					add(nightBG);
					if (isStoryMode)
					{
						health -= 0.2;
					}
				}
				var flatgrass:BGSprite = new BGSprite('flatgrass', 350, 75, Paths.image('backgrounds/farm/gm_flatgrass'), null, 0.65, 0.65);
				flatgrass.setGraphicSize(Std.int(flatgrass.width * 0.34));
				flatgrass.updateHitbox();
				sprites.add(flatgrass);
				
				var hills:BGSprite = new BGSprite('hills', -173, 100, Paths.image('backgrounds/farm/orangey hills'), null, 0.65, 0.65);
				sprites.add(hills);
				
				var farmHouse:BGSprite = new BGSprite('farmHouse', 100, 125, Paths.image('backgrounds/farm/funfarmhouse', 'shared'), null, 0.7, 0.7);
				farmHouse.setGraphicSize(Std.int(farmHouse.width * 0.9));
				farmHouse.updateHitbox();
				sprites.add(farmHouse);

				var grassLand:BGSprite = new BGSprite('grassLand', -600, 500, Paths.image('backgrounds/farm/grass lands', 'shared'), null);
				sprites.add(grassLand);

				var cornFence:BGSprite = new BGSprite('cornFence', -400, 200, Paths.image('backgrounds/farm/cornFence', 'shared'), null);
				sprites.add(cornFence);
				
				var cornFence2:BGSprite = new BGSprite('cornFence2', 1100, 200, Paths.image('backgrounds/farm/cornFence2', 'shared'), null);
				sprites.add(cornFence2);

				var bagType = FlxG.random.int(0, 1000) == 0 ? 'popeye' : 'cornbag';
				var cornBag:BGSprite = new BGSprite('cornFence2', 1200, 550, Paths.image('backgrounds/farm/$bagType', 'shared'), null);
				sprites.add(cornBag);
				
				var sign:BGSprite = new BGSprite('sign', 0, 350, Paths.image('backgrounds/farm/sign', 'shared'), null);
				sprites.add(sign);

				var variantColor:FlxColor = getBackgroundColor(stageName);
				
				flatgrass.color = variantColor;
				hills.color = variantColor;
				farmHouse.color = variantColor;
				grassLand.color = variantColor;
				cornFence.color = variantColor;
				cornFence2.color = variantColor;
				cornBag.color = variantColor;
				sign.color = variantColor;
				
				add(flatgrass);
				add(hills);
				add(farmHouse);
				add(grassLand);
				add(cornFence);
				add(cornFence2);
				add(cornBag);
				add(sign);

				if (['blocked', 'corn-theft', 'maze', 'mealie', 'indignancy'].contains(SONG.song.toLowerCase()) && !MathGameState.failedGame && FlxG.random.int(0, 4) == 0)
				{
					FlxG.mouse.visible = true;
					baldi = new BGSprite('baldi', 400, 110, Paths.image('backgrounds/farm/baldo', 'shared'), null, 0.65, 0.65);
					baldi.setGraphicSize(Std.int(baldi.width * 0.31));
					baldi.updateHitbox();
					baldi.color = variantColor;
					sprites.insert(members.indexOf(hills), baldi);
					insert(members.indexOf(hills), baldi);
				}

				if (SONG.song.toLowerCase() == 'splitathon')
				{
					var picnic:BGSprite = new BGSprite('picnic', 1050, 650, Paths.image('backgrounds/farm/picnic_towel_thing', 'shared'), null);
					sprites.insert(sprites.members.indexOf(cornBag), picnic);
					picnic.color = variantColor;
					insert(members.indexOf(cornBag), picnic);
				}
			case 'festival':
				bgZoom = 0.7;
				stageName = 'festival';
				
				var mainChars:Array<Dynamic> = null;
				switch (SONG.song.toLowerCase())
				{
					case 'shredder':
						mainChars = [
							//char name, prefix, size, x, y, flip x
							['dave', 'idle', 0.8, 175, 100],
							['tristan', 'bop', 0.4, 800, 325]
						];
					case 'greetings':
						if (isGreetingsCutscene)
						{
							mainChars = [
								['bambi', 'bambi idle', 0.9, 400, 350],
								['tristan', 'bop', 0.4, 800, 325]
							];
						}
						else
						{
							mainChars = [
								['dave', 'idle', 0.8, 175, 100],
								['bambi', 'bambi idle', 0.9, 700, 350],
							];
						}
					case 'interdimensional':
						mainChars = [
							['bambi', 'bambi idle', 0.9, 400, 350],
							['tristan', 'bop', 0.4, 800, 325]
						];
				}
				var bg:BGSprite = new BGSprite('bg', -600, -230, Paths.image('backgrounds/shared/sky_festival'), null, 0.6, 0.6);
				sprites.add(bg);
				add(bg);

				var flatGrass:BGSprite = new BGSprite('flatGrass', 800, -100, Paths.image('backgrounds/festival/gm_flatgrass'), null, 0.7, 0.7);
				sprites.add(flatGrass);
				add(flatGrass);

				var farmHouse:BGSprite = new BGSprite('farmHouse', -300, -150, Paths.image('backgrounds/festival/farmHouse'), null, 0.7, 0.7);
				sprites.add(farmHouse);
				add(farmHouse);
				
				var hills:BGSprite = new BGSprite('hills', -1000, -100, Paths.image('backgrounds/festival/hills'), null, 0.7, 0.7);
				sprites.add(hills);
				add(hills);

				var corn:BGSprite = new BGSprite('corn', -1000, 120, 'backgrounds/festival/corn', [
					new Animation('corn', 'idle', 5, true, [false, false])
				], 0.85, 0.85, true, true);
				corn.animation.play('corn');
				sprites.add(corn);
				add(corn);

				var cornGlow:BGSprite = new BGSprite('cornGlow', -1000, 120, 'backgrounds/festival/cornGlow', [
					new Animation('cornGlow', 'idle', 5, true, [false, false])
				], 0.85, 0.85, true, true);
				cornGlow.blend = BlendMode.ADD;
				cornGlow.animation.play('cornGlow');
				sprites.add(cornGlow);
				add(cornGlow);
				
				var backGrass:BGSprite = new BGSprite('backGrass', -1000, 475, Paths.image('backgrounds/festival/backGrass'), null, 0.85, 0.85);
				sprites.add(backGrass);
				add(backGrass);
				
				var crowd = new BGSprite('crowd', -500, -150, 'backgrounds/festival/crowd', [
					new Animation('idle', 'crowdDance', 24, true, [false, false])
				], 0.85, 0.85, true, true);
				crowd.animation.play('idle');
				sprites.add(crowd);
				crowdPeople.add(crowd);
				add(crowd);
				
				for (i in 0...mainChars.length)
				{					
					var crowdChar = new BGSprite(mainChars[i][0], mainChars[i][3], mainChars[i][4], 'backgrounds/festival/mainCrowd/${mainChars[i][0]}', [
						new Animation('idle', mainChars[i][1], 24, false, [false, false], null)
					], 0.85, 0.85, true, true);
					crowdChar.setGraphicSize(Std.int(crowdChar.width * mainChars[i][2]));
					crowdChar.updateHitbox();
					sprites.add(crowdChar);
					crowdPeople.add(crowdChar);
					add(crowdChar);
				}
				
				var frontGrass:BGSprite = new BGSprite('frontGrass', -1300, 600, Paths.image('backgrounds/festival/frontGrass'), null, 1, 1);
				sprites.add(frontGrass);
				add(frontGrass);

				var stageGlow:BGSprite = new BGSprite('stageGlow', -450, 300, 'backgrounds/festival/generalGlow', [
					new Animation('glow', 'idle', 5, true, [false, false])
				], 0, 0, true, true);
				stageGlow.blend = BlendMode.ADD;
				stageGlow.animation.play('glow');
				sprites.add(stageGlow);
				add(stageGlow);

			case 'backyard':
				bgZoom = 0.7;
				stageName = 'backyard';

				var festivalSky:BGSprite = new BGSprite('bg', -600, -400, Paths.image('backgrounds/shared/sky_festival'), null, 0.6, 0.6);
				sprites.add(festivalSky);
				add(festivalSky);

				if (SONG.song.toLowerCase() == 'rano')
				{
					var sunriseBG:BGSprite = new BGSprite('sunriseBG', -600, -400, Paths.image('backgrounds/shared/sky_sunrise'), null, 0.6, 0.6);
					sunriseBG.alpha = 0;
					sprites.add(sunriseBG);
					add(sunriseBG);

					var skyBG:BGSprite = new BGSprite('bg', -600, -400, Paths.image('backgrounds/shared/sky'), null, 0.6, 0.6);
					skyBG.alpha = 0;
					sprites.add(skyBG);
					add(skyBG);
				}

				var hills:BGSprite = new BGSprite('hills', -1330, -432, Paths.image('backgrounds/backyard/hills', 'shared'), null, 0.75, 0.75, true);
				sprites.add(hills);
				add(hills);

				var grass:BGSprite = new BGSprite('grass', -800, 150, Paths.image('backgrounds/backyard/supergrass', 'shared'), null, 1, 1, true);
				sprites.add(grass);
				add(grass);

				var gates:BGSprite = new BGSprite('gates', 564, -33, Paths.image('backgrounds/backyard/gates', 'shared'), null, 1, 1, true);
				sprites.add(gates);
				add(gates);
				
				var bear:BGSprite = new BGSprite('bear', -1035, -710, Paths.image('backgrounds/backyard/bearDude', 'shared'), null, 0.95, 0.95, true);
				sprites.add(bear);
				add(bear);

				var house:BGSprite = new BGSprite('house', -1025, -323, Paths.image('backgrounds/backyard/house', 'shared'), null, 0.95, 0.95, true);
				sprites.add(house);
				add(house);

				var grill:BGSprite = new BGSprite('grill', -489, 452, Paths.image('backgrounds/backyard/grill', 'shared'), null, 0.95, 0.95, true);
				sprites.add(grill);
				add(grill);

				var variantColor = getBackgroundColor(stageName);

				hills.color = variantColor;
				bear.color = variantColor;
				grass.color = variantColor;
				gates.color = variantColor;
				house.color = variantColor;
				grill.color = variantColor;
			case 'desktop':
				bgZoom = 0.5;
				stageName = 'desktop';

				expungedBG = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
				expungedBG.setPosition(0, 200);
				expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
				expungedBG.scrollFactor.set();
				expungedBG.antialiasing = false;
				sprites.add(expungedBG);
				add(expungedBG);
				voidShader(expungedBG);
			case 'red-void' | 'green-void' | 'glitchy-void':
				bgZoom = 0.7;

				var bg:BGSprite = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				
				switch (bgName.toLowerCase())
				{
					case 'red-void':
						bgZoom = 0.8;
						bg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
						stageName = 'daveEvilHouse';
					case 'green-void':
						stageName = 'cheating';
						bg.loadGraphic(Paths.image('backgrounds/void/cheater'));
						bg.setPosition(-700, -350);
						bg.setGraphicSize(Std.int(bg.width * 2));
					case 'glitchy-void':
						bg.loadGraphic(Paths.image('backgrounds/void/scarybg'));
						bg.setPosition(0, 200);
						bg.setGraphicSize(Std.int(bg.width * 3));
						stageName = 'unfairness';
				}
				sprites.add(bg);
				add(bg);
				voidShader(bg);
			case 'interdimension-void':
				bgZoom = 0.6;
				stageName = 'interdimension';

				var bg:BGSprite = new BGSprite('void', -700, -350, Paths.image('backgrounds/void/interdimensions/interdimensionVoid'), null, 1, 1, false, true);
				bg.setGraphicSize(Std.int(bg.width * 1.75));
				sprites.add(bg);
				add(bg);

				voidShader(bg);
				
				interdimensionBG = bg;

				for (char in ['ball', 'bimpe', 'maldo', 'memes kids', 'muko', 'ruby man', 'tristan', 'bambi'])
				{
					var bgChar = new FlyingBGChar(char, Paths.image('backgrounds/festival/scaredCrowd/$char'));
					sprites.add(bgChar);
					flyingBgChars.add(bgChar);
				}
				add(flyingBgChars);
			case 'exbungo-land':
				bgZoom = 0.7;
				stageName = 'kabunga';
				
				var bg:BGSprite = new BGSprite('bg', -320, -160, Paths.image('backgrounds/void/exbongo/Exbongo'), null, 1, 1, true, true);
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				sprites.add(bg);
				add(bg);

				var circle:BGSprite = new BGSprite('circle', -30, 550, Paths.image('backgrounds/void/exbongo/Circle'), null);
				sprites.add(circle);	
				add(circle);

				place = new BGSprite('place', 860, -15, Paths.image('backgrounds/void/exbongo/Place'), null);
				sprites.add(place);	
				add(place);
				
				voidShader(bg);
			case 'rapBattle':
				bgZoom = 1;
				stageName = 'rapLand';

				var bg:BGSprite = new BGSprite('rapBG', -640, -360, Paths.image('backgrounds/rapBattle'), null);
				sprites.add(bg);
				add(bg);
			case 'freeplay':
				bgZoom = 0.4;
				stageName = 'freeplay';
				
				darkSky = new BGSprite('darkSky', darkSkyStartPos, 0, Paths.image('recursed/darkSky'), null, 1, 1, true);
				darkSky.scale.set((1 / bgZoom) * 2, 1 / bgZoom);
				darkSky.updateHitbox();
				darkSky.y = (FlxG.height - darkSky.height) / 2;
				add(darkSky);
				
				darkSky2 = new BGSprite('darkSky', darkSky.x - darkSky.width, 0, Paths.image('recursed/darkSky'), null, 1, 1, true);
				darkSky2.scale.set((1 / bgZoom) * 2, 1 / bgZoom);
				darkSky2.updateHitbox();
				darkSky2.x = darkSky.x - darkSky.width;
				darkSky2.y = (FlxG.height - darkSky2.height) / 2;
				add(darkSky2);

				freeplayBG = new BGSprite('freeplay', 0, 0, daveBG, null, 0, 0, true);
				freeplayBG.setGraphicSize(Std.int(freeplayBG.width * 2));
				freeplayBG.updateHitbox();
				freeplayBG.screenCenter();
				freeplayBG.color = FlxColor.multiply(0xFF4965FF, FlxColor.fromRGB(44, 44, 44));
				freeplayBG.alpha = 0;
				add(freeplayBG);

				initAlphabet(daveSongs);
			case 'roof':
				bgZoom = 0.8;
				stageName = 'roof';
				var roof:BGSprite = new BGSprite('roof', -584, -397, Paths.image('backgrounds/gm_house5', 'shared'), null, 1, 1, true);
				roof.setGraphicSize(Std.int(roof.width * 2));
				roof.antialiasing = false;
				add(roof);
			case 'bedroom':
				bgZoom = 0.8;
				stageName = 'bedroom';
				
				var sky:BGSprite = new BGSprite('nightSky', -285, 318, Paths.image('backgrounds/bedroom/sky', 'shared'), null, 0.8, 0.8, true);
				sprites.add(sky);
				add(sky);

				var bg:BGSprite = new BGSprite('bg', -687, 0, Paths.image('backgrounds/bedroom/bg', 'shared'), null, 1, 1, true);
				sprites.add(bg);
				add(bg);

				var baldi:BGSprite = new BGSprite('baldi', 788, 788, Paths.image('backgrounds/bedroom/bed', 'shared'), null, 1, 1, true);
				sprites.add(baldi);
				add(baldi);

				tristanInBotTrot = new BGSprite('tristan', 888, 688, 'backgrounds/bedroom/TristanSitting', [
					new Animation('idle', 'daytime', 24, true, [false, false]),
					new Animation('idleNight', 'nighttime', 24, true, [false, false])
				], 1, 1, true, true);
				tristanInBotTrot.setGraphicSize(Std.int(tristanInBotTrot.width * 0.8));
				tristanInBotTrot.animation.play('idle');
				add(tristanInBotTrot);
				if (formoverride == 'tristan' || formoverride == 'tristan-golden' || formoverride == 'tristan-golden-glowing') {
					remove(tristanInBotTrot);	
			    }
			case 'office':
				bgZoom = 0.9;
				stageName = 'office';
				
				var backFloor:BGSprite = new BGSprite('backFloor', -500, -310, Paths.image('backgrounds/office/backFloor'), null, 1, 1);
				sprites.add(backFloor);
				add(backFloor);
			case 'desert':
				bgZoom = 0.5;
				stageName = 'desert';

				var bg:BGSprite = new BGSprite('bg', -900, -400, Paths.image('backgrounds/shared/sky'), null, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				sprites.add(bg);
				add(bg);

				var sunsetBG:BGSprite = new BGSprite('sunsetBG', -900, -400, Paths.image('backgrounds/shared/sky_sunset'), null, 0.2, 0.2);
				sunsetBG.setGraphicSize(Std.int(sunsetBG.width * 2));
				sunsetBG.updateHitbox();
				sunsetBG.alpha = 0;
				sprites.add(sunsetBG);
				add(sunsetBG);
				
				var nightBG:BGSprite = new BGSprite('nightBG', -900, -400, Paths.image('backgrounds/shared/sky_night'), null, 0.2, 0.2);
				nightBG.setGraphicSize(Std.int(nightBG.width * 2));
				nightBG.updateHitbox();
				nightBG.alpha = 0;
				sprites.add(nightBG);
				add(nightBG);
				
				desertBG = new BGSprite('desert', -786, -500, Paths.image('backgrounds/wedcape_from_cali_backlground', 'shared'), null, 1, 1, true);
				desertBG.setGraphicSize(Std.int(desertBG.width * 1.2));
				desertBG.updateHitbox();
				sprites.add(desertBG);
				add(desertBG);

				desertBG2 = new BGSprite('desert2', desertBG.x - desertBG.width, desertBG.y, Paths.image('backgrounds/wedcape_from_cali_backlground', 'shared'), null, 1, 1, true);
				desertBG2.setGraphicSize(Std.int(desertBG2.width * 1.2));
				desertBG2.updateHitbox();
				sprites.add(desertBG2);
				add(desertBG2);
				
				sign = new BGSprite('sign', 500, 450, Paths.image('california/leavingCalifornia', 'shared'), null, 1, 1, true);
				sprites.add(sign);
				add(sign);

				train = new BGSprite('train', -800, 500, 'california/train', [
					new Animation('idle', 'trainRide', 24, true, [false, false])
				], 1, 1, true, true);
				train.animation.play('idle');
				train.setGraphicSize(Std.int(train.width * 2.5));
				train.updateHitbox();
				train.antialiasing = false;
				sprites.add(train);
				add(train);
			case 'master':
				bgZoom = 0.4;
				stageName = 'master';

				var space:BGSprite = new BGSprite('space', -1724, -971, Paths.image('backgrounds/shared/sky_space'), null, 1.2, 1.2);
				space.setGraphicSize(Std.int(space.width * 10));
				space.antialiasing = false;
				sprites.add(space);
				add(space);
	
				var land:BGSprite = new BGSprite('land', 675, 555, Paths.image('backgrounds/dave-house/land'), null, 0.9, 0.9);
				sprites.add(land);
				add(land);
			case 'overdrive':
				bgZoom = 0.8;
				stageName = 'overdrive';

				var stfu:BGSprite = new BGSprite('stfu', -583, -383, Paths.image('backgrounds/stfu'), null, 1, 1);
				sprites.add(stfu);
				add(stfu);
			default:
				bgZoom = 0.9;
				stageName = 'stage';

				var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/stage/stageback'), null, 0.9, 0.9);
				sprites.add(bg);
				add(bg);
	
				var stageFront:BGSprite = new BGSprite('stageFront', -650, 600, Paths.image('backgrounds/stage/stagefront'), null, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				sprites.add(stageFront);
				add(stageFront);
	
				var stageCurtains:BGSprite = new BGSprite('stageCurtains', -500, -300, Paths.image('backgrounds/stage/stagecurtains'), null, 1.3, 1.3);
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				sprites.add(stageCurtains);
				add(stageCurtains);
		}
		if (!revertedBG)
		{
			defaultCamZoom = bgZoom;
			curStage = stageName;
		}

		return sprites;
	}
	public function getBackgroundColor(stage:String):FlxColor
	{
		var variantColor:FlxColor = FlxColor.WHITE;
		switch (stage)
		{
			case 'bambiFarmNight' | 'daveHouse_night' | 'backyard' | 'bedroomNight':
				variantColor = nightColor;
			case 'bambiFarmSunset' | 'daveHouse_sunset':
				variantColor = sunsetColor;
			default:
				variantColor = FlxColor.WHITE;
		}
		return variantColor;
	}

	function schoolIntro(?dialogueBox:DialogueBox, isStart:Bool = true):Void
	{
		inCutscene = true;
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x - 200, dad.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var stupidBasics:Float = 1;
		if (isStart)
		{
			FlxTween.tween(black, {alpha: 0}, stupidBasics);
		}
		else
		{
			black.alpha = 0;
			stupidBasics = 0;
		}
		new FlxTimer().start(stupidBasics, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox != null)
			{
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function voidShader(background:BGSprite)
	{
		#if SHADERS_ENABLED
		var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
		testshader.waveAmplitude = 0.1;
		testshader.waveFrequency = 5;
		testshader.waveSpeed = 2;
		
		background.shader = testshader.shader;
		#end
		curbg = background;
	}
	function changeInterdimensionBg(type:String)
	{
		for (sprite in backgroundSprites)
		{
			backgroundSprites.remove(sprite);
			remove(sprite);
		}
		interdimensionBG = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
		backgroundSprites.add(interdimensionBG);
		add(interdimensionBG);
		switch (type)
		{
			case 'interdimension-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/interdimensionVoid'));
				interdimensionBG.setPosition(-700, -350);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 1.75));
			case 'spike-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/spike'));
				interdimensionBG.setPosition(-200, 0);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 3));
			case 'darkSpace':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/darkSpace'));
				interdimensionBG.setPosition(-200, 0);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 2.75));
			case 'hexagon-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/hexagon'));
				interdimensionBG.setPosition(-200, 0);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 3));
			case 'nimbi-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/nimbi/nimbiVoid'));
				interdimensionBG.setPosition(-200, 0);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 2.75));

				nimbiLand = new BGSprite('nimbiLand', 200, 100, Paths.image('backgrounds/void/interdimensions/nimbi/nimbi_land'), null, 1, 1, false, true);
				backgroundSprites.add(nimbiLand);
				nimbiLand.setGraphicSize(Std.int(nimbiLand.width * 1.5));
				insert(members.indexOf(flyingBgChars), nimbiLand);

				nimbiSign = new BGSprite('sign', 800, -73, Paths.image('backgrounds/void/interdimensions/nimbi/sign'), null, 1, 1, false, true);
				backgroundSprites.add(nimbiSign);
				nimbiSign.setGraphicSize(Std.int(nimbiSign.width * 0.2));
				insert(members.indexOf(flyingBgChars), nimbiSign);
		}
		voidShader(interdimensionBG);
	}
	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;
		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle', true);
			crowdPeople.forEach(function(crowdPerson:BGSprite)
			{
				crowdPerson.animation.play('idle', true);
			});

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			var introSoundAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			var soundAssetsAlt:Array<String> = new Array<String>();

			if (SONG.song.toLowerCase() == "exploitation")
				introAssets.set('default', ['ui/ready', "ui/set", "ui/go_glitch"]);
			else if (SONG.song.toLowerCase() == "overdrive")
				introAssets.set('default', ['ui/spr_start_sprites_0', "ui/spr_start_sprites_1", "ui/spr_start_sprites_2"]);
			else
				introAssets.set('default', ['ui/ready', "ui/set", "ui/go"]);

			introSoundAssets.set('default', ['default/intro3', 'default/intro2', 'default/intro1', 'default/introGo']);
			introSoundAssets.set('pixel', ['pixel/intro3-pixel', 'pixel/intro2-pixel', 'pixel/intro1-pixel', 'pixel/introGo-pixel']);
			introSoundAssets.set('dave', ['dave/intro3_dave', 'dave/intro2_dave', 'dave/intro1_dave', 'dave/introGo_dave']);
			introSoundAssets.set('bambi', ['bambi/intro3_bambi', 'bambi/intro2_bambi', 'bambi/intro1_bambi', 'bambi/introGo_bambi']);
			introSoundAssets.set('ex', ['default/intro3', 'default/intro2', 'default/intro1', 'ex/introGo_weird']);
			introSoundAssets.set('overdriving', ['dave/intro1_dave', 'dave/intro2_dave', 'dave/intro3_dave', 'dave/introGo_dave']);

			switch (SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'polygonized' | 'bonus-song' | 'interdimensional' | 'five-nights' |
				'memory' | 'vs-dave-rap' | 'vs-dave-rap-two':
					soundAssetsAlt = introSoundAssets.get('dave');
				case 'blocked' | 'cheating' | 'corn-theft' | 'glitch' | 'maze' | 'mealie' | 'secret' |
				'shredder' | 'supernovae' | 'unfairness':
					soundAssetsAlt = introSoundAssets.get('bambi');
				case 'exploitation':
					soundAssetsAlt = introSoundAssets.get('ex');
				case 'overdrive':
					soundAssetsAlt = introSoundAssets.get('overdriving');	
				default:
					soundAssetsAlt = introSoundAssets.get('default');
			}

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			var doing_funny:Bool = true;

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[0]), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = false;
						ZoomCam(false);
					}
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();
					ready.antialiasing = true;

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[1]), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
			
					set.screenCenter();

					set.antialiasing = true;
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[2]), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = false;
						ZoomCam(false);
					}
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					go.updateHitbox();

					go.screenCenter();

					go.antialiasing = true;
					add(go);

					var sex:Float = 1000;

					if (SONG.song.toLowerCase() == "exploitation")
					{
						sex = 300;
					}

					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / sex, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[3]), 0.6);

					if (doing_funny)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}
				case 4:
					if (!isGreetingsCutscene)
					{
						creditsPopup = new CreditsPopUp(FlxG.width, 200);
						creditsPopup.camera = camHUD;
						creditsPopup.scrollFactor.set();
						creditsPopup.x = creditsPopup.width * -1;
						add(creditsPopup);
	
						FlxTween.tween(creditsPopup, {x: 0}, 0.5, {ease: FlxEase.backOut, onComplete: function(tweeen:FlxTween)
						{
							FlxTween.tween(creditsPopup, {x: creditsPopup.width * -1} , 1, {ease: FlxEase.backIn, onComplete: function(tween:FlxTween)
							{
								creditsPopup.destroy();
							}, startDelay: 3});
						}});
					}
					if (['polygonized', 'interdimensional', 'five-nights'].contains(SONG.song.toLowerCase()) && localFunny != CharacterFunnyEffect.Recurser)
					{
						var shapeNoteWarning = new FlxSprite(0, FlxG.height * 2).loadGraphic(Paths.image(!inFiveNights ? 'ui/shapeNoteWarning' : 'ui/doorWarning'));
						shapeNoteWarning.cameras = [camHUD];
						shapeNoteWarning.scrollFactor.set();
						shapeNoteWarning.antialiasing = false;
						shapeNoteWarning.alpha = 0;
						add(shapeNoteWarning);

						FlxTween.tween(shapeNoteWarning, {alpha: 1}, 1);
						FlxTween.tween(shapeNoteWarning, {y: 450}, 1, {ease: FlxEase.backOut, 
							onComplete: function(tween:FlxTween)
							{
								new FlxTimer().start(2, function(timer:FlxTimer)
								{
									FlxTween.tween(shapeNoteWarning, {alpha: 0}, 1);
									FlxTween.tween(shapeNoteWarning, {y: FlxG.height * 2}, 1, {
										ease: FlxEase.backIn,
										onComplete: function(tween:FlxTween)
										{
											remove(shapeNoteWarning);
										}
									});
								});
							}
						});
					}
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
			vocals.play();
		}
		for (tween in tweenList)
		{
			tween.active = true;
		}
		activateSunTweens = true;

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		FlxG.sound.music.onComplete = endSong;
		if (songPosBar != null)
		{
			songPosBar.setRange(0, FlxG.sound.music.length);
		}
		if (songName != null && barType == 'ShowTime')
		{
			FlxTween.tween(songName, {alpha: 1}, 1);
		}
		switch (SONG.song.toLowerCase())
		{
			case 'escape-from-california':
				dad.canSing = false;
				dad.canDance = false;
				dad.playAnim('helpMe', true);
				dad.animation.finishCallback = function(anim:String)
				{
					dad.canSing = true;
					dad.canDance = true;
				}
				FlxTween.num(0, 30, 2, {}, function(newValue:Float)
				{
					trainSpeed = newValue;
					train.animation.curAnim.frameRate = Std.int(FlxMath.lerp(0, 24, (trainSpeed / 30)));
				});
			case 'exploitation':
				blackScreen = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				blackScreen.cameras = [camHUD];
				blackScreen.screenCenter();
				blackScreen.scrollFactor.set();
				blackScreen.alpha = 0;
				add(blackScreen);
			case 'vs-dave-rap' | 'vs-dave-rap-two':
				FlxTween.tween(blackScreen, {alpha: 0}, 3, {onComplete: function(tween:FlxTween)
				{
					remove(blackScreen);
				}});
			case 'five-nights':
				FlxG.mouse.visible = true;
			case 'greetings':
				if (isGreetingsCutscene)
				{
					generatedMusic = false;
					vocals.stop();
					vocals.volume = 0;
					FlxG.sound.music.onComplete = null;
					FlxG.sound.music.stop();
					for (note in unspawnNotes)
					{
						unspawnNotes.remove(note);
					}
					greetingsCutscene();
				}
			case 'indignancy':
				vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
				vignette.screenCenter();
				vignette.scrollFactor.set();
				vignette.cameras = [camHUD];
				vignette.alpha = 0;
				add(vignette);
				FlxTween.tween(vignette, {alpha: 0.7}, 1);
		}
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song, localFunny == CharacterFunnyEffect.Tristan ? "-Tristan" : ""));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		for (section in noteData)
		{
			var sectionCount = noteData.indexOf(section);

			var isGuitarSection = (sectionCount >= 64 && sectionCount < 80) && SONG.song.toLowerCase() == 'shredder'; //wtf

			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % (isGuitarSection ? 5 : 4));
				var OGNoteDat = daNoteData;
				if (localFunny == CharacterFunnyEffect.Bambi)
				{
					daNoteData = 2;
				}
				var daNoteStyle:String = songNotes[3];
				if (localFunny == CharacterFunnyEffect.Recurser)
				{
					daNoteStyle = 'normal';
				}

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > (isGuitarSection ? 4 : 3))
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, gottaHitNote, daNoteStyle, false, isGuitarSection);
				swagNote.originalType = OGNoteDat;
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
						gottaHitNote, daNoteStyle, false, isGuitarSection);
					sustainNote.originalType = OGNoteDat;
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;
				}

				swagNote.mustPress = gottaHitNote;
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int, regenerate:Bool = false, fadeIn:Bool = true):Void
	{
		var note_order:Array<Int> = [0,1,2,3];
		if (localFunny == CharacterFunnyEffect.Bambi)
		{
			note_order = [2,2,2,2];
		}
		else if (localFunny == CharacterFunnyEffect.Tristan)
		{
			note_order = [0,3,2,1];
		}
		for (i in 0...4)
		{
			var arrowType:Int = note_order[i];
			var strumType:String = '';
			if ((funnyFloatyBoys.contains(dad.curCharacter) || dad.curCharacter == "nofriend") && player == 0 || funnyFloatyBoys.contains(boyfriend.curCharacter) && player == 1)
			{
				strumType = '3D';
			}
			else
			{
				switch (curStage)
				{
					default:
						if (SONG.song.toLowerCase() == "overdrive")
							strumType = 'top10awesome';
				}
			}
			if (pressingKey5Global)
			{
				strumType = 'shape';
			}
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, strumType, arrowType, player == 1);

			if (!isStoryMode && fadeIn)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			babyArrow.x += Note.swagWidth * Math.abs(i);
			babyArrow.x += 78 + 78 / playerStrumAmount;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			babyArrow.baseX = babyArrow.x;
			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				dadStrums.add(babyArrow);
			}
			strumLineNotes.add(babyArrow);
		}
	}
	function generateGhNotes(player:Int)
	{
		for (i in 0...5)
		{
			var arrowType:Int = i;
			if (localFunny == CharacterFunnyEffect.Bambi)
			{
				arrowType = 2;
			}
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, 'gh', i, false);

			babyArrow.x += Note.swagWidth * Math.abs(i);
			babyArrow.x += 78;
			babyArrow.baseX = babyArrow.x;
			dadStrums.add(babyArrow);
			strumLineNotes.add(babyArrow);
		}
	}
	function regenerateStaticArrows(player:Int, fadeIn = true)
	{
		switch (player)
		{
			case 0:
				dadStrums.forEach(function(spr:StrumNote)
				{
					dadStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
			case 1:
				playerStrums.forEach(function(spr:StrumNote)
				{
					playerStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
		}
		generateStaticArrows(player, false, fadeIn);
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.sineInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
				if (exbungo_funny != null)
				{
					exbungo_funny.pause();
				}
			}
			if (tweenList != null && tweenList.length != 0)
			{
				for (tween in tweenList)
				{
					if (!tween.finished)
					{
						tween.active = false;
					}
				}
			}
			if (rotatingCamTween != null)
			{
				rotatingCamTween.active = false;
			}
			for (tween in pauseTweens)
			{
				tween.active = false;
			}
			
			#if desktop
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") |",
				"Acc: "
				+ truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	public function throwThatBitchInThere(guyWhoComesIn:String = 'bambi', guyWhoFliesOut:String = 'dave')
	{
		hasTriggeredDumbshit = true;
		if(BAMBICUTSCENEICONHURHURHUR != null)
		{
			remove(BAMBICUTSCENEICONHURHURHUR);
		}
		BAMBICUTSCENEICONHURHURHUR = new HealthIcon(guyWhoComesIn, false);
		BAMBICUTSCENEICONHURHURHUR.changeState(iconP2.getState());
		BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
		add(BAMBICUTSCENEICONHURHURHUR);
		BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
		BAMBICUTSCENEICONHURHURHUR.x = -100;
		FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3, true, {ease: FlxEase.expoInOut});
		AUGHHHH = guyWhoComesIn;
		AHHHHH = guyWhoFliesOut;
		new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;

			if (tweenList != null && tweenList.length != 0)
			{
				for (tween in tweenList)
				{
					if (!tween.finished && activateSunTweens)
					{
						tween.active = true;
					}
				}
			}
			if (rotatingCamTween != null)
			{
				rotatingCamTween.active = true;
			}
			for (tween in pauseTweens)
			{
				tween.active = true;
			}
			paused = false;

			if (startTimer != null && startTimer.finished)
			{
				#if desktop
				DiscordClient.changePresence(detailsText
					+ " "
					+ SONG.song
					+ " ("
					+ storyDifficultyText
					+ ") ",
					"\nAcc: "
					+ truncateFloat(accuracy, 2)
					+ "% | Score: "
					+ songScore
					+ " | Misses: "
					+ misses, iconRPC, true,
					FlxG.sound.music.length
					- Conductor.songPosition);
				#end
			}
			else
			{
				#if desktop
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") ", iconRPC);
				#end
			}
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	public static var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;

		if (songName != null && barType == 'ShowTime')
		{
			songName.text = FlxStringUtil.formatTime((FlxG.sound.music.length - FlxG.sound.music.time) / 1000);
		}

		if (startingSong && startTimer != null && !startTimer.active)
			startTimer.active = true;
			
		if (paused && FlxG.sound.music != null && vocals != null && vocals.playing)
		{
			FlxG.sound.music.pause();
			vocals.pause();
		}
		if (curbg != null)
		{
			if (curbg.active) // only the polygonized background is active
			{
				#if SHADERS_ENABLED
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
				#end
			}
		}
		
		var toy = -100 + -Math.sin((curStep / 9.5) * 2) * 30 * 5;
		var tox = -330 -Math.cos((curStep / 9.5)) * 100;

		//welcome to 3d sinning avenue
      if (stageCheck == 'exbungo-land') {
			place.y -= (Math.sin(elapsedtime) * 0.4);
		}
		if (dad.curCharacter == 'recurser')
		{
			toy = 100 + -Math.sin((elapsedtime) * 2) * 300;
			tox = -400 - Math.cos((elapsedtime)) * 200;

			dad.x += (tox - dad.x);
			dad.y += (toy - dad.y);
		}

		if(funnyFloatyBoys.contains(dad.curCharacter.toLowerCase()) && canFloat)
		{
			if (dad.curCharacter.toLowerCase() == "expunged")
			{
				// mentally insane movement
				dad.x += (tox - dad.x) / 12;
				dad.y += (toy - dad.y) / 12;
			}
			else
			{
				dad.y += (Math.sin(elapsedtime) * 0.2);
			}
		}
		if(funnyFloatyBoys.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.2);
		}

		if(funnyFloatyBoys.contains(gf.curCharacter.toLowerCase()) && canFloat)
		{
			gf.y += (Math.sin(elapsedtime) * 0.2);
		}
		if ((SONG.song.toLowerCase() == 'cheating' || localFunny == CharacterFunnyEffect.Dave) && !inCutscene) // fuck you
		{
			playerStrums.forEach(function(spr:StrumNote)                                               
			{
				spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x -= Math.sin(elapsedtime) * 1.5;
			});
			dadStrums.forEach(function(spr:StrumNote)
			{
				spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x += Math.sin(elapsedtime) * 1.5;
			});
		}
		if (SONG.song.toLowerCase() == 'unfairness' && !inCutscene) // fuck you x2
		{
			playerStrums.forEach(function(spr:StrumNote)
			{
				spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID))) * 300);
				spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID))) * 300);
			});
			dadStrums.forEach(function(spr:StrumNote)
			{
				spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID)) * 2) * 300);
				spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
			});
		}

		// no more 3d sinning avenue
		if (daveFlying)
		{
			dad.y -= elapsed * 50;
			dad.angle -= elapsed * 6;
		}
		if (tweenList != null && tweenList.length != 0)
		{
			for (tween in tweenList)
			{
				if (tween.active && !tween.finished && !activateSunTweens)
					tween.percent = FlxG.sound.music.time / tweenTime;
			}
		}
        
		#if SHADERS_ENABLED
		FlxG.camera.filters = [new ShaderFilter(screenshader.shader)]; // this is very stupid but doesn't effect memory all that much so
		#end
		if (shakeCam && eyesoreson)
		{
			FlxG.camera.shake(0.010, 0.010);
		}

		#if SHADERS_ENABLED
		screenshader.shader.uTime.value[0] += elapsed;
		lazychartshader.shader.uTime.value[0] += elapsed;
		if (blockedShader != null)
		{
			blockedShader.update(elapsed);
		}
		if (shakeCam && eyesoreson)
		{
			screenshader.shader.uampmul.value[0] = 1;
		}
		else
		{
			screenshader.shader.uampmul.value[0] -= (elapsed / 2);
		}
		screenshader.Enabled = shakeCam && eyesoreson;
		#end

		super.update(elapsed);
		scoreTxt.text = 
		LanguageManager.getTextString('play_score') + Std.string(songScore) + " | " + 
		LanguageManager.getTextString('play_miss') + misses +  " | " + 
		LanguageManager.getTextString('play_accuracy') + truncateFloat(accuracy, 2) + "%";
		if (noMiss)
		{
			scoreTxt.text += " | NO MISS!!";
		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			if(FlxTransitionableState.skipNextTransIn)
			{
				Transition.nextCamera = null;
			}
			
			#if SHADERS_ENABLED
			resetShader();
			#end
			FlxG.switchState(new ChartingState());
			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		var thingy = 0.88; //(144 / Main.fps.currentFPS) * 0.88;
		//still gotta make this fps consistent crap

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, thingy)),Std.int(FlxMath.lerp(150, iconP1.height, thingy)));
		iconP1.updateHitbox();

		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, thingy)),Std.int(FlxMath.lerp(150, iconP2.height, thingy)));
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		if (inFiveNights)
		{
			iconP1.x = (healthBar.x + healthBar.width) - (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) + iconOffset);
			iconP2.x = (healthBar.x + healthBar.width) - (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}
		else
		{
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}

		if (health > 2)
			health = 2;

		if (SONG.song.toLowerCase() != "five-nights")
		{
			if (healthBar.percent < 20)
				iconP1.changeState('losing');
			else
				iconP1.changeState('normal');

			if (healthBar.percent > 80)
				iconP2.changeState('losing');
			else
				iconP2.changeState('normal');
		}
		else
		{
			if (healthBar.percent < 20)
				iconP2.changeState('losing');
			else
				iconP2.changeState('normal');

			if (healthBar.percent > 80)
				iconP1.changeState('losing');
			else
				iconP1.changeState('normal');
		}

	
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
				{
					startSong();
				}
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}
		if (crazyZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (health <= 0)
		{
			if(!perfectMode)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
	
				vocals.stop();
				FlxG.sound.music.stop();
				
				#if SHADERS_ENABLED
				screenshader.shader.uampmul.value[0] = 0;
				screenshader.Enabled = false;
				#end
			}

			if (!shakeCam)
			{
				if(!perfectMode)
				{
					gameOver();
				}
			}
			else
			{
				CharacterSelectState.unlockCharacter('bambi-3d');
				if (isStoryMode)
				{
					switch (SONG.song.toLowerCase())
					{
						default:
							if (shakeCam)
							{
								CharacterSelectState.unlockCharacter('bambi-3d');
							}
							FlxG.switchState(new EndingState('rtxx_ending', 'badEnding'));
					}
				}
				else
				{
					if (!perfectMode)
					{
						if(shakeCam)
						{
							CharacterSelectState.unlockCharacter('bambi-3d');
						}
						gameOver();
					}
				}
			}

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			var thing:Int = (SONG.song.toLowerCase() == 'unfairness' || PlayState.SONG.song.toLowerCase() == 'exploitation' ? 15000 : 1500);

			if (unspawnNotes[0].strumTime - Conductor.songPosition < thing)
			{
				var dunceNote:Note = unspawnNotes[0];
				dunceNote.finishedGenerating = true;

				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}
		var currentSection = SONG.notes[Math.floor(curStep / 16)];

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}
				if (daNote.mustPress && (Conductor.songPosition >= daNote.strumTime) && daNote.health != 2 && daNote.noteStyle == 'phone')
				{
					daNote.health = 2;
					dad.playAnim(dad.animation.getByName("singThrow") == null ? 'singSmash' : 'singThrow', true);
				}
				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Warmup')
						camZooming = true; 

					var altAnim:String = "";
					var healthtolower:Float = 0.02;

					if (currentSection != null)
					{
						if (daNote.noteStyle == 'phone-alt')
						{
							altAnim = '-alt';
						}
						if (currentSection.altAnim)
							if (SONG.song.toLowerCase() != "cheating")
							{
								altAnim = '-alt';
							}
							else
							{
								healthtolower = 0.005;
							}
					}

					var noteTypes = guitarSection ? notestuffsGuitar : notestuffs;
					var noteToPlay:String = noteTypes[Math.round(Math.abs(daNote.originalType)) % dadStrumAmount];
					switch (daNote.noteStyle)
					{
						case 'phone':
							dad.playAnim('singSmash', true);
						default:
							if (dad.nativelyPlayable)
							{
								switch (noteToPlay)
								{
									case 'LEFT':
										noteToPlay = 'RIGHT';
									case 'RIGHT':
										noteToPlay = 'LEFT';
								}
							}
							dad.playAnim('sing' + noteToPlay + altAnim, true);
							if (dadmirror != null)
							{
								dadmirror.playAnim('sing' + noteToPlay + altAnim, true);
							}
					}
					cameraMoveOnNote(daNote.originalType, 'dad');
					
					dadStrums.forEach(function(sprite:StrumNote)
					{
						if (Math.abs(Math.round(Math.abs(daNote.noteData)) % dadStrumAmount) == sprite.ID)
						{
							sprite.animation.play('confirm', true);
							if (sprite.animation.curAnim.name == 'confirm')
							{
								sprite.centerOffsets();
								sprite.offset.x -= 13;
								sprite.offset.y -= 13;
							}
							else
							{
								sprite.centerOffsets();
							}
							sprite.animation.finishCallback = function(name:String)
							{
								sprite.animation.play('static', true);
								sprite.centerOffsets();
							}
						}
					});
					if (UsingNewCam)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}

					switch (SONG.song.toLowerCase())
					{
						case 'cheating':
							health -= healthtolower;
						case 'unfairness':
							health -= (healthtolower / 3);
						case 'exploitation':
							if (((health + (FlxEase.backInOut(health / 16.5)) - 0.002) >= 0) && !(curBeat >= 320 && curBeat <= 330))
							{
								health += ((FlxEase.backInOut(health / 16.5)) * (curBeat <= 160 ? 0.25 : 1)) - 0.002; //some training wheels cuz rapparep say mod too hard
							}
						case 'mealie':
							if (curBeat >= 464 && curBeat <= 592) {
								health -= (healthtolower / 1.5);
							}
						case 'five-nights':
							if ((health - 0.023) > 0)
							{
								health -= 0.023;
							}
							else
							{
								health = 0.001;
							}
					}
					// boyfriend.playAnim('hit',true);
					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				if (daNote.MyStrum != null)
				{
					daNote.y = yFromNoteStrumTime(daNote, daNote.MyStrum, scrollType == 'downscroll');
				}
				else
				{
					daNote.y = yFromNoteStrumTime(daNote, strumLine, scrollType == 'downscroll');
				}
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				var noteSpeed = (daNote.LocalScrollSpeed == 0 ? 1 : daNote.LocalScrollSpeed);
				
				if (daNote.wasGoodHit && daNote.isSustainNote && Conductor.songPosition >= (daNote.strumTime + 10))
				{
					destroyNote(daNote);
				}
				if (!daNote.wasGoodHit && daNote.mustPress && daNote.finishedGenerating && Conductor.songPosition >= daNote.strumTime + (350 / (0.45 * FlxMath.roundDecimal(SONG.speed * noteSpeed, 2))))
				{
					if (!noMiss)
						noteMiss(daNote.originalType, daNote);

					vocals.volume = 0;

					destroyNote(daNote);
				}
			});
		}

		ZoomCam(focusOnDadGlobal);

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		if (updatevels)
		{
			stupidx *= 0.98;
			stupidy += elapsed * 6;
			if (BAMBICUTSCENEICONHURHURHUR != null)
			{
				BAMBICUTSCENEICONHURHURHUR.x += stupidx;
				BAMBICUTSCENEICONHURHURHUR.y += stupidy;
			}
		}
	}
	

	function FlingCharacterIconToOblivionAndBeyond(e:FlxTimer = null):Void
	{
		iconP2.changeIcon(AUGHHHH);
		
		BAMBICUTSCENEICONHURHURHUR.changeIcon(AHHHHH);
		BAMBICUTSCENEICONHURHURHUR.changeState(iconP2.getState());
		stupidx = -5;
		stupidy = -5;
		updatevels = true;
	}
	function destroyNote(note:Note)
	{
		note.active = false;
		note.visible = false;
		note.kill();
		notes.remove(note, true);
		note.destroy();
	}
	function yFromNoteStrumTime(note:Note, strumLine:FlxSprite, downScroll:Bool):Float
	{
		var change = downScroll ? -1 : 1;
		var speed:Float = SONG.speed;
		if (localFunny == CharacterFunnyEffect.Tristan)
		{
			speed += (Math.sin(elapsedtime / 5)) * 1;
		}
		var val:Float = strumLine.y - (Conductor.songPosition - note.strumTime) * (change * 0.45 * FlxMath.roundDecimal(speed * note.LocalScrollSpeed, 2));
		if (note.isSustainNote && downScroll && note.animation != null)
		{
			if (note.animation.curAnim.name.endsWith('end'))
			{
				val += (note.height * 2.05);
			}
		}
		return val;
	}
	function ZoomCam(focusondad:Bool):Void
	{
		var bfplaying:Bool = false;
		if (focusondad)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (!bfplaying)
				{
					if (daNote.mustPress)
					{
						bfplaying = true;
					}
				}
			});
			if (UsingNewCam && bfplaying)
			{
				return;
			}
		}
		if (!lockCam)
		{
			if (focusondad)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'playrobot':
						camFollow.x = dad.getMidpoint().x + 50;
					case 'playrobot-shadow':
						camFollow.x = dad.getMidpoint().x + 50;
						camFollow.y -= 100;
					case 'dave-angey' | 'dave-festival-3d' | 'dave-3d-recursed':
						camFollow.y = dad.getMidpoint().y;
					case 'nofriend':
						camFollow.x = dad.getMidpoint().x + 50;
						camFollow.y = dad.getMidpoint().y - 50;
					case 'bambi-3d':
						camFollow.x = dad.getMidpoint().x;
						camFollow.y -= 50;
				}

				if (SONG.song.toLowerCase() == 'warmup')
				{
					tweenCamIn();
				}

				bfNoteCamOffset[0] = 0;
				bfNoteCamOffset[1] = 0;

				camFollow.x += dadNoteCamOffset[0];
				camFollow.y += dadNoteCamOffset[1];
			}
			else
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
	
				switch (boyfriend.curCharacter)
				{
					case 'bf-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 250;
					case 'bf-3d':
						camFollow.y += 100;
					case 'dave-angey':
						camFollow.y = boyfriend.getMidpoint().y;
					case 'bambi-3d':
						camFollow.x = boyfriend.getMidpoint().x - 375;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'dave-fnaf':
						camFollow.x += 100;
				}
				dadNoteCamOffset[0] = 0;
				dadNoteCamOffset[1] = 0;

				camFollow.x += bfNoteCamOffset[0];
				camFollow.y += bfNoteCamOffset[1];

				if (SONG.song.toLowerCase() == 'warmup')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.sineInOut});
				}
			}
			switch (SONG.song.toLowerCase())
			{
				case 'escape-from-california':
					camFollow.y += 150;
			}
		}
	}


	function THROWPHONEMARCELLO(e:FlxTimer = null):Void
	{
		STUPDVARIABLETHATSHOULDNTBENEEDED.animation.play("throw_phone");
		new FlxTimer().start(5.5, function(timer:FlxTimer)
		{ 
			if(isStoryMode) {
				FlxG.sound.music.stop();
				nextSong();
			}
			else {
				FlxG.switchState(new FreeplayState());
			}
		});
	}

	function endSong():Void
	{
		inCutscene = false;
		canPause = false;
		if (MathGameState.failedGame)
		{
			MathGameState.failedGame = false;
		}
		if (recursedStaticWeek)
		{
			recursedStaticWeek = false;
		}

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.save.flush();
		Highscore.saveScore(SONG.song, songScore, storyDifficulty, characteroverride == "none"
			|| characteroverride == "bf" ? "bf" : characteroverride);

		if (isStoryMode)
		{
			campaignScore += songScore;

			var completedSongs:Array<String> = [];
			var mustCompleteSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Blocked', 'Corn-Theft', 'Maze', 'Splitathon', 'Shredder', 'Greetings', 'Interdimensional', 'Rano'];
			var allSongsCompleted:Bool = true;
			if (FlxG.save.data.songsCompleted == null)
			{
				FlxG.save.data.songsCompleted = new Array<String>();
			}
			completedSongs = FlxG.save.data.songsCompleted;
			completedSongs.push(storyPlaylist[0]);
			for (i in 0...mustCompleteSongs.length)
			{
				if (!completedSongs.contains(mustCompleteSongs[i]))
				{
					allSongsCompleted = false;
					break;
				}
			}
			if (allSongsCompleted && CharacterSelectState.isLocked('tristan-golden'))
			{
				CharacterSelectState.unlockCharacter('tristan-golden');
			}
			FlxG.save.data.songsCompleted = completedSongs;
			FlxG.save.flush();

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				if(FlxTransitionableState.skipNextTransIn)
				{
					Transition.nextCamera = null;
				}
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.switchState(new StoryMenuState());
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				Highscore.saveWeekScore(storyWeek, campaignScore,
					storyDifficulty, characteroverride == "none" || characteroverride == "bf" ? "bf" : characteroverride);

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{	
				nextSong();
			}
		}
		else
		{
			FlxG.switchState(new FreeplayState());
			if(FlxTransitionableState.skipNextTransIn)
			{
				Transition.nextCamera = null;
			}
		}
	}

	function nextSong()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();

		LoadingState.loadAndSwitchState(new PlayState());
	}
	function greetingsCutsceneSetup()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		SONG = Song.loadFromJson('greetings');
		SONG.player2 = 'dave-festival';
		FlxG.sound.music.stop();
		
		LoadingState.loadAndSwitchState(new PlayState());
	}
	function greetingsCutscene()
	{
		canPause = false;
		boyfriend.canDance = false;
		boyfriend.stunned = false;
		dad.canDance = false;
		dad.playAnim('scared',true);
		gf.canDance = false;

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);

		FlxTween.tween(camHUD, {alpha: 0}, 1);
		FlxG.camera.shake(0.0175, 999);
		FlxG.sound.playMusic(Paths.sound('rumble', 'shared'), 0.8, true, null);
		new FlxTimer().start(2, function(timer:FlxTimer)
		{
			originalPosition = dad.getPosition();
			daveFlying = true;
			
			new FlxTimer().start(3, function(timer:FlxTimer)
			{
				FlxG.sound.play(Paths.sound('transition', 'shared'), 1, false, null, false);
				FlxG.camera.fade(FlxColor.WHITE, 3, false, function()
				{
					daveFlying = false;
					isGreetingsCutscene = false;
					dad.setPosition(originalPosition.x, originalPosition.y);
					camFollow.setPosition(originalPosition.x,originalPosition.y);

					FlxG.camera.stopFX();
					FlxG.camera.fade(FlxColor.BLACK, 0);
					
					FlxG.sound.music.stop();
					FlxG.sound.music.fadeOut(1.9, 0);
					vocals.stop();

					canPause = false;
					hasDialogue = true;

					var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/greetings-cutscene')), false);
					doof.scrollFactor.set();
					doof.cameras = [camDialogue];
					doof.finishThing = function()
					{
						new FlxTimer().start(1, function(timer:FlxTimer)
						{
							nextSong();
						});
					};
					schoolIntro(doof, false);
				});
			});
		});
	}

	public function createScorePopUp(daX:Float, daY:Float, autoPos:Bool, daRating:String, daCombo:Int, daStyle:String):Void
	{

		var assetPath:String = '';
		switch (daStyle)
		{
			case '3D' | 'shape':
			  	assetPath = '3D/';
		}

		var placement:String = Std.string(daCombo);

		var coolText:FlxText = new FlxText(daX, daY, 0, placement, 32);
		if (autoPos)
		{
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
		}
		var rating = new FlxSprite().loadGraphic(Paths.image("ui/" + assetPath + daRating));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image("ui/" + assetPath + "combo"));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);
		if (combo >= 10)
		{
			add(comboSpr);
		}

		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.antialiasing = true;
		comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		comboSpr.antialiasing = true;

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		var comboSplit:Array<String> = (daCombo + "").split('');

		if (comboSplit.length == 2)
			seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

		for (i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image("ui/" + assetPath + "num" + Std.int(i)));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.antialiasing = true;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (daCombo >= 10 || daCombo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		*/

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}


	private function popUpScore(strumtime:Float, note:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = 10;
			ss = false;
			shits++;
		}
		else if (noteDiff < Conductor.safeZoneOffset * -2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = 25;
			ss = false;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45)
		{
			daRating = 'bad';
			score = 100;
			totalNotesHit += 0.2;
			ss = false;
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			totalNotesHit += 0.65;
			score = 200;
			ss = false;
			goods++;
		}
		if (daRating == 'sick')
		{
			totalNotesHit += 1;
			sicks++;
		}
		score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[note.noteData], 0), Int); //this is old code thats stupid Std.Int exists but i dont feel like changing this

		if (!noMiss)
		{
			songScore += score;
		}

		if (!inFiveNights)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'bot-trot':
					createScorePopUp(-400, 300, true, daRating, combo, note.noteStyle);
				default:
					createScorePopUp(0,0, true, daRating, combo, note.noteStyle);
			}
			
		}
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var key5 = controls.KEY5 && (SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'interdimensional') && localFunny != CharacterFunnyEffect.Recurser;
		
		playerStrums.forEach(function(strum:StrumNote) {
			strum.pressingKey5 = key5;
		});

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		var releaseArray:Array<Bool> = [leftR, downR, upR, rightR];

		if (noteLimbo != null)
		{
			if (noteLimbo.exists)
			{
				if (noteLimbo.wasGoodHit)
				{
					if (key5 && noteLimbo.noteStyle == 'shape')
					{
						goodNoteHit(noteLimbo);
						if (noteLimbo.wasGoodHit)
						{
							noteLimbo.kill();
							notes.remove(noteLimbo, true);
							noteLimbo.destroy();
						}
						noteLimbo = null;
					}
					else if (!key5 && noteLimbo.noteStyle != 'shape')
					{
						goodNoteHit(noteLimbo);
						if (noteLimbo.wasGoodHit)
						{
							noteLimbo.kill();
							notes.remove(noteLimbo, true);
							noteLimbo.destroy();
						}
						noteLimbo = null;
					}
				}
				else
				{
					noteLimbo = null;
				}
			}
		}

		if (noteLimboFrames != 0)
		{
			noteLimboFrames--;
		}
		else
		{
			noteLimbo = null;
		}

		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			possibleNotes = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && daNote.finishedGenerating)
				{
					possibleNotes.push(daNote);
				}
			});

			haxe.ds.ArraySort.sort(possibleNotes, function(a, b):Int {
				var notetypecompare:Int = Std.int(a.noteData - b.noteData);

				if (notetypecompare == 0)
				{
					return Std.int(a.strumTime - b.strumTime);
				}
				return notetypecompare;
			});

			

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				var lasthitnote:Int = -1;
				var lasthitnotetime:Float = -1;

				for (note in possibleNotes) 
				{
					if (!note.mustPress)
					{
						continue; //how did this get here
					}
					if (controlArray[note.noteData % 4])
					{ //further tweaks to the conductor safe zone offset multiplier needed.
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.08)) //reduce the past allowed barrier just so notes close together that aren't jacks dont cause missed inputs
						{
							if ((note.noteData % 4) == (lasthitnote % 4))
							{
								lasthitnotetime = -999999; //reset the last hit note time
								continue; //the jacks are too close together
							}
						}
						if (note.noteStyle == 'shape' && !key5)
						{
							//FlxG.sound.play(Paths.sound('ANGRY'), FlxG.random.float(0.2, 0.3));
							noteLimbo = note;
							noteLimboFrames = 8; //note limbo, the place where notes that could've been hit go.
							continue;
						}
						else if (note.noteStyle != 'shape' && key5)
						{
							//FlxG.sound.play(Paths.sound('ANGRY'), FlxG.random.float(0.2, 0.3));
							noteLimbo = note;
							noteLimboFrames = 8;
							continue;
						}
						lasthitnote = note.noteData;
						lasthitnotetime = note.strumTime;
						goodNoteHit(note);
					}
				}
				
				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else if (!theFunne)
			{
				if(!inCutscene)
					badNoteCheck(null);
			}
		}

		if ((up || right || down || left) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					if ((daNote.noteStyle == 'shape' && key5) || (daNote.noteStyle != 'shape' && !key5))
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);
						}
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if ((boyfriend.animation.curAnim.name.startsWith('sing')) && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
				
				bfNoteCamOffset[0] = 0;
				bfNoteCamOffset[1] = 0;
			}
		}

		playerStrums.forEach(function(spr:StrumNote)
		{
			if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
			{
				spr.animation.play('pressed');
			}
			if (releaseArray[spr.ID])
			{
				spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm')
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1, note:Note):Void
	{
		if (true)
		{
			misses++;	
			if (inFiveNights)
			{
				health -= 0.004;
			}
			else
			{
				health -= 0.04;
			}
			if (combo > 5)
			{
				gf.playAnim('sad');
			}
			combo = 0;
			songScore -= 100;

			if (note != null)
			{
				switch (note.noteStyle)
				{
					case 'phone':
						var hitAnimation:Bool = boyfriend.animation.getByName("hit") != null;
						boyfriend.playAnim(hitAnimation ? 'hit' : 'singRIGHTmiss', true);
						FlxTween.cancelTweensOf(note.MyStrum);
						note.MyStrum.alpha = 0.01;
						var noteTween = FlxTween.tween(note.MyStrum, {alpha: 1}, 7, {ease: FlxEase.expoIn});
						pauseTweens.push(noteTween);
						health -= 0.07;
						updateAccuracy();
						return;
				}
			}
			var deathSound:FlxSound = new FlxSound();
			switch (curSong.toLowerCase())
			{
				case 'overdrive':
					deathSound.loadEmbedded(Paths.sound('bad_disc'));
				case 'vs-dave-rap' | 'vs-dave-rap-two':
					deathSound.loadEmbedded(Paths.sound('deathbell'));
				default:
					deathSound.loadEmbedded(Paths.soundRandom('missnote', 1, 3));
			}
			deathSound.volume = FlxG.random.float(0.1, 0.2);
			deathSound.play();

			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			
			var noteTypes = guitarSection ? notestuffsGuitar : notestuffs;
			var noteToPlay:String = noteTypes[Math.round(Math.abs(direction)) % playerStrumAmount];
			if (!boyfriend.nativelyPlayable)
			{
				switch (noteToPlay)
				{
					case 'LEFT':
						noteToPlay = 'RIGHT';
					case 'RIGHT':
						noteToPlay = 'LEFT';
				}
			}
			if (boyfriend.animation.getByName('sing${noteToPlay}miss') != null)
			{
				boyfriend.playAnim('sing' + noteToPlay + "miss", true);
			}
			else
			{
				boyfriend.color = 0xFF000084;
				boyfriend.playAnim('sing' + noteToPlay, true);
			}
			updateAccuracy();
		}
	}

	function cameraMoveOnNote(note:Int, character:String)
	{
		var amount:Array<Float> = new Array<Float>();
		var followAmount:Float = FlxG.save.data.noteCamera ? 20 : 0;
		switch (note)
		{
			case 0:
				amount[0] = -followAmount;
				amount[1] = 0;
			case 1:
				amount[0] = 0;
				amount[1] = followAmount;
			case 2:
				amount[0] = 0;
				amount[1] = -followAmount;
			case 3:
				amount[0] = followAmount;
				amount[1] = 0;
		}
		switch (character)
		{
			case 'dad':
				dadNoteCamOffset = amount;
			case 'bf':
				bfNoteCamOffset = amount;
		}
	}

	function badNoteCheck(note:Note = null)
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		if (note != null)
		{
			if(note.mustPress && note.finishedGenerating)
			{
				if (!noMiss)
					noteMiss(note.noteData, note);
			}
			return;
		}
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		for (i in 0...controlArray.length)
		{
			if (controlArray[i])
			{
				if (!noMiss)
					noteMiss(i, note);
			}	
		}
		updateAccuracy();
	}

	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
	}

	function noteCheck(keyP:Bool, note:Note):Void // sorry lol
	{
		if (keyP)
		{
			goodNoteHit(note);
		}
		else if (!theFunne)
		{
			badNoteCheck(note);
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note);
				if (FlxG.save.data.donoteclick)
				{
					FlxG.sound.play(Paths.sound('note_click'));
				}
				combo += 1;
			} else totalNotesHit += 1;

			if (!isRecursed)
			{
				health += 0.023;
			}
			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && formoverride != 'tristan-golden-glowing' && bfTween == null)
			{
				boyfriend.color = nightColor;
			}
			else if (sunsetLevels.contains(curStage) && bfTween == null)
			{
				boyfriend.color = sunsetColor;
			}
			else if (bfTween == null)
			{
				boyfriend.color = FlxColor.WHITE;
			}
			else
			{
				if (!bfTween.active && !bfTween.finished)
				{
					bfTween.active = true;
				}
				boyfriend.color = bfTween.color;
			}


			switch (note.noteStyle)
			{
				default:
					var fuckingDumbassBullshitFuckYou:String;
					var noteTypes = guitarSection ? notestuffsGuitar : notestuffs;
					fuckingDumbassBullshitFuckYou = noteTypes[Math.round(Math.abs(note.originalType)) % playerStrumAmount];
					if(!boyfriend.nativelyPlayable)
					{
						switch(noteTypes[Math.round(Math.abs(note.originalType)) % playerStrumAmount])
						{
							case 'LEFT':
								fuckingDumbassBullshitFuckYou = 'RIGHT';
							case 'RIGHT':
								fuckingDumbassBullshitFuckYou = 'LEFT';
						}
					}
					boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);

				case 'phone':
					var hitAnimation:Bool = boyfriend.animation.getByName("dodge") != null;
					var heyAnimation:Bool = boyfriend.animation.getByName("hey") != null;
					boyfriend.playAnim(hitAnimation ? 'dodge' : (heyAnimation ? 'hey' : 'singUPmiss'), true);
					gf.playAnim('cheer', true);
					if (note.health != 2)
					{
						dad.playAnim(dad.animation.getByName("singThrow") == null ? 'singSmash' : 'singThrow', true);
					}
			}
			cameraMoveOnNote(note.originalType, 'bf');
			if (UsingNewCam)
			{
				focusOnDadGlobal = false;
				ZoomCam(false);
			}

			playerStrums.forEach(function(spr:StrumNote)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	function initAlphabet(songList:Array<String>)
	{
		for (letter in alphaCharacters)
		{
			alphaCharacters.remove(letter);
			remove(letter);
		}
		var startWidth = 640;
		var width:Float = startWidth;
		var row:Float = 0;
		
		while (row < FlxG.height)
		{
			while (width < FlxG.width * 2.5)
			{
				for (i in 0...songList.length)
				{
					var curSong = songList[i];
					var song = new Alphabet(0, 0, curSong, true);
					song.x = width;
					song.y = row;

					width += song.width + 20;
					alphaCharacters.add(song);
					add(song);
					
					if (width > FlxG.width * 2.5)
					{
						break;
					}
				}
			}
			row += 120;
			width = startWidth;
		}
		for (char in alphaCharacters)
		{
			for (letter in char.characters)
			{
				letter.alpha = 0;
			}
		}
		for (char in alphaCharacters)
		{
			char.unlockY = true;
			for (alphaChar in char.characters)
			{
				alphaChar.velocity.set(new FlxRandom().float(-50, 50), new FlxRandom().float(-50, 50));
				alphaChar.angularVelocity = new FlxRandom().int(30, 50);

				alphaChar.setPosition(new FlxRandom().float(-FlxG.width / 2, FlxG.width * 2.5), new FlxRandom().float(0, FlxG.height * 2.5));
			}
		}
	}
	function rotateRecursedCam()
	{
		rotatingCamTween = FlxTween.tween(FlxG.camera, {angle: 8}, 5, {onComplete: function(tween:FlxTween)
		{
			FlxTween.tween(FlxG.camera, {angle: -8}, 5);
		}, type: FlxTweenType.ONESHOT, ease: FlxEase.backOut});
	}
	function cancelRecursedCamTween()
	{
		if (rotatingCamTween != null)
		{
			rotatingCamTween.cancel();
			rotatingCamTween = null;
	
			camRotateAngle = 0;
			
			FlxG.camera.angle = 0;
			camHUD.angle = 0;
		}
	}
	function cinematicBars(time:Float, closeness:Float)
	{
		var upBar = new FlxSprite().makeGraphic(Std.int(FlxG.width * ((1 / defaultCamZoom) * 2)), Std.int(FlxG.height / 2), FlxColor.BLACK);
		var downBar = new FlxSprite().makeGraphic(Std.int(FlxG.width * ((1 / defaultCamZoom) * 2)), Std.int(FlxG.height / 2), FlxColor.BLACK);

		upBar.screenCenter();
		downBar.screenCenter();
		upBar.scrollFactor.set();
		downBar.scrollFactor.set();
		upBar.cameras = [camHUD];
		downBar.cameras = [camHUD];

		upBar.y -= 2000;
		downBar.y += 2000;

		add(upBar);
		add(downBar);
		
		FlxTween.tween(upBar, {y: (FlxG.height - upBar.height) / 2 - closeness}, (Conductor.crochet / 1000) / 2, {ease: FlxEase.expoInOut, onComplete: function(tween:FlxTween)
		{
			new FlxTimer().start(time, function(timer:FlxTimer)
			{
				FlxTween.tween(upBar, {y: upBar.y - 2000}, (Conductor.crochet / 1000) / 2, {ease: FlxEase.expoIn, onComplete: function(tween:FlxTween)
				{
					remove(upBar);
				}});
			});
		}});
		FlxTween.tween(downBar, {y: (FlxG.height - downBar.height) / 2 + closeness}, (Conductor.crochet / 1000) / 2, {ease: FlxEase.expoInOut, onComplete: function(tween:FlxTween)
		{
			new FlxTimer().start(time, function(timer:FlxTimer)
			{
				FlxTween.tween(downBar, {y: downBar.y + 2000}, (Conductor.crochet / 1000) / 2, {ease: FlxEase.expoIn, onComplete: function(tween:FlxTween)
				{
					remove(downBar);
				}});
			});
		}});
	}
	function swapGlitch(glitchTime:Float, toBackground:String)
	{
		//hey t5 if you make the static fade in and out, can you use the sounds i made? they are in preload
		var glitch = new BGSprite('glitch', 0, 0, 'ui/glitch/glitchSwitch', 
		[
			new Animation('glitch', 'glitchScreen', 24, true, [false, false])
		], 0, 0, false, true);
		glitch.scrollFactor.set();
		glitch.cameras = [camHUD];
		glitch.setGraphicSize(FlxG.width, FlxG.height);
		glitch.updateHitbox();
		glitch.screenCenter();
		if (FlxG.save.data.eyesores)
		{
			glitch.animation.play('glitch');
		}
		add(glitch);

		new FlxTimer().start(glitchTime, function(timer:FlxTimer)
		{
			expungedBG.setPosition(0, 200);
			switch (toBackground)
			{
				case 'expunged':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
				case 'cheating':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/cheater GLITCH'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'cheating-2':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/glitchy_cheating_2'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'unfair':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/glitchyUnfairBG'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'chains':
					expungedBG.setPosition(-300, 0);
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/expunged_chains'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
			}
			remove(glitch);
		});
	}
	var black:FlxSprite;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			resyncVocals();

		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"Acc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			FlxG.sound.music.length
			- Conductor.songPosition);
	}

	override function beatHit()
	{
		super.beatHit();

		if (spotLightPart && spotLight != null && spotLight.exists && curBeat % 3 == 0)
		{
			FlxTween.cancelTweensOf(spotLight);
			if (spotLight.health != 3)
			{
				FlxTween.tween(spotLight, {angle: 2}, (Conductor.crochet / 1000) * 3, {ease: FlxEase.expoInOut});
				spotLight.health = 3;
			}
			else
			{
				FlxTween.tween(spotLight, {angle: -2}, (Conductor.crochet / 1000) * 3, {ease: FlxEase.expoInOut});
				spotLight.health = 1;
			}
		}

		var currentSection = SONG.notes[Std.int(curStep / 16)];
		if (!UsingNewCam)
		{
			if (generatedMusic && currentSection != null)
			{
				if (curBeat % 4 == 0)
				{
					// trace(currentSection.mustHitSection);
				}

				focusOnDadGlobal = !currentSection.mustHitSection;
				ZoomCam(!currentSection.mustHitSection);
			}
		}
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (currentSection != null)
		{
			if (currentSection.changeBPM)
			{
				Conductor.changeBPM(currentSection.bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		if (dad.animation.finished)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'warmup':
					dad.dance();
					if (dadmirror != null)
					{
						dadmirror.dance();
					}
				default:
					if (dad.holdTimer <= 0 && curBeat % 2 == 0)
					{
						dad.dance();
						if (dadmirror != null)
						{
							dadmirror.dance();
						}

						dadNoteCamOffset[0] = 0;
						dadNoteCamOffset[1] = 0;
					}
			}
		}
		
		if (curBeat % gfSpeed == 0)
		{
			if (!shakeCam && gf.canDance)
			{
				gf.dance();
			}
		}

		if (camZooming && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (crazyZooming)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}	
		if (curBeat % 2 == 0)
		{
			crowdPeople.forEach(function(crowdPerson:BGSprite)
			{
				crowdPerson.animation.play('idle', true);
			});
		}
		if (curBeat % 4 == 0 && spotLightPart && spotLight != null)
		{
			updateSpotlight(currentSection.mustHitSection);
		}

		if (shakeCam)
		{
			gf.playAnim('scared', true);
		}

		var funny:Float = Math.max(Math.min(healthBar.value,1.9),0.1);//Math.clamp(healthBar.value,0.02,1.98);//Math.min(Math.min(healthBar.value,1.98),0.02);

		//health icon bounce but epic
		if (!inFiveNights)
		{
			iconP1.setGraphicSize(Std.int(iconP1.width + (50 * (funny + 0.1))),Std.int(iconP1.height - (25 * funny)));
			iconP2.setGraphicSize(Std.int(iconP2.width + (50 * ((2 - funny) + 0.1))),Std.int(iconP2.height - (25 * ((2 - funny) + 0.1))));
		}
		else
		{
			iconP2.setGraphicSize(Std.int(iconP2.width + (50 * funny)),Std.int(iconP2.height - (25 * funny)));
			iconP1.setGraphicSize(Std.int(iconP1.width + (50 * ((2 - funny) + 0.1))),Std.int(iconP1.height - (25 * ((2 - funny) + 0.1))));
		}

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if(curBeat % 2 == 0)
		{
			if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.canDance && (boyfriend.animation.curAnim.name == "hit" ? boyfriend.animation.curAnim.finished : true) && (boyfriend.animation.curAnim.name == "dodge" ? boyfriend.animation.curAnim.finished : true))
			{
				boyfriend.playAnim('idle', true);
				if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && formoverride != 'tristan-golden-glowing' && bfTween == null)
				{
					boyfriend.color = nightColor;
				}
				else if(sunsetLevels.contains(curStage) && bfTween == null)
				{
					boyfriend.color = sunsetColor;
				}
				else if (bfTween == null)
				{
					boyfriend.color = FlxColor.WHITE;
				}
				else
				{
					if (!bfTween.active && !bfTween.finished)
					{
						bfTween.active = true;
					}
					boyfriend.color = bfTween.color;
				}
			}
		}

	}
	function gameOver()
	{
		var deathSkinCheck = formoverride == "bf" || formoverride == "none" ? SONG.player1 : isRecursed ? boyfriend.curCharacter : formoverride;
		openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, deathSkinCheck));
		#if desktop
			DiscordClient.changePresence("GAME OVER -- "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	public function preload(graphic:String) //preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}
	public function repositionChar(char:Character)
	{
		char.x += char.globalOffset[0];
		char.y += char.globalOffset[1];
	}
	function updateSpotlight(bfSinging:Bool)
	{
		var curSinger = bfSinging ? boyfriend : dad;

		if (lastSinger != curSinger)
		{
			gf.canDance = false;
			bfSinging ? gf.playAnim("singRIGHT", true) : gf.playAnim("singLEFT", true);
			gf.animation.finishCallback = function(anim:String)
			{
				gf.canDance = true;
			}

			var positionOffset:FlxPoint = new FlxPoint(0,-150);

			switch (curSinger.curCharacter)
			{
				case 'bambi-new':
					positionOffset.x = -25;
					positionOffset.y += -70;
				case 'bf-pixel':
					positionOffset.y += -225;
			}
			var targetPosition = new FlxPoint(curSinger.getGraphicMidpoint().x - spotLight.width / 2 + positionOffset.x, curSinger.getGraphicMidpoint().y + curSinger.frameHeight / 2 - (spotLight.height) - positionOffset.y);
			
			if (SONG.song.toLowerCase() == 'indignancy')
			{
				targetPosition.y += 80;
			}

			FlxTween.tween(spotLight, {x: targetPosition.x, y: targetPosition.y}, 0.66, {ease: FlxEase.circOut});
			lastSinger = curSinger;
		}
	}
	function sixAM()
	{
		FlxG.sound.music.volume = 1;
		vocals.volume = 1;
		camHUD.alpha = 1;

		FlxG.camera.flash(FlxColor.WHITE, 0.5);
		black = new FlxSprite(0, 0).makeGraphic(2560, 1440, FlxColor.BLACK);
		black.screenCenter();
		black.scrollFactor.set();
		black.cameras = [camHUD];
		add(black);

		var sixAM:FlxText = new FlxText(0, 0, 0, "6 AM", 90);
		sixAM.setFormat(Paths.font('fnaf.ttf'), 90, FlxColor.WHITE, CENTER);
		sixAM.antialiasing = false;
		sixAM.scrollFactor.set();
		sixAM.screenCenter();
		sixAM.cameras = [camHUD];
		sixAM.alpha = 0;
		add(sixAM);

		FlxTween.tween(sixAM, {alpha: 1}, 1);

		var crowdSmall = new FlxSound().loadEmbedded(Paths.sound('fiveNights/CROWD_SMALL_CHIL_EC049202', 'shared'));
		crowdSmall.play();
	}
	public function getCamZoom():Float
	{
		return defaultCamZoom;
	}
	public static function resetShader()
	{
		PlayState.instance.shakeCam = false;
		PlayState.instance.camZooming = false;
		#if SHADERS_ENABLED
		screenshader.shader.uampmul.value[0] = 0;
		screenshader.Enabled = false;
		#end
	}

	function sectionStartTime(section:Int):Float
	{
		var daBPM:Float = SONG.bpm;
		var daPos:Float = 0;
		for (i in 0...section)
		{
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}
	function switchNoteScroll(cancelTweens:Bool = true)
	{
		switch (scrollType)
		{
			case 'upscroll':
				strumLine.y = DOWNSCROLL_Y;
				scrollType = 'downscroll';
			case 'downscroll':
				strumLine.y = UPSCROLL_Y;
				scrollType = 'upscroll';
		}
		for (strumNote in strumLineNotes)
		{
			if (cancelTweens)
			{
				FlxTween.completeTweensOf(strumNote);
			}
			strumNote.angle = 0;
			
			FlxTween.angle(strumNote, strumNote.angle, strumNote.angle + 360, 0.4, {ease: FlxEase.expoOut});
			FlxTween.tween(strumNote, {y: strumLine.y}, 0.6, {ease: FlxEase.backOut});
		}
	}

	function switchNoteSide()
	{
		for (i in 0...4)
		{
			var curOpponentNote = dadStrums.members[i];
			var curPlayerNote = playerStrums.members[i];

			FlxTween.tween(curOpponentNote, {x: curPlayerNote.x}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
			FlxTween.tween(curPlayerNote, {x: curOpponentNote.x}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
		}
		switchSide = !switchSide;
	}

	function switchNotePositions(order:Array<Int>)
	{
		var positions:Array<Float> = [];
		for (i in 0...4)
		{
			var curNote = playerStrums.members[i];
			positions.push(curNote.baseX);
		}
		for (i in 0...4)
		{
			var curNote = dadStrums.members[i];
			positions.push(curNote.baseX);
		}
		for (i in 0...4)
		{
			var curOpponentNote = dadStrums.members[i];
			var curPlayerNote = playerStrums.members[i];

			FlxTween.tween(curOpponentNote, {x: positions[order[i + playerStrumAmount]]}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
			FlxTween.tween(curPlayerNote, {x: positions[order[i]]}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
		}
		switchSide = !switchSide;
	}

	function switchDad(newChar:String, position:FlxPoint, reposition:Bool = true, updateColor:Bool = true)
	{
		if (reposition)
		{
			position.x -= dad.globalOffset[0];
			position.y -= dad.globalOffset[1];
		}
		dadGroup.remove(dad);
		dad = new Character(position.x, position.y, newChar, false);
		dadGroup.add(dad);
		if (FileSystem.exists(Paths.image('ui/iconGrid/${dad.curCharacter}', 'preload')))
		{
			iconP2.changeIcon(dad.curCharacter);
		}
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
		
		if (updateColor)
		{
			dad.color = getBackgroundColor(curStage);
		}
		if (reposition)
		{
			repositionChar(dad);
		}
	}
	function switchBF(newChar:String, position:FlxPoint, reposition:Bool = true, updateColor:Bool = true)
	{
		if (reposition)
		{
			position.x -= boyfriend.globalOffset[0];
			position.y -= boyfriend.globalOffset[1];
		}
		bfGroup.remove(boyfriend);
		boyfriend = new Boyfriend(position.x, position.y, newChar);
		bfGroup.add(boyfriend);
		if (FileSystem.exists(Paths.image('ui/iconGrid/${boyfriend.curCharacter}', 'preload')))
		{
			iconP1.changeIcon(boyfriend.curCharacter);
		}
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
		
		if (updateColor)
		{
			boyfriend.color = getBackgroundColor(curStage);
		}
		if (reposition)
		{
			repositionChar(boyfriend);
		}
	}
	function switchGF(newChar:String, position:FlxPoint, reposition:Bool = true, updateColor:Bool = true)
	{
		if (reposition)
		{
			position.x -= gf.globalOffset[0];
			position.y -= gf.globalOffset[1];
		}
		gfGroup.remove(gf);
		gf = new Character(position.x, position.y, newChar);
		gfGroup.add(gf);
		
		if (updateColor)
		{
			gf.color = getBackgroundColor(curStage);
		}
		if (reposition)
		{
			repositionChar(gf);
		}
	}

	function makeInvisibleNotes(invisible:Bool)
	{
		if (invisible)
		{
			for (strumNote in strumLineNotes)
			{
				FlxTween.cancelTweensOf(strumNote);
				FlxTween.tween(strumNote, {alpha: 0}, 1);
			}
		}
		else
		{
			for (strumNote in strumLineNotes)
			{
				FlxTween.cancelTweensOf(strumNote);
				FlxTween.tween(strumNote, {alpha: 1}, 1);
			}
		}
	}
	function changeDoorState(closed:Bool)
	{
		doorClosed = closed;
		doorChanging = true;
		FlxG.sound.play(Paths.sound('fiveNights/doorInteract', 'shared'), 1);
		if (doorClosed)
		{
			doorButton.loadGraphic(Paths.image('fiveNights/btn_doorClosed'));
			powerMeter.loadGraphic(Paths.image('fiveNights/powerMeter_2'));
			door.animation.play('doorShut');
			
			powerDrainer = 3;
		}
		else
		{
			doorButton.loadGraphic(Paths.image('fiveNights/btn_doorOpen'));
			powerMeter.loadGraphic(Paths.image('fiveNights/powerMeter'));
			door.animation.play('doorOpen');

			powerDrainer = 1;
		}
		door.animation.finishCallback = function(animation:String)
		{
			doorChanging = false;
		}
	}
	function changeSign(asset:String, ?position:FlxPoint)
	{
		sign.loadGraphic(Paths.image('california/$asset', 'shared'));
		if (position != null)
		{
			sign.setPosition(position.x, position.y);
		}
		else
		{
			sign.setPosition(FlxG.width + sign.width, 450);
		}
	}
}

enum CharacterFunnyEffect
{
	None; Dave; Bambi; Tristan; Exbungo; Recurser;
}
