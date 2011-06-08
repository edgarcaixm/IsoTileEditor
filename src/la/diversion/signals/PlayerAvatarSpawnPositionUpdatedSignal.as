/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Jun 6, 2011
 *
 */

package la.diversion.signals
{
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	
	public class PlayerAvatarSpawnPositionUpdatedSignal extends Signal
	{
		public function PlayerAvatarSpawnPositionUpdatedSignal(...parameters)
		{
			super(Point);
		}
	}
}