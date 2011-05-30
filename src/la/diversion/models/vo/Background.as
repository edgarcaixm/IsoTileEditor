/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 6, 2011
 *
 */

package la.diversion.models.vo
{
	import com.adobe.serialization.json.DiversionJSON;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class Background extends Bitmap implements IAsset
	{
		private var _id:String;
		private var _displayClassId:String;
		private var _displayClass:Class;
		private var _displayClassType:String;
		private var _fileUrl:String;
		private var _classRef:String;
		private var _spriteSheet:SpriteSheet;
		
		public function Background(id:String, displayClassId:String, displayClass:Class, displayClassType:String, fileUrl:String, classRef:String, bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			_id = id;
			_displayClassId = displayClassId;
			_displayClass = displayClass;
			_displayClassType = displayClassType;
			_fileUrl = fileUrl;
			_classRef = classRef;
		}
		
		public function get spriteSheet():SpriteSheet {
			return _spriteSheet;
		}

		public function set spriteSheet(value:SpriteSheet):void {
			_spriteSheet = value;
		}

		public function get classRef():String {
			return _classRef;
		}

		public function set classRef(value:String):void {
			_classRef = value;
		}

		public function get fileUrl():String {
			return _fileUrl;
		}

		public function set fileUrl(value:String):void {
			_fileUrl = value;
		}

		public function get displayClassType():String {
			return _displayClassType;
		}

		public function set displayClassType(value:String):void {
			_displayClassType = value;
		}

		public function get displayClass():Class {
			return _displayClass;
		}

		public function set displayClass(value:Class):void {
			_displayClass = value;
		}

		public function get displayClassId():String {
			return _displayClassId;
		}

		public function set displayClassId(value:String):void {
			_displayClassId = value;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function toJSON():String{
			var result:Object = new Object();
			
			result.id = id;
			result.displayClassId = _displayClassId;
			result.fileUrl = _fileUrl;
			result.x = this.x;
			result.y = this.y;
			result.classRef = _classRef;
			return DiversionJSON.encode(result);
		}
		
		public function clone():*{
			return new Background(_id, _displayClassId, _displayClass, _displayClassType, _fileUrl, _classRef, this.bitmapData, this.pixelSnapping, this.smoothing);
		}
	}
}