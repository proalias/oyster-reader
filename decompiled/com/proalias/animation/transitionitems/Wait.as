//Created by Action Script Viewer - http://www.buraks.com/asv
package com.proalias.animation.transitionitems
{
    public class Wait 
    {

        var $time:Number;

        public function Wait(_arg1:Number)
        {
            $time = _arg1;
        }

        public function execute():Boolean
        {
            trace("Wait.execute()");
            if ($time > 0)
            {
                $time--;
                return (true);
            };
            return (false);
        }


    }
}//package com.proalias.animation.transitionitems
