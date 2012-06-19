package com.proalias.animation.transitionitems { 

	public class Wait {
		var $time:Number;
		public function Wait(time:Number) {
			$time = time;
		}
		public function execute():Boolean{
			trace("Wait.execute()");
			if ($time>0){
				$time--;
				return true;
			}else{
				return false;
			}
		}
	}
}