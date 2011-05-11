/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 28, 2011
 *
 */

package la.diversion.views {
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.primitive.IsoPrimitive;
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.SolidColorFill;
	import as3isolib.graphics.Stroke;
	
	import caurina.transitions.Tweener;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import la.diversion.models.components.GameAsset;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class IsoSceneView extends Sprite {
		
		public var cellSize:int = 64;
		
		public var isoView:IsoView;
		public var isoScene:IsoScene;
		public var isoGrid:IsoGrid;
		public var highlight:IsoRectangle;
		public var dragImage:Sprite;
		public var colRowText:TextField;
		public var colRowTextLabel:TextField;
		public var bg:Sprite;
		
		public var enterFrame:NativeSignal;
		public var addedToStage:NativeSignal;
		public var stageMouseEventClick:NativeSignal;
		public var stageMouseEventMouseMove:NativeSignal;
		public var stageMouseEventMouseDown:NativeSignal;
		public var stageMouseEventMouseUp:NativeSignal;
		public var stageMouseEventMouseWheel:NativeSignal;
		public var thisMouseEventRollOut:NativeSignal;
		public var thisMouseEventRollOver:NativeSignal;
		
		public function IsoSceneView()
		{
			super();
			
			//background blue sprite
			bg = new Sprite();
			bg.graphics.beginFill(0x00FFFF);
			bg.graphics.drawRect(0,0,760,760);
			bg.graphics.endFill();
			this.addChildAt(bg,0);
			
			//row, col position
			colRowTextLabel = new TextField();
			colRowTextLabel.mouseEnabled = false;
			colRowTextLabel.x = 710;
			colRowTextLabel.y = 1;
			colRowTextLabel.multiline = true;
			colRowTextLabel.defaultTextFormat = new TextFormat(null,14);
			colRowTextLabel.text = "col:\nrow:"
			this.addChildAt(colRowTextLabel, 1);
			colRowText = new TextField();
			colRowText.mouseEnabled = false;
			colRowText.x = 740;
			colRowText.y = 1;
			colRowText.multiline = true;
			colRowText.defaultTextFormat = new TextFormat(null,14);
			this.addChildAt(colRowText, 1);
			
			
			thisMouseEventRollOut = new NativeSignal(this, MouseEvent.ROLL_OUT, MouseEvent);
			thisMouseEventRollOver = new NativeSignal(this, MouseEvent.ROLL_OVER, MouseEvent);
			enterFrame = new NativeSignal(this, Event.ENTER_FRAME, Event);
			addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			addedToStage.add(handleThisAddedToStage);
		}
		
		private function handleThisAddedToStage(event:Event):void{
			stageMouseEventClick = new NativeSignal(stage, MouseEvent.CLICK, MouseEvent);
			stageMouseEventMouseMove = new NativeSignal(stage, MouseEvent.MOUSE_MOVE, MouseEvent);
			stageMouseEventMouseDown = new NativeSignal(stage, MouseEvent.MOUSE_DOWN, MouseEvent);
			stageMouseEventMouseUp = new NativeSignal(stage, MouseEvent.MOUSE_UP, MouseEvent);
			stageMouseEventMouseWheel = new NativeSignal(stage, MouseEvent.MOUSE_WHEEL, MouseEvent);
		}
		
		public function get position():Point {
			return new Point(isoView.x, isoView.y);
		}
		
	}
}