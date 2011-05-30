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
	public interface IAsset
	{
		function get id():String;
		
		function get displayClassId():String;
		
		function get displayClass():Class;
		
		function get displayClassType():String;
		
		function get fileUrl():String;
		
		function get spriteSheet():SpriteSheet;
		
		function clone():*;
	}
}