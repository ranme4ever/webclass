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
		public static const CMD_CONNECT_LBS_SERVER:uint=0x0000001
		/**
		 * Auth server connect command 
		 */
		public static const CMD_CONNECT_AUTH_SERVER:uint=0x0000002;
		
		/**
		 * login  
		 */
		public static const CMD_USER_LOGIN:uint = 0x0000003;
			
		/**
		 * login success 
		 */
		public static const CMD_LOGIN_SUCCESS:uint = 0x0000004;
		
		/**
		 * get user info 
		 */
		public static const CMD_GET_USER_INFO:uint =0x0000005;
		/**
		 * 获取教室信息 
		 */		
		public static const CMD_CLASS_SERVER_INFO:uint = 0x0000006;
		
		/**
		 * 连接教室 
		 */
		public static const CMD_CONNECT_CLASSROOM:uint = 0x0000007;
		
		/**
		 * 心跳指令
		 */
		public static const CMD_HEART_BEAT:uint = 0x0000008;
		/**
		 * enter class 
		 */		
		public static const CMD_ENTER_CLASS:uint = 0x0000009;
		
		/**
		 * 课件切换 
		 */
		public static const CMD_COURSEWARE_CHANGE:uint = 0x0000010;
		
		/**
		 * 白板数据 
		 */
		public static const WRITE_BOARD_DATA:uint = 0x0000011;
		
		public static const PPT_DATA:uint = 0x0000012;
		
		public static const DESK_SHARE_DATA:uint =0x0000013;
		
		public static const CAMERA_DATA:uint = 0x0000014;
		
		public static const CHAT_MESSAGE:uint= 0x0000015;
		
		private static const protocolSchemas:Array =[
			{
				cmd:CMD_CONNECT_LBS_SERVER,
				fields:[
				]
			},{
				cmd:CMD_CONNECT_AUTH_SERVER,
				fields:[
				]
			},{
				cmd:CMD_USER_LOGIN,
				fields:[
					{
						name:'username',
						length:32,
						type:'String'
					},{
						name:'password',
						length:32,
						type:'String'
					},{
						name:'uid',
						length:32,
						type:'uint'
					}
				]
			},{
				cmd:CMD_GET_USER_INFO,
				fields:[
				]
			},{
				cmd:CMD_CLASS_SERVER_INFO,
				fields:[
				]
			},{
				cmd:CMD_CONNECT_CLASSROOM,
				fields:[
				]
			},{
				cmd:CMD_HEART_BEAT,
				fields:[
				]
			},{
				cmd:CMD_ENTER_CLASS,
				fields:[
				]
			},{
				cmd:CMD_LOGIN_SUCCESS,
				fields:[
				]
			},{
				cmd:CMD_COURSEWARE_CHANGE,
				fields:[
				]
			},{
				cmd:WRITE_BOARD_DATA,
				fields:[
				]
			},{
				cmd:PPT_DATA,
				fields:[
				]
			},{
				cmd:DESK_SHARE_DATA,
				fields:[
				]
			},{
				cmd:CAMERA_DATA,
				fields:[
				]
			},{
				cmd:CHAT_MESSAGE,
				fields:[
					{
						name:'uid',
						type:"uint",
						length:32
					},{
						name:'message',
						type:"String",
						length:'x'
					}
				]
			}
			
		];
		public static function getSchema(cmd:uint):Object
		{
			for each(var schema:Object in protocolSchemas){
				if(cmd == schema.cmd)
					return schema;
			}
			return null;
		}
		
	}
}