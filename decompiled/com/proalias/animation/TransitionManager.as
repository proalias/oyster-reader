//Created by Action Script Viewer - http://www.buraks.com/asv
package com.proalias.animation
{
    import flash.display.MovieClip;
    import com.proalias.animation.transitionitems.Wait;
    import flash.events.Event;
    import flash.events.*;
    import com.proalias.animation.transitionitems.*;

    public class TransitionManager extends MovieClip 
    {

        private static var $instance:TransitionManager;

        private var $queueArray:Array;
        private var $totalQueues:int;
        private var $working:Boolean;

        public function TransitionManager():void
        {
            init();
        }

        public static function get instance():TransitionManager
        {
            if ($instance == null)
            {
                $instance = new (TransitionManager)();
            };
            return ($instance);
        }


        public function init():void
        {
            $queueArray = new Array();
            $working = false;
            $totalQueues = 0;
        }

        public function get working():Boolean
        {
            return ($working);
        }

        public function stopQueue():void
        {
            this.removeEventListener(Event.ENTER_FRAME, executeQueue);
            $working = false;
        }

        public function addItem(_arg1:Object, _arg2:String):Boolean
        {
            if (_arg2 == null)
            {
                _arg2 = "default";
            };
            if ($queueArray[_arg2] == undefined)
            {
                addQueue(_arg2);
            };
            $queueArray[_arg2].push(_arg1);
            $working = true;
            startQueue();
            return (true);
        }

        public function wait(_arg1:String, _arg2:Number):void
        {
            var _local3:Wait;
            _local3 = new Wait(_arg2);
            addItem(_local3, _arg1);
        }

        private function doneAllTransitions():void
        {
            $working = false;
            this.removeEventListener(Event.ENTER_FRAME, executeQueue);
        }

        public function clearAllTweens():void
        {
            var _local1:*;
            for (_local1 in $queueArray)
            {
                delete $queueArray[_local1];
            };
            $queueArray = new Array();
        }

        private function executeQueue(_arg1:Event):void
        {
            var _local2:String;
            var _local3:String;
            var _local4:Boolean;
            for (_local2 in $queueArray)
            {
                _local3 = (_local3 + (":" + _local2));
                if ($queueArray[_local2].length > 0)
                {
                    $working = true;
                    _local4 = $queueArray[_local2][0].execute();
                    if (!_local4)
                    {
                        $queueArray[_local2].shift();
                        if ($queueArray[_local2].length == 0)
                        {
                            delete $queueArray[_local2];
                            $totalQueues--;
                        };
                    };
                };
            };
            if ($totalQueues == 0)
            {
                $working = false;
                doneAllTransitions();
                stopQueue();
            };
        }

        public function startQueue():void
        {
            this.addEventListener(Event.ENTER_FRAME, executeQueue);
            $working = true;
        }

        public function removeQueue(_arg1:String):void
        {
            var _local2:*;
            for (_local2 in $queueArray)
            {
                if (_local2 == _arg1)
                {
                    delete $queueArray[_local2];
                    if ($totalQueues > 0)
                    {
                        $totalQueues--;
                    };
                };
            };
        }

        private function addQueue(_arg1:String):void
        {
            $queueArray[_arg1] = new Array();
            $totalQueues++;
        }


    }
}//package com.proalias.animation
