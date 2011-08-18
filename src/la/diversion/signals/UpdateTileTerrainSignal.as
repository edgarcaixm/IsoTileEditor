/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Aug 16, 2011
 *
 */

package la.diversion.signals
{
	import org.osflash.signals.Signal;
	
	public class UpdateTileTerrainSignal extends Signal
	{
		public function UpdateTileTerrainSignal(...parameters)
		{
			super(Array, String);
		}
	}
}