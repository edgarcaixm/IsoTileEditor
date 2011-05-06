package com.adobe.serialization.json
{
	public class DiversionJSONEncoder extends JSONEncoder
	{
		
		public function DiversionJSONEncoder( value:* )
		{
			super( value );
		}
		
		override protected function convertToString(value:*):String{
			// determine what value is and convert it based on it's type
			if ( value is String )
			{
				// escape the string so it's formatted correctly
				return escapeString( value as String );
			}
			else if ( value is Number )
			{
				// only encode numbers that finate
				return isFinite( value as Number ) ? value.toString() : "null";
			}
			else if ( value is Boolean )
			{
				// convert boolean to string easily
				return value ? "true" : "false";
			}
			else if ( value is Array )
			{
				// call the helper method to convert an array
				return arrayToString( value as Array );
			}
			else if( value != null && "toJSON" in value)
			{
				return value["toJSON"]();	
			}
			else if ( value is Object && value != null )
			{
				// call the helper method to convert an object
				return objectToString( value );
			}
			
			return "null";
		}
	}
}