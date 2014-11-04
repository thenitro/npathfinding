package npathfinding.base {
    import ncollections.grid.IGridObject;

    public final class Node implements IGridObject {
		public var g:Number;
		public var f:Number;
		public var h:Number;
		
		public var parent:Node;
		
		public var opened:Boolean;
		public var closed:Boolean;
		
		private var _indexX:int;
		private var _indexY:int;
		
		private var _walkable:Boolean;

        private var _disposed:Boolean;
		
		public function Node(pWalkable:Boolean = false) {
			_walkable = pWalkable;
		};
		
		public function get indexX():int {
			return _indexX;
		};
		
		public function get indexY():int {
			return _indexY;
		};
		
		public function get reflection():Class {
			return Node;
		};

        public function get disposed():Boolean {
            return _disposed;
        };
		
		public function set walkable(pValue:Boolean):void {
			_walkable = pValue;
		};
		
		public function get walkable():Boolean {
			return _walkable;
		};
		
		public function updateIndex(pX:int, pY:int):void {
			_indexX = pX;
			_indexY = pY;
		};
		
		public function clone():IGridObject {
			return null;
		};
		
		public function poolPrepare():void {
		};
		
		public function dispose():void {
            _disposed = true;
		};
		
		public function toString():String {
			return '[object Node x=' + indexX + ', y=' + indexY + ', f=' + f + ', walkable=' + walkable + ' ]';
		};
	}
}