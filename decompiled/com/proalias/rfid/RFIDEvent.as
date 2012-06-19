//Created by Action Script Viewer - http://www.buraks.com/asv
package com.proalias.rfid
{
    import flash.events.Event;

    public class RFIDEvent extends Event 
    {

        public static var TAG_RESPONSE:String = "receiveTag";
        public static var NO_TAG:String = "noTag";

        private var _tag_type_name:String;
        private var _tag:String;
        private var _tag_type:uint;

        public function RFIDEvent(_arg1:String, _arg2:String, _arg3:uint, _arg4:String)
        {
            trace((((((((("RFIDEvent.RFIDEvent(" + _arg1) + ",") + _arg2) + ",") + _arg3) + ",") + _arg4) + ")"));
            super(_arg1);
            _tag = _arg2.toUpperCase();
            _tag_type = _arg3;
            _tag_type_name = _arg4;
        }

        public function get tag_type_num():uint
        {
            return (_tag_type);
        }

        public function get tag_type_name():String
        {
            return (_tag_type_name);
        }

        public function set tag_type_num(_arg1:uint):void
        {
            _tag_type = _arg1;
        }

        public function set tag_type_name(_arg1:String):void
        {
            _tag_type_name = _arg1;
        }

        public function get tag():String
        {
            return (_tag);
        }

        override public function clone():Event
        {
            return (new RFIDEvent(type, _tag, _tag_type, _tag_type_name));
        }

        public function set tag(_arg1:String):void
        {
            _tag = _arg1;
        }


    }
}//package com.proalias.rfid
