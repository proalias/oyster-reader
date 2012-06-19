package com.proalias.rfid {

	/**
	 * @author Alias Cummins
	 */
	public class Commands {
		
		public static const RESET:int = 0x80;
  		public static const READ_FIRMWARE_VERSION:int = 0x81;
  		public static const SEEK_FOR_TAG:int = 0x82;
  		public static const SELECT_TAG:int = 0x83;
  		public static const AUTHENTICATE:int = 0x85;
  		public static const READ_BLOCK:int = 0x86;
  		public static const READ_VALUE:int = 0x87;
  		public static const WRITE_BLOCK:int = 0x88;
  		public static const WRITE_VALUE:int = 0x89;
  		public static const WRITE_4_BYTE_BLOCK:int = 0x8B;
  		public static const WRITE_KEY:int = 0x8C;
  		public static const INCREMENT:int = 0x8D;
  		public static const DECREMENT:int = 0x8E;
  		public static const ANTENNA_POWER:int = 0x90;
  		public static const READ_PORT:int = 0x91;
  		public static const WRITE_PORT:int = 0x92;
 		public static const HALT:int = 0x93;
  		public static const SET_BAUDRATE:int = 0x94;
  		public static const SLEEP:int = 0x96;

		public static function getCommandLength(cmd : int) : int {
			var length:int = 0;
			/*
			 * TODO - go through and figure out the default response length for each of these commands
			 */
			switch(cmd){
				case SEEK_FOR_TAG:
				case READ_FIRMWARE_VERSION:
									length= 1;
									break;
				default:			length = 1;
			}
			return length;
		}
	}
}
