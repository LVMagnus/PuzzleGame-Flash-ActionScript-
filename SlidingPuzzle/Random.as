package 
{
	import adobe.utils.CustomActions;
	
	/**
	 * ...
	 * @author Luiz de Mello
	 */
	public class Random 
	{
		private static var last:int;
		public static function NewNumber(exclusiveMax:Number=1, inclusiveMin:Number=0):int
		{
			if (inclusiveMin >= exclusiveMax)
				throw new Error("Random.NewNumber(): inclusiveMin must be smaller than exclusiveMax");
			
			last = Math.floor( Math.random() * (exclusiveMax - inclusiveMin) + inclusiveMin);
			return last;
		}
		
		public static function get Last():int
		{
			return last;
		}
		

	}
	
}