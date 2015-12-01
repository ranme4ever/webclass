package com.protocol
{
	public class NetProtocol
	{
		public function NetProtocol()
		{
		}
		
		/**
		 * LBS server connect ommand 
		 */
		public static const CMD_CONNECT_LBS_SERVER:uint=1
		/**
		 * Auth server connect command 
		 */
		public static const CMD_CONNECT_AUTH_SERVER:uint=2;
		
		public static const CMD_USER_LOGIN:uint = 3;
			
		public static const CMD_LOGIN_SUCCESS:uint = 4;
		
		public static const CMD_GET_USER_INFO:uint =5;
	}
}