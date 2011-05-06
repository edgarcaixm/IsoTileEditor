package com.adobe.serialization.json
{
	
	public class DiversionJSON
	{
		
		public static function encode( o:Object ):String
		{
			return new DiversionJSONEncoder( o ).getString();
		}
		
		public static function decode( s:String, strict:Boolean = true ):*
		{
			return new JSONDecoder( s, strict ).getValue();
		}
	}
}