//Created by Action Script Viewer - http://www.buraks.com/asv
package com.proalias.animation.easing
{
    public class Quad 
    {


        public static function easeOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            _arg1 = (_arg1 / _arg4);
            return ((((-(_arg3) * _arg1) * (_arg1 - 2)) + _arg2));
        }

        public static function easeIn(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            _arg1 = (_arg1 / _arg4);
            return ((((_arg3 * _arg1) * _arg1) + _arg2));
        }

        public static function easeInOut(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number
        {
            _arg1 = (_arg1 / (_arg4 / 2));
            if (_arg1 < 1)
            {
                return (((((_arg3 / 2) * _arg1) * _arg1) + _arg2));
            };
            --_arg1;
            return ((((-(_arg3) / 2) * ((_arg1 * (_arg1 - 2)) - 1)) + _arg2));
        }


    }
}//package com.proalias.animation.easing
