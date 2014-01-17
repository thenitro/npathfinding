package npathfinding.base {
	import flash.errors.IllegalOperationError;
	
	
	public final class Heuristic {
		
		public function Heuristic() {
			throw new IllegalOperationError("Heuristic is static!");
		};
		
		public static function manhattan(pNode:Node, pEndNode:Node, 
										 pStraightCost:Number, pDiagonalCost:Number):Number {
			return Math.abs(pNode.indexX - pEndNode.indexX) * pStraightCost + 
				   Math.abs(pNode.indexY + pEndNode.indexY) * pStraightCost;
		};
		
		public static function euclidean(pNode:Node, pEndNode:Node,
										 pStraightCost:Number, pDiagonalCost:Number):Number {
			var dx:Number = pNode.indexX - pEndNode.indexX;
			var dy:Number = pNode.indexY - pEndNode.indexY;
			
			return Math.sqrt(dx * dx + dy * dy) * pStraightCost;
		};
		
		public static function diagonal(pNode:Node, pEndNode:Node,
										pStraightCost:Number, pDiagonalCost:Number):Number {
			var dx:Number = Math.abs(pNode.indexX - pEndNode.indexX);
			var dy:Number = Math.abs(pNode.indexY - pEndNode.indexY);
			
			var diagonal:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			
			return pDiagonalCost * diagonal + pStraightCost * (straight - 2 * diagonal);
		};
	}
}