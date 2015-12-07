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
		
		/**
		 * login  
		 */
		public static const CMD_USER_LOGIN:uint = 3;
			
		/**
		 * login success 
		 */
		public static const CMD_LOGIN_SUCCESS:uint = 4;
		
		/**
		 * get user info 
		 */
		public static const CMD_GET_USER_INFO:uint =5;
		/**
		 * 获取教室信息 
		 */		
		public static const CMD_CLASS_SERVER_INFO:uint = 6;
		
		/**
		 * 连接教室 
		 */
		public static const CMD_CONNECT_CLASSROOM:uint = 7;
		
		/**
		 * 心跳指令
		 */
		public static const CMD_HEART_BEAT:uint = 8;
		/**
		 * enter class 
		 */		
		public static const CMD_ENTER_CLASS:uint = 9;
		
		/**
		 * 课件切换 
		 */
		public static const CMD_COURSEWARE_CHANGE:uint = 10;
		
		/**
		 * 白板数据 
		 */
		public static const WRITE_BOARD_DATA:uint = 11;
		
		public static const PPT_DATA:uint = 12;
		
		public static const DESK_SHARE_DATA:uint =13;
		
		public static const CAMERA_DATA:uint = 14;
		
	}
}