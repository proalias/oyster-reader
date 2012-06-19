//Created by Action Script Viewer - http://www.buraks.com/asv
package com.proalias.rfid
{
    public class Commands 
    {

        public static const RESET:int = 128;
        public static const READ_FIRMWARE_VERSION:int = 129;
        public static const SEEK_FOR_TAG:int = 130;
        public static const SELECT_TAG:int = 131;
        public static const AUTHENTICATE:int = 133;
        public static const READ_BLOCK:int = 134;
        public static const READ_VALUE:int = 135;
        public static const WRITE_BLOCK:int = 136;
        public static const WRITE_VALUE:int = 137;
        public static const WRITE_4_BYTE_BLOCK:int = 139;
        public static const WRITE_KEY:int = 140;
        public static const INCREMENT:int = 141;
        public static const DECREMENT:int = 142;
        public static const ANTENNA_POWER:int = 144;
        public static const READ_PORT:int = 145;
        public static const WRITE_PORT:int = 146;
        public static const HALT:int = 147;
        public static const SET_BAUDRATE:int = 148;
        public static const SLEEP:int = 150;


        public static function getCommandLength(_arg1:int):int
        {
            var _local2:int;
            _local2 = 0;
            switch (_arg1)
            {
                case SEEK_FOR_TAG:
                case READ_FIRMWARE_VERSION:
                    _local2 = 1;
                    break;
                default:
                    _local2 = 1;
            };
            return (_local2);
        }


    }
}//package com.proalias.rfid
