package com.component.button
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.components.Button;
	
	public class IconButton extends Button
	{
		public function IconButton()
		{
			super();
			useHandCursor=true;
			buttonMode=true;
		}
		
		private var _imgSource:Class;
		
		[Bindable]
		public var bSelected:Boolean = false;
		[Bindable]
		public var upIcon:Bitmap;
		[Bindable]
		public var overIcon:Bitmap;
		[Bindable]
		public var downIcon:Bitmap;
		[Bindable]
		public var disabledIcon:Bitmap;
		
		/**
		 * 如果是嵌入，设定此值
		 */
		public function get imgSource():Class
		{
			return _imgSource;
		}

		/**
		 * @private
		 */
		public function set imgSource(value:Class):void
		{
			_imgSource = value;
			cutImg();
		}

		private function cutImg():void {
			var bitmap:Bitmap;
			if (imgSource) {
				bitmap = new imgSource();
				solveBitmap(bitmap);
				bitmap = null;
			}
		}
		
		private function solveBitmap(bitmap:Bitmap):void {
			//cut image
			doCut(bitmap);
		}
		
		private function doCut(bitmap:Bitmap):void {
			var bCount:uint = bitmap.bitmapData.width/bitmap.bitmapData.height;
			if (bitmap.bitmapData.width % bCount) {
				return;
			}
			var icons:Array = [];
			for (var i:int = 0; i < bCount; i++) {
				var bitmapData:BitmapData = new BitmapData(bitmap.bitmapData.width / bCount,
					bitmap.bitmapData.height);
				var rc:Rectangle = new Rectangle(i * bitmap.bitmapData.width / bCount, 0,
					bitmap.bitmapData.width / bCount, bitmap.bitmapData.height);
				bitmapData.copyPixels(bitmap.bitmapData, rc, new Point(0, 0));
				var bitmapCut:Bitmap = new Bitmap(bitmapData);
				icons.push(bitmapCut);
			}
			upIcon = icons[0%bCount];
			overIcon = icons[1%bCount];
			downIcon = icons[2%bCount];
			disabledIcon = icons[3%bCount];
		}
	}
}