package npathfinding.sample.view {
	import flash.errors.IllegalOperationError;
	
	import ncollections.grid.IGridObject;
	
	import ngine.display.gridcontainer.interfaces.IVisualGridObject;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	public final class VisualNode extends Quad implements IVisualGridObject {
		public static const OPEN_COLOR:uint   = 0xFFFFFF;
		public static const CLOSED_COLOR:uint = 0x000000;
		
		public static const SELECT_COLOR:uint = 0xCCCCCC;
		
		public static const START_COLOR:uint = 0x00FF00; 
		public static const END_COLOR:uint   = 0xFF0000; 
		
		private var _indexX:int;
		private var _indexY:int;
		
		public function VisualNode(pWidth:Number, pHeight:Number) {
			super(pWidth, pHeight);
			
			_indexX = 0;
			_indexY = 0;
		};
		
		public function get indexX():int {
			return _indexX;
		};
		
		public function get indexY():int {
			return _indexY;
		};
		
		public function get reflection():Class {
			return VisualNode;
		};
		
		public function updateIndex(pX:int, pY:int):void {
			_indexX = pX;
			_indexY = pY;
		};
		
		public function clone():IGridObject {
			throw new IllegalOperationError(this + '.clone: Not implemented!');
			return null;
		};
		
		
		public function poolPrepare():void {
			
		};
		
		public function toString():String {
			return '[object VisualNode x=' + indexX + ', y=' + indexY + ']';
		};
	}
}