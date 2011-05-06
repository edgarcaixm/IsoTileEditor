/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 1, 2011
 *
 */

package la.diversion.signals {
	import org.osflash.signals.Signal;
	
	import la.diversion.models.components.Tile;
	
	public class UpdateTileWalkableSignal extends Signal {
		public function UpdateTileWalkableSignal(...parameters)
		{
			super(Tile, Boolean);
		}
	}
}