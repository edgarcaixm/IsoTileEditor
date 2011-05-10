/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 25, 2011
 *
 */

package la.diversion.views.components {
	import com.bit101.components.Label;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import la.diversion.enums.AssetTypes;
	import la.diversion.models.components.GameAsset;
	import la.diversion.models.components.IAsset;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class AssetListItem extends Sprite {
		
		private var _label:Label;
		private var _gameAsset:IAsset;
		private var _addedToStage:NativeSignal;
		
		public var mouseDown:NativeSignal;
		public var mouseUp:NativeSignal;
		
		public function AssetListItem(gameAsset:IAsset, item_width:Number, item_height:Number, labelTxt:String)
		{
			super();
			this._gameAsset = gameAsset;
			
			// item bg
			this.graphics.lineStyle(.5, 0x000000);
			this.graphics.beginFill(0xdddddd);
			this.graphics.drawRect(0, 0, item_width, item_height);
			this.graphics.endFill();
			
			this.width = item_width;
			this.height = item_height;
			
			// generate thumbnail
			var tBmd:BitmapData = new BitmapData(32, 32, true, 0x00000000);
			var tAsset:Sprite;
			if(gameAsset.displayClassType == AssetTypes.SPRITE){
				tAsset = new gameAsset.displayClass as Sprite;
			}else if(gameAsset.displayClassType == AssetTypes.BITMAP){
				tAsset = new Sprite();
				var tBitmap:Bitmap = new Bitmap(new gameAsset.displayClass as BitmapData);
				tAsset.addChild(tBitmap);
			}else{
				tAsset = new Sprite();
			}
			// since image data can be off stage (positioned less than 0,0)
			// we need to translate and then scale bitmaps using Matrix transforms
			var imgArea:Rectangle = tAsset.getBounds(tAsset); // gets full extent of image even if off stage
			var transform:Matrix = new Matrix(1,0,0,1, -imgArea.x, -imgArea.y);
			// scale and constraint proportions
			var tScaleX:Number = 32/imgArea.width;
			var tScaleY:Number = 32/imgArea.height;
			if (tScaleX > tScaleY) {
				tScaleX = tScaleY;
			} else {
				tScaleY = tScaleX;
			}
			transform.scale(tScaleX, tScaleY);
			
			tBmd.draw(tAsset, transform, null, null, null, true);
			var thumb:Bitmap = new Bitmap(tBmd);
			thumb.name = "thumb";
			thumb.x = thumb.y = 4;
			this.addChild(thumb);
			// title
			_label = new Label(this, 40, 5, labelTxt);
			_label.name = "label";
			
			_addedToStage = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			_addedToStage.add(handleAddedToStage);
		}
		
		private function handleAddedToStage(event:Event):void{
			mouseDown = new NativeSignal(this, MouseEvent.MOUSE_DOWN, MouseEvent);
			mouseUp = new NativeSignal(stage,MouseEvent.MOUSE_UP, MouseEvent);
		}
		
		public function get gameAsset():IAsset{
			return _gameAsset;
		}

		public function set gameAsset(value:IAsset):void{
			_gameAsset = value;
		}
		
		public function get label():Label {
			return _label;
		}

		public function set label(value:Label):void {
			_label = value;
		}
		
		public function cleanup():void{
			_addedToStage.removeAll();
			mouseDown.removeAll();
			mouseUp.removeAll();
		}

	}
}
