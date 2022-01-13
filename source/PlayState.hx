package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import objects.Line;

class PlayState extends FlxState
{
	var upperLeg1:Line = new Line();
	var lowerLeg1:Line = new Line();
	var l1:Float = 100;
	var l2:Float = 100;
	var x1:Float = FlxG.width / 2;
	var y1:Float = FlxG.height / 2;
	var sign:Int = 1;

	override public function create()
	{
		super.create();
		add(upperLeg1);
		add(lowerLeg1);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
			sign = -sign;

		var limb1:Limb = {
			limb: upperLeg1,
			lenght: l1,
			X: x1,
			Y: y1
		}
		var limb2:Limb = {
			limb: lowerLeg1,
			lenght: l2,
			X: FlxG.mouse.screenX,
			Y: FlxG.mouse.screenY
		}

		IK_limb(limb1, limb2, sign);
	}

	/**
	 * @param   limb1			 The first part of the limb.
	 * @param   limb2		     The second part of the limb.
	 * @param   sign		     Affects limb's destination by passing a positive or a negative Int
	 */
	function IK_limb(limb1:Limb, limb2:Limb, sign:Int):Void
	{
		//		A
		//		|\
		//		| \ b
		//		|  \
		//		|   \
		//	   c|   / C
		//		|  /
		//		| / a
		//		|/
		//		B

		// A-----b----C-----a-----B <-- lenght of bone1 (b) and bone2 (a)
		// a: the distance between C and B
		// b: the distance between A and C
		// c: the distance between A and B

		// bones length
		var b = limb1.lenght;
		var a = limb2.lenght;
		// the anchor point
		var Ax = limb1.X;
		var Ay = limb1.Y;
		// the mouse point
		var ax = limb2.X;
		var ay = limb2.Y;

		// the distance between point A and B
		var c = Math.min(Math.round(FlxMath.vectorLength(Ax - ax, Ay - ay) + (b / 12)), a + b);

		// The angle of A
		var alpha = Math.round(FlxAngle.asDegrees(Math.atan2(ay - Ay, ax - Ax)));

		// The position of point B
		var Bx = Ax + c * Math.cos(FlxAngle.asRadians(alpha));
		var By = Ay + c * Math.sin(FlxAngle.asRadians(alpha));

		// The angle of point C
		var beta = FlxMath.signOf(sign) * FlxAngle.asDegrees(Math.acos(Math.min(1, Math.max(-1, b * b + c * c - a * a) / (2 * b * c))));
		var gama = alpha - beta;

		// The position of point C
		var Cx = Ax + b * Math.cos(FlxAngle.asRadians(gama));
		var Cy = Ay + b * Math.sin(FlxAngle.asRadians(gama));

		// draw it!

		cast(limb1.limb, Line).drawIt(Ax, Ay, Cx, Cy);
		cast(limb2.limb, Line).drawIt(Cx, Cy, Bx, By);
	}
}

/**
 * @param limb	The Line to be drawn
 * @param lengh The lenght of the line
 * @param X		The X(n) position of the line. If this limb is the first n = 1 (aka X1) else n = 2 (aka X2)
 * @param Y		The Y(n) position of the line. If this limb is the first n = 1 (aka Y1) else n = 2 (aka Y2)
 */
typedef Limb =
{
	var limb:Line;
	var lenght:Float;
	var X:Float;
	var Y:Float;
}
