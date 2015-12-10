package com.model
{
	[Bindable]
	public class ApplicationModelocator
	{
		public function ApplicationModelocator()
		{
			if(_instance)
				throw new Error("please use ApplicationModelocator.getInstance() to get instance");
		}
		private static var _instance:ApplicationModelocator;
		public static function getInstance():ApplicationModelocator
		{
			if(!_instance)
				_instance = new ApplicationModelocator();
			return _instance;
		}
		
		public var UID:uint;
		public var userName:String;
		public var classId:uint;
		
		public var teacherName:String;
		public var courseName:String;
		public var courseTime:String="12-10 09:00";
	}
}