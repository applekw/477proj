<?php
	include_once("JSONEncodableObject.php");
	class Tutor extends JSONEncodableObject
	{
		public $TID;
		public $name;
		public $year;
		public $major;
		public $Room_Number;
		public $about_tutor;
		
		public static $TIDQueryString = "TID";
		public static $nameQueryString = "name";
		public static $yearQueryString = "year";
		public static $majorQueryString = "major";
		public static $Room_NumberQueryString = "room";
		public static $about_tutorQueryString = "about_tutor";
		
		
		
	}
?>