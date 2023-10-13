package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import lime.app.Application;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;
	var updateCamera:Bool = false;

	var stageSuffix:String = "";
	var deathSuffix:String = '';

	public function new(x:Float, y:Float,char:String)
	{
		var daBf:String = '';
		switch (char)
		{
			case 'bf-pixel':
				daBf = "bf-pixel-dead";
				stageSuffix = '-pixel';
				deathSuffix = '-pixel';
			case 'dave' | 'dave-recursed' | 'dave-angey':
				daBf = 'dave-death';
				deathSuffix = '-dave';
			case 'tristan' | 'tristan-recursed':
				daBf = 'tristan-death';
				deathSuffix = '-tristan';
			case 'tristan-golden':
				daBf = 'tristan-golden-death';
				deathSuffix = '-tristan';
			case 'bambi-new' | 'bambi-recursed':
				daBf = 'bambi-death';
				deathSuffix = '-bambi';
			case 'nofriend':
				daBf = 'nofriend-death';
				deathSuffix = '-nofriend';
			case 'dave-fnaf' | 'bf-cool':
				daBf = 'generic-death';
				deathSuffix = '-generic';
			default:
				daBf = char;
		}
		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		if(bf.animation.getByName('firstDeath') == null)
		{
			bf = new Boyfriend(x, y, "bf");
		}
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('death/fnf_loss_sfx' + deathSuffix));
		Conductor.changeBPM(105);

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			Application.current.window.title = Main.applicationName;

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath') {
			if (bf.animation.curAnim.curFrame >= 12 && !isFollowingAlready) {
				FlxG.camera.follow(camFollow, LOCKON, 0.01);
				updateCamera = true;
				isFollowingAlready = true;
			}
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		}

		if(updateCamera) FlxG.camera.followLerp = FlxMath.bound(elapsed * .6 / (FlxG.updateFramerate / 60), 0, 1);
		else FlxG.camera.followLerp = 0;

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer) {
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
