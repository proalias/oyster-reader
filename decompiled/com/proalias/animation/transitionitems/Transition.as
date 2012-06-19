//Created by Action Script Viewer - http://www.buraks.com/asv
package com.proalias.animation.transitionitems
{
    public class Transition 
    {

        private var $easingFunction:Function;
        private var $startValues:Object;
        private var $time:Number;
        public var finished:Boolean;
        private var $target:Object;
        private var $properties:Object;
        private var $duration:Number;

        public function Transition(_arg1:Object, _arg2:Object, _arg3:Function, _arg4:Number)
        {
            $target = _arg1;
            $time = 0;
            $duration = int(_arg4);
            $properties = _arg2;
            $easingFunction = _arg3;
            finished = false;
        }

        public function execute():Boolean
        {
            var _local1:Function;
            var _local2:*;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            _local1 = $easingFunction;
            if ($startValues == null)
            {
                $startValues = new Object();
                for (_local2 in $properties)
                {
                    $startValues[_local2] = $target[_local2];
                };
            };
            if ($time < $duration)
            {
                for (_local2 in $properties)
                {
                    _local3 = $startValues[_local2];
                    _local4 = ($properties[_local2] - _local3);
                    _local5 = $duration;
                    $target[_local2] = _local1($time, _local3, _local4, _local5);
                };
                $time++;
                return (true);
            };
            for (_local2 in $properties)
            {
                $target[_local2] = $properties[_local2];
            };
            finished = true;
            return (false);
        }


    }
}//package com.proalias.animation.transitionitems
